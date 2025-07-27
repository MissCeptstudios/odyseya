import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../providers/onboarding_provider.dart';

class OnboardingLayout extends ConsumerWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final String nextButtonText;
  final bool showProgress;
  final bool showBackButton;

  const OnboardingLayout({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.onNext,
    this.onSkip,
    this.nextButtonText = 'Continue',
    this.showProgress = true,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingData = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      backgroundColor: DesertColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: showBackButton && onboardingData.currentStep > 0
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios, color: DesertColors.onSurface),
                onPressed: () => onboardingNotifier.previousStep(),
              )
            : null,
        actions: [
          if (onSkip != null)
            TextButton(
              onPressed: onSkip,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: DesertColors.onSecondary,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (showProgress) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: LinearProgressIndicator(
                  value: onboardingNotifier.progress,
                  backgroundColor: DesertColors.waterWash.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(DesertColors.primary),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null) ...[
                      Text(
                        title!,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: DesertColors.onSurface,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    if (subtitle != null) ...[
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 18,
                          color: DesertColors.onSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                    
                    child,
                  ],
                ),
              ),
            ),
            
            if (onNext != null) ...[
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onboardingNotifier.canProceedFromCurrentStep
                        ? onNext
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DesertColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      disabledBackgroundColor: DesertColors.waterWash.withValues(alpha: 0.5),
                      disabledForegroundColor: DesertColors.onSecondary,
                    ),
                    child: Text(
                      nextButtonText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}