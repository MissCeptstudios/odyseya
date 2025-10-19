// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';

/// Odyseya Color Palette - Aligned with UX Framework v1.4
/// "Desert calm meets emotional clarity"
class DesertColors {
  // ============================================
  // FRAMEWORK CORE PALETTE (v1.4)
  // ============================================

  /// Primary Brown (Bramble) - Main text, headers, interface elements
  static const Color brownBramble = Color(0xFF57351E);

  /// Accent Caramel (Primary Action) - Primary buttons, active borders
  static const Color westernSunrise = Color(0xFFD8A36C);

  /// Light Caramel (Secondary) - Gradient backgrounds, warmth highlights
  static const Color caramelDrizzle = Color(0xFFDBAC80);

  /// Highlight Blue (Calm Blue) - Active states, emotional highlights
  static const Color arcticRain = Color(0xFFC6D9ED);

  /// Muted Brown (Tree Branch) - Descriptive text, placeholders
  static const Color treeBranch = Color(0xFF8B7362);

  /// Background Sand (Base) - App background
  static const Color backgroundSand = Color(0xFFF9F5F0);

  /// Card White - Widget, card, and field backgrounds
  static const Color cardWhite = Color(0xFFFFFFFF);

  /// Shadow Grey - Subtle shadow under elements
  static const Color shadowGrey = Color(0x14000000); // rgba(0,0,0,0.08)

  /// Warm Brown - Bottom nav inactive icons (Framework spec)
  static const Color warmBrown = Color(0xFF7A4C25);

  // ============================================
  // LEGACY PALETTE (Maintain for backward compatibility)
  // ============================================

  static const Color roseSand = Color(0xFFC89B7A);
  static const Color dustyBlue = Color(0xFFB0C4DE);
  static const Color paleDesert = Color(0xFFF2D8C1);
  static const Color offWhite = Color(0xFFFEFCFA);
  static const Color deepBrown = Color(0xFF442B0C);
  static const Color taupe = Color(0xFF8B7355);
  static const Color waterWash = Color(0xFFAAC8E5);
  static const Color creamBeige = Color(0xFFF9F6F0); // Alias for backgroundSand

  // ============================================
  // BUTTON STATE COLORS (Framework v1.4)
  // ============================================

  /// Functional Button - Unselected state
  static const Color buttonUnselectedBg = cardWhite; // White background
  static const Color buttonUnselectedBorder = westernSunrise; // 1.5px #D8A36C border
  static const Color buttonUnselectedText = brownBramble; // #57351E text

  /// Functional Button - Selected state
  static const Color buttonSelectedBg = arcticRain; // #C6D9ED background
  static const Color buttonSelectedBorder = cardWhite; // 2px white border
  static const Color buttonSelectedText = cardWhite; // White text

  // ============================================
  // GRADIENT COLORS (Framework v1.4)
  // ============================================

  /// Desert Dawn: #DBAC80 → #FFFFFF
  static const List<Color> gradientDesertDawn = [caramelDrizzle, cardWhite];

  /// Western Sunrise: #D8A36C → #FFFFFF
  static const List<Color> gradientWesternSunrise = [westernSunrise, cardWhite];

  /// Arctic Glow: #C6D9ED → #FFFFFF
  static const List<Color> gradientArcticGlow = [arcticRain, cardWhite];

  /// Bramble Depth: #57351E (20%) → #FFFFFF (85%)
  static const List<Color> gradientBrambleDepth = [Color(0x3357351E), Color(0xD9FFFFFF)];

  // ============================================
  // LEGACY COLORS (Backward compatibility)
  // ============================================

  static const Color sandDune = Color(0xFFE8D4B0);
  static const Color terracotta = Color(0xFFD4896B);
  static const Color dustyRose = Color(0xFFCB9B9B);
  static const Color sageGreen = Color(0xFF9CAE9A);
  static const Color softLavender = Color(0xFFB5A3C7);
  static const Color warmBeige = Color(0xFFF5F1E8);
  static const Color sunsetOrange = Color(0xFFE8B55D);
  static const Color desertMist = Color(0xFFE0D8CC);
  static const Color earthBrown = Color(0xFF8B6F47);
  static const Color skyBlue = Color(0xFFB8D4E3);

  // ============================================
  // SEMANTIC COLORS (Framework-aligned)
  // ============================================

  /// Primary action color - Accent Caramel #D8A36C
  static const Color primary = westernSunrise;

  /// Secondary color - Arctic Rain #C6D9ED
  static const Color secondary = arcticRain;

  /// App background - Background Sand #F9F5F0
  static const Color background = backgroundSand;

  /// Card/surface background - White #FFFFFF
  static const Color surface = cardWhite;

  /// Text on surface - Brown Bramble #57351E
  static const Color onSurface = brownBramble;

  /// Text on secondary - Tree Branch #8B7362
  static const Color onSecondary = treeBranch;

  /// Accent color - Light Caramel #DBAC80
  static const Color accent = caramelDrizzle;

  /// Card background - White #FFFFFF
  static const Color cardBackground = cardWhite;

  /// Text on background - Brown Bramble #57351E
  static const Color onBackground = brownBramble;

  /// Text on primary - White #FFFFFF
  static const Color onPrimary = cardWhite;

  /// Text on accent - White #FFFFFF
  static const Color onAccent = cardWhite;

  /// Surface variant - Light sand tint
  static const Color surfaceVariant = Color(0xFFF8F6F3);

  /// Text on surface variant - Tree Branch #8B7362
  static const Color onSurfaceVariant = treeBranch;

  /// Shadow color - Black
  static const Color shadow = Colors.black;
}