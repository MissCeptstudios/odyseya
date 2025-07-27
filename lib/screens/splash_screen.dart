import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _textController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    
    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();
    
    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();
    
    await Future.delayed(const Duration(milliseconds: 2000));
    _navigateToHome();
  }

  void _navigateToHome() {
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesertColors.background,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              DesertColors.background,
              DesertColors.warmBeige,
              DesertColors.desertMist,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  DesertColors.sunsetOrange.withValues(alpha: 0.8),
                                  DesertColors.terracotta,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: DesertColors.terracotta.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.self_improvement,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              AnimatedBuilder(
                animation: _textFadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Odyseya',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w300,
                            color: DesertColors.onSurface,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Your emotional journey awaits',
                          style: TextStyle(
                            fontSize: 16,
                            color: DesertColors.onSurface.withValues(alpha: 0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              const Spacer(flex: 3),
              
              AnimatedBuilder(
                animation: _textFadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          DesertColors.sageGreen.withValues(alpha: 0.6),
                        ),
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}