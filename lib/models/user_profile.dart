import 'package:cloud_firestore/cloud_firestore.dart';

/// User profile model for the top-level users collection
/// Stores user metadata, settings, and GDPR consent
class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final GdprConsent gdprConsent;
  final SubscriptionStatus subscriptionStatus;
  final UserSettings settings;
  final StatsCache? statsCache;
  final UserMetadata metadata;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
    this.lastLoginAt,
    required this.gdprConsent,
    required this.subscriptionStatus,
    required this.settings,
    this.statsCache,
    required this.metadata,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
      'gdprConsent': gdprConsent.toMap(),
      'subscriptionStatus': subscriptionStatus.toMap(),
      'settings': settings.toMap(),
      'statsCache': statsCache?.toMap(),
      'metadata': metadata.toMap(),
    };
  }

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserProfile(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp?)?.toDate(),
      gdprConsent: GdprConsent.fromMap(data['gdprConsent'] ?? {}),
      subscriptionStatus: SubscriptionStatus.fromMap(data['subscriptionStatus'] ?? {}),
      settings: UserSettings.fromMap(data['settings'] ?? {}),
      statsCache: data['statsCache'] != null ? StatsCache.fromMap(data['statsCache']) : null,
      metadata: UserMetadata.fromMap(data['metadata'] ?? {}),
    );
  }

  UserProfile copyWith({
    String? email,
    String? displayName,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    GdprConsent? gdprConsent,
    SubscriptionStatus? subscriptionStatus,
    UserSettings? settings,
    StatsCache? statsCache,
    UserMetadata? metadata,
  }) {
    return UserProfile(
      uid: uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      gdprConsent: gdprConsent ?? this.gdprConsent,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      settings: settings ?? this.settings,
      statsCache: statsCache ?? this.statsCache,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// GDPR consent tracking
class GdprConsent {
  final bool accepted;
  final DateTime acceptedAt;
  final String? ip;
  final String version;

  const GdprConsent({
    required this.accepted,
    required this.acceptedAt,
    this.ip,
    required this.version,
  });

  Map<String, dynamic> toMap() {
    return {
      'accepted': accepted,
      'acceptedAt': Timestamp.fromDate(acceptedAt),
      'ip': ip,
      'version': version,
    };
  }

  factory GdprConsent.fromMap(Map<String, dynamic> map) {
    return GdprConsent(
      accepted: map['accepted'] ?? false,
      acceptedAt: (map['acceptedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      ip: map['ip'],
      version: map['version'] ?? 'v1.0',
    );
  }
}

/// Subscription status
class SubscriptionStatus {
  final bool isPremium;
  final String tier; // 'free', 'monthly', 'annual'
  final DateTime? expiresAt;
  final DateTime? trialEndsAt;
  final bool willRenew;
  final String? revenueCatId;

  const SubscriptionStatus({
    required this.isPremium,
    required this.tier,
    this.expiresAt,
    this.trialEndsAt,
    required this.willRenew,
    this.revenueCatId,
  });

  Map<String, dynamic> toMap() {
    return {
      'isPremium': isPremium,
      'tier': tier,
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'trialEndsAt': trialEndsAt != null ? Timestamp.fromDate(trialEndsAt!) : null,
      'willRenew': willRenew,
      'revenueCatId': revenueCatId,
    };
  }

  factory SubscriptionStatus.fromMap(Map<String, dynamic> map) {
    return SubscriptionStatus(
      isPremium: map['isPremium'] ?? false,
      tier: map['tier'] ?? 'free',
      expiresAt: (map['expiresAt'] as Timestamp?)?.toDate(),
      trialEndsAt: (map['trialEndsAt'] as Timestamp?)?.toDate(),
      willRenew: map['willRenew'] ?? false,
      revenueCatId: map['revenueCatId'],
    );
  }

  bool get isInTrial {
    if (trialEndsAt == null) return false;
    return DateTime.now().isBefore(trialEndsAt!);
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}

/// User settings
class UserSettings {
  final bool notificationsEnabled;
  final String language;
  final String theme; // 'light', 'dark', 'system'
  final Map<String, bool> featureToggles;
  final Map<String, dynamic> preferences;

  const UserSettings({
    required this.notificationsEnabled,
    required this.language,
    required this.theme,
    required this.featureToggles,
    required this.preferences,
  });

  Map<String, dynamic> toMap() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'language': language,
      'theme': theme,
      'featureToggles': featureToggles,
      'preferences': preferences,
    };
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      language: map['language'] ?? 'en',
      theme: map['theme'] ?? 'system',
      featureToggles: Map<String, bool>.from(map['featureToggles'] ?? {}),
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
    );
  }

  static UserSettings get defaults => const UserSettings(
    notificationsEnabled: true,
    language: 'en',
    theme: 'system',
    featureToggles: {},
    preferences: {},
  );
}

/// Precomputed statistics cache for fast dashboard loading
class StatsCache {
  final int totalEntries;
  final int currentStreak;
  final int longestStreak;
  final String? dominantMood;
  final DateTime lastUpdated;
  final Map<String, int> moodCounts;

  const StatsCache({
    required this.totalEntries,
    required this.currentStreak,
    required this.longestStreak,
    this.dominantMood,
    required this.lastUpdated,
    required this.moodCounts,
  });

  Map<String, dynamic> toMap() {
    return {
      'totalEntries': totalEntries,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'dominantMood': dominantMood,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'moodCounts': moodCounts,
    };
  }

  factory StatsCache.fromMap(Map<String, dynamic> map) {
    return StatsCache(
      totalEntries: map['totalEntries'] ?? 0,
      currentStreak: map['currentStreak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      dominantMood: map['dominantMood'],
      lastUpdated: (map['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      moodCounts: Map<String, int>.from(map['moodCounts'] ?? {}),
    );
  }
}

/// User device/app metadata
class UserMetadata {
  final String appVersion;
  final String? deviceId;
  final String platform; // 'ios', 'android'
  final String? fcmToken;

  const UserMetadata({
    required this.appVersion,
    this.deviceId,
    required this.platform,
    this.fcmToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'appVersion': appVersion,
      'deviceId': deviceId,
      'platform': platform,
      'fcmToken': fcmToken,
    };
  }

  factory UserMetadata.fromMap(Map<String, dynamic> map) {
    return UserMetadata(
      appVersion: map['appVersion'] ?? '1.0.0',
      deviceId: map['deviceId'],
      platform: map['platform'] ?? 'unknown',
      fcmToken: map['fcmToken'],
    );
  }
}
