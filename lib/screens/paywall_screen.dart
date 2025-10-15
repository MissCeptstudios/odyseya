import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';
import '../providers/subscription_provider.dart';
import '../widgets/common/app_background.dart';

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

    return AppBackground(
      useOverlay: true,
      overlayOpacity: 0.03,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: subscriptionState.isLoading && offerings == null
              ? _buildLoadingState()
              : offerings?.current == null
                  ? _buildErrorState()
                  : _buildContent(offerings!.current!),
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
              color: DesertColors.taupe,
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
                color: DesertColors.deepBrown,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection and try again.',
              style: OdyseyaTypography.body.copyWith(
                color: DesertColors.taupe,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(subscriptionProvider.notifier).refreshSubscriptionStatus();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DesertColors.roseSand,
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
                style: TextStyle(color: DesertColors.taupe),
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
                  color: DesertColors.deepBrown,
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
              color: DesertColors.deepBrown,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Subtitle
          Text(
            'Get unlimited access to all features and insights',
            style: OdyseyaTypography.bodyLarge.copyWith(
              color: DesertColors.taupe,
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
        color: DesertColors.offWhite.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: DesertColors.dustyBlue.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Premium Features',
            style: OdyseyaTypography.h2.copyWith(
              color: DesertColors.deepBrown,
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
              color: DesertColors.roseSand.withOpacity(0.2),
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
                    color: DesertColors.deepBrown,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: OdyseyaTypography.ui.copyWith(
                    color: DesertColors.taupe,
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
              color: DesertColors.deepBrown,
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
              ? DesertColors.roseSand.withOpacity(0.1)
              : DesertColors.offWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? DesertColors.roseSand
                : DesertColors.dustyBlue.withOpacity(0.3),
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
                      : DesertColors.taupe,
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
                          color: DesertColors.deepBrown,
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
                      color: DesertColors.taupe,
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
                color: DesertColors.deepBrown,
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
                backgroundColor: DesertColors.roseSand,
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
              color: DesertColors.taupe,
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
                  color: DesertColors.taupe,
                  fontSize: 11,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Open terms of service
                },
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
                  color: DesertColors.taupe,
                  fontSize: 11,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Open privacy policy
                },
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
}
