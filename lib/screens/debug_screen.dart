import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/colors.dart';
import '../widgets/common/app_background.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      useOverlay: true,
      overlayOpacity: 0.8,
      child: Scaffold(
        backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Debug Navigation'),
        backgroundColor: DesertColors.primary,
        foregroundColor: DesertColors.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Debug Screen',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: DesertColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            ElevatedButton.icon(
              onPressed: () => context.go('/calendar'),
              icon: const Icon(Icons.calendar_today),
              label: const Text('Go to Calendar Screen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: DesertColors.primary,
                foregroundColor: DesertColors.onPrimary,
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 16),
            
            ElevatedButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.mood),
              label: const Text('Go to Mood Selection'),
              style: ElevatedButton.styleFrom(
                backgroundColor: DesertColors.sageGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 16),
            
            ElevatedButton.icon(
              onPressed: () => context.go('/journal'),
              icon: const Icon(Icons.mic),
              label: const Text('Go to Journal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: DesertColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'Use this screen to navigate directly to different parts of the app for testing.',
              style: TextStyle(
                color: DesertColors.onSurfaceVariant,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
    );
  }
}