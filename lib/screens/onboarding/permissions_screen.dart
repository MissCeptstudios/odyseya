// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constants/colors.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/onboarding/onboarding_layout.dart';

class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key});

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen> {
  @override
  Widget build(BuildContext context) {
    final onboardingData = ref.watch(onboardingProvider);

    return OnboardingLayout(
      title: 'Let\'s set up your experience',
      subtitle: 'These permissions help us provide you with the best journaling experience. You can always change these later in settings.',
      onNext: () => context.go('/welcome'),
      onSkip: () => context.go('/welcome'),
      child: Column(
        children: [
          _buildPermissionCard(
            icon: Icons.mic,
            title: 'Microphone Access',
            description: 'Record your voice entries and enable speech-to-text transcription',
            isGranted: onboardingData.microphonePermission,
            onToggle: () => _requestMicrophonePermission(),
            isRequired: true,
          ),
          
          const SizedBox(height: 16),
          
          _buildPermissionCard(
            icon: Icons.notifications,
            title: 'Notifications',
            description: 'Gentle reminders to help you maintain your journaling practice',
            isGranted: onboardingData.notificationPermission,
            onToggle: () => _requestNotificationPermission(),
            isRequired: false,
          ),
          
          const SizedBox(height: 16),
          
          _buildPermissionCard(
            icon: Icons.location_on,
            title: 'Location (Optional)',
            description: 'Add weather and location context to your journal entries',
            isGranted: onboardingData.locationPermission,
            onToggle: () => _requestLocationPermission(),
            isRequired: false,
          ),
          
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DesertColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: DesertColors.accent.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: DesertColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your privacy is our priority. All data is encrypted and stored securely on your device and our protected servers.',
                    style: TextStyle(
                      fontSize: 14,
                      color: DesertColors.onSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isGranted,
    required VoidCallback onToggle,
    required bool isRequired,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesertColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isGranted 
              ? DesertColors.primary.withValues(alpha: 0.3)
              : DesertColors.waterWash.withValues(alpha: 0.3),
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isGranted 
                  ? DesertColors.primary.withValues(alpha: 0.2)
                  : DesertColors.waterWash.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isGranted ? DesertColors.primary : DesertColors.onSecondary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: DesertColors.onSurface,
                        ),
                      ),
                    ),
                    if (isRequired) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: DesertColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Required',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: DesertColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: DesertColors.onSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 56,
              height: 32,
              decoration: BoxDecoration(
                color: isGranted ? DesertColors.primary : DesertColors.waterWash.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: isGranted ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isGranted ? Icons.check : Icons.close,
                    size: 16,
                    color: isGranted ? DesertColors.primary : DesertColors.onSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestMicrophonePermission() async {
    try {
      final onboardingNotifier = ref.read(onboardingProvider.notifier);
      final status = await Permission.microphone.request();
      onboardingNotifier.updateMicrophonePermission(status.isGranted);
    } catch (e) {
      debugPrint('Microphone permission error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to request microphone permission. Please check settings.'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  Future<void> _requestNotificationPermission() async {
    try {
      final onboardingNotifier = ref.read(onboardingProvider.notifier);
      final notificationNotifier = ref.read(notificationProvider.notifier);

      // Use the notification service to request permissions
      final granted = await notificationNotifier.requestPermissions();

      // Update onboarding state
      onboardingNotifier.updateNotificationPermission(granted);
    } catch (e) {
      debugPrint('Notification permission error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to request notification permission. You can enable it later in settings.'),
            backgroundColor: Colors.orange.shade700,
          ),
        );
      }
    }
  }

  Future<void> _requestLocationPermission() async {
    try {
      final onboardingNotifier = ref.read(onboardingProvider.notifier);
      final status = await Permission.locationWhenInUse.request();
      onboardingNotifier.updateLocationPermission(status.isGranted);
    } catch (e) {
      debugPrint('Location permission error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to request location permission. This is optional and can be enabled later.'),
            backgroundColor: Colors.orange.shade700,
          ),
        );
      }
    }
  }
}