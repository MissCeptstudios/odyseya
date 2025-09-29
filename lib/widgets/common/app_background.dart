import 'package:flutter/material.dart';
import '../../services/background_service.dart';

/// Unified background widget for consistent app background across all screens
class AppBackground extends StatelessWidget {
  final Widget child;
  final bool useOverlay;
  final double overlayOpacity;

  const AppBackground({
    super.key,
    required this.child,
    this.useOverlay = false,
    this.overlayOpacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(BackgroundService.getCurrentBackground()),
          fit: BoxFit.cover,
        ),
      ),
      child: useOverlay
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: overlayOpacity),
              ),
              child: child,
            )
          : child,
    );
  }
}

/// Extension for easy background application to any widget
extension BackgroundExtension on Widget {
  Widget withAppBackground({bool useOverlay = false, double overlayOpacity = 0.1}) {
    return AppBackground(
      useOverlay: useOverlay,
      overlayOpacity: overlayOpacity,
      child: this,
    );
  }
}