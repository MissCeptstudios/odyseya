import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../providers/subscription_provider.dart';

/// Premium badge widget to show premium status or lock icon
class PremiumBadge extends ConsumerWidget {
  final bool small;
  final Color? backgroundColor;

  const PremiumBadge({
    super.key,
    this.small = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 4 : 6,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DesertColors.roseSand,
            DesertColors.dustyBlue,
          ],
        ),
        borderRadius: BorderRadius.circular(small ? 8 : 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium,
            color: Colors.white,
            size: small ? 12 : 16,
          ),
          SizedBox(width: small ? 4 : 6),
          Text(
            'PRO',
            style: OdyseyaTypography.ui.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: small ? 10 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget that wraps content and shows a lock overlay if not premium
class PremiumGate extends ConsumerWidget {
  final Widget child;
  final PremiumFeature feature;
  final String featureName;
  final String featureDescription;
  final bool showBadge;

  const PremiumGate({
    super.key,
    required this.child,
    required this.feature,
    required this.featureName,
    required this.featureDescription,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasAccess = ref.watch(hasFeatureAccessProvider(feature));

    if (hasAccess) {
      return child;
    }

    return Stack(
      children: [
        // Blurred/dimmed child
        Opacity(
          opacity: 0.3,
          child: IgnorePointer(
            child: child,
          ),
        ),

        // Lock overlay
        Positioned.fill(
          child: GestureDetector(
            onTap: () => _showUpgradeDialog(context),
            child: Container(
              decoration: BoxDecoration(
                color: DesertColors.offWhite.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: DesertColors.roseSand.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    size: 48,
                    color: DesertColors.roseSand,
                  ),
                  const SizedBox(height: 12),
                  if (showBadge) const PremiumBadge(),
                  const SizedBox(height: 12),
                  Text(
                    featureName,
                    style: OdyseyaTypography.h2.copyWith(
                      color: DesertColors.brownBramble,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      featureDescription,
                      style: OdyseyaTypography.body.copyWith(
                        color: DesertColors.treeBranch,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/paywall');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DesertColors.roseSand,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Upgrade to Premium',
                      style: OdyseyaTypography.button,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesertColors.offWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const PremiumBadge(small: true),
            const SizedBox(width: 12),
            Text(
              'Premium Feature',
              style: OdyseyaTypography.h2.copyWith(
                color: DesertColors.brownBramble,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              featureName,
              style: OdyseyaTypography.button.copyWith(
                color: DesertColors.brownBramble,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              featureDescription,
              style: OdyseyaTypography.body.copyWith(
                color: DesertColors.treeBranch,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Upgrade to Premium to unlock this and many other features.',
              style: OdyseyaTypography.body.copyWith(
                color: DesertColors.treeBranch,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Not Now',
              style: TextStyle(color: DesertColors.treeBranch),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/paywall');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DesertColors.roseSand,
              foregroundColor: Colors.white,
            ),
            child: const Text('See Plans'),
          ),
        ],
      ),
    );
  }
}

/// Small premium lock icon for buttons or list items
class PremiumLockIcon extends ConsumerWidget {
  final double size;

  const PremiumLockIcon({
    super.key,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: DesertColors.roseSand,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.lock,
        size: size,
        color: Colors.white,
      ),
    );
  }
}

/// Button that checks premium status before executing action
class PremiumButton extends ConsumerWidget {
  final PremiumFeature feature;
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isPrimary;

  const PremiumButton({
    super.key,
    required this.feature,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasAccess = ref.watch(hasFeatureAccessProvider(feature));

    return ElevatedButton(
      onPressed: hasAccess
          ? onPressed
          : () {
              context.push('/paywall');
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? DesertColors.roseSand
            : DesertColors.offWhite,
        foregroundColor: isPrimary
            ? Colors.white
            : DesertColors.brownBramble,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: OdyseyaTypography.button,
          ),
          if (!hasAccess) ...[
            const SizedBox(width: 8),
            const PremiumLockIcon(size: 14),
          ],
        ],
      ),
    );
  }
}
