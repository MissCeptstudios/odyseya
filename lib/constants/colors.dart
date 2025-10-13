import 'package:flutter/material.dart';

class DesertColors {
  // Cool Desert Morning palette
  static const Color roseSand = Color(0xFFC89B7A); // Primary - Main actions, buttons
  static const Color dustyBlue = Color(0xFFB0C4DE); // Secondary - Accents
  static const Color paleDesert = Color(0xFFF2D8C1); // Background - Main backgrounds
  static const Color offWhite = Color(0xFFFEFCFA); // Surface - Cards, elevated surfaces
  static const Color deepBrown = Color(0xFF442B0C); // Text Primary - Main text
  static const Color taupe = Color(0xFF8B7355); // Text Secondary - Secondary text

  // New color palette for onboarding
  static const Color arcticRain = Color(0xFFC6D9ED);
  static const Color waterWash = Color(0xFFAAC8E5);
  static const Color caramelDrizzle = Color(0xFFDBAC80);
  static const Color westernSunrise = Color(0xFFD8A36C);
  static const Color treeBranch = Color(0xFF8B7362);
  static const Color brownBramble = Color(0xFF57351E);
  static const Color creamBeige = Color(0xFFF9F6F0); // New cream beige for branding backgrounds

  // Button state colors
  static const Color buttonUnselectedBg = Color(0xFFF9F6F0); // Cream beige for unselected
  static const Color buttonUnselectedBorder = Color(0xFFD0C4B8); // Muted beige border
  static const Color buttonUnselectedText = Color(0xFF8B7362); // Tree branch for text
  static const Color buttonSelectedBg = Color(0xFFDBAC80); // Caramel drizzle for selected
  static const Color buttonSelectedBorder = Color(0xFFD8A36C); // Western sunrise accent
  static const Color buttonSelectedText = Color(0xFF57351E); // Brown bramble for text

  // Gradient colors for smooth transitions
  static const Color gradientBlue = Color(0xFF6BB6FF); // Soft blue for gradients
  static const Color gradientLightBlue = Color(0xFFB8D4E3); // Light blue
  static const Color gradientWhite = Colors.white; // Pure white
  
  // Legacy colors (keep for existing screens)
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
  
  // Updated semantic colors
  static const Color primary = westernSunrise;
  static const Color secondary = waterWash;
  static const Color background = Colors.white; // Changed to white
  static const Color surface = Colors.white;
  static const Color onSurface = brownBramble;
  static const Color onSecondary = treeBranch;
  static const Color accent = caramelDrizzle;
  static const Color cardBackground = Colors.white;
  
  // Additional semantic colors
  static const Color onBackground = brownBramble;
  static const Color onPrimary = Colors.white;
  static const Color onAccent = Colors.white;
  static const Color surfaceVariant = Color(0xFFF8F6F3);
  static const Color onSurfaceVariant = treeBranch;
  static const Color shadow = Colors.black;
}