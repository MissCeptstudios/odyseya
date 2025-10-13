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

    // Initialize rotation animation controller for compass searching for north
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Smooth rotation
      vsync: this,
    );

    // Full rotation animation - compass spins around its own axis searching for north
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.14159, // Full 360 degree rotation (2π radians)
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
    // Wait for 10 seconds
    await Future.delayed(const Duration(seconds: 10));

    // Navigate to home screen (main app shell)
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Full screen background
          Image.asset('assets/images/Background_F.png', fit: BoxFit.cover),

          // 2. Content with compass and logo centered in middle of screen
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Compass layers - perfectly aligned and symmetric
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Inner landscape (STATIC - blue/brown doesn't move)
                    Image.asset(
                      'assets/images/inside_compass.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),

                    // Outer compass ring (ANIMATED - compass rotates searching for north)
                    AnimatedBuilder(
                      animation: _rotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value,
                          alignment: Alignment.center,
                          child: child,
                        );
                      },
                      child: Image.asset(
                        'assets/images/just_compass.png',
                        width: 320,
                        height: 320,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Odyseya Logo below compass
                Image.asset(
                  'assets/images/Odyseya_logo_noBGR.png',
                  width: 200,
                  height: 80,
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
