import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background image
          Image.asset(
            'assets/images/Background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Content overlay - centered vertically with improved layout
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive padding based on screen height
                final verticalPadding = constraints.maxHeight * 0.05;
                final horizontalPadding = constraints.maxWidth * 0.06;

                return Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding.clamp(20.0, 32.0),
                      vertical: verticalPadding.clamp(16.0, 32.0),
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 480, // Maximum width for better readability
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 28.0,
                        vertical: 36.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ZWARTA SEKCJA LOGO - Kompas + Odyseya + Podtytuł

                          // Compass Logo
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.28,
                            height: MediaQuery.of(context).size.width * 0.28,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Inner compass graphic (blue crown)
                                Image.asset(
                                  'assets/images/inside_compass.png',
                                  width: MediaQuery.of(context).size.width * 0.19,
                                  height: MediaQuery.of(context).size.width * 0.19,
                                  fit: BoxFit.contain,
                                ),
                                // Outer compass ring
                                Image.asset(
                                  'assets/images/just_compass.png',
                                  width: MediaQuery.of(context).size.width * 0.28,
                                  height: MediaQuery.of(context).size.width * 0.28,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // App Name Logo
                          Image.asset(
                            'assets/images/Odyseya_word.png',
                            width: MediaQuery.of(context).size.width * 0.42,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 24),

                          // Poetic Quote
                          Text(
                            'Like a desert wanderer,\ndiscover your true self\nin the silence of your path',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'CormorantGaramond',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                              height: 1.5,
                              color: Color(0xFF57351E),
                            ),
                          ),
                          const SizedBox(height: 36),

                      // Sign In Button (Primary Button - 56px height, 16px radius)
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000), // rgba(0,0,0,0.08)
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => context.go('/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DesertColors.westernSunrise, // #D8A36C
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'BACK TO YOUR JOURNEY',
                            style: OdyseyaTypography.buttonLarge,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Create Account Button (Functional Button - 56px height, 16px radius)
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0F000000), // rgba(0,0,0,0.06)
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: OutlinedButton(
                          onPressed: () => context.go('/signup'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: DesertColors.cardWhite, // #FFFFFF
                            foregroundColor: DesertColors.brownBramble, // #57351E Primary Brown
                            side: const BorderSide(
                              color: DesertColors.westernSunrise, // #D8A36C
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'CREATE ACCOUNT',
                            style: OdyseyaTypography.buttonLarge.copyWith(
                              color: DesertColors.brownBramble,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              },
            ),
          ),
        ],
      ),
    );
  }
}
r 