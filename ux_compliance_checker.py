#!/usr/bin/env python3
"""
UX Compliance Checker for Odyseya
Monitors Flutter codebase for UX/accessibility issues and auto-fixes them.
"""

import os
import re
import sys
import time
import argparse
from pathlib import Path
from typing import List, Dict, Tuple, Set
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class UXIssue:
    def __init__(self, file_path: str, line_num: int, severity: str, issue_type: str, message: str, auto_fix: str = None):
        self.file_path = file_path
        self.line_num = line_num
        self.severity = severity  # 'error', 'warning', 'info'
        self.issue_type = issue_type
        self.message = message
        self.auto_fix = auto_fix

    def __str__(self):
        severity_icon = {'error': '❌', 'warning': '⚠️', 'info': 'ℹ️'}
        return f"{severity_icon.get(self.severity, '•')} {self.file_path}:{self.line_num} - {self.message}"

class UXComplianceChecker:
    def __init__(self, auto_fix: bool = False):
        self.auto_fix = auto_fix
        self.issues: List[UXIssue] = []
        self.fixes_applied = 0
        
        # Patterns to check
        self.checks = [
            self.check_hardcoded_colors,
            self.check_hardcoded_spacing,
            self.check_hardcoded_text_styles,
            self.check_missing_semantics,
            self.check_insufficient_touch_targets,
            self.check_missing_keys,
            self.check_text_contrast,
            self.check_loading_states,
            self.check_error_handling,
            self.check_hardcoded_strings,
            self.check_accessibility_labels,
            self.check_gesture_exclusions,
        ]

    def check_file(self, file_path: str) -> List[UXIssue]:
        """Run all compliance checks on a single file."""
        if not file_path.endswith('.dart') or 'firebase_options.dart' in file_path:
            return []
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                lines = content.split('\n')
        except Exception as e:
            print(f"Error reading {file_path}: {e}")
            return []

        self.issues = []
        
        for check in self.checks:
            check(file_path, content, lines)
        
        return self.issues

    def check_hardcoded_colors(self, file_path: str, content: str, lines: List[str]):
        """Check for hardcoded color values instead of using constants."""
        color_patterns = [
            (r'Color\(0x[A-Fa-f0-9]{8}\)', 'Use AppColors constants instead of hardcoded colors'),
            (r'Color\.fromRGBO\(', 'Use AppColors constants instead of Color.fromRGBO'),
            (r'Colors\.\w+(?!\w*\.withOpacity)', 'Consider using AppColors constants for consistency'),
        ]
        
        # Skip if this is the colors.dart file itself
        if 'constants/colors.dart' in file_path:
            return
        
        for i, line in enumerate(lines, 1):
            for pattern, message in color_patterns:
                if re.search(pattern, line) and 'AppColors' not in line:
                    # Skip comments
                    if line.strip().startswith('//'):
                        continue
                    
                    self.issues.append(UXIssue(
                        file_path, i, 'warning', 'hardcoded-color',
                        f"{message}: {line.strip()}"
                    ))

    def check_hardcoded_spacing(self, file_path: str, content: str, lines: List[str]):
        """Check for hardcoded spacing values."""
        if 'constants/spacing.dart' in file_path or 'constants/' in file_path:
            return
        
        spacing_patterns = [
            (r'EdgeInsets\.all\((?!AppSpacing)(\d+\.?\d*)\)', 'Use AppSpacing constants'),
            (r'EdgeInsets\.symmetric\([^)]*(?!AppSpacing)(?:horizontal|vertical):\s*(\d+\.?\d*)', 'Use AppSpacing constants'),
            (r'SizedBox\((?:width|height):\s*(\d+\.?\d*)\)', 'Consider using AppSpacing constants'),
            (r'padding:\s*const\s*EdgeInsets\.all\((\d+\.?\d*)\)', 'Use AppSpacing constants'),
        ]
        
        for i, line in enumerate(lines, 1):
            if line.strip().startswith('//'):
                continue
            
            for pattern, message in spacing_patterns:
                matches = re.finditer(pattern, line)
                for match in matches:
                    value = match.group(1) if match.groups() else None
                    # Allow 0 and very small values
                    if value and float(value) > 4:
                        self.issues.append(UXIssue(
                            file_path, i, 'info', 'hardcoded-spacing',
                            f"{message}: {line.strip()}"
                        ))

    def check_hardcoded_text_styles(self, file_path: str, content: str, lines: List[str]):
        """Check for hardcoded text styles."""
        if 'constants/typography.dart' in file_path:
            return
        
        for i, line in enumerate(lines, 1):
            if line.strip().startswith('//'):
                continue
            
            # Check for inline TextStyle without using AppTypography
            if 'TextStyle(' in line and 'AppTypography' not in line and 'style:' in line:
                # Skip if it's modifying an existing style with copyWith
                if '.copyWith' not in line:
                    self.issues.append(UXIssue(
                        file_path, i, 'info', 'hardcoded-textstyle',
                        f"Consider using AppTypography constants: {line.strip()}"
                    ))

    def check_missing_semantics(self, file_path: str, content: str, lines: List[str]):
        """Check for interactive widgets without semantic labels."""
        interactive_widgets = [
            'IconButton', 'TextButton', 'ElevatedButton', 'OutlinedButton',
            'FloatingActionButton', 'GestureDetector', 'InkWell'
        ]
        
        for i, line in enumerate(lines, 1):
            if line.strip().startswith('//'):
                continue
            
            for widget in interactive_widgets:
                if widget in line:
                    # Check if there's a Semantics wrapper nearby or tooltip
                    context_start = max(0, i - 3)
                    context_end = min(len(lines), i + 10)
                    context = '\n'.join(lines[context_start:context_end])
                    
                    has_semantics = 'Semantics(' in context or 'semanticsLabel:' in context
                    has_tooltip = 'tooltip:' in context or 'Tooltip(' in context
                    
                    if not has_semantics and not has_tooltip and widget in ['IconButton', 'GestureDetector', 'InkWell']:
                        self.issues.append(UXIssue(
                            file_path, i, 'warning', 'missing-semantics',
                            f"{widget} should have a semanticsLabel or tooltip for accessibility"
                        ))

    def check_insufficient_touch_targets(self, file_path: str, content: str, lines: List[str]):
        """Check for touch targets smaller than 44x44."""
        size_pattern = r'(?:width|height):\s*(\d+\.?\d*)'
        
        for i, line in enumerate(lines, 1):
            if 'IconButton' in line or 'GestureDetector' in line or 'InkWell' in line:
                # Check the next few lines for size constraints
                context_start = i - 1
                context_end = min(len(lines), i + 10)
                context = '\n'.join(lines[context_start:context_end])
                
                sizes = re.findall(size_pattern, context)
                for size in sizes:
                    if float(size) < 44 and float(size) > 0:
                        self.issues.append(UXIssue(
                            file_path, i, 'warning', 'small-touch-target',
                            f"Touch target may be too small ({size}px). Minimum recommended: 44x44"
                        ))

    def check_missing_keys(self, file_path: str, content: str, lines: List[str]):
        """Check for list items without keys."""
        for i, line in enumerate(lines, 1):
            if '.map(' in line or 'ListView.builder' in line or 'GridView.builder' in line:
                # Check next few lines for key property
                context_start = i - 1
                context_end = min(len(lines), i + 15)
                context = '\n'.join(lines[context_start:context_end])
                
                if 'key:' not in context and 'Key(' not in context:
                    self.issues.append(UXIssue(
                        file_path, i, 'info', 'missing-key',
                        "Consider adding keys to list items for better performance"
                    ))

    def check_text_contrast(self, file_path: str, content: str, lines: List[str]):
        """Check for potential text contrast issues."""
        # This is a simple check - real contrast checking would need color analysis
        for i, line in enumerate(lines, 1):
            if 'Text(' in line:
                if 'color:' in line and 'white' in line.lower() and 'background' not in line.lower():
                    self.issues.append(UXIssue(
                        file_path, i, 'info', 'contrast-check',
                        "Verify text contrast meets WCAG AA standards (4.5:1 for normal text)"
                    ))

    def check_loading_states(self, file_path: str, content: str, lines: List[str]):
        """Check for async operations without loading states."""
        if 'screens/' not in file_path:
            return
        
        has_async = False
        has_loading = False
        
        for line in lines:
            if 'async' in line or 'Future' in line or '.then(' in line:
                has_async = True
            if 'CircularProgressIndicator' in line or 'LinearProgressIndicator' in line or 'isLoading' in line:
                has_loading = True
        
        if has_async and not has_loading:
            self.issues.append(UXIssue(
                file_path, 1, 'warning', 'missing-loading-state',
                "Screen has async operations but no visible loading indicators"
            ))

    def check_error_handling(self, file_path: str, content: str, lines: List[str]):
        """Check for async operations without error handling."""
        if 'screens/' not in file_path and 'widgets/' not in file_path:
            return
        
        has_async = False
        has_error_handling = False
        
        for line in lines:
            if 'async' in line or 'Future' in line:
                has_async = True
            if 'try' in line or 'catch' in line or 'onError' in line or 'SnackBar' in line:
                has_error_handling = True
        
        if has_async and not has_error_handling:
            self.issues.append(UXIssue(
                file_path, 1, 'warning', 'missing-error-handling',
                "Async operations should have error handling and user feedback"
            ))

    def check_hardcoded_strings(self, file_path: str, content: str, lines: List[str]):
        """Check for hardcoded user-facing strings."""
        if 'test' in file_path or 'constants/' in file_path:
            return
        
        for i, line in enumerate(lines, 1):
            if line.strip().startswith('//'):
                continue
            
            # Look for Text widgets with hardcoded strings
            text_match = re.search(r'Text\s*\(\s*["\'](.+?)["\']\s*[,\)]', line)
            if text_match:
                string_content = text_match.group(1)
                # Skip very short strings, technical strings, or empty strings
                if len(string_content) > 3 and not string_content.replace(' ', '').isdigit():
                    self.issues.append(UXIssue(
                        file_path, i, 'info', 'hardcoded-string',
                        f"Consider extracting string to constants for localization: '{string_content}'"
                    ))

    def check_accessibility_labels(self, file_path: str, content: str, lines: List[str]):
        """Check for images without semantic labels."""
        for i, line in enumerate(lines, 1):
            if 'Image.' in line or 'Image(' in line:
                context_start = max(0, i - 3)
                context_end = min(len(lines), i + 10)
                context = '\n'.join(lines[context_start:context_end])
                
                if 'semanticLabel:' not in context and 'Semantics(' not in context:
                    self.issues.append(UXIssue(
                        file_path, i, 'warning', 'missing-image-label',
                        "Images should have semantic labels for screen readers"
                    ))

    def check_gesture_exclusions(self, file_path: str, content: str, lines: List[str]):
        """Check for overlapping gesture detectors."""
        gesture_count = content.count('GestureDetector(') + content.count('InkWell(')
        
        if gesture_count > 3:
            self.issues.append(UXIssue(
                file_path, 1, 'info', 'multiple-gestures',
                f"File has {gesture_count} gesture detectors. Verify they don't conflict."
            ))

    def apply_auto_fixes(self, file_path: str):
        """Apply automatic fixes to a file where possible."""
        if not self.auto_fix:
            return
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                lines = content.split('\n')
            
            modified = False
            
            # Auto-fix: Add import for constants if using them
            if 'AppColors' in content and "import 'package:odyseya/constants/colors.dart'" not in content:
                lines.insert(0, "import 'package:odyseya/constants/colors.dart';")
                modified = True
                self.fixes_applied += 1
            
            if 'AppSpacing' in content and "import 'package:odyseya/constants/spacing.dart'" not in content:
                lines.insert(0, "import 'package:odyseya/constants/spacing.dart';")
                modified = True
                self.fixes_applied += 1
            
            if 'AppTypography' in content and "import 'package:odyseya/constants/typography.dart'" not in content:
                lines.insert(0, "import 'package:odyseya/constants/typography.dart';")
                modified = True
                self.fixes_applied += 1
            
            if modified:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write('\n'.join(lines))
                print(f"✅ Auto-fixed imports in {file_path}")
        
        except Exception as e:
            print(f"❌ Error applying auto-fixes to {file_path}: {e}")

    def scan_directory(self, directory: str) -> Dict[str, List[UXIssue]]:
        """Scan all Dart files in a directory."""
        all_issues = {}
        
        for root, dirs, files in os.walk(directory):
            # Skip test directories
            if 'test' in root or '.dart_tool' in root:
                continue
            
            for file in files:
                if file.endswith('.dart'):
                    file_path = os.path.join(root, file)
                    issues = self.check_file(file_path)
                    
                    if self.auto_fix:
                        self.apply_auto_fixes(file_path)
                    
                    if issues:
                        all_issues[file_path] = issues
        
        return all_issues

    def print_report(self, all_issues: Dict[str, List[UXIssue]]):
        """Print a formatted report of all issues."""
        print("\n" + "="*80)
        print("UX COMPLIANCE REPORT - Odyseya")
        print("="*80 + "\n")
        
        if not all_issues:
            print("✨ No UX compliance issues found! Great job! ✨\n")
            return
        
        # Group by severity
        errors = []
        warnings = []
        info = []
        
        for file_issues in all_issues.values():
            for issue in file_issues:
                if issue.severity == 'error':
                    errors.append(issue)
                elif issue.severity == 'warning':
                    warnings.append(issue)
                else:
                    info.append(issue)
        
        total = len(errors) + len(warnings) + len(info)
        
        print(f"📊 Total Issues: {total}")
        print(f"   ❌ Errors: {len(errors)}")
        print(f"   ⚠️  Warnings: {len(warnings)}")
        print(f"   ℹ️  Info: {len(info)}\n")
        
        if self.auto_fix:
            print(f"✅ Auto-fixes applied: {self.fixes_applied}\n")
        
        # Print issues by file
        for file_path, issues in sorted(all_issues.items()):
            rel_path = os.path.relpath(file_path)
            print(f"\n📄 {rel_path}")
            print("-" * 80)
            
            for issue in issues:
                print(f"  {issue}")
        
        print("\n" + "="*80)
        print("💡 TIP: Run with --auto-fix to automatically fix some issues")
        print("="*80 + "\n")


class FileChangeHandler(FileSystemEventHandler):
    """Handle file system events for watch mode."""
    
    def __init__(self, checker: UXComplianceChecker, debounce_seconds: float = 1.0):
        self.checker = checker
        self.debounce_seconds = debounce_seconds
        self.pending_checks: Set[str] = set()
        self.last_check_time = {}
    
    def on_modified(self, event):
        if event.is_directory or not event.src_path.endswith('.dart'):
            return
        
        # Debounce: only check if enough time has passed
        current_time = time.time()
        last_check = self.last_check_time.get(event.src_path, 0)
        
        if current_time - last_check > self.debounce_seconds:
            self.check_file(event.src_path)
            self.last_check_time[event.src_path] = current_time
    
    def check_file(self, file_path: str):
        print(f"\n🔍 Checking {os.path.relpath(file_path)}...")
        issues = self.checker.check_file(file_path)
        
        if self.checker.auto_fix:
            self.checker.apply_auto_fixes(file_path)
        
        if issues:
            print(f"Found {len(issues)} issue(s):")
            for issue in issues:
                print(f"  {issue}")
        else:
            print("✅ No issues found")


def main():
    parser = argparse.ArgumentParser(
        description='UX Compliance Checker for Odyseya Flutter App',
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument(
        'directory',
        nargs='?',
        default='./lib',
        help='Directory to check (default: ./lib)'
    )
    parser.add_argument(
        '--watch',
        action='store_true',
        help='Watch for file changes and check continuously'
    )
    parser.add_argument(
        '--auto-fix',
        action='store_true',
        help='Automatically fix issues where possible'
    )
    
    args = parser.parse_args()
    
    # Resolve directory path
    directory = os.path.abspath(args.directory)
    
    if not os.path.exists(directory):
        print(f"❌ Error: Directory '{directory}' does not exist")
        sys.exit(1)
    
    print("🚀 Starting UX Compliance Checker for Odyseya...")
    print(f"📁 Directory: {directory}")
    print(f"🔧 Auto-fix: {'enabled' if args.auto_fix else 'disabled'}")
    print(f"👁️  Watch mode: {'enabled' if args.watch else 'disabled'}\n")
    
    checker = UXComplianceChecker(auto_fix=args.auto_fix)
    
    if args.watch:
        # Initial scan
        print("Running initial scan...")
        all_issues = checker.scan_directory(directory)
        checker.print_report(all_issues)
        
        # Set up file watcher
        print(f"\n👀 Watching for changes in {directory}...")
        print("Press Ctrl+C to stop\n")
        
        event_handler = FileChangeHandler(checker)
        observer = Observer()
        observer.schedule(event_handler, directory, recursive=True)
        observer.start()
        
        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            print("\n\n👋 Stopping UX compliance checker...")
            observer.stop()
        
        observer.join()
    else:
        # One-time scan
        all_issues = checker.scan_directory(directory)
        checker.print_report(all_issues)
        
        # Exit with error code if there are issues
        sys.exit(1 if all_issues else 0)


if __name__ == '__main__':
    main()
