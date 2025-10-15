import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/common/odyseya_screen_layout.dart';

class QuestionnaireQ2Screen extends ConsumerWidget {
  const QuestionnaireQ2Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingProvider);
    final selectedOption = onboarding.q2Frequency;

    return OdyseyaScreenLayout(
      totalSteps: 4,
      currentStep: 2,
      title: 'How often would you like to check in with yourself?',
      subtitle: 'Set your intention — we\'ll gently remind you',
      primaryButtonText: 'Continue',
      onPrimaryPressed: selectedOption != null
        ? () => context.go('/onboarding/questionnaire/q3')
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
            option['description'] as String,
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
        'value': 'daily',
        'label': 'Every day',
        'description': 'Daily check-ins to build a consistent habit',
      },
      {
        'value': 'few_times_week',
        'label': 'A few times a week',
        'description': 'Regular but flexible reflection schedule',
      },
      {
        'value': 'when_needed',
        'label': 'Only when I feel like I need it',
        'description': 'Intuitive journaling when emotions arise',
      },
      {
        'value': 'not_sure',
        'label': 'Not sure yet',
        'description': 'We\'ll help you find your rhythm',
      },
    ];
  }

  Widget _buildOptionCard(
    BuildContext context,
    WidgetRef ref,
    String value,
    String label,
    String description,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final notifier = ref.read(onboardingProvider.notifier);
            notifier.updateQ2Frequency(value);
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
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      )
                    : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected 
                            ? DesertColors.onSurface
                            : DesertColors.onSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: DesertColors.onSecondary.withValues(alpha: 0.8),
                          height: 1.3,
                        ),
                      ),
                    ],
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