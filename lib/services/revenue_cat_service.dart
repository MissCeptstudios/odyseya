import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../config/env_config.dart';

/// Service for managing RevenueCat subscriptions and in-app purchases
class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();
  factory RevenueCatService() => _instance;
  RevenueCatService._internal();

  bool _isInitialized = false;
  CustomerInfo? _customerInfo;
  Offerings? _offerings;

  /// Initialize RevenueCat SDK
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('RevenueCat already initialized');
      return;
    }

    try {
      // Get API key based on platform
      final apiKey = _getApiKey();

      if (apiKey.isEmpty) {
        debugPrint('⚠️ RevenueCat API key not found in environment');
        return;
      }

      // Configure RevenueCat
      await Purchases.configure(PurchasesConfiguration(apiKey));

      // Enable debug logs if in debug mode
      if (kDebugMode) {
        await Purchases.setLogLevel(LogLevel.debug);
      }

      _isInitialized = true;
      debugPrint('✅ RevenueCat initialized successfully');

      // Load initial data
      await refreshCustomerInfo();
      await fetchOfferings();
    } on PlatformException catch (e) {
      debugPrint('❌ RevenueCat initialization failed: ${e.message}');
    } catch (e) {
      debugPrint('❌ RevenueCat initialization error: $e');
    }
  }

  /// Get the appropriate API key based on platform and environment
  String _getApiKey() {
    // In production, use production keys
    // In development, use development keys
    if (EnvConfig.isProduction) {
      // TODO: Add production keys to .env
      return '';
    }

    // Development keys
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return EnvConfig.revenueCatIosKey ?? '';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return EnvConfig.revenueCatAndroidKey ?? '';
    }

    return '';
  }

  /// Refresh customer info (subscription status, purchases, etc.)
  Future<CustomerInfo?> refreshCustomerInfo() async {
    if (!_isInitialized) {
      debugPrint('⚠️ RevenueCat not initialized');
      return null;
    }

    try {
      _customerInfo = await Purchases.getCustomerInfo();
      debugPrint('Customer info refreshed: ${_customerInfo?.entitlements.all}');
      return _customerInfo;
    } on PlatformException catch (e) {
      debugPrint('Error refreshing customer info: ${e.message}');
      return null;
    }
  }

  /// Fetch available offerings (subscription packages)
  Future<Offerings?> fetchOfferings() async {
    if (!_isInitialized) {
      debugPrint('⚠️ RevenueCat not initialized');
      return null;
    }

    try {
      _offerings = await Purchases.getOfferings();

      if (_offerings?.current == null) {
        debugPrint('⚠️ No current offering found');
      } else {
        debugPrint('✅ Offerings fetched: ${_offerings?.current?.availablePackages.length} packages');
      }

      return _offerings;
    } on PlatformException catch (e) {
      debugPrint('Error fetching offerings: ${e.message}');
      return null;
    }
  }

  /// Purchase a package
  Future<bool> purchasePackage(Package package) async {
    if (!_isInitialized) {
      debugPrint('⚠️ RevenueCat not initialized');
      return false;
    }

    try {
      final purchaserInfo = await Purchases.purchasePackage(package);
      _customerInfo = purchaserInfo;

      debugPrint('✅ Purchase successful');
      return isPremiumUser;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);

      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('User cancelled purchase');
      } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        debugPrint('Purchase not allowed');
      } else {
        debugPrint('Purchase error: ${e.message}');
      }

      return false;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    if (!_isInitialized) {
      debugPrint('⚠️ RevenueCat not initialized');
      return false;
    }

    try {
      final purchaserInfo = await Purchases.restorePurchases();
      _customerInfo = purchaserInfo;

      debugPrint('✅ Purchases restored');
      return isPremiumUser;
    } on PlatformException catch (e) {
      debugPrint('Error restoring purchases: ${e.message}');
      return false;
    }
  }

  /// Check if user has premium access
  bool get isPremiumUser {
    if (_customerInfo == null) return false;

    // Check if user has active premium entitlement
    final entitlement = _customerInfo!.entitlements.all['premium'];
    return entitlement?.isActive ?? false;
  }

  /// Get current customer info
  CustomerInfo? get customerInfo => _customerInfo;

  /// Get available offerings
  Offerings? get offerings => _offerings;

  /// Get current offering
  Offering? get currentOffering => _offerings?.current;

  /// Get monthly package
  Package? get monthlyPackage {
    return currentOffering?.availablePackages.firstWhere(
      (package) => package.identifier.contains('monthly'),
      orElse: () => currentOffering!.availablePackages.first,
    );
  }

  /// Get annual package
  Package? get annualPackage {
    return currentOffering?.availablePackages.firstWhere(
      (package) => package.identifier.contains('annual'),
      orElse: () => currentOffering!.availablePackages.last,
    );
  }

  /// Set user ID (for analytics and tracking)
  Future<void> setUserId(String userId) async {
    if (!_isInitialized) {
      debugPrint('⚠️ RevenueCat not initialized');
      return;
    }

    try {
      await Purchases.logIn(userId);
      await refreshCustomerInfo();
      debugPrint('✅ User ID set: $userId');
    } on PlatformException catch (e) {
      debugPrint('Error setting user ID: ${e.message}');
    }
  }

  /// Log out user
  Future<void> logOut() async {
    if (!_isInitialized) return;

    try {
      await Purchases.logOut();
      _customerInfo = null;
      debugPrint('✅ User logged out from RevenueCat');
    } on PlatformException catch (e) {
      debugPrint('Error logging out: ${e.message}');
    }
  }

  /// Get subscription expiration date
  DateTime? get subscriptionExpirationDate {
    if (_customerInfo == null) return null;

    final entitlement = _customerInfo!.entitlements.all['premium'];
    final expirationDateString = entitlement?.expirationDate;

    if (expirationDateString == null) return null;

    // Parse the date string to DateTime
    return DateTime.tryParse(expirationDateString);
  }

  /// Check if subscription will renew
  bool get willRenew {
    if (_customerInfo == null) return false;

    final entitlement = _customerInfo!.entitlements.all['premium'];
    return entitlement?.willRenew ?? false;
  }

  /// Get subscription period type
  String? get subscriptionPeriod {
    if (_customerInfo == null) return null;

    final entitlement = _customerInfo!.entitlements.all['premium'];
    return entitlement?.periodType.name;
  }
}