// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';
import '../../constants/spacing.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/onboarding/onboarding_layout.dart';

class AccountCreationScreen extends ConsumerStatefulWidget {
  const AccountCreationScreen({super.key});

  @override
  ConsumerState<AccountCreationScreen> createState() => _AccountCreationScreenState();
}

class _AccountCreationScreenState extends ConsumerState<AccountCreationScreen> {
  @override
  Widget build(BuildContext context) {
    final onboardingNotifier = ref.read(onboardingProvider.notifier);
    final authNotifier = ref.read(authStateProvider.notifier);

    // Listen to auth state changes
    ref.listen(authStateProvider, (previous, next) {
      if (next.isAuthenticated && !next.isLoading) {
        // User successfully signed in, continue onboarding
        onboardingNotifier.nextStep();
      }

      if (next.error != null && !next.isLoading) {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: DesertColors.terracotta,
          ),
        );
        authNotifier.clearError();
      }
    });

    return OnboardingLayout(
      title: 'Create your account',
      subtitle: 'Secure your journal entries and sync across devices with an Odyseya account.',
      onNext: () => onboardingNotifier.nextStep(),
      nextButtonText: 'Continue',
      child: Column(
        children: [
          _buildSignUpOption(
            icon: Icons.email,
            title: 'Continue with Email',
            subtitle: 'Create an account with your email address',
            onTap: () => _showEmailSignUp(context),
            isPrimary: true,
          ),
          
          const SizedBox(height: 12),
          
          _buildSignUpOption(
            icon: Icons.g_mobiledata,
            title: 'Continue with Google',
            subtitle: 'Quick sign-up with your Google account',
            onTap: () => _signUpWithGoogle(),
          ),
          
          const SizedBox(height: 12),
          
          _buildSignUpOption(
            icon: Icons.apple,
            title: 'Continue with Apple',
            subtitle: 'Sign in with your Apple ID',
            onTap: () => _signUpWithApple(),
          ),
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'or',
                  style: TextStyle(
                    color: DesertColors.onSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildGuestOption(onboardingNotifier),
          
          const SizedBox(height: 32),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DesertColors.waterWash.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: DesertColors.waterWash.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Your data is protected',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: DesertColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'End-to-end encryption • GDPR compliant • Never sold or shared',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: DesertColors.onSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'By continuing, you agree to our ',
                style: TextStyle(
                  fontSize: 12,
                  color: DesertColors.onSecondary,
                ),
              ),
              GestureDetector(
                onTap: () => _showTerms(),
                child: Text(
                  'Terms',
                  style: TextStyle(
                    fontSize: 12,
                    color: DesertColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                ' and ',
                style: TextStyle(
                  fontSize: 12,
                  color: DesertColors.onSecondary,
                ),
              ),
              GestureDetector(
                onTap: () => _showPrivacyPolicy(),
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 12,
                    color: DesertColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPrimary ? DesertColors.primary : DesertColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isPrimary 
                ? DesertColors.primary 
                : DesertColors.waterWash.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isPrimary 
                    ? Colors.white.withValues(alpha: 0.2)
                    : DesertColors.waterWash.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isPrimary ? Colors.white : DesertColors.onSurface,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isPrimary ? Colors.white : DesertColors.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isPrimary 
                          ? Colors.white.withValues(alpha: 0.8)
                          : DesertColors.onSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isPrimary ? Colors.white : DesertColors.onSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestOption(OnboardingNotifier onboardingNotifier) {
    return GestureDetector(
      onTap: () => onboardingNotifier.nextStep(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: DesertColors.accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: DesertColors.accent.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.person_outline,
              color: DesertColors.accent,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Continue as guest',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: DesertColors.onSurface,
                    ),
                  ),
                  Text(
                    'Start journaling now, create account later',
                    style: TextStyle(
                      fontSize: 13,
                      color: DesertColors.onSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: DesertColors.onSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showEmailSignUp(BuildContext context) {
    // Show email sign-up modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EmailSignUpModal(
        onSignUp: (email, password, name) async {
          final authNotifier = ref.read(authStateProvider.notifier);
          await authNotifier.signUpWithEmail(
            email: email,
            password: password,
            fullName: name,
          );
        },
      ),
    );
  }

  void _signUpWithGoogle() async {
    final authNotifier = ref.read(authStateProvider.notifier);
    await authNotifier.signInWithGoogle();
  }

  void _signUpWithApple() async {
    final authNotifier = ref.read(authStateProvider.notifier);
    await authNotifier.signInWithApple();
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesertColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OdyseyaSpacing.radiusCard),
        ),
        title: Text(
          'Terms of Service',
          style: OdyseyaTypography.h2.copyWith(
            color: DesertColors.onSurface,
          ),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Terms and conditions content here...\n\n'
            'By using Odyseya, you agree to our terms and conditions.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: OdyseyaTypography.button.copyWith(
                color: DesertColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesertColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OdyseyaSpacing.radiusCard),
        ),
        title: Text(
          'Privacy Policy',
          style: OdyseyaTypography.h2.copyWith(
            color: DesertColors.onSurface,
          ),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Privacy policy content here...\n\n'
            'We respect your privacy and protect your personal data.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: OdyseyaTypography.button.copyWith(
                color: DesertColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Email Sign-Up Modal Widget
class _EmailSignUpModal extends StatefulWidget {
  final Future<void> Function(String email, String password, String name) onSignUp;

  const _EmailSignUpModal({required this.onSignUp});

  @override
  State<_EmailSignUpModal> createState() => _EmailSignUpModalState();
}

class _EmailSignUpModalState extends State<_EmailSignUpModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await widget.onSignUp(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DesertColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: DesertColors.onSecondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  'Create Account',
                  style: OdyseyaTypography.h2.copyWith(
                    color: DesertColors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Start your journaling journey',
                  style: OdyseyaTypography.body.copyWith(
                    color: DesertColors.onSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your name',
                    filled: true,
                    fillColor: DesertColors.waterWash.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'your@email.com',
                    filled: true,
                    fillColor: DesertColors.waterWash.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'At least 6 characters',
                    filled: true,
                    fillColor: DesertColors.waterWash.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter password',
                    filled: true,
                    fillColor: DesertColors.waterWash.withValues(alpha: 0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Sign Up Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesertColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Create Account',
                          style: OdyseyaTypography.button,
                        ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}