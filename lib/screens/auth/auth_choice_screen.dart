import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../widgets/auth/privacy_notice.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

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
              // Logo and Welcome Text
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [DesertColors.caramelDrizzle, DesertColors.caramelDrizzle],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: DesertColors.caramelDrizzle.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.self_improvement,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to Odyseya',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  color: DesertColors.onSurface,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your safe space for emotional exploration',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: DesertColors.onSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 48),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => context.go('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesertColors.caramelDrizzle,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => context.go('/signup'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: DesertColors.caramelDrizzle,
                    side: BorderSide(color: DesertColors.caramelDrizzle),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const Spacer(),
              // Privacy Notice
              const PrivacyNotice(),
            ],
          ),
        ),
      ),
    );
  }
} 