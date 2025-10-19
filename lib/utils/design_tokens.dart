/// Design Tokens for Odyseya Design System v1.4
///
/// Enforces consistent styling across all screens per UX framework specification.
/// Reference: /UX/UX_odyseya_framework.md
library;

import 'package:flutter/material.dart';
import '../constants/colors.dart';

class DesignTokens {
  // ============================================================================
  // BORDER RADIUS (Section 9: Consistency Rules)
  // ============================================================================

  /// Standard border radius for cards, buttons, fields
  /// Spec: 24px global standard
  static const double borderRadiusStandard = 24.0;

  /// Modal border radius
  /// Spec: 32px for modals
  static const double borderRadiusModal = 32.0;

  /// Toast/Snackbar border radius
  /// Spec: 16px for toasts
  static const double borderRadiusToast = 16.0;

  /// Standard BorderRadius for cards, buttons, fields
  static const BorderRadius standardBorderRadius = BorderRadius.all(
    Radius.circular(borderRadiusStandard),
  );

  /// Modal BorderRadius
  static const BorderRadius modalBorderRadius = BorderRadius.all(
    Radius.circular(borderRadiusModal),
  );

  /// Toast BorderRadius
  static const BorderRadius toastBorderRadius = BorderRadius.all(
    Radius.circular(borderRadiusToast),
  );

  // ============================================================================
  // BUTTON DIMENSIONS (Section 3: Buttons)
  // ============================================================================

  /// Primary button height
  /// Spec: 56px
  static const double buttonHeightPrimary = 56.0;

  /// Button elevation
  /// Spec: 0 (flat design, shadows used instead)
  static const double buttonElevation = 0.0;

  // ============================================================================
  // SPACING (Section 9: Consistency Rules)
  // ============================================================================

  /// Card padding
  /// Spec: 20px
  static const double cardPadding = 20.0;

  /// Grid spacing unit
  /// Spec: 8px base grid
  static const double gridUnit = 8.0;

  /// Standard EdgeInsets for cards
  static const EdgeInsets cardPaddingInsets = EdgeInsets.all(cardPadding);

  // ============================================================================
  // SHADOWS (Section 6: Shadows & Elevation)
  // ============================================================================

  /// Level 1 Shadow - Cards, buttons
  /// Spec: 0 4 8 rgba(0,0,0,0.08)
  static BoxShadow get shadowLevel1 => BoxShadow(
    color: Colors.black.withValues(alpha: 0.08),
    blurRadius: 8,
    offset: const Offset(0, 4),
  );

  /// Level 2 Shadow - Active elements
  /// Spec: 0 2 4 rgba(0,0,0,0.10)
  static BoxShadow get shadowLevel2 => BoxShadow(
    color: Colors.black.withValues(alpha: 0.10),
    blurRadius: 4,
    offset: const Offset(0, 2),
  );

  /// Level 3 Shadow - Bottom navigation
  /// Spec: 0 -2 6 rgba(0,0,0,0.04)
  static BoxShadow get shadowLevel3 => BoxShadow(
    color: Colors.black.withValues(alpha: 0.04),
    blurRadius: 6,
    offset: const Offset(0, -2),
  );

  /// Modal Shadow
  /// Spec: 0 4 12 rgba(0,0,0,0.10)
  static BoxShadow get shadowModal => BoxShadow(
    color: Colors.black.withValues(alpha: 0.10),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );

  // ============================================================================
  // BORDERS (Sections 3 & 4: Buttons, Fields & Cards)
  // ============================================================================

  /// Functional button border (unselected state)
  /// Spec: 1.5px solid #D8A36C
  static BorderSide get functionalButtonBorder => BorderSide(
    color: DesertColors.westernSunrise,
    width: 1.5,
  );

  /// Selected state border (functional button selected)
  /// Spec: 2px solid #FFFFFF
  static const BorderSide selectedStateBorder = BorderSide(
    color: Colors.white,
    width: 2.0,
  );

  /// Active field border
  /// Spec: 1.5px solid #D8A36C
  static BorderSide get activeFieldBorder => BorderSide(
    color: DesertColors.westernSunrise,
    width: 1.5,
  );

  // ============================================================================
  // BUTTON STYLES (Section 3: Buttons)
  // ============================================================================

  /// Primary Button Style
  /// Background: #D8A36C, Text: #FFFFFF, Height: 56px, Radius: 24px
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: DesertColors.westernSunrise,
    foregroundColor: Colors.white,
    elevation: buttonElevation,
    minimumSize: const Size(double.infinity, buttonHeightPrimary),
    shape: RoundedRectangleBorder(
      borderRadius: standardBorderRadius,
    ),
    shadowColor: Colors.black.withValues(alpha: 0.08),
  );

  /// Functional Button Style (Unselected)
  /// Background: #FFFFFF, Text: #57351E, Border: 1.5px #D8A36C, Radius: 24px
  static ButtonStyle get functionalButtonStyle => OutlinedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: DesertColors.brownBramble,
    side: functionalButtonBorder,
    elevation: buttonElevation,
    shape: RoundedRectangleBorder(
      borderRadius: standardBorderRadius,
    ),
    shadowColor: Colors.black.withValues(alpha: 0.06),
  );

  /// Functional Button Style (Selected)
  /// Background: #C6D9ED, Text: #FFFFFF, Border: 2px #FFFFFF, Radius: 24px
  static ButtonStyle get functionalButtonStyleSelected => OutlinedButton.styleFrom(
    backgroundColor: DesertColors.arcticRain,
    foregroundColor: Colors.white,
    side: selectedStateBorder,
    elevation: buttonElevation,
    shape: RoundedRectangleBorder(
      borderRadius: standardBorderRadius,
    ),
    shadowColor: Colors.black.withValues(alpha: 0.08),
  );

  // ============================================================================
  // INPUT DECORATION (Section 4: Fields & Cards)
  // ============================================================================

  /// Standard Input Decoration (Inactive)
  /// Background: #FFFFFF, Border: none, Shadow: 0 4 8 rgba(0,0,0,0.08)
  static InputDecoration getInputDecoration({
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: cardPaddingInsets,
      border: OutlineInputBorder(
        borderRadius: standardBorderRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: standardBorderRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: standardBorderRadius,
        borderSide: activeFieldBorder,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: standardBorderRadius,
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: standardBorderRadius,
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }

  // ============================================================================
  // CARD DECORATION (Section 4: Fields & Cards)
  // ============================================================================

  /// Standard Card Decoration (Inactive)
  /// Background: #FFFFFF, Radius: 24px, Shadow: 0 4 8 rgba(0,0,0,0.08)
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: standardBorderRadius,
    boxShadow: [shadowLevel1],
  );

  /// Active Card Decoration (with border)
  /// Background: #FFFFFF, Border: 1.5px #D8A36C, Shadow: 0 4 8 rgba(0,0,0,0.10)
  static BoxDecoration get cardDecorationActive => BoxDecoration(
    color: Colors.white,
    borderRadius: standardBorderRadius,
    border: Border.all(
      color: DesertColors.westernSunrise,
      width: 1.5,
    ),
    boxShadow: [shadowLevel2],
  );

  /// Disabled Card Decoration
  /// Background: #F9F5F0, no border, no shadow
  static BoxDecoration get cardDecorationDisabled => BoxDecoration(
    color: DesertColors.backgroundSand,
    borderRadius: standardBorderRadius,
  );

  // ============================================================================
  // ANIMATION DURATIONS (Section 7: Motion & Interactions)
  // ============================================================================

  /// Standard animation duration
  /// Spec: 200-300ms
  static const Duration animationDurationStandard = Duration(milliseconds: 200);

  /// Long animation duration
  static const Duration animationDurationLong = Duration(milliseconds: 300);

  /// Toast duration
  /// Spec: 3 seconds
  static const Duration toastDuration = Duration(seconds: 3);

  /// Animation curve
  /// Spec: cubic-bezier(0.4, 0, 0.2, 1) - Material ease-in-out
  static const Curve animationCurve = Curves.easeInOut;

  // ============================================================================
  // BOTTOM NAVIGATION (Section 5: Bottom Navigation)
  // ============================================================================

  /// Bottom navigation height
  /// Spec: 84px
  static const double bottomNavHeight = 84.0;

  /// Bottom navigation top radius
  /// Spec: 24px
  static const double bottomNavTopRadius = 24.0;

  // ============================================================================
  // TYPOGRAPHY HELPERS (Section 2: Typography)
  // ============================================================================

  /// H1 Large style - 32pt, weight 600
  /// Usage: "What's on your mind today?"
  static TextStyle get h1Large => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: DesertColors.brownBramble,
  );

  /// H1 style - 24pt, weight 600
  /// Usage: "Today's affirmation", section headers
  static TextStyle get h1 => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: DesertColors.brownBramble,
  );

  /// H2 style - 20pt, weight 600
  /// Usage: Card titles, subsections
  static TextStyle get h2 => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: DesertColors.brownBramble,
  );

  /// Body style - 16pt, weight 400
  /// Usage: Main journal text
  static TextStyle get body => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: DesertColors.brownBramble,
  );

  /// Body small style - 14pt, weight 400
  /// Usage: Secondary body text
  static TextStyle get bodySmall => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: DesertColors.brownBramble,
  );

  /// Secondary style - 14pt, weight 400
  /// Usage: Subtitles, descriptions
  static TextStyle get secondary => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: DesertColors.treeBranch,
  );

  /// Button style - 16pt, weight 600
  /// Usage: Button text
  static TextStyle get button => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  /// Caption style - 12pt, weight 300
  /// Usage: Hints, metadata, timestamps
  static TextStyle get caption => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: DesertColors.treeBranch,
  );
}
