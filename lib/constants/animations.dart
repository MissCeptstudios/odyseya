import 'package:flutter/material.dart';

/// Animation constants for consistent motion design throughout the app
/// Following Material Motion principles adapted for Odyseya's calm aesthetic
class OdyseyaAnimations {
  OdyseyaAnimations._();

  // Duration constants
  static const Duration instant = Duration.zero;
  static const Duration fastest = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration slower = Duration(milliseconds: 600);
  static const Duration slowest = Duration(milliseconds: 800);

  // Specific animation durations
  static const Duration buttonTap = Duration(milliseconds: 150);
  static const Duration cardSelection = Duration(milliseconds: 300);
  static const Duration navigationTransition = Duration(milliseconds: 300);
  static const Duration pageTransition = Duration(milliseconds: 400);
  static const Duration fadeIn = Duration(milliseconds: 300);
  static const Duration fadeOut = Duration(milliseconds: 200);
  static const Duration slideIn = Duration(milliseconds: 400);
  static const Duration modalAppear = Duration(milliseconds: 300);
  static const Duration shimmer = Duration(milliseconds: 1500);

  // Curve constants - following Material Design principles
  static const Curve emphasized = Curves.easeOutCubic;
  static const Curve decelerate = Curves.easeOut;
  static const Curve accelerate = Curves.easeIn;
  static const Curve standard = Curves.easeInOut;
  static const Curve linear = Curves.linear;
  static const Curve bounce = Curves.bounceOut;
  static const Curve elastic = Curves.elasticOut;

  // Common animation curves for specific use cases
  static const Curve button = Curves.easeOutCubic;
  static const Curve card = Curves.easeInOut;
  static const Curve page = Curves.easeOutCubic;
  static const Curve modal = Curves.easeOut;
  static const Curve fade = Curves.easeInOut;

  // Scale animation values
  static const double scaleNormal = 1.0;
  static const double scaleTapped = 0.95;
  static const double scaleUnselected = 0.92;
  static const double scalePressed = 0.97;
  static const double scaleExpanded = 1.05;

  // Opacity animation values
  static const double opacityVisible = 1.0;
  static const double opacityHidden = 0.0;
  static const double opacityDimmed = 0.6;
  static const double opacitySubtle = 0.3;

  // Offset values for slide animations
  static const Offset slideFromRight = Offset(1.0, 0.0);
  static const Offset slideFromLeft = Offset(-1.0, 0.0);
  static const Offset slideFromTop = Offset(0.0, -1.0);
  static const Offset slideFromBottom = Offset(0.0, 1.0);
  static const Offset slideCenter = Offset.zero;

  // Rotation values (in radians)
  static const double rotationQuarter = 1.5708; // 90 degrees
  static const double rotationHalf = 3.14159;   // 180 degrees
  static const double rotationFull = 6.28318;   // 360 degrees

  // Common animation configurations

  /// Button press animation configuration
  static AnimationController createButtonController(TickerProvider vsync) {
    return AnimationController(
      duration: buttonTap,
      vsync: vsync,
    );
  }

  /// Scale tween for button press
  static Tween<double> get buttonScaleTween => Tween<double>(
        begin: scaleNormal,
        end: scaleTapped,
      );

  /// Fade in tween
  static Tween<double> get fadeInTween => Tween<double>(
        begin: opacityHidden,
        end: opacityVisible,
      );

  /// Fade out tween
  static Tween<double> get fadeOutTween => Tween<double>(
        begin: opacityVisible,
        end: opacityHidden,
      );

  /// Slide from right tween
  static Tween<Offset> get slideFromRightTween => Tween<Offset>(
        begin: slideFromRight,
        end: slideCenter,
      );

  /// Slide from bottom tween
  static Tween<Offset> get slideFromBottomTween => Tween<Offset>(
        begin: slideFromBottom,
        end: slideCenter,
      );

  // Pre-configured animation helpers

  /// Create a fade transition
  static Widget fadeTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Create a slide transition
  static Widget slideTransition({
    required Animation<Offset> animation,
    required Widget child,
  }) {
    return SlideTransition(
      position: animation,
      child: child,
    );
  }

  /// Create a scale transition
  static Widget scaleTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }

  /// Animated container for card selection
  static Duration get cardTransitionDuration => cardSelection;
  static Curve get cardTransitionCurve => card;
}

/// Haptic feedback patterns for consistent tactile responses
class OdyseyaHaptics {
  OdyseyaHaptics._();

  /// Light haptic feedback for subtle interactions
  static Future<void> light() async {
    // Note: Import flutter/services.dart in the file where this is used
    // HapticFeedback.lightImpact();
  }

  /// Medium haptic feedback for standard interactions
  static Future<void> medium() async {
    // HapticFeedback.mediumImpact();
  }

  /// Heavy haptic feedback for important interactions
  static Future<void> heavy() async {
    // HapticFeedback.heavyImpact();
  }

  /// Selection feedback for picker/list selections
  static Future<void> selection() async {
    // HapticFeedback.selectionClick();
  }

  /// Vibration pattern for success
  static Future<void> success() async {
    // HapticFeedback.lightImpact();
    // await Future.delayed(const Duration(milliseconds: 100));
    // HapticFeedback.lightImpact();
  }

  /// Vibration pattern for error
  static Future<void> error() async {
    // HapticFeedback.heavyImpact();
  }
}
