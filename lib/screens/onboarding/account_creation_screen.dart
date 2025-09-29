import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/onboarding/onboarding_layout.dart';

class AccountCreationScreen extends ConsumerWidget {
  const AccountCreationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

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
              borderRadius: BorderRadius.circular(12),
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
          borderRadius: BorderRadius.circular(12),
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
          borderRadius: BorderRadius.circular(12),
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
    // TODO: Implement email sign-up modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email sign-up coming soon!')),
    );
  }

  void _signUpWithGoogle() {
    // TODO: Implement Google sign-in
    debugPrint('Google sign-in');
  }

  void _signUpWithApple() {
    // TODO: Implement Apple sign-in
    debugPrint('Apple sign-in');
  }

  void _showTerms() {
    // TODO: Show terms of service
    debugPrint('Show terms');
  }

  void _showPrivacyPolicy() {
    // TODO: Show privacy policy
    debugPrint('Show privacy policy');
  }
}