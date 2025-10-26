// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/onboarding/onboarding_layout.dart';
import '../action/mood_selection_screen.dart';

class FirstJournalScreen extends ConsumerWidget {
  const FirstJournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return OnboardingLayout(
      title: 'Ready for your first entry?',
      subtitle: 'Let\'s create your first journal entry together. We\'ll guide you through each step.',
      onNext: () => _completeOnboarding(context, onboardingNotifier),
      nextButtonText: 'Start Journaling',
      showProgress: true,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  DesertColors.primary.withValues(alpha: 0.1),
                  DesertColors.accent.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: DesertColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        DesertColors.primary,
                        DesertColors.accent,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: DesertColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Your journey begins now',
                  style: AppTextStyles.h2.copyWith(
                    color: DesertColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Take a moment to reflect on how you\'re feeling and what\'s on your mind.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: DesertColors.onSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          _buildGuideStep(
            number: '1',
            title: 'Choose your mood',
            description: 'Select how you\'re feeling right now',
            icon: Icons.mood,
          ),
          
          const SizedBox(height: 16),
          
          _buildGuideStep(
            number: '2',
            title: 'Record your thoughts',
            description: 'Speak freely about what\'s on your mind',
            icon: Icons.mic,
          ),
          
          const SizedBox(height: 16),
          
          _buildGuideStep(
            number: '3',
            title: 'Receive insights',
            description: 'Get personalized understanding of your feelings',
            icon: Icons.psychology,
          ),
          
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DesertColors.waterWash.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: DesertColors.waterWash.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: DesertColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Helpful tip',
                        style: AppTextStyles.ui.copyWith(
                          fontWeight: FontWeight.w600,
                          color: DesertColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'There\'s no right or wrong way to journal. Just be honest and speak from your heart.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: DesertColors.onSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideStep({
    required String number,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: DesertColors.primary,
          ),
          child: Center(
            child: Text(
              number,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: DesertColors.accent.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: DesertColors.accent,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: DesertColors.onSurface,
                ),
              ),
              Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: DesertColors.onSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _completeOnboarding(BuildContext context, OnboardingNotifier onboardingNotifier) {
    onboardingNotifier.completeOnboarding();
    
    // Show celebration
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: DesertColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    DesertColors.primary,
                    DesertColors.accent,
                  ],
                ),
              ),
              child: const Icon(
                Icons.celebration,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome to Odyseya!',
              style: AppTextStyles.h1.copyWith(
                color: DesertColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You\'re all set to begin your emotional journaling journey. Let\'s create your first entry!',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: DesertColors.onSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const MoodSelectionScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesertColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Let\'s Go!'.toUpperCase(),
                  style: AppTextStyles.buttonLarge.copyWith(
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}