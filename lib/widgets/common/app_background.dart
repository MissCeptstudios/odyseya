// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import '../../services/background_service.dart';
import '../../constants/colors.dart';

/// Unified background widget for consistent app background across all screens
/// Enhanced with desert texture grain and subtle gradients
class AppBackground extends StatelessWidget {
  final Widget child;
  final bool useOverlay;
  final double overlayOpacity;
  final Color overlayColor;
  final bool addGrain; // Add subtle grain texture
  final bool addGradient; // Add subtle gradient overlay

  const AppBackground({
    super.key,
    required this.child,
    this.useOverlay = false,
    this.overlayOpacity = 0.1,
    this.overlayColor = Colors.white,
    this.addGrain = true,
    this.addGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ResizeImage(
            AssetImage(BackgroundService.getCurrentBackground()),
            width: 1080,  // ⚡ Performance: Cache at FHD resolution
            height: 1920,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Subtle gradient overlay for depth
          if (addGradient)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    DesertColors.paleDesert.withValues(alpha: 0.05),
                    Colors.transparent,
                    DesertColors.caramelDrizzle.withValues(alpha: 0.03),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

          // Grain texture overlay
          if (addGrain)
            Opacity(
              opacity: 0.03,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ResizeImage(
                      const AssetImage('assets/images/background_day.png'),
                      width: 1080,  // ⚡ Performance: Cache grain texture
                      height: 1920,
                    ),
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.repeat,
                    opacity: 0.1,
                  ),
                ),
              ),
            ),

          // Main overlay
          if (useOverlay)
            Container(
              decoration: BoxDecoration(
                color: overlayColor.withValues(alpha: overlayOpacity),
              ),
            ),

          // Content
          child,
        ],
      ),
    );
  }
}

/// Extension for easy background application to any widget
extension BackgroundExtension on Widget {
  Widget withAppBackground({
    bool useOverlay = false,
    double overlayOpacity = 0.1,
    Color overlayColor = Colors.white,
    bool addGrain = true,
    bool addGradient = true,
  }) {
    return AppBackground(
      useOverlay: useOverlay,
      overlayOpacity: overlayOpacity,
      overlayColor: overlayColor,
      addGrain: addGrain,
      addGradient: addGradient,
      child: this,
    );
  }
}