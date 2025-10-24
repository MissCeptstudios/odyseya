// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';

class OnboardingSuccessScreen extends StatefulWidget {
  const OnboardingSuccessScreen({super.key});

  @override
  State<OnboardingSuccessScreen> createState() => _OnboardingSuccessScreenState();
}

class _OnboardingSuccessScreenState extends State<OnboardingSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
    });
    
    // Auto-navigate after 3 seconds
    _autoNavigate();
  }

  Future<void> _autoNavigate() async {
    try {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      // Log error but continue - user can tap "Continue to App" button
      debugPrint('Auto-navigation error: $e');
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesertColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Success Icon with Animation
              AnimatedBuilder(
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
                            DesertColors.caramelDrizzle,
                            DesertColors.caramelDrizzle,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: DesertColors.caramelDrizzle.withValues(alpha: 0.3),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
              // Animated Text Content
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        Text(
                          'Welcome to Odyseya!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: DesertColors.onSurface,
                            letterSpacing: 0.5,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        Text(
                          'Your emotional journey begins now',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: DesertColors.onSecondary,
                            height: 1.4,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: DesertColors.waterWash.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: DesertColors.waterWash.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.self_improvement,
                                size: 32,
                                color: DesertColors.primary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Enjoy your journaling journey',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: DesertColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Take a moment to reflect, express yourself, and discover insights about your emotional world',
                                textAlign: TextAlign.center,
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
                },
              ),
              
              const Spacer(),
              
              // Skip Button
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value * 0.7,
                    child: TextButton(
                      onPressed: () => context.go('/home'),
                      child: Text(
                        'Continue to App',
                        style: TextStyle(
                          color: DesertColors.primary,
                          fontSize: 16,
                        ),
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