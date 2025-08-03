import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/colors.dart';

/// Debug screen to test navigation functionality
/// Remove this file once navigation is verified to work correctly
class DebugNavigationTest extends ConsumerWidget {
  const DebugNavigationTest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: DesertColors.background,
      appBar: AppBar(
        title: const Text('Navigation Test'),
        backgroundColor: DesertColors.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Bottom Navigation Test',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: DesertColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'Test the bottom navigation by tapping the buttons below:',
              style: TextStyle(
                fontSize: 16,
                color: DesertColors.onSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            _buildNavigationButton(
              context,
              label: 'Home (Mood Selection)',
              route: '/home',
              icon: Icons.mood,
              description: 'Navigate to mood selection screen',
            ),
            
            const SizedBox(height: 16),
            
            _buildNavigationButton(
              context,
              label: 'Journal',
              route: '/journal',
              icon: Icons.mic,
              description: 'Navigate to voice journal screen',
            ),
            
            const SizedBox(height: 16),
            
            _buildNavigationButton(
              context,
              label: 'Calendar',
              route: '/calendar',
              icon: Icons.calendar_today,
              description: 'Navigate to journal calendar screen',
            ),
            
            const SizedBox(height: 16),
            
            _buildNavigationButton(
              context,
              label: 'Settings',
              route: '/settings',
              icon: Icons.settings,
              description: 'Navigate to settings screen',
            ),
            
            const Spacer(),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DesertColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: DesertColors.accent.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: DesertColors.accent,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Each button should navigate to the corresponding screen with the bottom navigation bar visible and the correct tab highlighted.',
                    style: TextStyle(
                      fontSize: 14,
                      color: DesertColors.onSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context, {
    required String label,
    required String route,
    required IconData icon,
    required String description,
  }) {
    return ElevatedButton(
      onPressed: () => context.go(route),
      style: ElevatedButton.styleFrom(
        backgroundColor: DesertColors.surface,
        foregroundColor: DesertColors.onSurface,
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: DesertColors.waterWash.withValues(alpha: 0.3),
          ),
        ),
        elevation: 0,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: DesertColors.primary,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: DesertColors.onSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: DesertColors.onSecondary,
            size: 16,
          ),
        ],
      ),
    );
  }
}