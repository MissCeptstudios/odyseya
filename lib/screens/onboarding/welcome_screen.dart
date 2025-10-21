// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../widgets/common/odyseya_screen_layout.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OdyseyaScreenLayout(
      primaryButtonText: 'Continue',
      onPrimaryPressed: () => context.go('/onboarding/questionnaire/q1'),
      child: Column(
        children: [
          const SizedBox(height: 24),

          // Value Proposition Cards
          _buildFeatureCard(
            icon: Icons.mic,
            title: 'Voice Journaling',
            description: 'Express your thoughts naturally through voice, with intelligent transcription',
          ),
          
          const SizedBox(height: 16),
          
          _buildFeatureCard(
            icon: Icons.psychology,
            title: 'AI Insights',
            description: 'Discover patterns, triggers, and growth opportunities in your emotional journey',
          ),
          
          const SizedBox(height: 16),
          
          _buildFeatureCard(
            icon: Icons.security,
            title: 'Privacy First',
            description: 'Your emotional data is encrypted, secure, and completely under your control',
          ),
          
          const SizedBox(height: 40),
          
          // Trust Indicators
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DesertColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: DesertColors.waterWash.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTrustBadge(Icons.verified_user, 'GDPR\nCompliant'),
                _buildTrustBadge(Icons.lock, 'End-to-End\nEncrypted'),
                _buildTrustBadge(Icons.privacy_tip, 'Privacy\nFocused'),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesertColors.surface,
        borderRadius: BorderRadius.circular(24),
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
              color: DesertColors.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: DesertColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: DesertColors.onSurface,
                  ),
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
        ],
      ),
    );
  }

  Widget _buildTrustBadge(IconData icon, String text) {
    return Column(
      children: [
        Icon(
          icon,
          color: DesertColors.primary,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: DesertColors.onSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}