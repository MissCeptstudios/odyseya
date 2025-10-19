// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
              color: isDisabled
                ? Colors.white.withValues(alpha: 0.5)
                : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                  ? const Color(0xFF6B4423) // Brown border when selected
                  : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
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
                      ? const Color(0xFFC9A882) // Tan/beige background for check
                      : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                        ? const Color(0xFFC9A882)
                        : isDisabled
                          ? const Color(0xFFD4C4B0).withValues(alpha: 0.3)
                          : const Color(0xFFD4C4B0).withValues(alpha: 0.5),
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
                      color: isDisabled
                        ? const Color(0xFF8B6F47).withValues(alpha: 0.5)
                        : const Color(0xFF6B4423),
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