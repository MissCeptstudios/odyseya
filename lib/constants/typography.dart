import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Odyseya Typography System v2.0 - Optimized for Readability & Accessibility
///
/// This configuration follows WCAG 2.1 AA standards and iOS Human Interface Guidelines
/// for optimal readability, especially for long-form journal content.
///
/// Font Families:
/// - Primary: Inter (via Google Fonts) - Modern sans-serif for UI and body text
/// - Accent: Cormorant Garamond - Elegant serif for affirmations and quotes
/// - Display: Josefin Sans - Clean sans-serif for splash screens
///
/// Key Accessibility Features:
/// - Minimum 16pt/sp for body text (17pt on iOS forms to prevent auto-zoom)
/// - Line height 1.5-1.6x for optimal reading comfort
/// - WCAG AA compliant contrast ratios (minimum 4.5:1)
/// - Touch target sizes meet iOS HIG (minimum 44pt)
///
/// References:
/// - WCAG 2.1: https://www.w3.org/WAI/WCAG21/quickref/
/// - iOS HIG: https://developer.apple.com/design/human-interface-guidelines/typography
/// - Material Design: https://material.io/design/typography

class AppTextStyles {
  // ============================================================================
  // JOURNAL BODY TEXT - Optimized for Long-Form Reading
  // ============================================================================

  /// Primary journal body text - Optimized for extended reading sessions
  ///
  /// Spec: 17pt, Regular (400), Line Height 1.6
  /// Usage: Journal entries, long-form content, transcriptions
  /// Rationale:
  /// - 17pt prevents iOS auto-zoom on form fields
  /// - 1.6 line height reduces eye strain for long reading sessions
  /// - Regular weight maintains readability without fatigue
  static TextStyle get journalBodyText => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 17.0,
        height: 1.6, // Critical: Optimal line spacing for readability
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  /// Journal body text (Large variant) - For enhanced readability
  ///
  /// Spec: 18pt, Regular (400), Line Height 1.6
  /// Usage: Main journal display when more spacing is needed
  static TextStyle get journalBodyTextLarge => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 18.0,
        height: 1.6,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  /// Journal body text (Emphasized) - For highlighted content
  ///
  /// Spec: 17pt, Medium (500), Line Height 1.6
  /// Usage: Emphasized passages within journal entries
  static TextStyle get journalBodyTextEmphasis => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 17.0,
        height: 1.6,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  // ============================================================================
  // FORM INPUT TEXT - iOS Optimized
  // ============================================================================

  /// Input field text - Prevents iOS auto-zoom
  ///
  /// Spec: 17pt, Regular (400), Line Height 1.4
  /// Usage: Text input fields, form fields
  /// Critical: 17pt minimum on iOS prevents automatic zoom on focus
  static TextStyle get inputText => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 17.0,
        height: 1.4,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  /// Input placeholder text
  ///
  /// Spec: 17pt, Light (300), Line Height 1.4
  /// Usage: Placeholder text in input fields
  static TextStyle get inputPlaceholder => GoogleFonts.inter(
        fontWeight: FontWeight.w300,
        fontSize: 17.0,
        height: 1.4,
        color: DesertColors.treeBranch,
        letterSpacing: 0.0,
      );

  // ============================================================================
  // HEADINGS - Clear Hierarchy
  // ============================================================================

  /// H1 Display - Largest heading for key screens
  ///
  /// Spec: 40pt, Semibold (600), Line Height 1.2
  /// Usage: Welcome screens, major section intros
  static TextStyle get h1Display => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 40.0,
        height: 1.2,
        color: DesertColors.brownBramble,
        letterSpacing: -0.5,
      );

  /// H1 Large - Main page titles
  ///
  /// Spec: 32pt, Semibold (600), Line Height 1.3
  /// Usage: "What's on your mind?"
  static TextStyle get h1Large => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 32.0,
        height: 1.3,
        color: DesertColors.brownBramble,
        letterSpacing: -0.3,
      );

  /// H1 - Section headers
  ///
  /// Spec: 24pt, Semibold (600), Line Height 1.3
  /// Usage: "Hey Mike!", "Today's affirmation"
  static TextStyle get h1 => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 24.0,
        height: 1.3,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  /// H2 Large - Major subsections
  ///
  /// Spec: 22pt, Semibold (600), Line Height 1.3
  /// Usage: Large subsection headers
  static TextStyle get h2Large => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 22.0,
        height: 1.3,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  /// H2 - Subsection headers
  ///
  /// Spec: 20pt, Semibold (600), Line Height 1.3
  /// Usage: Card titles, section labels
  static TextStyle get h2 => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 20.0,
        height: 1.3,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  /// H2 Medium - Subsection with medium weight
  ///
  /// Spec: 20pt, Medium (500), Line Height 1.3
  /// Usage: Softer subsection headers
  static TextStyle get h2Medium => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 20.0,
        height: 1.3,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  /// H3 - Small headers
  ///
  /// Spec: 18pt, Semibold (600), Line Height 1.4
  /// Usage: Card titles, list headers
  static TextStyle get h3 => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
        height: 1.4,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  /// H4 - Smallest headers
  ///
  /// Spec: 16pt, Semibold (600), Line Height 1.4
  /// Usage: Small section headers
  static TextStyle get h4 => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
        height: 1.4,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  // ============================================================================
  // BODY TEXT - Standard Content
  // ============================================================================

  /// Body Large - Emphasized body content
  ///
  /// Spec: 18pt, Regular (400), Line Height 1.5
  /// Usage: Important body text, introductions
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 18.0,
        height: 1.5,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  /// Body - Standard body text
  ///
  /// Spec: 16pt, Regular (400), Line Height 1.5
  /// Usage: General UI text, descriptions
  static TextStyle get body => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 16.0,
        height: 1.5,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  /// Body Medium - Emphasized standard text
  ///
  /// Spec: 16pt, Medium (500), Line Height 1.5
  /// Usage: Emphasized body text
  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        height: 1.5,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  /// Body Small - Compact body text
  ///
  /// Spec: 14pt, Regular (400), Line Height 1.5
  /// Usage: Smaller body text, list items
  static TextStyle get bodySmall => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
        height: 1.5,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  // ============================================================================
  // SECONDARY TEXT - Muted/Descriptive Content
  // ============================================================================

  /// Secondary Large - Supporting information
  ///
  /// Spec: 16pt, Regular (400), Line Height 1.5
  /// Usage: Descriptive text under main elements
  static TextStyle get secondaryLarge => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 16.0,
        height: 1.5,
        color: DesertColors.treeBranch,
        letterSpacing: 0.0,
      );

  /// Secondary - Standard supporting text
  ///
  /// Spec: 14pt, Regular (400), Line Height 1.4
  /// Usage: Secondary information, subtitles
  static TextStyle get secondary => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 14.0,
        height: 1.4,
        color: DesertColors.treeBranch,
        letterSpacing: 0.0,
      );

  /// Secondary Small - Compact supporting text
  ///
  /// Spec: 12pt, Regular (400), Line Height 1.4
  /// Usage: Tiny descriptive text, metadata
  static TextStyle get secondarySmall => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 12.0,
        height: 1.4,
        color: DesertColors.treeBranch,
        letterSpacing: 0.0,
      );

  // ============================================================================
  // BUTTONS - WCAG Compliant (Minimum 16pt)
  // ============================================================================

  /// CTA Button Text - Primary call-to-action
  ///
  /// Spec: 16pt, Semibold (600), Line Height 1.0, UPPERCASE
  /// Usage: Primary action buttons
  /// Critical: Minimum 16pt for accessibility (WCAG AA)
  /// Note: Text should be converted to uppercase using .toUpperCase() on the string
  static TextStyle get ctaButtonText => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
        height: 1.0,
        color: Colors.white,
        letterSpacing: 1.2,
      );

  /// Button Large - Larger CTA buttons
  ///
  /// Spec: 18pt, Semibold (600), Line Height 1.2, UPPERCASE
  /// Usage: Large primary buttons
  /// Note: Text should be converted to uppercase using .toUpperCase() on the string
  static TextStyle get buttonLarge => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
        height: 1.2,
        color: Colors.white,
        letterSpacing: 1.5,
      );

  /// Button - Standard buttons
  ///
  /// Spec: 16pt, Semibold (600), Line Height 1.2, UPPERCASE
  /// Usage: Standard action buttons
  /// Note: Text should be converted to uppercase using .toUpperCase() on the string
  static TextStyle get button => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
        height: 1.2,
        color: Colors.white,
        letterSpacing: 1.2,
      );

  /// Button Small - Tertiary buttons
  ///
  /// Spec: 14pt, Medium (500), Line Height 1.2
  /// Usage: Small action buttons, text buttons
  static TextStyle get buttonSmall => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
        height: 1.2,
        color: DesertColors.brownBramble,
        letterSpacing: 0.3,
      );

  // ============================================================================
  // UI ELEMENTS - Labels & Interface Text
  // ============================================================================

  /// UI Large - Major UI sections
  ///
  /// Spec: 16pt, Medium (500), Line Height 1.3
  /// Usage: Top bar, major UI sections
  static TextStyle get uiLarge => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        height: 1.3,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  /// UI - Standard labels
  ///
  /// Spec: 14pt, Medium (500), Line Height 1.3
  /// Usage: Form labels, section labels
  static TextStyle get ui => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
        height: 1.3,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  /// UI Small - Compact labels
  ///
  /// Spec: 12pt, Medium (500), Line Height 1.3
  /// Usage: Small labels, tags
  static TextStyle get uiSmall => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 12.0,
        height: 1.3,
        color: DesertColors.brownBramble,
        letterSpacing: 0.2,
      );

  // ============================================================================
  // NAVIGATION - Tab Bar & Bottom Nav
  // ============================================================================

  /// Navigation Active - Selected state
  ///
  /// Spec: 12pt, Semibold (600), Line Height 1.2
  /// Usage: Active navigation item
  static TextStyle get navActive => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 12.0,
        height: 1.2,
        color: DesertColors.caramelDrizzle,
        letterSpacing: 0.2,
      );

  /// Navigation Inactive - Unselected state
  ///
  /// Spec: 12pt, Regular (400), Line Height 1.2
  /// Usage: Inactive navigation items
  static TextStyle get navInactive => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 12.0,
        height: 1.2,
        color: DesertColors.treeBranch,
        letterSpacing: 0.2,
      );

  // ============================================================================
  // CAPTIONS & HINTS - Minimal Text
  // ============================================================================

  /// Caption - Standard minimal text
  ///
  /// Spec: 14pt, Light (300), Line Height 1.4
  /// Usage: Hint text, placeholders
  static TextStyle get caption => GoogleFonts.inter(
        fontWeight: FontWeight.w300,
        fontSize: 14.0,
        height: 1.4,
        color: DesertColors.treeBranch,
        letterSpacing: 0.0,
      );

  /// Caption Small - Timestamps & metadata
  ///
  /// Spec: 12pt, Light (300), Line Height 1.3
  /// Usage: Timestamps, meta information
  /// Note: 12pt is minimum for accessibility (WCAG AA with 4.5:1 contrast)
  static TextStyle get captionSmall => GoogleFonts.inter(
        fontWeight: FontWeight.w300,
        fontSize: 12.0,
        height: 1.3,
        color: DesertColors.treeBranch,
        letterSpacing: 0.2,
      );

  /// Hint - Form field hints
  ///
  /// Spec: 13pt, Light (300), Line Height 1.4
  /// Usage: Input field hints, labels inside cards
  static TextStyle get hint => GoogleFonts.inter(
        fontWeight: FontWeight.w300,
        fontSize: 13.0,
        height: 1.4,
        color: DesertColors.treeBranch,
        letterSpacing: 0.0,
      );

  // ============================================================================
  // ACCENT STYLES - Emphasis & Special Content
  // ============================================================================

  /// Accent Body - Emphasized with accent color
  ///
  /// Spec: 16pt, Medium (500), Line Height 1.5
  /// Usage: Highlighted body text, calls to attention
  static TextStyle get accentBody => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        height: 1.5,
        color: DesertColors.caramelDrizzle,
        letterSpacing: 0.0,
      );

  /// Accent Small - Small emphasized text
  ///
  /// Spec: 14pt, Medium (500), Line Height 1.4
  /// Usage: Small accent text, badges
  static TextStyle get accentSmall => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
        height: 1.4,
        color: DesertColors.caramelDrizzle,
        letterSpacing: 0.0,
      );

  // ============================================================================
  // DISPLAY & AFFIRMATIONS - Special Serif Fonts
  // ============================================================================

  /// Affirmation Display - Large elegant serif
  ///
  /// Spec: 38pt, Light (300), Line Height 1.3
  /// Font: Cormorant Garamond
  /// Usage: Daily affirmations, inspirational quotes
  static TextStyle get affirmationDisplay => GoogleFonts.cormorantGaramond(
        fontWeight: FontWeight.w300,
        fontSize: 38.0,
        height: 1.3,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  /// Affirmation Display Large - Extra large affirmations
  ///
  /// Spec: 40pt, Light (300), Line Height 1.3
  /// Font: Cormorant Garamond
  /// Usage: Main affirmation screens
  static TextStyle get affirmationDisplayLarge => GoogleFonts.cormorantGaramond(
        fontWeight: FontWeight.w300,
        fontSize: 40.0,
        height: 1.3,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  /// Quote Text - Medium elegant serif
  ///
  /// Spec: 24pt, Regular (400), Line Height 1.4
  /// Font: Cormorant Garamond
  /// Usage: Featured quotes
  static TextStyle get quoteText => GoogleFonts.cormorantGaramond(
        fontWeight: FontWeight.w400,
        fontSize: 24.0,
        height: 1.4,
        color: DesertColors.brownBramble,
        letterSpacing: 0.0,
      );

  /// Splash Quote - Splash screen text
  ///
  /// Spec: 28pt, Regular (400), Line Height 1.4
  /// Font: Josefin Sans
  /// Usage: Splash screen quotes
  static TextStyle get splashQuote => GoogleFonts.josefinSans(
        fontWeight: FontWeight.w400,
        fontSize: 28.0,
        height: 1.4,
        color: DesertColors.brownBramble,
        letterSpacing: 0.5,
      );

  /// Splash Quote Emphasis - Emphasized splash text
  ///
  /// Spec: 28pt, Semibold (600), Line Height 1.4
  /// Font: Josefin Sans
  /// Usage: Emphasized splash screen text
  static TextStyle get splashQuoteEmphasis => GoogleFonts.josefinSans(
        fontWeight: FontWeight.w600,
        fontSize: 28.0,
        height: 1.4,
        color: DesertColors.brownBramble,
        letterSpacing: 0.5,
      );

  // ============================================================================
  // HELPER METHODS - Color Variants
  // ============================================================================

  /// Apply primary brown color to any TextStyle
  static TextStyle withPrimaryColor(TextStyle style) {
    return style.copyWith(color: DesertColors.brownBramble);
  }

  /// Apply muted brown (secondary) color to any TextStyle
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

  /// Apply custom line height to any TextStyle
  static TextStyle withLineHeight(TextStyle style, double height) {
    return style.copyWith(height: height);
  }

  /// Apply custom letter spacing to any TextStyle
  static TextStyle withLetterSpacing(TextStyle style, double spacing) {
    return style.copyWith(letterSpacing: spacing);
  }
}

// ============================================================================
// BACKWARDS COMPATIBILITY - Legacy OdyseyaTypography Class
// ============================================================================

/// Legacy typography class for backwards compatibility
/// @deprecated Use AppTextStyles instead
class OdyseyaTypography {
  // Font family
  static const String inter = 'Inter';

  // Headings
  static TextStyle get h1Large => AppTextStyles.h1Large;
  static TextStyle get h1 => AppTextStyles.h1;
  static TextStyle get h2Large => AppTextStyles.h2Large;
  static TextStyle get h2 => AppTextStyles.h2;
  static TextStyle get h3 => AppTextStyles.h3;

  // Body text
  static TextStyle get bodyLarge => AppTextStyles.bodyLarge;
  static TextStyle get body => AppTextStyles.body;
  static TextStyle get bodyMedium => AppTextStyles.bodyMedium;
  static TextStyle get bodySmall => AppTextStyles.bodySmall;

  // Secondary text
  static TextStyle get secondaryLarge => AppTextStyles.secondaryLarge;
  static TextStyle get secondary => AppTextStyles.secondary;
  static TextStyle get secondarySmall => AppTextStyles.secondarySmall;

  // Buttons
  static TextStyle get buttonLarge => AppTextStyles.buttonLarge;
  static TextStyle get button => AppTextStyles.button;
  static TextStyle get buttonSmall => AppTextStyles.buttonSmall;

  // UI elements
  static TextStyle get uiLarge => AppTextStyles.uiLarge;
  static TextStyle get ui => AppTextStyles.ui;
  static TextStyle get uiSmall => AppTextStyles.uiSmall;

  // Navigation
  static TextStyle get navActive => AppTextStyles.navActive;
  static TextStyle get navInactive => AppTextStyles.navInactive;

  // Captions & hints
  static TextStyle get caption => AppTextStyles.caption;
  static TextStyle get captionSmall => AppTextStyles.captionSmall;
  static TextStyle get hint => AppTextStyles.hint;

  // Accent styles
  static TextStyle get accentBody => AppTextStyles.accentBody;
  static TextStyle get accentSmall => AppTextStyles.accentSmall;

  // Helper methods
  static TextStyle withPrimaryColor(TextStyle style) =>
      AppTextStyles.withPrimaryColor(style);
  static TextStyle withSecondaryColor(TextStyle style) =>
      AppTextStyles.withSecondaryColor(style);
  static TextStyle withAccentColor(TextStyle style) =>
      AppTextStyles.withAccentColor(style);
  static TextStyle withWhiteColor(TextStyle style) =>
      AppTextStyles.withWhiteColor(style);
}

// ============================================================================
// STRING EXTENSIONS - Uppercase Helper for CTA Buttons
// ============================================================================

/// Extension to easily convert strings to uppercase for CTA buttons
///
/// Usage:
/// ```dart
/// Text('Continue'.toButtonText(), style: AppTextStyles.ctaButtonText)
/// ```
extension StringButtonExtension on String {
  /// Converts string to uppercase for use with CTA button styles
  ///
  /// This ensures button text follows the design system requirement
  /// for uppercase CTA buttons
  String toButtonText() => toUpperCase();
}
