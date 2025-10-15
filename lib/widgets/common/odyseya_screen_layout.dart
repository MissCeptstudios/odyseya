import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import 'app_background.dart';
import 'step_indicator.dart';
import 'odyseya_button.dart';

/// Standard screen layout component for consistent UX across all screens
/// Matches the reference design with desert background, centered content, and clean layout
class OdyseyaScreenLayout extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final bool isPrimaryLoading;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final int? totalSteps;
  final int? currentStep;
  final bool showBackButton;
  final VoidCallback? onBack;
  final IconData? helpIcon;
  final VoidCallback? onHelp;
  final bool centerContent;
  final EdgeInsets contentPadding;

  const OdyseyaScreenLayout({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.primaryButtonText,
    this.onPrimaryPressed,
    this.isPrimaryLoading = false,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.totalSteps,
    this.currentStep,
    this.showBackButton = true,
    this.onBack,
    this.helpIcon,
    this.onHelp,
    this.centerContent = false,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      useOverlay: true,
      overlayOpacity: 0.03,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header with back button and help icon
              _buildHeader(context),

              // Step indicator (if provided)
              if (totalSteps != null && currentStep != null)
                StepIndicator(
                  totalSteps: totalSteps!,
                  currentStep: currentStep!,
                ),

              // Title and subtitle
              if (title != null) _buildTitleSection(),

              // Main content
              Expanded(
                child: centerContent
                    ? Center(
                        child: SingleChildScrollView(
                          padding: contentPadding,
                          child: child,
                        ),
                      )
                    : SingleChildScrollView(
                        padding: contentPadding,
                        child: child,
                      ),
              ),

              // Bottom buttons
              if (primaryButtonText != null || secondaryButtonText != null)
                _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          if (showBackButton)
            IconButton(
              onPressed: onBack ?? () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back,
                color: DesertColors.deepBrown,
              ),
            )
          else
            const SizedBox(width: 48),

          // Help icon
          if (helpIcon != null)
            IconButton(
              onPressed: onHelp,
              icon: Icon(
                helpIcon,
                color: DesertColors.taupe,
              ),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        children: [
          if (title != null)
            Text(
              title!,
              style: OdyseyaTypography.h1.copyWith(
                color: DesertColors.deepBrown,
              ),
              textAlign: TextAlign.center,
            ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: OdyseyaTypography.body.copyWith(
                color: DesertColors.taupe,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            DesertColors.paleDesert.withValues(alpha: 0.0),
            DesertColors.paleDesert.withValues(alpha: 0.95),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Primary button
          if (primaryButtonText != null)
            OdyseyaButton.secondary(
              text: primaryButtonText!,
              onPressed: onPrimaryPressed,
              isLoading: isPrimaryLoading,
            ),

          if (primaryButtonText != null && secondaryButtonText != null)
            const SizedBox(height: 12),

          // Secondary button
          if (secondaryButtonText != null)
            OdyseyaButton.tertiary(
              text: secondaryButtonText!,
              onPressed: onSecondaryPressed,
            ),
        ],
      ),
    );
  }
}

/// Simplified version for screens with just centered content and a button
class SimpleOdyseyaScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final String buttonText;
  final VoidCallback onPressed;
  final bool isLoading;

  const SimpleOdyseyaScreen({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    required this.buttonText,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OdyseyaScreenLayout(
      title: title,
      subtitle: subtitle,
      centerContent: true,
      showBackButton: false,
      primaryButtonText: buttonText,
      onPrimaryPressed: onPressed,
      isPrimaryLoading: isLoading,
      child: child,
    );
  }
}
