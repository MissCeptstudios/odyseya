// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';

/// Coming Soon placeholder screen for Renewal tab (MVP1)
///
/// Framework Reference: Section 8 - Renewal Tab
/// Purpose: Placeholder for self-care features (breathing, manifestation, future letters)
/// MVP2 Features: self_helper_screen, feedback_screen, manifestation_screen, letter_to_future_screen
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DesertColors.creamBeige,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0), // Framework spec: 24px screen padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon - Gentle leaf representing renewal
                Icon(
                  Icons.eco_outlined,
                  size: 80,
                  color: DesertColors.westernSunrise.withValues(alpha: 0.7),
                ),

                const SizedBox(height: 32),

                // Title - Using framework typography
                Text(
                  'Renewal',
                  style: AppTextStyles.h1.copyWith(
                    color: DesertColors.brownBramble,
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Subtitle - Poetic description
                Text(
                  'Your space for healing & reconnection',
                  style: AppTextStyles.body.copyWith(
                    color: DesertColors.treeBranch,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Coming Soon Card - Framework-compliant design
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: DesertColors.cardWhite,
                    borderRadius: BorderRadius.circular(16), // Framework spec: 16px
                    boxShadow: [
                      BoxShadow(
                        color: DesertColors.shadowGrey,
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Coming Soon heading
                      Text(
                        'Coming Soon',
                        style: AppTextStyles.h3.copyWith(
                          color: DesertColors.brownBramble,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      // Feature list with icons
                      _buildFeatureItem(Icons.spa_outlined, 'Guided Breathing'),
                      _buildFeatureItem(Icons.auto_fix_high_outlined, 'Manifestation Rituals'),
                      _buildFeatureItem(Icons.mail_outline, 'Letters to Future Self'),
                      _buildFeatureItem(Icons.feedback_outlined, 'Whisper to Creator'),

                      const SizedBox(height: 16),

                      // Poetic message
                      Text(
                        'Rest here.\nNew paths are being shaped by the wind.',
                        style: AppTextStyles.body.copyWith(
                          fontStyle: FontStyle.italic,
                          color: DesertColors.treeBranch,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // MVP2 Timeline hint
                Text(
                  'Available in the next release',
                  style: AppTextStyles.caption.copyWith(
                    color: DesertColors.treeBranch.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
    );
  }

  /// Build feature list item with icon
  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: DesertColors.westernSunrise,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(
                color: DesertColors.brownBramble,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
