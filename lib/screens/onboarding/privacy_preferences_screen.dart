import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../models/onboarding_data.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/onboarding/onboarding_layout.dart';

class PrivacyPreferencesScreen extends ConsumerWidget {
  const PrivacyPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingData = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return OnboardingLayout(
      title: 'How would you like to use AI insights?',
      subtitle: 'Choose the level of AI analysis that feels comfortable for you. You can change this anytime in settings.',
      onNext: () => onboardingNotifier.nextStep(),
      child: Column(
        children: [
          ...PrivacyPreference.options.map((option) {
            final isSelected = onboardingData.privacyPreference == option['value'];
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: _buildPrivacyCard(
                label: option['label']!,
                description: option['description']!,
                value: option['value']!,
                isSelected: isSelected,
                onTap: () {
                  onboardingNotifier.updatePrivacyPreference(option['value']!);
                },
              ),
            );
          }),
          
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  DesertColors.primary.withValues(alpha: 0.1),
                  DesertColors.accent.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: DesertColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: DesertColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your privacy is our priority',
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
                  '• All processing happens securely with enterprise-grade encryption\n• Your journal entries are never shared or sold\n• AI analysis is performed with strict privacy controls\n• You can export or delete your data anytime',
                  style: TextStyle(
                    fontSize: 14,
                    color: DesertColors.onSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard({
    required String label,
    required String description,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    IconData icon;
    Color iconColor;
    
    switch (value) {
      case 'full_analysis':
        icon = Icons.psychology;
        iconColor = Colors.purple;
        break;
      case 'gentle_suggestions':
        icon = Icons.favorite_outline;
        iconColor = Colors.pink;
        break;
      case 'transcription_only':
        icon = Icons.lock;
        iconColor = Colors.green;
        break;
      case 'learn_more':
        icon = Icons.help_outline;
        iconColor = DesertColors.primary;
        break;
      default:
        icon = Icons.settings;
        iconColor = DesertColors.primary;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected 
                    ? iconColor.withValues(alpha: 0.2)
                    : DesertColors.waterWash.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? iconColor : DesertColors.onSecondary,
                size: 24,
              ),
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
                      color: isSelected ? DesertColors.primary : DesertColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected 
                          ? DesertColors.primary.withValues(alpha: 0.8)
                          : DesertColors.onSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: DesertColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}