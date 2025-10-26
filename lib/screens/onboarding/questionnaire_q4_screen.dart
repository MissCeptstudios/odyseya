// Enforce design consistency based on UX_odyseya_framework.md
import '../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/common/odyseya_screen_layout.dart';
import '../../constants/typography.dart';

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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: DesertColors.waterWash.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
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
                  color: const Color(0xFF8B6F47).withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppTextStyles.body.copyWith(color: DesertColors.brownBramble,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Or choose from common emotions:',
            style: AppTextStyles.bodySmall.copyWith(color: Color(0xFF8B6F47),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                  ? DesertColors.brownBramble // Brown border when selected
                  : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
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
                      ? DesertColors.brownBramble // Brown background when selected
                      : Colors.white,
                    border: Border.all(
                      color: isSelected
                        ? DesertColors.brownBramble
                        : DesertColors.treeBranch.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                    ? Center(
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                      )
                    : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.ui.copyWith(color: DesertColors.brownBramble,
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