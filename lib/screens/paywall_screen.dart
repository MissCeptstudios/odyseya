import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';
import '../providers/subscription_provider.dart';
import '../widgets/common/app_background.dart';
import '../widgets/navigation/top_navigation_bar.dart';

/// Paywall screen showing premium features and subscription options
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  int _selectedPackageIndex = 1; // Default to annual (best value)
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionProvider);
    final offerings = subscriptionState.offerings;

    // If user is already premium, show success and navigate back
    if (subscriptionState.isPremium) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.pop();
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const OdyseyaTopNavigationBar(),
            Expanded(
              child: AppBackground(
                useOverlay: true,
                overlayOpacity: 0.03,
                child: subscriptionState.isLoading && offerings == null
                    ? _buildLoadingState()
                    : offerings?.current == null
                        ? _buildErrorState()
                        : _buildContent(offerings!.current!),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(DesertColors.roseSand),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading subscription options...',
            style: OdyseyaTypography.body.copyWith(
              color: DesertColors.treeBranch,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: DesertColors.terracotta,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load subscription options',
              style: OdyseyaTypography.h2.copyWith(
                color: DesertColors.brownBramble,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection and try again.',
              style: OdyseyaTypography.body.copyWith(
                color: DesertColors.treeBranch,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(subscriptionProvider.notifier).refreshSubscriptionStatus();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DesertColors.westernSunrise,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.pop(),
              child: Text(
                'Go Back',
                style: TextStyle(color: DesertColors.treeBranch),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(Offering offering) {
    final packages = offering.availablePackages;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Premium Features List
          _buildPremiumFeatures(),

          // Subscription Packages
          _buildSubscriptionPackages(packages),

          // Purchase Button
          _buildPurchaseButton(packages),

          // Footer (Restore & Terms)
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.close,
                  color: DesertColors.brownBramble,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Premium Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  DesertColors.roseSand,
                  DesertColors.dustyBlue,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'PREMIUM',
                  style: OdyseyaTypography.button.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            'Unlock Your Full\nEmotional Journey',
            style: OdyseyaTypography.h1.copyWith(
              color: DesertColors.brownBramble,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Subtitle
          Text(
            'Get unlimited access to all features and insights',
            style: OdyseyaTypography.bodyLarge.copyWith(
              color: DesertColors.treeBranch,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumFeatures() {
    final features = [
      {
        'icon': Icons.edit_note,
        'title': 'Unlimited Entries',
        'description': 'Journal as much as you need without limits',
      },
      {
        'icon': Icons.psychology,
        'title': 'Advanced AI Insights',
        'description': 'Deep emotional analysis and personalized guidance',
      },
      {
        'icon': Icons.mic,
        'title': 'Voice Transcription',
        'description': 'Unlimited voice-to-text journaling',
      },
      {
        'icon': Icons.analytics,
        'title': 'Advanced Analytics',
        'description': 'Track your emotional patterns over time',
      },
      {
        'icon': Icons.download,
        'title': 'Export & Backup',
        'description': 'Download your journal entries anytime',
      },
      {
        'icon': Icons.support_agent,
        'title': 'Priority Support',
        'description': 'Get help from our team when you need it',
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DesertColors.offWhite.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: DesertColors.dustyBlue.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Premium Features',
            style: OdyseyaTypography.h2.copyWith(
              color: DesertColors.brownBramble,
            ),
          ),
          const SizedBox(height: 20),
          ...features.map((feature) => _buildFeatureItem(
                icon: feature['icon'] as IconData,
                title: feature['title'] as String,
                description: feature['description'] as String,
              )),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: DesertColors.roseSand.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: DesertColors.roseSand,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: OdyseyaTypography.button.copyWith(
                    color: DesertColors.brownBramble,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: OdyseyaTypography.ui.copyWith(
                    color: DesertColors.treeBranch,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionPackages(List<Package> packages) {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Your Plan',
            style: OdyseyaTypography.h2.copyWith(
              color: DesertColors.brownBramble,
            ),
          ),
          const SizedBox(height: 16),
          ...packages.asMap().entries.map((entry) {
            final index = entry.key;
            final package = entry.value;
            return _buildPackageCard(package, index);
          }),
        ],
      ),
    );
  }

  Widget _buildPackageCard(Package package, int index) {
    final isSelected = _selectedPackageIndex == index;
    final isAnnual = package.identifier.contains('annual') ||
                     package.identifier.contains('yearly') ||
                     package.packageType == PackageType.annual;

    // Calculate savings for annual plan
    String? savingsText;
    if (isAnnual && package.storeProduct.priceString.isNotEmpty) {
      savingsText = 'Save 40%';
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPackageIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? DesertColors.roseSand.withValues(alpha: 0.1)
              : DesertColors.offWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? DesertColors.roseSand
                : DesertColors.dustyBlue.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio Button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? DesertColors.roseSand
                      : DesertColors.treeBranch,
                  width: 2,
                ),
                color: isSelected ? DesertColors.roseSand : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),

            const SizedBox(width: 16),

            // Package Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        package.storeProduct.title.replaceAll('(Odyseya)', '').trim(),
                        style: OdyseyaTypography.button.copyWith(
                          color: DesertColors.brownBramble,
                          fontSize: 18,
                        ),
                      ),
                      if (savingsText != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: DesertColors.sageGreen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            savingsText,
                            style: OdyseyaTypography.ui.copyWith(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    package.storeProduct.description,
                    style: OdyseyaTypography.ui.copyWith(
                      color: DesertColors.treeBranch,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Price
            Text(
              package.storeProduct.priceString,
              style: OdyseyaTypography.h2.copyWith(
                color: DesertColors.brownBramble,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseButton(List<Package> packages) {
    final subscriptionState = ref.watch(subscriptionProvider);
    final hasError = subscriptionState.error != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                subscriptionState.error!,
                style: OdyseyaTypography.ui.copyWith(
                  color: DesertColors.terracotta,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isProcessing || packages.isEmpty
                  ? null
                  : () => _handlePurchase(packages[_selectedPackageIndex]),
              style: ElevatedButton.styleFrom(
                backgroundColor: DesertColors.westernSunrise,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Start Premium',
                      style: OdyseyaTypography.button.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Cancel anytime from your device settings',
            style: OdyseyaTypography.ui.copyWith(
              color: DesertColors.treeBranch,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Restore Purchases
          TextButton(
            onPressed: _isProcessing ? null : _handleRestore,
            child: Text(
              'Restore Purchases',
              style: OdyseyaTypography.button.copyWith(
                color: DesertColors.dustyBlue,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Terms & Privacy
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text(
                'By subscribing, you agree to our ',
                style: OdyseyaTypography.ui.copyWith(
                  color: DesertColors.treeBranch,
                  fontSize: 11,
                ),
              ),
              GestureDetector(
                onTap: () => _showTermsOfService(context),
                child: Text(
                  'Terms of Service',
                  style: OdyseyaTypography.ui.copyWith(
                    color: DesertColors.dustyBlue,
                    fontSize: 11,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                ' and ',
                style: OdyseyaTypography.ui.copyWith(
                  color: DesertColors.treeBranch,
                  fontSize: 11,
                ),
              ),
              GestureDetector(
                onTap: () => _showPrivacyPolicy(context),
                child: Text(
                  'Privacy Policy',
                  style: OdyseyaTypography.ui.copyWith(
                    color: DesertColors.dustyBlue,
                    fontSize: 11,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _handlePurchase(Package package) async {
    setState(() {
      _isProcessing = true;
    });

    final success = await ref
        .read(subscriptionProvider.notifier)
        .purchasePackage(package);

    setState(() {
      _isProcessing = false;
    });

    if (success && mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Welcome to Premium! 🎉'),
          backgroundColor: DesertColors.sageGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      // Navigate back
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          context.pop();
        }
      });
    }
  }

  Future<void> _handleRestore() async {
    setState(() {
      _isProcessing = true;
    });

    final success = await ref
        .read(subscriptionProvider.notifier)
        .restorePurchases();

    setState(() {
      _isProcessing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Purchases restored successfully!'
                : 'No purchases found to restore',
          ),
          backgroundColor: success
              ? DesertColors.sageGreen
              : DesertColors.terracotta,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      if (success) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            context.pop();
          }
        });
      }
    }
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesertColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          'Terms of Service',
          style: OdyseyaTypography.h2.copyWith(
            color: DesertColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Text(
              _getTermsOfService(),
              style: OdyseyaTypography.body.copyWith(
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
              style: OdyseyaTypography.button.copyWith(
                color: DesertColors.primary,
              ),
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
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          'Privacy Policy',
          style: OdyseyaTypography.h2.copyWith(
            color: DesertColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Text(
              _getPrivacyPolicy(),
              style: OdyseyaTypography.body.copyWith(
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
              style: OdyseyaTypography.button.copyWith(
                color: DesertColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTermsOfService() {
    return '''Terms & Conditions for Odyseya

Last updated: ${DateTime.now().year}

1. ACCEPTANCE OF TERMS
By using Odyseya, you agree to be bound by these Terms & Conditions.

2. DESCRIPTION OF SERVICE
Odyseya is a voice journaling application that helps users track their emotional well-being through voice recordings and AI-powered insights.

3. SUBSCRIPTION TERMS
- Subscriptions automatically renew unless cancelled at least 24 hours before the end of the current period
- Account will be charged for renewal within 24 hours prior to the end of the current period
- Subscriptions may be managed and auto-renewal turned off in Account Settings
- Any unused portion of a free trial period will be forfeited when purchasing a subscription

4. USER RESPONSIBILITIES
- You are responsible for maintaining the confidentiality of your account
- You must provide accurate information when creating your account
- You agree to use the service for lawful purposes only

5. PRIVACY AND DATA
- Your voice recordings and journal entries are encrypted and stored securely
- We do not share your personal data with third parties without consent
- You can export or delete your data at any time

6. INTELLECTUAL PROPERTY
- You retain ownership of your journal content
- Odyseya retains rights to the application and its features

7. LIMITATION OF LIABILITY
Odyseya is provided "as is" and we make no warranties about the service's availability or accuracy.

8. TERMINATION
You may terminate your account at any time. We may terminate accounts that violate these terms.

9. CHANGES TO TERMS
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
}
