// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../models/onboarding_data.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/onboarding/onboarding_layout.dart';

class JournalingExperienceScreen extends ConsumerWidget {
  const JournalingExperienceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingData = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return OnboardingLayout(
      title: 'Tell us about your journaling journey',
      subtitle: 'This helps us tailor the experience to your needs and provide the most relevant guidance.',
      onNext: () => onboardingNotifier.nextStep(),
      child: Column(
        children: [
          ...JournalingExperience.options.map((option) {
            final isSelected = onboardingData.journalingExperience == option['value'];
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: _buildOptionCard(
                label: option['label']!,
                value: option['value']!,
                isSelected: isSelected,
                onTap: () {
                  onboardingNotifier.updateJournalingExperience(option['value']!);
                },
              ),
            );
          }),
          
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DesertColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: DesertColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: DesertColors.primary,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  'No matter where you\'re starting from, Odyseya will meet you there',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: DesertColors.onSurface,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Whether you\'re completely new to journaling or a seasoned writer, we\'ll provide personalized guidance and support.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: DesertColors.onSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
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
                shape: BoxShape.circle,
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
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: DesertColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}