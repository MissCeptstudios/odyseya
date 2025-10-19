// Enforce design consistency based on UX_odyseya_framework.md
/// Spacing constants for consistent layout throughout the app
/// Following an 8px base scale system
class OdyseyaSpacing {
  OdyseyaSpacing._();

  // Base spacing scale (8px increments)
  static const double xs = 4.0;      // Extra small
  static const double sm = 8.0;      // Small
  static const double md = 12.0;     // Medium
  static const double lg = 16.0;     // Large
  static const double xl = 20.0;     // Extra large
  static const double xxl = 24.0;    // 2X large
  static const double xxxl = 32.0;   // 3X large
  static const double huge = 40.0;   // Huge
  static const double massive = 48.0; // Massive

  // Common padding patterns
  static const double screenHorizontal = 24.0;
  static const double screenVertical = 16.0;
  static const double contentHorizontal = 16.0;
  static const double contentVertical = 20.0;

  // Card and container padding
  static const double cardPadding = 20.0;
  static const double cardMargin = 12.0;

  // Button spacing (Framework v1.4)
  static const double buttonHeight = 56.0;  // Framework: 56px
  static const double buttonVerticalSpacing = 8.0;
  static const double buttonHorizontalPadding = 32.0;

  // Navigation (Framework v1.4)
  static const double navBarHeight = 84.0;  // Framework: 84px (was 72px)
  static const double navBarPadding = 16.0;

  // Section spacing
  static const double sectionSpacing = 24.0;
  static const double sectionSpacingLarge = 32.0;
  static const double heroSpacing = 40.0;

  // Border radius (Framework v1.4: Global standard 24px)
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;    // Toast: 16px
  static const double radiusXLarge = 20.0;
  static const double radiusXXLarge = 24.0;  // Standard: 24px
  static const double radiusCard = 24.0;     // Framework: Cards 24px
  static const double radiusButton = 24.0;   // Framework: Buttons 24px
  static const double radiusModal = 32.0;    // Framework: Modals 32px
  static const double radiusPill = 24.0;     // Framework: Changed from 28px to 24px

  // Icon sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 20.0;
  static const double iconLarge = 22.0;
  static const double iconXLarge = 24.0;
  static const double iconHuge = 32.0;
  static const double iconMoodCard = 64.0;

  // Touch target sizes (minimum for accessibility)
  static const double minTouchTarget = 48.0;

  // Progress indicators
  static const double stepIndicatorSize = 40.0;
  static const double stepIndicatorSmall = 32.0;
  static const double dotIndicator = 6.0;
  static const double stepSpacing = 16.0;

  // Form spacing
  static const double formFieldSpacing = 12.0;
  static const double formSectionSpacing = 20.0;
}
