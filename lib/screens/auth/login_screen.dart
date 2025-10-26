import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../models/auth_user.dart';
import '../../constants/typography.dart';
import '../../constants/colors.dart';
import '../../constants/spacing.dart';
import '../../config/env_config.dart';
import '../../widgets/auth/social_auth_buttons.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Auto-fill demo credentials in debug mode for easier testing
    if (kDebugMode && !EnvConfig.isProduction) {
      _emailController.text = 'demo@odyseya.app';
      _passwordController.text = 'DemoPass123!';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      ref.read(authStateProvider.notifier).signInWithEmail(
        email: email,
        password: password,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    // Listen for authentication success
    ref.listen(authStateProvider, (previous, next) {
      if (next.isAuthenticated && next.lastAction == AuthAction.signIn) {
        // Navigation is handled by router redirect logic
      }
    });

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

          // Content overlay
          SafeArea(
            child: Column(
              children: [
                // Debug mode indicator
                if (kDebugMode && !EnvConfig.isProduction)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: DesertColors.waterWash,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bug_report,
                          size: 14,
                          color: DesertColors.brownBramble,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'DEBUG MODE - Auto-filled',
                          style: AppTextStyles.uiSmall.copyWith(color: DesertColors.brownBramble),
                        ),
                      ],
                    ),
                  ),

                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 28,
                      ),
                      color: DesertColors.brownBramble,
                      onPressed: () => context.go('/first-download'),
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          // Title
                          Text(
                            'Sign In',
                            style: AppTextStyles.h1Large.copyWith(
                              fontSize: 40,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Subtitle
                          Text(
                            'Welcome back to your journey',
                            style: AppTextStyles.body.copyWith(color: DesertColors.treeBranch),
                          ),

                          const SizedBox(height: 40),

                          // Social Auth Buttons
                          SocialAuthButtons(
                            onAppleSignIn: () {
                              ref.read(authStateProvider.notifier).signInWithApple();
                            },
                            onGoogleSignIn: () {
                              ref.read(authStateProvider.notifier).signInWithGoogle();
                            },
                            isLoading: authState.isLoading,
                          ),

                          // Divider
                          const AuthDivider(),

                          // Email Field
                          Container(
                            height: OdyseyaSpacing.buttonHeight, // Match button height
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: AppTextStyles.bodyLarge.copyWith(color: DesertColors.brownBramble),
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  color: DesertColors.brownBramble,
                                  fontSize: 18,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                return ref.read(emailValidationProvider(value.trim()));
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Password Field
                          Container(
                            height: OdyseyaSpacing.buttonHeight, // Match button height
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              style: AppTextStyles.bodyLarge.copyWith(color: DesertColors.brownBramble),
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: DesertColors.brownBramble,
                                  fontSize: 18,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: DesertColors.brownBramble,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => _submitForm(),
                            ),
                          ),

                          if (authState.error != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.shade300),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red.shade700),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      authState.error!,
                                      style: AppTextStyles.body.copyWith(color: Colors.red.shade700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 32),

                          // Sign In Button
                          SizedBox(
                            width: double.infinity,
                            height: OdyseyaSpacing.buttonHeight,
                            child: ElevatedButton(
                              onPressed: authState.isLoading ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DesertColors.westernSunrise,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shadowColor: Colors.black.withValues(alpha: 0.08),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: authState.isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Sign In'.toUpperCase(),
                                      style: AppTextStyles.buttonLarge.copyWith(
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Don't have an account? Sign up
                          Center(
                            child: GestureDetector(
                              onTap: () => context.go('/signup'),
                              child: RichText(
                                text: TextSpan(
                                  style: AppTextStyles.body.copyWith(color: Colors.white),
                                  children: [
                                    const TextSpan(
                                      text: "Don't have an account? ",
                                    ),
                                    TextSpan(
                                      text: 'Sign up',
                                      style: AppTextStyles.body.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
