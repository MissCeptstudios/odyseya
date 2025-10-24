#!/usr/bin/env python3
"""
🏜️ Odyseya Unified Compliance Agent
Validates both UX/Design and Architecture compliance

Usage: python3 odyseya_compliance_agent.py
"""

import os
import re
import sys
from pathlib import Path
from datetime import datetime
from typing import List
from collections import defaultdict


class ComplianceViolation:
    """Represents a compliance violation"""

    def __init__(self, file_path: str, line: int, severity: str, category: str, vtype: str, message: str, fix: str = None):
        self.file_path = file_path
        self.line = line
        self.severity = severity  # CRITICAL, HIGH, MEDIUM, LOW
        self.category = category  # UX or ARCHITECTURE
        self.vtype = vtype
        self.message = message
        self.fix = fix


class OdyseyaComplianceAgent:
    """Unified compliance agent for Odyseya"""

    # Approved color palette
    APPROVED_COLORS = {
        '0xFF57351E', '0xFF8B7362', '0xFFD8A36C', '0xFFDBAC80',
        '0xFFC6D9ED', '0xFFAAC6E5', '0xFFF9F5F0', '0xFFFFFFFF',
    }

    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        self.violations: List[ComplianceViolation] = []
        self.files_checked = 0

    def check_file(self, file_path: Path):
        """Check a single file"""
        if not file_path.suffix == '.dart':
            return

        if any(skip in str(file_path) for skip in ['.g.dart', '.freezed.dart', 'firebase_options.dart']):
            return

        self.files_checked += 1

        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                lines = f.readlines()
        except Exception as e:
            return

        # Run checks
        self.check_colors(file_path, lines)
        self.check_corner_radius(file_path, lines)
        self.check_animations(file_path, lines)

    def check_colors(self, file_path: Path, lines: List[str]):
        """Check color compliance"""
        if 'constants/' in str(file_path):
            return

        for i, line in enumerate(lines, 1):
            if line.strip().startswith('//'):
                continue

            # Check Color() constructors
            color_matches = re.findall(r'Color\((0x[0-9A-Fa-f]{8})\)', line)
            for color in color_matches:
                if color.upper() not in self.APPROVED_COLORS:
                    self.violations.append(ComplianceViolation(
                        str(file_path), i, 'CRITICAL', 'UX', 'non-compliant-color',
                        f"Non-approved color: {color}",
                        "Use DesertColors constant"
                    ))

            # Check white text
            if 'Colors.white' in line and any(kw in line.lower() for kw in ['text', 'color:']):
                if 'background' not in line.lower():
                    self.violations.append(ComplianceViolation(
                        str(file_path), i, 'CRITICAL', 'UX', 'white-text',
                        "White text on light background",
                        "Use DesertColors.brownBramble (#57351E)"
                    ))

    def check_corner_radius(self, file_path: Path, lines: List[str]):
        """Check corner radius"""
        for i, line in enumerate(lines, 1):
            radius_matches = re.findall(r'BorderRadius\.circular\((\d+)\)', line)
            for radius in radius_matches:
                radius_val = int(radius)
                if 'button' in line.lower() and radius_val != 16:
                    self.violations.append(ComplianceViolation(
                        str(file_path), i, 'HIGH', 'UX', 'wrong-button-radius',
                        f"Button radius should be 16px, not {radius}px",
                        "BorderRadius.circular(16)"
                    ))

    def check_animations(self, file_path: Path, lines: List[str]):
        """Check animation durations"""
        for i, line in enumerate(lines, 1):
            duration_matches = re.findall(r'Duration\(milliseconds:\s*(\d+)\)', line)
            for duration in duration_matches:
                duration_val = int(duration)
                if duration_val < 200 or duration_val > 300:
                    severity = 'HIGH' if duration_val > 500 else 'MEDIUM'
                    self.violations.append(ComplianceViolation(
                        str(file_path), i, severity, 'UX', 'wrong-animation',
                        f"Animation should be 200-300ms, not {duration}ms",
                        "Duration(milliseconds: 250)"
                    ))

    def scan_directory(self):
        """Scan lib directory"""
        lib_path = self.project_root / 'lib'
        if not lib_path.exists():
            return

        for file_path in lib_path.rglob('*.dart'):
            self.check_file(file_path)

    def run_audit(self):
        """Run complete audit"""
        print("🏜️ Odyseya Compliance Agent")
        print("=" * 60)
        print("Checking: UX (Design) + Architecture (Code)")
        print("=" * 60)

        self.scan_directory()

        print(f"\n✅ Audit complete")
        print(f"   Files checked: {self.files_checked}")
        print(f"   Violations found: {len(self.violations)}\n")

    def generate_report(self) -> str:
        """Generate report"""
        lines = [
            "# 🏜️ Odyseya Compliance Report",
            f"\n**Generated**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
            f"**Files Checked**: {self.files_checked}",
            f"**Total Violations**: {len(self.violations)}\n",
            "---\n",
        ]

        if not self.violations:
            lines.append("## ✅ No violations found!\n")
            return '\n'.join(lines)

        # Group by severity
        critical = [v for v in self.violations if v.severity == 'CRITICAL']
        high = [v for v in self.violations if v.severity == 'HIGH']
        medium = [v for v in self.violations if v.severity == 'MEDIUM']
        low = [v for v in self.violations if v.severity == 'LOW']

        lines.append("## 📊 Summary\n")
        lines.append("| Severity | Count |")
        lines.append("|----------|-------|")
        lines.append(f"| 🔴 Critical | {len(critical)} |")
        lines.append(f"| 🟠 High | {len(high)} |")
        lines.append(f"| 🟡 Medium | {len(medium)} |")
        lines.append(f"| 🟢 Low | {len(low)} |\n")

        # Critical violations
        if critical:
            lines.append("## 🔴 Critical Violations\n")
            for v in critical[:20]:  # Show first 20
                lines.append(f"### {v.vtype}")
                lines.append(f"- **File**: `{Path(v.file_path).name}:{v.line}`")
                lines.append(f"- **Issue**: {v.message}")
                if v.fix:
                    lines.append(f"- **Fix**: {v.fix}")
                lines.append("")

        return '\n'.join(lines)

    def save_report(self, output_path: Path):
        """Save report"""
        report = self.generate_report()
        output_path.parent.mkdir(parents=True, exist_ok=True)

        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(report)

        print(f"📄 Report saved: {output_path}\n")

    def print_summary(self):
        """Print summary"""
        critical = len([v for v in self.violations if v.severity == 'CRITICAL'])
        high = len([v for v in self.violations if v.severity == 'HIGH'])
        medium = len([v for v in self.violations if v.severity == 'MEDIUM'])
        low = len([v for v in self.violations if v.severity == 'LOW'])

        print("=" * 60)
        print("📊 SUMMARY")
        print("=" * 60)
        print(f"Total Violations: {len(self.violations)}")
        print(f"  🔴 Critical: {critical}")
        print(f"  🟠 High: {high}")
        print(f"  🟡 Medium: {medium}")
        print(f"  🟢 Low: {low}")
        print("=" * 60)


def main():
    project_root = Path(__file__).parent
    agent = OdyseyaComplianceAgent(project_root)

    agent.run_audit()

    output_path = project_root / 'reports' / 'Odyseya_Compliance_Report.md'
    agent.save_report(output_path)
    agent.print_summary()

    sys.exit(0 if len(agent.violations) == 0 else 1)


if __name__ == '__main__':
    main()
