import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/common/odyseya_screen_layout.dart';

class QuestionnaireQ3Screen extends ConsumerWidget {
  const QuestionnaireQ3Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingProvider);
    final selectedOptions = onboarding.q3Feelings;

    return OdyseyaScreenLayout(
      totalSteps: 4,
      currentStep: 3,
      title: 'Which of these describes how you\'ve been feeling lately?',
      subtitle: 'Pick up to 2',
      primaryButtonText: 'Continue',
      onPrimaryPressed: selectedOptions.isNotEmpty
        ? () => context.go('/onboarding/questionnaire/q4')
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
            selectedOptions.length >= 2 && !selectedOptions.contains(option['value']),
          )),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  List<Map<String, String>> _buildOptions() {
    return [
      {
        'value': 'emotionally_overwhelmed',
        'label': 'Emotionally overwhelmed',
      },
      {
        'value': 'lost_uncertain',
        'label': 'Lost or uncertain',
      },
      {
        'value': 'healing_from_something',
        'label': 'Healing from something',
      },
      {
        'value': 'stable_curious',
        'label': 'Stable, but curious',
      },
      {
        'value': 'optimistic_growing',
        'label': 'Optimistic and growing',
      },
      {
        'value': 'numb_not_sure',
        'label': 'Numb / not sure',
      },
    ];
  }

  Widget _buildOptionCard(
    BuildContext context,
    WidgetRef ref,
    String value,
    String label,
    bool isSelected,
    bool isDisabled,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : () {
            final notifier = ref.read(onboardingProvider.notifier);
            notifier.toggleQ3Feeling(value);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected 
                ? DesertColors.accent.withValues(alpha: 0.1)
                : isDisabled 
                  ? DesertColors.surface.withValues(alpha: 0.5)
                  : DesertColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                  ? DesertColors.primary
                  : isDisabled
                    ? DesertColors.waterWash.withValues(alpha: 0.2)
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
                        : isDisabled 
                          ? DesertColors.onSecondary.withValues(alpha: 0.2)
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
                        : isDisabled 
                          ? DesertColors.onSecondary.withValues(alpha: 0.5)
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