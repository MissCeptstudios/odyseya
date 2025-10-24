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

          // Content overlay - centered vertically
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // GÓRNA CZĘŚĆ - Logo + Tytuł + Podtytuł
                      // Compass Logo
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.width * 0.35,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Inner compass graphic (blue crown)
                            Image.asset(
                              'assets/images/inside_compass.png',
                              width: MediaQuery.of(context).size.width * 0.23,
                              height: MediaQuery.of(context).size.width * 0.23,
                              fit: BoxFit.contain,
                            ),
                            // Outer compass ring
                            Image.asset(
                              'assets/images/just_compass.png',
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: MediaQuery.of(context).size.width * 0.35,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // App Name Logo - TYTUŁ (zaraz pod kompasem)
                      Image.asset(
                        'assets/images/Odyseya_word.png',
                        width: MediaQuery.of(context).size.width * 0.45,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 12),

                      // Tagline - PODTYTUŁ (ten sam kolor co logo Odyseya - wizualnie spójne)
                      Text(
                        'Your voice. Your journey.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'CormorantGaramond',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          height: 1.3,
                          color: Color(0xFF57351E), // Ten sam kolor co logo dla spójności
                          shadows: [
                            Shadow(
                              offset: Offset(0.5, 0.5),
                              blurRadius: 1.0,
                              color: Color.fromARGB(15, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // DOLNA CZĘŚĆ - Cytat poetycki
                      // Poetic Quote - większy akcent, oddzielony od góry
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Like a desert wanderer,\ndiscover your true self\nin the silence of your path',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'CormorantGaramond',
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                            height: 1.45,
                            color: Color(0xFF57351E),
                            shadows: [
                              Shadow(
                                offset: Offset(0.5, 0.5),
                                blurRadius: 1.5,
                                color: Color.fromARGB(20, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

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
                            'SIGN IN',
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
