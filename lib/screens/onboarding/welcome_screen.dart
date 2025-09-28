import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../widgets/onboarding/onboarding_layout.dart';
import '../../widgets/common/app_background.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBackground(
      useOverlay: true,
      overlayOpacity: 0.02,
      child: OnboardingLayout(
        showProgress: false,
        showBackButton: false,
        onNext: () => context.go('/onboarding/questionnaire/q1'),
        nextButtonText: 'Continue',
        child: Column(
          children: [
          const SizedBox(height: 40),
          
          // Hero Logo Section
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  DesertColors.primary.withValues(alpha: 0.8),
                  DesertColors.accent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: DesertColors.primary.withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.self_improvement,
              size: 70,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 40),
          
          // App Name and Tagline
          Text(
            'Odyseya',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w200,
              color: DesertColors.onSurface,
              letterSpacing: 3.0,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Your safe space for emotional exploration',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: DesertColors.onSecondary,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.5,
            ),
          ),
          
          const SizedBox(height: 48),
          
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
              borderRadius: BorderRadius.circular(16),
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
        borderRadius: BorderRadius.circular(16),
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