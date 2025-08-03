import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pure white background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with Tagline
              Column(
                children: [
                  // Logo
                  Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Image.asset(
                      'assets/images/Odyseya_Icon.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Brand Name
                  Image.asset(
                    'assets/images/Odyseya_word.png',
                    height: 56,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  // Tagline
                  Text(
                    'Your voice. Your journey.',
                    style: TextStyle(
                      fontSize: 16,
                      color: DesertColors.treeBranch,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    'Your safe space for emotional exploration',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: DesertColors.onSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
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
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
} 