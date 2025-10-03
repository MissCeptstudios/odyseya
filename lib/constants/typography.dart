import 'package:flutter/material.dart';

/// Odyseya Typography System
///
/// Font Families:
/// - Inter: UI elements, navigation, buttons
/// - Nunito Sans: Journaling content, body text
/// - Cormorant Garamond: Quotes, affirmations, welcome screens
///
/// Hierarchy:
/// H1: 22-24pt Cormorant (welcome screens, quotes)
/// H2: 18-20pt Inter Medium (sections, AI insights)
/// Body: 16pt Nunito Sans Regular (journal entries)
/// Subtext: 12-13pt Inter/Nunito Light (meta info)
/// Navigation: 11-12pt Inter (nav labels)

class OdyseyaTypography {
  // Font families
  static const String inter = 'Inter';
  static const String nunitoSans = 'Nunito Sans';
  static const String cormorantGaramond = 'Cormorant Garamond';

  // ============================================
  // H1 - Cormorant Garamond (Welcome screens, Quotes, Affirmations)
  // ============================================

  /// H1 Large - Affirmations on welcome screen (24pt)
  static const TextStyle h1Large = TextStyle(
    fontFamily: cormorantGaramond,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  /// H1 Regular - Quote headers (22pt)
  static const TextStyle h1 = TextStyle(
    fontFamily: cormorantGaramond,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  /// H1 Italic - Quote headers with emphasis (22pt italic)
  static const TextStyle h1Italic = TextStyle(
    fontFamily: cormorantGaramond,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    height: 1.3,
  );

  // ============================================
  // H2 - Inter Medium (Section headers, AI insights)
  // ============================================

  /// H2 Large - Major section headers (20pt)
  static const TextStyle h2Large = TextStyle(
    fontFamily: inter,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  /// H2 Regular - AI insights, subsection headers (18pt)
  static const TextStyle h2 = TextStyle(
    fontFamily: inter,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // ============================================
  // Body Text - Nunito Sans (Journal entries, main content)
  // ============================================

  /// Body Large - Main journal text (16pt)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: nunitoSans,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Body Regular - Secondary content (15pt)
  static const TextStyle body = TextStyle(
    fontFamily: nunitoSans,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Body Medium - Emphasized body text (16pt medium)
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: nunitoSans,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  // ============================================
  // Buttons - Inter (CTA buttons, action buttons)
  // ============================================

  /// Button Large - Primary CTA buttons (16pt bold)
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: inter,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// Button Regular - Secondary buttons (16pt regular)
  static const TextStyle button = TextStyle(
    fontFamily: inter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  /// Button Small - Tertiary buttons (14pt medium)
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: inter,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  // ============================================
  // UI Elements - Inter (Sections, labels, top bar)
  // ============================================

  /// UI Large - Top bar, major sections (16pt medium)
  static const TextStyle uiLarge = TextStyle(
    fontFamily: inter,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  /// UI Regular - Section labels (14pt medium)
  static const TextStyle ui = TextStyle(
    fontFamily: inter,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  // ============================================
  // Navigation - Inter (Bottom nav, tabs)
  // ============================================

  /// Navigation Active - Selected nav item (12pt semibold)
  static const TextStyle navActive = TextStyle(
    fontFamily: inter,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Navigation Inactive - Unselected nav item (11pt regular)
  static const TextStyle navInactive = TextStyle(
    fontFamily: inter,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  // ============================================
  // Subtext / Meta Info - Inter/Nunito Light (Timestamps, hints)
  // ============================================

  /// Caption - Hint text, placeholders (13pt light)
  static const TextStyle caption = TextStyle(
    fontFamily: nunitoSans,
    fontSize: 13,
    fontWeight: FontWeight.w300,
    height: 1.3,
  );

  /// Caption Small - Timestamps, meta info (12pt light)
  static const TextStyle captionSmall = TextStyle(
    fontFamily: inter,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    height: 1.3,
  );

  // ============================================
  // Special - Quote attribution
  // ============================================

  /// Quote Author - Author/source of quote (14pt Cormorant)
  static const TextStyle quoteAuthor = TextStyle(
    fontFamily: cormorantGaramond,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );
}
