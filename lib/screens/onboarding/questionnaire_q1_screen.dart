import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/common/odyseya_screen_layout.dart';

class QuestionnaireQ1Screen extends ConsumerWidget {
  const QuestionnaireQ1Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingProvider);
    final selectedOptions = onboarding.q1Goals;

    return OdyseyaScreenLayout(
      totalSteps: 4,
      currentStep: 1,
      title: 'What do you hope Odyseya will help you with?',
      subtitle: 'Choose one or more',
      primaryButtonText: 'Continue',
      onPrimaryPressed: selectedOptions.isNotEmpty
        ? () => context.go('/onboarding/questionnaire/q2')
        : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          ..._buildOptions().map((option) => _buildOptionCard(
            context,
            ref,
            option['value'] as String,
            option['label'] as String,
            selectedOptions.contains(option['value']),
          )),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  List<Map<String, String>> _buildOptions() {
    return [
      {
        'value': 'breakup_loss',
        'label': 'Processing a breakup or loss',
      },
      {
        'value': 'understand_emotions',
        'label': 'Understanding my emotions better',
      },
      {
        'value': 'reflection_habit',
        'label': 'Building a daily reflection habit',
      },
      {
        'value': 'stress_anxiety',
        'label': 'Managing stress or anxiety',
      },
      {
        'value': 'self_discovery',
        'label': 'Discovering more about myself',
      },
      {
        'value': 'curious_exploring',
        'label': 'Just curious — exploring',
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
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final notifier = ref.read(onboardingProvider.notifier);
            notifier.toggleQ1Goal(value);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected 
                ? DesertColors.accent.withValues(alpha: 0.1)
                : DesertColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                  ? DesertColors.primary
                  : DesertColors.waterWash.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: DesertColors.waterWash.withValues(alpha: 0.1),
                  blurRadius: 8,
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