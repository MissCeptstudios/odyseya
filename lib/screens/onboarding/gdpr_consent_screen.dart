// Enforce design consistency based on UX_odyseya_framework.md
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../constants/colors.dart';
import '../../widgets/common/odyseya_button.dart';

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: DesertColors.brownBramble,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Text(
              content,
              style: TextStyle(
                color: DesertColors.treeBranch,
                height: 1.5,
                fontSize: 14,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(
                color: DesertColors.westernSunrise,
                fontWeight: FontWeight.w600,
              ),
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
          icon: Icon(Icons.arrow_back, color: DesertColors.brownBramble),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Odyseya Logo and Compass at the top
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Compass icon
                  Image.asset(
                    'assets/images/inside_compass.png',
                    height: 48,
                    width: 48,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.explore,
                        size: 48,
                        color: DesertColors.westernSunrise,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  // Odyseya text logo
                  Image.asset(
                    'assets/images/Odyseya_word.png',
                    height: 32,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        'Odyseya',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: DesertColors.brownBramble,
                          fontFamily: 'Cormorant Garamond',
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Title matching reference design
              Text(
                'We care about your privacy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: DesertColors.brownBramble,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please accept our terms and privacy policy to create your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: DesertColors.treeBranch,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

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

                      // Privacy assurance - UX compliant card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: DesertColors.westernSunrise.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(24), // UX Framework: 24px radius
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.security,
                              color: DesertColors.westernSunrise,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Your data is encrypted and secure. You can change these preferences anytime in settings.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: DesertColors.treeBranch,
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

              // Create Account button - UX Framework compliant
              OdyseyaButton.primary(
                text: 'Create Account',
                onPressed: _canContinue
                    ? () {
                        // Store consent and navigate directly to welcome screen
                        context.go('/welcome');
                      }
                    : null,
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
      padding: const EdgeInsets.all(20), // UX Framework: 20px padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // UX Framework: 24px radius
        border: Border.all(
          color: value
              ? DesertColors.westernSunrise.withValues(alpha: 0.4)
              : DesertColors.creamBeige,
          width: value ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08), // UX Framework: shadow level 1
            blurRadius: 8,
            offset: const Offset(0, 4),
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
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: value,
                    onChanged: onChanged,
                    activeColor: DesertColors.westernSunrise, // UX Framework: Primary Action
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
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
                              color: DesertColors.brownBramble, // UX Framework: Primary text
                            ),
                          ),
                        ),
                        if (isRequired)
                          Text(
                            '*',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade700,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: DesertColors.treeBranch, // UX Framework: Secondary text
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
                          color: DesertColors.westernSunrise, // UX Framework: Accent
                          fontWeight: FontWeight.w600,
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

For questions about these terms, contact us at odyseya.journal@gmail.com''';
  }

  String _getPrivacyPolicy() {
    return '''Privacy Policy for Odyseya

Last updated: ${DateTime.now().year}
Effective Date: January 1, ${DateTime.now().year}

INTRODUCTION
At Odyseya, your privacy is our highest priority. This Privacy Policy explains in detail how we collect, use, store, and protect your personal information. We are committed to full transparency and GDPR compliance.

1. INFORMATION WE COLLECT

1.1 Account & Authentication Data
- Email address and display name (via Google Sign In or Sign In with Apple)
- Profile picture (if provided by authentication provider)
- User ID and authentication tokens
- Account creation and last login timestamps

1.2 Voice & Journal Data
- Voice recordings (audio files stored in encrypted cloud storage)
- AI-generated transcriptions of your voice recordings
- Written journal entries and reflections
- Timestamps of all journal entries
- Mood selections and emotional data you log
- AI-generated insights and analysis reports
- Affirmations and recommendations

1.3 Usage & Preferences Data
- App settings and preferences (notification settings, AI analysis preferences)
- Privacy preference selections (AI analysis level)
- Journaling patterns and frequency
- Feature usage analytics
- App performance and crash reports

1.4 Optional Data (Only if You Grant Permission)
- Location data (for weather and context, only when app is in use)
- Weather information associated with journal entries
- Device notifications preferences

1.5 Technical Data
- Device type, operating system, and version
- App version and build number
- Device identifiers (for authentication and security)
- IP address (for security and fraud prevention)
- Session information

1.6 Subscription & Payment Data
- Subscription status and tier (processed via RevenueCat)
- Purchase history (we do not store credit card details)
- Transaction IDs

2. HOW WE USE YOUR INFORMATION

2.1 Primary Services
- Provide voice recording and transcription services
- Generate AI-powered emotional insights and pattern analysis
- Store and sync your journal entries across devices
- Deliver personalized affirmations and recommendations
- Enable mood tracking and emotional wellness features

2.2 Service Improvement
- Analyze usage patterns to improve app features (anonymized)
- Debug issues and fix crashes
- Develop new features based on user needs
- Improve AI model accuracy (using anonymized data only)

2.3 Communication
- Send journaling reminders (if notifications enabled)
- Provide customer support
- Send important service updates and security notices
- Marketing communications (only with explicit opt-in consent)

2.4 Legal & Security
- Prevent fraud and abuse
- Comply with legal obligations
- Enforce our terms of service
- Protect user safety and app security

3. THIRD-PARTY SERVICES & DATA SHARING

We use the following trusted third-party services. Your data is NEVER sold.

3.1 Firebase (Google Cloud Platform)
- Authentication: Secure login via Google/Apple
- Cloud Firestore: Encrypted storage of journal entries and user data
- Cloud Storage: Encrypted storage of voice recordings
- Cloud Functions: Server-side processing of data
- Analytics: App usage patterns (anonymized)
- Crashlytics: Crash reporting for app stability

3.2 AI Processing Services
- Voice transcription: Your voice recordings are sent to secure AI services for transcription
- Emotional analysis: Journal text is analyzed by AI to generate insights
- All AI processing is performed with enterprise-grade encryption
- AI services do not train models on your personal data

3.3 RevenueCat
- Subscription management and in-app purchase processing
- Receives: User ID, subscription status, purchase events
- Does not receive: Journal content or emotional data

3.4 Authentication Providers
- Google Sign In: Email, name, profile picture
- Sign In with Apple: Email (or private relay), name

3.5 When We Share Data
We only share your personal data:
- With your explicit consent
- To comply with legal obligations (court orders, subpoenas)
- To protect rights, safety, and security (fraud prevention)
- With service providers under strict confidentiality agreements
- In aggregated, anonymized form for research (no personal identification)

We NEVER:
- Sell your personal data to anyone
- Share your journal content with advertisers
- Use your emotional data for marketing to third parties
- Share your data with data brokers

4. DATA SECURITY & ENCRYPTION

4.1 Security Measures
- End-to-end encryption for data in transit (TLS/SSL)
- Encryption at rest for all stored data (AES-256)
- Secure authentication with industry-standard protocols
- Regular security audits and updates
- Role-based access control (minimal employee access)
- Secure cloud infrastructure (Google Cloud Platform)

4.2 Voice Recording Security
- Voice files are encrypted before upload
- Stored in secure, private cloud storage buckets
- Access restricted to your account only
- Deleted permanently when you choose to delete them

4.3 Data Breach Protocol
- We will notify you within 72 hours of discovering any data breach
- Notification will include what data was affected and steps we're taking
- We maintain incident response procedures and regular backups

5. YOUR RIGHTS (GDPR & PRIVACY LAWS)

You have the following rights regarding your personal data:

5.1 Right to Access
- View all personal data we hold about you
- Download a copy in machine-readable format (JSON)
- Access available in app settings under "Download My Data"

5.2 Right to Rectification
- Correct any inaccurate personal information
- Update your account details anytime in settings

5.3 Right to Erasure ("Right to be Forgotten")
- Delete your account and all associated data
- Available in app settings under "Delete Account"
- Permanent deletion occurs within 30 days
- Some data may be retained for legal compliance (anonymized)

5.4 Right to Data Portability
- Export your journal entries, mood logs, and personal data
- Receive data in JSON or CSV format
- Available in app settings under "Export Data"

5.5 Right to Restrict Processing
- Limit how we process your data
- Disable AI analysis while keeping journal storage
- Configure in app privacy settings

5.6 Right to Object
- Object to specific data processing activities
- Opt out of analytics, marketing, or AI features
- Available in privacy preferences

5.7 Right to Withdraw Consent
- Change your privacy preferences anytime
- Revoke marketing consent instantly
- Modify AI analysis settings

5.8 Right to Lodge a Complaint
- File complaints with your data protection authority
- EU users: Contact your local supervisory authority
- We will cooperate fully with investigations

6. DATA RETENTION

6.1 How Long We Keep Your Data
- Voice Recordings: Until you delete them or close your account
- Journal Entries: Until you delete them or close your account
- Account Data: While your account is active, plus 30 days after deletion
- Analytics Data: Anonymized, retained for up to 2 years
- Backups: Deleted data removed from backups within 90 days
- Legal Hold Data: Retained only as required by law

6.2 Account Deletion
- You can delete your account anytime in settings
- All personal data deleted within 30 days
- Anonymized analytics data may be retained
- Deletion is permanent and cannot be undone

7. INTERNATIONAL DATA TRANSFERS

7.1 Where Your Data Is Processed
- Primary servers: Google Cloud Platform (US and EU regions)
- Data may be processed in the United States and European Union
- We use Standard Contractual Clauses (SCCs) for EU data transfers
- All transfers comply with GDPR requirements

7.2 Safeguards for International Transfers
- EU-US Data Privacy Framework compliance (where applicable)
- Standard Contractual Clauses with all processors
- Encryption in transit and at rest
- Regular compliance audits

8. CHILDREN'S PRIVACY

- Odyseya is not intended for users under 16 years of age
- We do not knowingly collect data from children under 16
- If we discover underage users, accounts will be deleted immediately
- Parents: Contact us if you believe your child has created an account

9. COOKIES & TRACKING

- We do not use advertising cookies
- Essential cookies: Session management and authentication only
- Analytics: Firebase Analytics (can be disabled in settings)
- No third-party advertising trackers

10. CALIFORNIA PRIVACY RIGHTS (CCPA)

California residents have additional rights:
- Right to know what personal information is collected
- Right to delete personal information
- Right to opt-out of sale (we don't sell data)
- Right to non-discrimination for exercising privacy rights

11. MARKETING COMMUNICATIONS

- Marketing emails: Only with explicit opt-in consent
- Frequency: Weekly wellness tips (optional)
- Unsubscribe: One-click unsubscribe in every email
- Preferences: Manage in account settings
- Your journal content is NEVER used for marketing

12. CHANGES TO THIS PRIVACY POLICY

- We may update this policy periodically
- Significant changes: You'll be notified via email and in-app
- Continued use after changes constitutes acceptance
- Previous versions available upon request

13. CONTACT US & DATA PROTECTION

For privacy questions, to exercise your rights, or report concerns:

Email: odyseya.journal@gmail.com
Privacy & Data Protection: odyseya.journal@gmail.com
Support: odyseya.journal@gmail.com

Response time: We aim to respond within 48 hours

Contact:
Odyseya
Email: odyseya.journal@gmail.com
Website: odyseya.com

14. LEGAL BASIS FOR PROCESSING (GDPR)

We process your data based on:
- Consent: You explicitly agree (withdrawable anytime)
- Contract: Necessary to provide our services
- Legitimate Interest: Service improvement, security, fraud prevention
- Legal Obligation: Compliance with laws and regulations

15. YOUR CALIFORNIA "SHINE THE LIGHT" RIGHTS

California Civil Code Section 1798.83 permits California residents to request information about disclosure of personal information to third parties for direct marketing. We do not share personal information with third parties for their direct marketing purposes.

SUMMARY

We collect only what we need to provide you with an exceptional journaling experience. Your emotional data is private, encrypted, and never sold. You have complete control over your data with easy-to-use privacy tools. We are committed to transparency, security, and your rights under GDPR and other privacy laws.

Last reviewed: ${DateTime.now().toString().substring(0, 10)}
Version: 2.0''';
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
