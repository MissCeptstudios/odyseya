import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../constants/spacing.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  // Layout Constants
  static const double _maxCardWidth = 480.0;
  static const double _cardBorderRadius = 24.0;
  static const double _buttonHeight = OdyseyaSpacing.buttonHeight; // 60.0 per UX framework
  static const double _buttonBorderRadius = 16.0;
  static const double _buttonBorderWidth = 1.5;

  // Spacing Constants
  static const double _logoToNameSpacing = 8.0;
  static const double _nameToQuoteSpacing = 24.0;
  static const double _quoteToButtonsSpacing = 36.0;
  static const double _buttonSpacing = 16.0;

  // Responsive Multipliers
  static const double _compassSizeMultiplier = 0.28;
  static const double _innerCompassSizeMultiplier = 0.19;
  static const double _logoWidthMultiplier = 0.42;
  static const double _verticalPaddingMultiplier = 0.05;
  static const double _horizontalPaddingMultiplier = 0.06;

  // Padding Constraints
  static const double _minHorizontalPadding = 20.0;
  static const double _maxHorizontalPadding = 32.0;
  static const double _minVerticalPadding = 16.0;
  static const double _maxVerticalPadding = 32.0;
  static const double _cardHorizontalPadding = 28.0;
  static const double _cardVerticalPadding = 36.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background image with error handling
          Image.asset(
            'assets/images/Background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: DesertColors.cardWhite,
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 64,
                    color: DesertColors.westernSunrise,
                  ),
                ),
              );
            },
          ),

          // Content overlay - centered vertically with improved layout
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive padding based on screen height
                final verticalPadding = constraints.maxHeight * _verticalPaddingMultiplier;
                final horizontalPadding = constraints.maxWidth * _horizontalPaddingMultiplier;

                // Cache screen width for responsive sizing
                final screenWidth = MediaQuery.of(context).size.width;
                final compassSize = screenWidth * _compassSizeMultiplier;
                final innerCompassSize = screenWidth * _innerCompassSizeMultiplier;
                final logoWidth = screenWidth * _logoWidthMultiplier;

                return Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding.clamp(_minHorizontalPadding, _maxHorizontalPadding),
                      vertical: verticalPadding.clamp(_minVerticalPadding, _maxVerticalPadding),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: _maxCardWidth,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: _cardHorizontalPadding,
                        vertical: _cardVerticalPadding,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(_cardBorderRadius),
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

                          // Compass Logo with accessibility
                          Semantics(
                            label: 'Odyseya compass logo',
                            child: SizedBox(
                              width: compassSize,
                              height: compassSize,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Inner compass graphic (blue crown)
                                  Image.asset(
                                    'assets/images/inside_compass.png',
                                    width: innerCompassSize,
                                    height: innerCompassSize,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                  // Outer compass ring
                                  Image.asset(
                                    'assets/images/just_compass.png',
                                    width: compassSize,
                                    height: compassSize,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.explore,
                                        size: 80,
                                        color: DesertColors.westernSunrise,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: _logoToNameSpacing),

                          // App Name Logo with accessibility
                          Semantics(
                            label: 'Odyseya',
                            child: Image.asset(
                              'assets/images/Odyseya_word.png',
                              width: logoWidth,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Text(
                                  'ODYSEYA',
                                  style: AppTextStyles.h1Display.copyWith(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: _nameToQuoteSpacing),

                          // Poetic Quote
                          Text(
                            'Like a desert wanderer,\ndiscover your true self\nin the silence of your path',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                              color: const Color(0xFF57351E),
                            ),
                          ),
                          const SizedBox(height: _quoteToButtonsSpacing),

                      // Sign In Button (Primary Button)
                      Semantics(
                        button: true,
                        label: 'Sign in to continue your journey',
                        child: Container(
                          width: double.infinity,
                          height: _buttonHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(_buttonBorderRadius),
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
                              backgroundColor: DesertColors.westernSunrise,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(_buttonBorderRadius),
                              ),
                              // Add smooth animation on press
                              animationDuration: const Duration(milliseconds: 200),
                            ),
                            child: Text(
                              'Back to Your Journey'.toUpperCase(),
                              style: AppTextStyles.buttonLarge.copyWith(
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: _buttonSpacing),

                      // Create Account Button (Functional Button)
                      Semantics(
                        button: true,
                        label: 'Create a new account to start your journey',
                        child: Container(
                          width: double.infinity,
                          height: _buttonHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(_buttonBorderRadius),
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
                              backgroundColor: DesertColors.cardWhite,
                              foregroundColor: DesertColors.brownBramble,
                              side: const BorderSide(
                                color: DesertColors.westernSunrise,
                                width: _buttonBorderWidth,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(_buttonBorderRadius),
                              ),
                              // Add smooth animation on press
                              animationDuration: const Duration(milliseconds: 200),
                            ),
                            child: Text(
                              'Start Your Journey'.toUpperCase(),
                              style: AppTextStyles.buttonLarge.copyWith(
                                color: DesertColors.brownBramble,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                        ],
                      ),
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