// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/common/app_background.dart';

class MarketingScreen extends StatelessWidget {
  const MarketingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 40),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildMainContent(),
                const SizedBox(height: 30),
                _buildFeaturesList(),
                const SizedBox(height: 30),
                _buildCTASection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildMainContent() {
    return Column(
      children: [
        const Text(
          'Like a desert wanderer, find your true self in the stillness of your own path.',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          'Transform your emotional well-being through AI-powered insights that turn daily feelings into actionable self-discovery.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      {
        'icon': '🎙️',
        'title': 'Effortless Emotional Capture',
        'description': 'Express yourself naturally through voice or text, with AI transcription that removes all barriers between your thoughts and meaningful self-reflection',
      },
      {
        'icon': '🧠',
        'title': 'Intelligent Pattern Recognition',
        'description': 'Discover hidden emotional triggers and growth opportunities through advanced AI analysis with personalized book recommendations',
      },
      {
        'icon': '🌱',
        'title': 'Complete Wellness Ecosystem',
        'description': 'Access guided breathing exercises, adaptive daily affirmations, and integrated mindfulness tools for your complete mental health journey',
      },
      {
        'icon': '🎨',
        'title': 'Therapeutic Design Experience',
        'description': 'Immerse yourself in a scientifically-designed calming environment with intuitive mood visualization and warm desert aesthetics',
      },
    ];

    return Column(
      children: features.map((feature) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: const Color(0xFFF0F0F0),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        feature['icon'] as String,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 44),
                child: Text(
                  feature['description'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }


  Widget _buildCTASection(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFC6D9ED), // Arctic Rain color
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC6D9ED).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              // Navigate to signup screen
              context.go('/signup');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC6D9ED), // Arctic Rain
              foregroundColor: const Color(0xFF1A1A1A), // Dark text for readability
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return const Color(0xFFAAC8E5); // Water Wash for pressed state
                  }
                  if (states.contains(WidgetState.hovered)) {
                    return const Color(0xFFAAC8E5).withValues(alpha: 0.5); // Water Wash for hover
                  }
                  return null;
                },
              ),
            ),
            child: const Text(
              'Start Your Inner Journey',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Your sanctuary awaits',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF9CA3AF),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}