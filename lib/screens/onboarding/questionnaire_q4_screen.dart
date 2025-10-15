import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/common/odyseya_screen_layout.dart';

class QuestionnaireQ4Screen extends ConsumerWidget {
  const QuestionnaireQ4Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingProvider);
    final selectedOption = onboarding.q4HardestEmotion;

    return OdyseyaScreenLayout(
      totalSteps: 4,
      currentStep: 4,
      title: 'What\'s one emotion or thought you find hardest to express in words?',
      subtitle: 'We\'ll help you gently unpack it over time',
      primaryButtonText: selectedOption != null ? 'Continue' : 'Skip for now',
      onPrimaryPressed: () => context.go('/mood-selection'), // Continue to main app flow
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          
          // Optional text input
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DesertColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: DesertColors.waterWash.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: DesertColors.waterWash.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                final notifier = ref.read(onboardingProvider.notifier);
                notifier.updateQ4HardestEmotion(value.trim().isNotEmpty ? value.trim() : null);
              },
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Type your thoughts here (optional)...',
                hintStyle: TextStyle(
                  color: DesertColors.onSecondary.withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
                fontSize: 16,
                color: DesertColors.onSurface,
                height: 1.5,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Or choose from common emotions:',
            style: TextStyle(
              fontSize: 14,
              color: DesertColors.onSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const SizedBox(height: 16),
          
          ..._buildOptions().map((option) => _buildOptionCard(
            context,
            ref,
            option['value'] as String,
            option['label'] as String,
            selectedOption == option['value'],
          )),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  List<Map<String, String>> _buildOptions() {
    return [
      {
        'value': 'anxiety',
        'label': 'Anxiety',
      },
      {
        'value': 'loneliness',
        'label': 'Loneliness',
      },
      {
        'value': 'anger',
        'label': 'Anger',
      },
      {
        'value': 'guilt',
        'label': 'Guilt',
      },
      {
        'value': 'confusion',
        'label': 'Confusion',
      },
      {
        'value': 'dont_know',
        'label': 'I don\'t even know',
      },
    ];
  }

  Widget _buildOptionCard(
    BuildContext context,
    WidgetRef ref,
    String value,
    String label,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final notifier = ref.read(onboardingProvider.notifier);
            // Toggle selection - if already selected, deselect it
            notifier.updateQ4HardestEmotion(isSelected ? null : value);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected 
                ? DesertColors.accent.withValues(alpha: 0.1)
                : DesertColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected 
                  ? DesertColors.primary
                  : DesertColors.waterWash.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected 
                      ? DesertColors.primary
                      : Colors.transparent,
                    border: Border.all(
                      color: isSelected 
                        ? DesertColors.primary
                        : DesertColors.onSecondary.withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                  child: isSelected 
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      )
                    : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected 
                        ? DesertColors.onSurface
                        : DesertColors.onSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}