import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../models/onboarding_data.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/onboarding/onboarding_layout.dart';

class EmotionalGoalsScreen extends ConsumerWidget {
  const EmotionalGoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingData = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return OnboardingLayout(
      title: 'What would you like to achieve?',
      subtitle: 'Choose all the goals that resonate with you. These will help us personalize your journaling experience.',
      onNext: () => onboardingNotifier.nextStep(),
      child: Column(
        children: [
          ...EmotionalGoals.options.map((option) {
            final isSelected = onboardingData.emotionalGoals.contains(option['value']);
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: _buildGoalCard(
                label: option['label']!,
                value: option['value']!,
                isSelected: isSelected,
                onTap: () {
                  onboardingNotifier.toggleEmotionalGoal(option['value']!);
                },
              ),
            );
          }),
          
          const SizedBox(height: 32),
          
          Container(
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
                Row(
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      color: DesertColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your emotional wellness journey is unique',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: DesertColors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'We\'ll use your goals to provide personalized insights, suggestions, and gentle guidance throughout your journaling practice.',
                  style: TextStyle(
                    fontSize: 14,
                    color: DesertColors.onSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          
          if (onboardingData.emotionalGoals.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DesertColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: DesertColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${onboardingData.emotionalGoals.length} goal${onboardingData.emotionalGoals.length > 1 ? "s" : ""} selected',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: DesertColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGoalCard({
    required String label,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? DesertColors.primary.withValues(alpha: 0.1) : DesertColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? DesertColors.primary 
                : DesertColors.waterWash.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? DesertColors.primary.withValues(alpha: 0.1)
                  : DesertColors.waterWash.withValues(alpha: 0.1),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? DesertColors.primary : DesertColors.waterWash,
                  width: 2,
                ),
                color: isSelected ? DesertColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? DesertColors.primary : DesertColors.onSurface,
                ),
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: DesertColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite,
                  size: 16,
                  color: DesertColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}