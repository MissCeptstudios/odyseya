// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';

/// Shadow and elevation constants for consistent depth throughout the app
/// Framework v1.4: Standard shadow 0 4 8 rgba(0,0,0,0.08)
class OdyseyaShadows {
  OdyseyaShadows._();

  // Elevation levels
  static const double elevation0 = 0.0;   // Flat
  static const double elevation1 = 2.0;   // Subtle
  static const double elevation2 = 4.0;   // Card
  static const double elevation3 = 8.0;   // Raised
  static const double elevation4 = 16.0;  // Floating
  static const double elevation5 = 24.0;  // Modal

  /// Framework standard shadow - Level 1 (Cards, Buttons)
  /// 0 4 8 rgba(0,0,0,0.08)
  static List<BoxShadow> get soft => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08), // Framework: 0.08
          blurRadius: 8, // Framework: 8
          offset: const Offset(0, 4), // Framework: 0 4
        ),
      ];

  /// Medium shadow - Level 2 (Active elements)
  /// 0 2 4 rgba(0,0,0,0.10)
  static List<BoxShadow> get medium => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.10), // Framework: 0.10
          blurRadius: 4, // Framework: 4
          offset: const Offset(0, 2), // Framework: 0 2
        ),
      ];

  /// Strong shadow - Modal
  /// 0 4 12 rgba(0,0,0,0.10)
  static List<BoxShadow> get strong => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.10), // Framework: 0.10
          blurRadius: 12, // Framework: 12
          offset: const Offset(0, 4), // Framework: 0 4
        ),
      ];

  /// Top shadow - used for navigation bars at top
  static List<BoxShadow> get topBar => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Bottom shadow - used for navigation bars at bottom
  /// Framework: 0 -2 6 rgba(0,0,0,0.04)
  static List<BoxShadow> get bottomBar => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04), // Framework: 0.04
          blurRadius: 6, // Framework: 6
          offset: const Offset(0, -2), // Framework: 0 -2
        ),
      ];

  /// Inner shadow effect - simulated with gradients
  /// Use with Container decoration for inset appearance
  static BoxDecoration get innerShadow => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.02),
            Colors.transparent,
          ],
          stops: const [0.0, 0.2],
        ),
      );

  /// Glow effect - used for primary actions or highlights
  static List<BoxShadow> glowShadow(Color color, {double alpha = 0.3}) => [
        BoxShadow(
          color: color.withValues(alpha: alpha),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  /// No shadow - explicitly removes shadow
  static List<BoxShadow> get none => [];

  // Themed shadow helpers for specific components

  /// Card shadow - for mood cards, entry cards
  static List<BoxShadow> get card => soft;

  /// Button shadow - for primary buttons
  static List<BoxShadow> get button => medium;

  /// Selected item shadow - for selected cards, active items
  static List<BoxShadow> get selected => strong;

  /// Modal shadow - for dialogs, sheets
  static List<BoxShadow> get modal => strong;

  /// Navigation bar shadow
  static List<BoxShadow> get navigation => bottomBar;
}

/// Opacity constants for overlays and scrim
class OdyseyaOpacity {
  OdyseyaOpacity._();

  static const double transparent = 0.0;
  static const double subtle = 0.05;
  static const double light = 0.1;
  static const double lightMedium = 0.2;
  static const double medium = 0.3;
  static const double mediumHeavy = 0.5;
  static const double heavy = 0.7;
  static const double veryHeavy = 0.85;
  static const double opaque = 1.0;

  // Common overlay opacities
  static const double backgroundOverlay = 0.1;
  static const double scrim = 0.5;
  static const double disabled = 0.5;
  static const double pressed = 0.8;
}
