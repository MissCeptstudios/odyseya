import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/revenue_cat_service.dart';

/// Premium features that can be gated
enum PremiumFeature {
  unlimitedEntries,
  aiInsights,
  voiceTranscription,
  exportData,
  customThemes,
  advancedAnalytics,
  prioritySupport,
}

/// Subscription state
class SubscriptionState {
  final bool isPremium;
  final bool isLoading;
  final CustomerInfo? customerInfo;
  final Offerings? offerings;
  final String? error;
  final DateTime? expirationDate;
  final bool willRenew;

  const SubscriptionState({
    this.isPremium = false,
    this.isLoading = false,
    this.customerInfo,
    this.offerings,
    this.error,
    this.expirationDate,
    this.willRenew = false,
  });

  SubscriptionState copyWith({
    bool? isPremium,
    bool? isLoading,
    CustomerInfo? customerInfo,
    Offerings? offerings,
    String? error,
    DateTime? expirationDate,
    bool? willRenew,
  }) {
    return SubscriptionState(
      isPremium: isPremium ?? this.isPremium,
      isLoading: isLoading ?? this.isLoading,
      customerInfo: customerInfo ?? this.customerInfo,
      offerings: offerings ?? this.offerings,
      error: error,
      expirationDate: expirationDate ?? this.expirationDate,
      willRenew: willRenew ?? this.willRenew,
    );
  }
}

/// Subscription provider notifier
class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  final RevenueCatService _revenueCatService;

  SubscriptionNotifier(this._revenueCatService) : super(const SubscriptionState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);

    await _revenueCatService.initialize();
    await refreshSubscriptionStatus();

    state = state.copyWith(isLoading: false);
  }

  /// Refresh subscription status
  Future<void> refreshSubscriptionStatus() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final customerInfo = await _revenueCatService.refreshCustomerInfo();
      final offerings = await _revenueCatService.fetchOfferings();

      state = state.copyWith(
        isPremium: _revenueCatService.isPremiumUser,
        customerInfo: customerInfo,
        offerings: offerings,
        expirationDate: _revenueCatService.subscriptionExpirationDate,
        willRenew: _revenueCatService.willRenew,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to refresh subscription status: $e',
        isLoading: false,
      );
    }
  }

  /// Purchase a package
  Future<bool> purchasePackage(Package package) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _revenueCatService.purchasePackage(package);

      if (success) {
        await refreshSubscriptionStatus();
        return true;
      } else {
        state = state.copyWith(
          error: 'Purchase failed',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Purchase error: $e',
        isLoading: false,
      );
      return false;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _revenueCatService.restorePurchases();

      if (success) {
        await refreshSubscriptionStatus();
        return true;
      } else {
        state = state.copyWith(
          error: 'No purchases to restore',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Restore error: $e',
        isLoading: false,
      );
      return false;
    }
  }

  /// Check if a specific feature is available
  bool hasAccess(PremiumFeature feature) {
    // For MVP, we'll have a simple model where all premium features
    // are unlocked with one subscription
    // In the future, you can implement tiered features here

    switch (feature) {
      case PremiumFeature.unlimitedEntries:
      case PremiumFeature.aiInsights:
      case PremiumFeature.voiceTranscription:
      case PremiumFeature.exportData:
      case PremiumFeature.customThemes:
      case PremiumFeature.advancedAnalytics:
      case PremiumFeature.prioritySupport:
        return state.isPremium;
    }
  }

  /// Get free tier limits
  static const int freeEntriesPerMonth = 10;
  static const int freeAIInsightsPerMonth = 5;

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Main subscription provider
final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier(RevenueCatService());
});

/// Quick access to premium status
final isPremiumProvider = Provider<bool>((ref) {
  return ref.watch(subscriptionProvider).isPremium;
});

/// Check if user has access to a specific feature
final hasFeatureAccessProvider = Provider.family<bool, PremiumFeature>((ref, feature) {
  return ref.watch(subscriptionProvider.notifier).hasAccess(feature);
});

/// Get monthly package
final monthlyPackageProvider = Provider<Package?>((ref) {
  final offerings = ref.watch(subscriptionProvider).offerings;
  return offerings?.current?.availablePackages.firstWhere(
    (package) => package.identifier.contains('monthly'),
    orElse: () => offerings.current!.availablePackages.first,
  );
});

/// Get annual package
final annualPackageProvider = Provider<Package?>((ref) {
  final offerings = ref.watch(subscriptionProvider).offerings;
  return offerings?.current?.availablePackages.firstWhere(
    (package) => package.identifier.contains('annual') || package.identifier.contains('yearly'),
    orElse: () => offerings.current!.availablePackages.last,
  );
});
