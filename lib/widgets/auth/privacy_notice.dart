import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/typography.dart';

class PrivacyNotice extends StatelessWidget {
  const PrivacyNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DesertColors.waterWash.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: DesertColors.waterWash.withValues(alpha: 0.3),
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
                    'Your data is encrypted and secure',
                    style: AppTextStyles.ui.copyWith(color: DesertColors.onSurface),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.captionSmall.copyWith(color: DesertColors.onSecondary, height: 1.4),
              children: [
                const TextSpan(text: 'By continuing, you agree to our '),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => _showTermsOfService(context),
                    child: Text(
                      'Terms of Service',
                      style: AppTextStyles.captionSmall.copyWith(color: DesertColors.primary),
                    ),
                  ),
                ),
                const TextSpan(text: ' and '),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () => _showPrivacyPolicy(context),
                    child: Text(
                      'Privacy Policy',
                      style: AppTextStyles.captionSmall.copyWith(color: DesertColors.primary),
                    ),
                  ),
                ),
                const TextSpan(text: '. Your emotional data is never shared or sold.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesertColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Terms of Service',
          style: AppTextStyles.body.copyWith(color: DesertColors.onSurface),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Text(
              _getTermsOfServiceText(),
              style: AppTextStyles.body.copyWith(color: DesertColors.onSecondary, height: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: AppTextStyles.body.copyWith(color: DesertColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesertColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Privacy Policy',
          style: AppTextStyles.body.copyWith(color: DesertColors.onSurface),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Text(
              _getPrivacyPolicyText(),
              style: AppTextStyles.body.copyWith(color: DesertColors.onSecondary, height: 1.5),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: AppTextStyles.body.copyWith(color: DesertColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  String _getTermsOfServiceText() {
    return '''
Odyseya Terms of Service

Last updated: ${DateTime.now().toString().substring(0, 10)}

1. ACCEPTANCE OF TERMS
By accessing and using Odyseya, you accept and agree to be bound by the terms and provision of this agreement.

2. DESCRIPTION OF SERVICE
Odyseya is an emotional voice journaling application that provides AI-powered insights to help users understand their emotional patterns and improve their mental wellness.

3. USER ACCOUNTS
- You are responsible for maintaining the confidentiality of your account credentials
- You agree to provide accurate and complete information when creating your account
- You are responsible for all activities that occur under your account

4. PRIVACY AND DATA PROTECTION
- Your journal entries and personal data are encrypted and stored securely
- We do not share, sell, or distribute your personal emotional data to third parties
- You maintain ownership of all content you create in the app

5. AI ANALYSIS
- AI insights are provided for informational purposes only
- These insights are not a substitute for professional medical or mental health advice
- Always consult with qualified healthcare providers for medical concerns

6. ACCEPTABLE USE
- Use the service only for lawful purposes
- Do not upload content that is harmful, threatening, or inappropriate
- Respect the privacy and rights of other users

7. TERMINATION
- You may terminate your account at any time
- We reserve the right to terminate accounts that violate these terms
- Upon termination, you can export your data before deletion

8. LIMITATION OF LIABILITY
Odyseya is provided "as is" without warranties of any kind. We are not liable for any damages resulting from use of the service.

9. CHANGES TO TERMS
We may update these terms from time to time. Continued use of the service constitutes acceptance of updated terms.

For questions about these terms, please contact us at odyseya.journal@gmail.com
''';
  }

  String _getPrivacyPolicyText() {
    return '''
Odyseya Privacy Policy

Last updated: ${DateTime.now().toString().substring(0, 10)}

COMMITMENT TO PRIVACY
At Odyseya, your privacy is our highest priority. This policy explains how we collect, use, and protect your personal information.

INFORMATION WE COLLECT
- Account information (email, name, profile picture)
- Voice recordings and transcriptions from your journal entries
- Mood selections and emotional data you provide
- Usage analytics to improve the app experience
- Device information and crash reports

HOW WE USE YOUR INFORMATION
- Provide AI-powered emotional insights and patterns
- Transcribe your voice recordings into text
- Send you reminders and notifications (if enabled)
- Improve our AI models and app functionality
- Provide customer support

DATA SECURITY
- All data is encrypted in transit and at rest using industry-standard encryption
- Voice recordings are processed securely and deleted after transcription
- We use Firebase's secure infrastructure for data storage
- Access to your data is strictly limited to essential personnel

THIRD-PARTY SERVICES
- Firebase (Google): Secure data storage and authentication
- AI Processing: Anonymous processing for transcription and insights
- Analytics: Anonymized usage data to improve the app
- No emotional data is shared with advertising networks

YOUR RIGHTS
- Access and download your data at any time
- Delete your account and all associated data
- Opt out of analytics and notifications
- Request data portability to other services
- Update or correct your personal information

GDPR COMPLIANCE
For users in the EU, we provide additional rights under GDPR:
- Right to be forgotten (complete data deletion)
- Right to data portability
- Right to restrict processing
- Right to object to processing

CHILDREN'S PRIVACY
Odyseya is not intended for users under 13. We do not knowingly collect data from children under 13.

DATA RETENTION
- Journal entries: Kept until you delete them or close your account
- Account data: Deleted within 30 days of account closure
- Analytics: Anonymized data may be retained for product improvement

INTERNATIONAL TRANSFERS
Your data may be processed in countries where our service providers operate, always with appropriate safeguards.

CONTACT US
For privacy questions or to exercise your rights:
- Email: odyseya.journal@gmail.com
- Privacy & Support: odyseya.journal@gmail.com

This policy may be updated periodically. We will notify you of significant changes.
''';
  }
}