// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
              color: Colors.white,
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
                      color: const Color(0xFF6B4423),
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