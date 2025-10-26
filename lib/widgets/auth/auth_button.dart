import 'package:flutter/material.dart';
import '../../constants/spacing.dart';
import '../../constants/typography.dart';
import '../../constants/animations.dart';

class AuthButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final bool isLoading;
  final VoidCallback? onPressed;

  const AuthButton({
    super.key,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: double.infinity,
      height: OdyseyaSpacing.buttonHeight,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          side: borderColor != null
              ? BorderSide(color: borderColor!, width: 1.5)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(OdyseyaSpacing.radiusButton),
          ),
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.5),
          disabledForegroundColor: textColor.withValues(alpha: 0.5),
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
                children: [
                  Icon(
                    icon,
                    size: OdyseyaSpacing.iconMedium,
                    color: textColor,
                  ),
                  SizedBox(width: OdyseyaSpacing.md),
                  Text(
                    text,
                    style: OdyseyaTypography.buttonLarge.copyWith(
                      color: textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}