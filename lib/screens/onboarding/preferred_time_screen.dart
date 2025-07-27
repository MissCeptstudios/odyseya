import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../models/onboarding_data.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/onboarding/onboarding_layout.dart';

class PreferredTimeScreen extends ConsumerWidget {
  const PreferredTimeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingData = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return OnboardingLayout(
      title: 'When would you prefer to journal?',
      subtitle: 'Choose the time that feels most natural for reflection and emotional check-ins.',
      onNext: () => onboardingNotifier.nextStep(),
      child: Column(
        children: [
          ...PreferredTime.options.map((option) {
            final isSelected = onboardingData.preferredTime == option['value'];
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: _buildTimeCard(
                label: option['label']! as String,
                description: option['description']! as String,
                value: option['value']! as String,
                iconName: option['icon']! as String,
                isSelected: isSelected,
                onTap: () {
                  onboardingNotifier.updatePreferredTime(option['value']! as String);
                },
              ),
            );
          }),
          
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DesertColors.waterWash.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: DesertColors.waterWash.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.schedule,
                  color: DesertColors.primary,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  'Flexible by design',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: DesertColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You can always adjust your journaling schedule later. We\'ll send gentle reminders based on your preference.',
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

  Widget _buildTimeCard({
    required String label,
    required String description,
    required String value,
    required String iconName,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    IconData icon;
    Color iconColor;
    
    switch (iconName) {
      case 'sun':
        icon = Icons.wb_sunny;
        iconColor = Colors.amber;
        break;
      case 'moon':
        icon = Icons.nightlight_round;
        iconColor = Colors.indigo;
        break;
      case 'clock':
        icon = Icons.access_time;
        iconColor = DesertColors.primary;
        break;
      case 'settings':
        icon = Icons.tune;
        iconColor = DesertColors.accent;
        break;
      default:
        icon = Icons.schedule;
        iconColor = DesertColors.primary;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? DesertColors.primary.withValues(alpha: 0.1) : DesertColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? DesertColors.primary 
                : DesertColors.waterWash.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                  ? DesertColors.primary.withValues(alpha: 0.2)
                  : DesertColors.waterWash.withValues(alpha: 0.1),
              blurRadius: isSelected ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected 
                    ? iconColor.withValues(alpha: 0.2)
                    : DesertColors.waterWash.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: isSelected ? iconColor : DesertColors.onSecondary,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
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
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: DesertColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}