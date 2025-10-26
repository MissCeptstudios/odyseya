// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/onboarding/onboarding_layout.dart';
import '../../constants/typography.dart';

class FeatureDemoScreen extends ConsumerStatefulWidget {
  const FeatureDemoScreen({super.key});

  @override
  ConsumerState<FeatureDemoScreen> createState() => _FeatureDemoScreenState();
}

class _FeatureDemoScreenState extends ConsumerState<FeatureDemoScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return OnboardingLayout(
      title: 'See how Odyseya works',
      subtitle: 'Experience the magic of voice journaling with AI-powered insights.',
      onNext: () => onboardingNotifier.nextStep(),
      onSkip: () => onboardingNotifier.nextStep(),
      nextButtonText: 'Continue to Setup',
      child: Column(
        children: [
          _buildDemoCard(
            title: 'Choose Your Mood',
            description: 'Start by selecting how you\'re feeling today',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMoodDemo('😊', DesertColors.primary, false),
                _buildMoodDemo('😌', DesertColors.accent, true),
                _buildMoodDemo('🤔', DesertColors.waterWash, false),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          _buildDemoCard(
            title: 'Record Your Voice',
            description: 'Speak naturally about your thoughts and feelings',
            child: Center(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            DesertColors.primary,
                            DesertColors.primary.withValues(alpha: 0.6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: DesertColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          _buildDemoCard(
            title: 'Receive AI Insights',
            description: 'Get personalized understanding of your emotional patterns',
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DesertColors.waterWash.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: DesertColors.waterWash.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.psychology,
                        color: DesertColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'AI Insight',
                        style: AppTextStyles.bodySmall.copyWith(color: DesertColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your calm mood suggests you\'re finding balance today. Consider exploring what\'s contributing to this peaceful feeling.',
                    style: AppTextStyles.hint.copyWith(color: DesertColors.onSecondary, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DesertColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: DesertColors.accent.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.play_circle_outline,
                  color: DesertColors.primary,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  'Ready to try it yourself?',
                  style: AppTextStyles.h3.copyWith(color: DesertColors.onSurface),
                ),
                const SizedBox(height: 8),
                Text(
                  'After setup, you\'ll create your first journal entry with guided prompts and gentle support.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(color: DesertColors.onSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesertColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: DesertColors.waterWash.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h4.copyWith(color: DesertColors.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTextStyles.bodySmall.copyWith(color: DesertColors.onSecondary),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildMoodDemo(String emoji, Color color, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.2) : DesertColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color : DesertColors.waterWash.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Center(
        child: Text(
          emoji,
          style: AppTextStyles.splashQuote,
        ),
      ),
    );
  }
}