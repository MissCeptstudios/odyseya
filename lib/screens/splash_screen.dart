// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize rotation animation for spinning compass
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // 3 seconds per full rotation
      vsync: this,
    );

    // Full rotation animation
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159, // 360 degrees (2π radians)
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    // Repeat the rotation continuously
    _controller.repeat();

    _navigateToHome();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToHome() async {
    try {
      // Wait for 8 seconds
      await Future.delayed(const Duration(seconds: 8));

      // Navigate to auth screen (Sign In / Create Account)
      if (mounted) {
        context.go('/auth');
      }
    } catch (e) {
      // Log error but don't show UI - splash screen should always proceed
      debugPrint('Splash navigation error: $e');
      // Fallback: navigate anyway after a short delay
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          context.go('/auth');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for proper sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final compassSize = screenWidth * 0.5; // Compass is 50% of screen width
    final insideSize = compassSize * 0.65; // Inside is 65% of compass size

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background image - no muting, full opacity
          Image.asset(
            'assets/images/Background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Content overlay
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Compass with spinning animation
                SizedBox(
                  width: compassSize,
                  height: compassSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Inner graphic (STATIC - blue crown stays in place)
                      Image.asset(
                        'assets/images/inside_compass.png',
                        width: insideSize,
                        height: insideSize,
                        fit: BoxFit.contain,
                      ),

                      // Outer compass ring (SPINNING ANIMATION)
                      AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: child,
                          );
                        },
                        child: Image.asset(
                          'assets/images/just_compass.png',
                          width: compassSize,
                          height: compassSize,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bardzo mały gap - logo zlizane jak na zdjęciu
                const SizedBox(height: 4),

                // "Odyseya" text from UX folder - bardzo blisko kompasu
                Image.asset(
                  'assets/images/Odyseya_word.png',
                  width: compassSize * 1.4,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
