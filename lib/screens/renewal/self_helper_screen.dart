// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../constants/spacing.dart';

/// Self Helper Screen - Rituals & Self-Care Hub
///
/// Provides access to healing rituals:
/// - Breathing exercises
/// - Manifestation practices
/// - Letters to future self
/// - Feedback & reflection
class SelfHelperScreen extends ConsumerWidget {
  const SelfHelperScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Renewal Rituals',
          style: AppTextStyles.h2,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: DesertColors.brownBramble,
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(OdyseyaSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header description
              Text(
                'Take a moment for yourself',
                style: AppTextStyles.secondary,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: OdyseyaSpacing.lg),

              // Ritual Tiles Grid
              _buildRitualTile(
                context: context,
                icon: Icons.air,
                title: 'Breathing',
                subtitle: 'Ground yourself with breath',
                color: DesertColors.arcticRain,
                onTap: () {
                  // TODO: Navigate to breathing screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Breathing exercises coming soon...')),
                  );
                },
              ),

              const SizedBox(height: OdyseyaSpacing.md),

              _buildRitualTile(
                context: context,
                icon: Icons.auto_awesome,
                title: 'Manifestation',
                subtitle: 'Set your intentions',
                color: DesertColors.sunsetOrange,
                onTap: () {
                  // TODO: Navigate to manifestation screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Manifestation coming soon...')),
                  );
                },
              ),

              const SizedBox(height: OdyseyaSpacing.md),

              _buildRitualTile(
                context: context,
                icon: Icons.mail_outline,
                title: 'Letter to Future Self',
                subtitle: 'Write to who you will become',
                color: DesertColors.westernSunrise,
                onTap: () {
                  // TODO: Navigate to letter screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Letter feature coming soon...')),
                  );
                },
              ),

              const SizedBox(height: OdyseyaSpacing.md),

              _buildRitualTile(
                context: context,
                icon: Icons.feedback_outlined,
                title: 'Feedback & Reflection',
                subtitle: 'Share your thoughts with us',
                color: DesertColors.caramelDrizzle,
                onTap: () {
                  // TODO: Navigate to feedback screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feedback coming soon...')),
                  );
                },
              ),

              const SizedBox(height: OdyseyaSpacing.xl),

              // Inspirational quote
              Container(
                padding: const EdgeInsets.all(OdyseyaSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.format_quote,
                      size: 32,
                      color: DesertColors.sunsetOrange.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: OdyseyaSpacing.sm),
                    Text(
                      'Self-care is not selfish. You cannot serve from an empty vessel.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontStyle: FontStyle.italic,
                        color: DesertColors.brownBramble,
                      ),
                    ),
                    const SizedBox(height: OdyseyaSpacing.xs),
                    Text(
                      '— Eleanor Brown',
                      style: AppTextStyles.captionSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
      ),
      ),
    );
  }

  Widget _buildRitualTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(OdyseyaSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: DesertColors.brownBramble.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 56,
              height: OdyseyaSpacing.buttonHeight,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),

            const SizedBox(width: OdyseyaSpacing.md),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.h3.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.secondary,
                  ),
                ],
              ),
            ),

            // Arrow indicator
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: DesertColors.brownBramble.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}
