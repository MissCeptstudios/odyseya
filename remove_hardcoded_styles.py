#!/usr/bin/env python3
"""
Automated script to replace ALL hardcoded TextStyle() instances with AppTextStyles
from the global UI framework in typography.dart
"""

import re
import os
from pathlib import Path

# Base directory
BASE_DIR = Path(__file__).parent / "lib"

# Style mapping based on fontSize and fontWeight
STYLE_MAPPINGS = {
    # Display and large headings
    (40, 'w600'): 'AppTextStyles.h1Display',
    (40, 'w300'): 'AppTextStyles.h1Display',
    (38, None): 'AppTextStyles.affirmationDisplay',
    (36, None): 'AppTextStyles.affirmationDisplay',
    (32, 'w600'): 'AppTextStyles.h1Large',
    (32, 'w300'): 'AppTextStyles.h1Large',
    (28, None): 'AppTextStyles.splashQuote',

    # Headings
    (24, 'w600'): 'AppTextStyles.h1',
    (24, 'w400'): 'AppTextStyles.quoteText',
    (22, 'w600'): 'AppTextStyles.h2Large',
    (22, 'w500'): 'AppTextStyles.h2Medium',
    (20, 'w600'): 'AppTextStyles.h2',
    (20, 'w500'): 'AppTextStyles.h2Medium',
    (18, 'w600'): 'AppTextStyles.h3',
    (18, 'w400'): 'AppTextStyles.bodyLarge',
    (16, 'w600'): 'AppTextStyles.h4',

    # Body text
    (17, 'w400'): 'AppTextStyles.journalBodyText',
    (17, 'w500'): 'AppTextStyles.journalBodyTextEmphasis',
    (17, None): 'AppTextStyles.inputText',
    (16, 'w500'): 'AppTextStyles.bodyMedium',
    (16, 'w400'): 'AppTextStyles.body',
    (16, None): 'AppTextStyles.body',
    (15, None): 'AppTextStyles.body',
    (14, 'w500'): 'AppTextStyles.ui',
    (14, 'w400'): 'AppTextStyles.bodySmall',
    (14, None): 'AppTextStyles.bodySmall',

    # Small text
    (13, 'w300'): 'AppTextStyles.hint',
    (13, None): 'AppTextStyles.hint',
    (12, 'w500'): 'AppTextStyles.uiSmall',
    (12, 'w300'): 'AppTextStyles.captionSmall',
    (12, None): 'AppTextStyles.captionSmall',
    (11, 'w600'): 'AppTextStyles.uiSmall',
    (11, None): 'AppTextStyles.captionSmall',
}

def extract_font_size(textstyle_content):
    """Extract fontSize from TextStyle content"""
    match = re.search(r'fontSize:\s*(\d+(?:\.\d+)?)', textstyle_content)
    if match:
        return int(float(match.group(1)))
    return None

def extract_font_weight(textstyle_content):
    """Extract fontWeight from TextStyle content"""
    match = re.search(r'fontWeight:\s*FontWeight\.(w\d+)', textstyle_content)
    if match:
        return match.group(1)
    return None

def get_appropriate_style(font_size, font_weight):
    """Get the appropriate AppTextStyle based on size and weight"""
    # Try with specific weight
    if (font_size, font_weight) in STYLE_MAPPINGS:
        return STYLE_MAPPINGS[(font_size, font_weight)]

    # Try without weight
    if (font_size, None) in STYLE_MAPPINGS:
        return STYLE_MAPPINGS[(font_size, None)]

    # Default fallbacks
    if font_size >= 24:
        return 'AppTextStyles.h1'
    elif font_size >= 18:
        return 'AppTextStyles.bodyLarge'
    elif font_size >= 16:
        return 'AppTextStyles.body'
    else:
        return 'AppTextStyles.bodySmall'

def extract_color(textstyle_content):
    """Extract color property if present"""
    match = re.search(r'color:\s*([^,\)]+)', textstyle_content)
    if match:
        return match.group(1).strip()
    return None

def extract_additional_props(textstyle_content):
    """Extract additional properties that should be preserved"""
    props = []

    # Check for height (line height)
    if 'height:' in textstyle_content:
        match = re.search(r'height:\s*(\d+(?:\.\d+)?)', textstyle_content)
        if match:
            props.append(f'height: {match.group(1)}')

    # Check for letterSpacing
    if 'letterSpacing:' in textstyle_content:
        match = re.search(r'letterSpacing:\s*(-?\d+(?:\.\d+)?)', textstyle_content)
        if match:
            props.append(f'letterSpacing: {match.group(1)}')

    return props

def replace_textstyle(match):
    """Replace a TextStyle with appropriate AppTextStyle"""
    full_match = match.group(0)
    textstyle_content = match.group(1)

    # Skip if already using a style variable
    if 'style:' not in full_match or 'AppTextStyles' in textstyle_content:
        return full_match

    # Extract properties
    font_size = extract_font_size(textstyle_content)
    font_weight = extract_font_weight(textstyle_content)
    color = extract_color(textstyle_content)
    additional_props = extract_additional_props(textstyle_content)

    # Get appropriate style
    if font_size:
        app_style = get_appropriate_style(font_size, font_weight)
    else:
        # If no fontSize specified, default to body
        app_style = 'AppTextStyles.body'

    # Build replacement
    if color or additional_props:
        # Need .copyWith()
        copy_with_props = []
        if color:
            copy_with_props.append(f'color: {color}')
        copy_with_props.extend(additional_props)

        replacement = f'style: {app_style}.copyWith({", ".join(copy_with_props)})'
    else:
        replacement = f'style: {app_style}'

    # Extract the style: part and replace it
    return re.sub(r'style:\s*(?:const\s+)?TextStyle\([^)]*\)', replacement, full_match)

def process_file(filepath):
    """Process a single Dart file"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        # Check if already has typography import
        has_typography_import = "import '../../constants/typography.dart'" in content or \
                                "import '../constants/typography.dart'" in content or \
                                "import 'constants/typography.dart'" in content

        original_content = content

        # Replace all TextStyle instances
        # Pattern to match: style: TextStyle(...) or style: const TextStyle(...)
        pattern = r'(style:\s*(?:const\s+)?TextStyle\([^)]*\))'
        content = re.sub(pattern, replace_textstyle, content)

        # Add import if needed and changes were made
        if content != original_content and not has_typography_import:
            # Determine correct import path based on file location
            rel_path = filepath.relative_to(BASE_DIR)
            depth = len(rel_path.parts) - 1
            import_path = '../' * depth + 'constants/typography.dart'

            # Add import after other imports
            import_pattern = r"(import\s+['\"].*?['\"];)"
            imports = re.findall(import_pattern, content)
            if imports:
                last_import = imports[-1]
                content = content.replace(
                    last_import,
                    f"{last_import}\nimport '{import_path}';"
                )

        # Write back if changed
        if content != original_content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            return True, filepath

        return False, None

    except Exception as e:
        print(f"Error processing {filepath}: {e}")
        return False, None

def main():
    """Main function to process all Dart files"""
    print("🚀 Starting automated TextStyle replacement...")
    print(f"📁 Base directory: {BASE_DIR}")

    # Find all .dart files
    dart_files = list(BASE_DIR.rglob('*.dart'))

    # Exclude test files
    dart_files = [f for f in dart_files if 'test' not in str(f)]

    print(f"📄 Found {len(dart_files)} Dart files to process\n")

    modified_files = []

    for filepath in dart_files:
        was_modified, modified_path = process_file(filepath)
        if was_modified:
            rel_path = modified_path.relative_to(BASE_DIR.parent)
            print(f"✅ Modified: {rel_path}")
            modified_files.append(modified_path)

    print(f"\n🎉 Complete!")
    print(f"📝 Modified {len(modified_files)} files")
    print(f"✨ All hardcoded TextStyle instances have been replaced with AppTextStyles")

    if modified_files:
        print("\n📋 Modified files:")
        for filepath in modified_files:
            print(f"   - {filepath.relative_to(BASE_DIR.parent)}")

if __name__ == '__main__':
    main()
