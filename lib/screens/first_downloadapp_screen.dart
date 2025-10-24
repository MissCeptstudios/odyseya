// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/typography.dart';
import '../constants/colors.dart';

class FirstDownloadAppScreen extends StatelessWidget {
  const FirstDownloadAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesertColors.creamBeige,
      body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Compass logo
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Inner compass graphic (static)
                        Image.asset(
                          'assets/images/inside_compass.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                          cacheWidth: 300,  // ⚡ Performance: 3x for high DPI
                          cacheHeight: 300,
                        ),
                        // Outer compass ring
                        Image.asset(
                          'assets/images/just_compass.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.contain,
                          cacheWidth: 450,  // ⚡ Performance: 3x for high DPI
                          cacheHeight: 450,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Odyseya text logo
                  Image.asset(
                    'assets/images/Odyseya_word.png',
                    width: 200,
                    height: 50,
                    fit: BoxFit.contain,
                    cacheWidth: 600,  // ⚡ Performance: 3x for high DPI
                    cacheHeight: 150,
                  ),

                  const Spacer(flex: 3),

                  // Sign in button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD8A36C), // #D8A36C westernSunrise
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Sign in',
                        style: OdyseyaTypography.buttonLarge,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Create account button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/signup');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF57351E), // #57351E brownBramble
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: const Color(0xFFD8A36C), width: 1.5),
                        ),
                      ),
                      child: Text(
                        'Create account',
                        style: OdyseyaTypography.buttonLarge.copyWith(
                          color: const Color(0xFF57351E), // #57351E brownBramble
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),
                ],
              ),
            ),
      ),
    );
  }
}
