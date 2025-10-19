// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';

class GdprConsentScreen extends ConsumerStatefulWidget {
  const GdprConsentScreen({super.key});

  @override
  ConsumerState<GdprConsentScreen> createState() => _GdprConsentScreenState();
}

class _GdprConsentScreenState extends ConsumerState<GdprConsentScreen> {
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;
  bool _acceptMarketing = false; // Optional

  bool get _canContinue => _acceptTerms && _acceptPrivacy;

  void _showDocument(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: TextStyle(
            color: DesertColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Text(
              content,
              style: TextStyle(
                color: DesertColors.onSecondary,
                height: 1.5,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: DesertColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: DesertColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title matching reference design
              Text(
                'We care about your privacy',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: DesertColors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please accept our terms and privacy policy to create your account.',
                style: TextStyle(
                  fontSize: 16,
                  color: DesertColors.onSecondary,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 40),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Terms & Conditions
                      _buildConsentItem(
                        title: 'I accept Terms & Conditions',
                        subtitle: 'Review our terms of service and user agreement',
                        value: _acceptTerms,
                        onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                        onReadMore: () => _showDocument('Terms & Conditions', _getTermsAndConditions()),
                        isRequired: true,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Privacy Policy
                      _buildConsentItem(
                        title: 'I accept Privacy Policy',
                        subtitle: 'Understand how we collect, use, and protect your data',
                        value: _acceptPrivacy,
                        onChanged: (value) => setState(() => _acceptPrivacy = value ?? false),
                        onReadMore: () => _showDocument('Privacy Policy', _getPrivacyPolicy()),
                        isRequired: true,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Marketing consent (optional)
                      _buildConsentItem(
                        title: 'I agree to receive marketing updates',
                        subtitle: 'Get wellness tips, app updates, and personalized insights',
                        value: _acceptMarketing,
                        onChanged: (value) => setState(() => _acceptMarketing = value ?? false),
                        onReadMore: () => _showDocument('Marketing Communications', _getMarketingPolicy()),
                        isRequired: false,
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Privacy assurance
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: DesertColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: DesertColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.security,
                              color: DesertColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Your data is encrypted and secure. You can change these preferences anytime in settings.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: DesertColors.onSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Create Account button (changed from Continue)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _canContinue
                      ? () {
                          // Store consent and navigate directly to welcome screen
                          context.go('/welcome');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canContinue
                        ? DesertColors.caramelDrizzle
                        : DesertColors.surface,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    disabledBackgroundColor: DesertColors.surface,
                    disabledForegroundColor: DesertColors.onSurface.withValues(alpha: 0.5),
                  ),
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsentItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required VoidCallback onReadMore,
    required bool isRequired,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DesertColors.surface,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: value,
                    onChanged: onChanged,
                    activeColor: DesertColors.caramelDrizzle,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: DesertColors.onSurface,
                            ),
                          ),
                        ),
                        if (isRequired)
                          Text(
                            '*',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: DesertColors.onSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: onReadMore,
                      child: Text(
                        'Read more',
                        style: TextStyle(
                          fontSize: 14,
                          color: DesertColors.caramelDrizzle,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTermsAndConditions() {
    return '''Terms & Conditions for Odyseya

Last updated: ${DateTime.now().year}

1. ACCEPTANCE OF TERMS
By using Odyseya, you agree to be bound by these Terms & Conditions.

2. DESCRIPTION OF SERVICE
Odyseya is a voice journaling application that helps users track their emotional well-being through voice recordings and AI-powered insights.

3. USER RESPONSIBILITIES
- You are responsible for maintaining the confidentiality of your account
- You must provide accurate information when creating your account
- You agree to use the service for lawful purposes only

4. PRIVACY AND DATA
- Your voice recordings and journal entries are encrypted and stored securely
- We do not share your personal data with third parties without consent
- You can export or delete your data at any time

5. INTELLECTUAL PROPERTY
- You retain ownership of your journal content
- Odyseya retains rights to the application and its features

6. LIMITATION OF LIABILITY
Odyseya is provided "as is" and we make no warranties about the service's availability or accuracy.

7. TERMINATION
You may terminate your account at any time. We may terminate accounts that violate these terms.

8. CHANGES TO TERMS
We may update these terms periodically. Continued use constitutes acceptance of new terms.

For questions about these terms, contact us at legal@odyseya.com''';
  }

  String _getPrivacyPolicy() {
    return '''Privacy Policy for Odyseya

Last updated: ${DateTime.now().year}

1. INFORMATION WE COLLECT
- Account information (email, name)
- Voice recordings and transcriptions
- Usage data and preferences
- Device information

2. HOW WE USE YOUR INFORMATION
- To provide voice journaling services
- To generate AI insights about your emotional patterns
- To improve our services
- To communicate with you about your account

3. DATA SHARING
We do not sell or share your personal data with third parties, except:
- With your explicit consent
- To comply with legal obligations
- To protect our rights and safety

4. DATA SECURITY
- All data is encrypted in transit and at rest
- We use industry-standard security measures
- Access to your data is restricted to essential personnel

5. YOUR RIGHTS (GDPR)
You have the right to:
- Access your personal data
- Correct inaccurate data
- Delete your data
- Export your data
- Object to data processing
- Withdraw consent at any time

6. DATA RETENTION
- Voice recordings: Retained until you delete them
- Account data: Retained while your account is active
- Deleted data is permanently removed within 30 days

7. INTERNATIONAL TRANSFERS
Your data may be processed in countries outside your residence, always with appropriate safeguards.

8. CONTACT US
For privacy questions or to exercise your rights, contact us at privacy@odyseya.com

9. CHANGES TO POLICY
We will notify you of significant changes to this privacy policy.''';
  }

  String _getMarketingPolicy() {
    return '''Marketing Communications Policy

By opting in to marketing communications, you agree to receive:

WHAT YOU'LL RECEIVE:
- Weekly wellness tips and journaling prompts
- Updates about new features and improvements
- Personalized insights about your journaling journey
- Special offers and premium feature announcements
- Community highlights and success stories

FREQUENCY:
- Weekly newsletter (Wednesdays)
- Feature updates (as released)
- Special promotions (monthly maximum)

YOUR CONTROL:
- Unsubscribe at any time via email links
- Update preferences in your account settings
- Choose which types of communications you receive

PRIVACY:
- We never share your email with third parties
- Marketing is based only on your app usage patterns
- Your journal content is never used in marketing

You can change these preferences at any time in your account settings or by contacting us at marketing@odyseya.com''';
  }
}