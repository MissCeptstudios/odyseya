import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';

/// Unified button component matching the reference design
/// Provides consistent button styling across the entire app
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

  /// Primary button - Blue background, white text
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
            ? DesertColors.dustyBlue.withValues(alpha: 0.5)
            : DesertColors.dustyBlue;
        textColor = Colors.white;
        borderColor = null;
        break;
      case OdyseyaButtonStyle.secondary:
        backgroundColor = isDisabled
            ? DesertColors.offWhite.withValues(alpha: 0.5)
            : DesertColors.offWhite;
        textColor = DesertColors.deepBrown;
        borderColor = null;
        break;
      case OdyseyaButtonStyle.tertiary:
        backgroundColor = Colors.transparent;
        textColor = DesertColors.deepBrown;
        borderColor = isDisabled
            ? DesertColors.taupe.withValues(alpha: 0.3)
            : DesertColors.taupe;
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
            borderRadius: BorderRadius.circular(28), // Fully rounded ends
            side: borderColor != null
                ? BorderSide(color: borderColor, width: 1.5)
                : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
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
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
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
  primary,   // Blue background (like "Voice" button)
  secondary, // Beige background (like "Continue" button)
  tertiary,  // Outline style
}
