import 'package:flutter/material.dart';
import 'colors.dart';

/// Odyseya Typography System
///
/// Primary Font: Inter (modern sans-serif for digital readability)
///
/// Font Weights:
/// - Bold/SemiBold (600-700): Titles like "Today's affirmation", "What's on your mind?", "Hey Mike!"
/// - Medium/Regular (400-500): Smaller labels, subtitles, body text
/// - Light (300): Optional hints, extra information, labels inside cards
///
/// Color Usage:
/// - Primary brown (#57351E): All core typography - headers, body text, settings, insights
/// - Accent caramel (#DBAC80): Active icons, dividers, selection states, emphasis words
/// - Muted brown (#8B7362): Secondary or descriptive text under main elements
/// - White (#FFFFFF): Button text and icons placed over filled shapes (blue or brown)

class OdyseyaTypography {
  // Font family
  static const String inter = 'Inter';

  // ============================================
  // HEADINGS - Inter Bold/SemiBold (600-700)
  // ============================================

  /// H1 Large - Main page titles, "What's on your mind?" (32pt, SemiBold)
  static const TextStyle h1Large = TextStyle(
    fontFamily: inter,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: DesertColors.brownBramble, // Primary brown
  );

  /// H1 - Section headers, "Hey Mike!", "Today's affirmation" (24pt, SemiBold)
  static const TextStyle h1 = TextStyle(
    fontFamily: inter,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: DesertColors.brownBramble, // Primary brown
  );

  /// H2 Large - Subsection headers (20pt, SemiBold)
  static const TextStyle h2Large = TextStyle(
    fontFamily: inter,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: DesertColors.brownBramble, // Primary brown
  );

  /// H2 - Card titles, section labels (18pt, SemiBold)
  static const TextStyle h2 = TextStyle(
    fontFamily: inter,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: DesertColors.brownBramble, // Primary brown
  );

  /// H3 - Small headers (16pt, SemiBold)
  static const TextStyle h3 = TextStyle(
    fontFamily: inter,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: DesertColors.brownBramble, // Primary brown
  );

  // ============================================
  // BODY TEXT - Inter Regular/Medium (400-500)
  // ============================================

  /// Body Large - Main content text (18pt, Regular)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: inter,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: DesertColors.brownBramble, // Primary brown
  );

  /// Body - Standard body text (16pt, Regular)
  static const TextStyle body = TextStyle(
    fontFamily: inter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: DesertColors.brownBramble, // Primary brown
  );

  /// Body Medium - Emphasized body text (16pt, Medium)
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: inter,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: DesertColors.brownBramble, // Primary brown
  );

  /// Body Small - Smaller body text (14pt, Regular)
  static const TextStyle bodySmall = TextStyle(
    fontFamily: inter,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: DesertColors.brownBramble, // Primary brown
  );

  // ============================================
  // SECONDARY TEXT - Inter Regular (400) with Muted Brown
  // ============================================

  /// Secondary Large - Descriptive text under main elements (16pt, Regular)
  static const TextStyle secondaryLarge = TextStyle(
    fontFamily: inter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: DesertColors.treeBranch, // Muted brown
  );

  /// Secondary - Smaller descriptive text (14pt, Regular)
  static const TextStyle secondary = TextStyle(
    fontFamily: inter,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: DesertColors.treeBranch, // Muted brown
  );

  /// Secondary Small - Tiny descriptive text (12pt, Regular)
  static const TextStyle secondarySmall = TextStyle(
    fontFamily: inter,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: DesertColors.treeBranch, // Muted brown
  );

  // ============================================
  // BUTTONS - Inter SemiBold/Bold (600-700)
  // ============================================

  /// Button Large - Primary CTA buttons (18pt, SemiBold)
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: inter,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 1.2,
    color: Colors.white, // White for buttons on filled backgrounds
  );

  /// Button - Standard buttons (16pt, SemiBold)
  static const TextStyle button = TextStyle(
    fontFamily: inter,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
    color: Colors.white, // White for buttons on filled backgrounds
  );

  /// Button Small - Tertiary/small buttons (14pt, Medium)
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: inter,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: DesertColors.brownBramble, // Primary brown for text buttons
  );

  // ============================================
  // UI ELEMENTS - Inter Medium (500)
  // ============================================

  /// UI Large - Top bar, major UI sections (16pt, Medium)
  static const TextStyle uiLarge = TextStyle(
    fontFamily: inter,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: DesertColors.brownBramble, // Primary brown
  );

  /// UI - Section labels, form labels (14pt, Medium)
  static const TextStyle ui = TextStyle(
    fontFamily: inter,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: DesertColors.brownBramble, // Primary brown
  );

  /// UI Small - Small labels (12pt, Medium)
  static const TextStyle uiSmall = TextStyle(
    fontFamily: inter,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: DesertColors.brownBramble, // Primary brown
  );

  // ============================================
  // NAVIGATION - Inter Medium/SemiBold (500-600)
  // ============================================

  /// Navigation Active - Selected nav item (12pt, SemiBold)
  static const TextStyle navActive = TextStyle(
    fontFamily: inter,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: DesertColors.caramelDrizzle, // Accent caramel for active state
  );

  /// Navigation Inactive - Unselected nav item (12pt, Regular)
  static const TextStyle navInactive = TextStyle(
    fontFamily: inter,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.2,
    color: DesertColors.treeBranch, // Muted brown
  );

  // ============================================
  // HINTS & CAPTIONS - Inter Light (300)
  // ============================================

  /// Caption - Hint text, placeholders, extra info (14pt, Light)
  static const TextStyle caption = TextStyle(
    fontFamily: inter,
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.4,
    color: DesertColors.treeBranch, // Muted brown
  );

  /// Caption Small - Timestamps, meta info (12pt, Light)
  static const TextStyle captionSmall = TextStyle(
    fontFamily: inter,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    height: 1.3,
    color: DesertColors.treeBranch, // Muted brown
  );

  /// Hint - Form field hints, labels inside cards (13pt, Light)
  static const TextStyle hint = TextStyle(
    fontFamily: inter,
    fontSize: 13,
    fontWeight: FontWeight.w300,
    height: 1.4,
    color: DesertColors.treeBranch, // Muted brown
  );

  // ============================================
  // ACCENT/EMPHASIS - Accent Caramel Color
  // ============================================

  /// Accent Body - Body text with accent color for emphasis (16pt, Medium)
  static const TextStyle accentBody = TextStyle(
    fontFamily: inter,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: DesertColors.caramelDrizzle, // Accent caramel
  );

  /// Accent Small - Small accent text (14pt, Medium)
  static const TextStyle accentSmall = TextStyle(
    fontFamily: inter,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: DesertColors.caramelDrizzle, // Accent caramel
  );

  // ============================================
  // HELPER METHODS - Apply colors to existing styles
  // ============================================

  /// Apply primary brown color to any TextStyle
  static TextStyle withPrimaryColor(TextStyle style) {
    return style.copyWith(color: DesertColors.brownBramble);
  }

  /// Apply muted brown color to any TextStyle
  static TextStyle withSecondaryColor(TextStyle style) {
    return style.copyWith(color: DesertColors.treeBranch);
  }

  /// Apply accent caramel color to any TextStyle
  static TextStyle withAccentColor(TextStyle style) {
    return style.copyWith(color: DesertColors.caramelDrizzle);
  }

  /// Apply white color to any TextStyle (for buttons on filled backgrounds)
  static TextStyle withWhiteColor(TextStyle style) {
    return style.copyWith(color: Colors.white);
  }
}
