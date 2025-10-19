// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../constants/spacing.dart';
import '../../constants/animations.dart';

/// Unified button component matching the reference design
/// Provides consistent button styling across the entire app
/// Framework: Height 56px, Radius 24px, Primary bg #D8A36C
class OdyseyaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final OdyseyaButtonStyle buttonStyle;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;

  const OdyseyaButton({
    super.key,
    required this.text,
    this.onPressed,
    this.buttonStyle = OdyseyaButtonStyle.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 56,
  });

  /// Primary button - Western Sunrise background, white text (emotional peak)
  const OdyseyaButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 56,
  }) : buttonStyle = OdyseyaButtonStyle.primary;

  /// Secondary button - Beige background, brown text
  const OdyseyaButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 56,
  }) : buttonStyle = OdyseyaButtonStyle.secondary;

  /// Tertiary button - Transparent background, brown text, border
  const OdyseyaButton.tertiary({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 56,
  }) : buttonStyle = OdyseyaButtonStyle.tertiary;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    // Define colors based on button style
    Color backgroundColor;
    Color textColor;
    Color? borderColor;

    switch (buttonStyle) {
      case OdyseyaButtonStyle.primary:
        backgroundColor = isDisabled
            ? DesertColors.westernSunrise.withValues(alpha: 0.4)
            : DesertColors.westernSunrise; // Framework: #D8A36C (Accent Caramel)
        textColor = Colors.white;
        borderColor = null;
        break;
      case OdyseyaButtonStyle.secondary:
        backgroundColor = isDisabled
            ? DesertColors.creamBeige.withValues(alpha: 0.5)
            : DesertColors.creamBeige;
        textColor = DesertColors.brownBramble; // Primary brown for text
        borderColor = null;
        break;
      case OdyseyaButtonStyle.tertiary:
        backgroundColor = Colors.transparent;
        textColor = DesertColors.brownBramble; // Primary brown for text
        borderColor = isDisabled
            ? DesertColors.treeBranch.withValues(alpha: 0.3)
            : DesertColors.treeBranch; // Muted brown for border
        break;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          disabledBackgroundColor: backgroundColor,
          disabledForegroundColor: textColor.withValues(alpha: 0.5),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(OdyseyaSpacing.radiusPill),
            side: borderColor != null
                ? BorderSide(color: borderColor, width: 1.5)
                : BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: OdyseyaSpacing.buttonHorizontalPadding,
            vertical: OdyseyaSpacing.lg,
          ),
          animationDuration: OdyseyaAnimations.buttonTap,
        ),
        child: isLoading
            ? SizedBox(
                width: OdyseyaSpacing.iconMedium,
                height: OdyseyaSpacing.iconMedium,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: OdyseyaSpacing.iconMedium),
                    SizedBox(width: OdyseyaSpacing.sm),
                  ],
                  Text(
                    text,
                    style: OdyseyaTypography.buttonLarge.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Button style variants
enum OdyseyaButtonStyle {
  primary,   // Western Sunrise background - Bold emotional peak CTA
  secondary, // Beige background - Calm secondary actions
  tertiary,  // Outline style - Minimal tertiary actions
}
