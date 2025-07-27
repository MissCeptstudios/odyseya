import 'package:flutter/material.dart';

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
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          side: borderColor != null 
              ? BorderSide(color: borderColor!)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.6),
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
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: textColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}