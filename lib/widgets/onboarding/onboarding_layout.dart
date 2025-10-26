import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../providers/onboarding_provider.dart';

class OnboardingLayout extends ConsumerStatefulWidget {
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
  ConsumerState<OnboardingLayout> createState() => _OnboardingLayoutState();
}

class _OnboardingLayoutState extends ConsumerState<OnboardingLayout>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingData = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
        backgroundColor: DesertColors.creamBeige,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.showBackButton && onboardingData.currentStep > 0
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: DesertColors.onSurface, size: 22),
                onPressed: () => onboardingNotifier.previousStep(),
                tooltip: 'Go back',
              )
            : null,
        actions: [
          if (widget.onSkip != null)
            TextButton(
              onPressed: widget.onSkip,
              style: TextButton.styleFrom(
                foregroundColor: DesertColors.onSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text(
                'Skip',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: DesertColors.onSecondary,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (widget.showProgress) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  tween: Tween<double>(
                    begin: 0.0,
                    end: onboardingNotifier.progress,
                  ),
                  builder: (context, value, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: value,
                        backgroundColor: DesertColors.waterWash.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(DesertColors.primary),
                        minHeight: 6,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.title != null) ...[
                          Text(
                            widget.title!,
                            style: AppTextStyles.h1Large,
                          ),
                          const SizedBox(height: 16),
                        ],

                        if (widget.subtitle != null) ...[
                          Text(
                            widget.subtitle!,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: DesertColors.onSecondary,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],

                        widget.child,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (widget.onNext != null) ...[
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: onboardingNotifier.canProceedFromCurrentStep
                        ? widget.onNext
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DesertColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: DesertColors.primary.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      disabledBackgroundColor: DesertColors.waterWash.withValues(alpha: 0.3),
                      disabledForegroundColor: DesertColors.onSecondary.withValues(alpha: 0.5),
                    ),
                    child: Text(
                      widget.nextButtonText.toUpperCase(), // CTA buttons use uppercase
                      style: AppTextStyles.buttonLarge,
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