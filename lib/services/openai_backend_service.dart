import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import '../models/ai_analysis.dart';
import 'ai_service_interface.dart';

/// OpenAI Service using secure Firebase Cloud Functions backend
/// API key is never exposed to the client - stored securely on server
/// Respects subscription tiers and usage limits
class OpenAIBackendService implements AIServiceInterface {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  static final OpenAIBackendService _instance = OpenAIBackendService._internal();
  factory OpenAIBackendService() => _instance;
  OpenAIBackendService._internal();

  @override
  String get serviceName => 'OpenAI (Secure Backend)';

  @override
  bool get isConfigured => true; // Backend handles API key configuration

  @override
  double getEstimatedCost(String text) {
    // Cost is handled on backend
    // Users see usage limits based on subscription tier
    return 0.0;
  }

  @override
  Future<AIAnalysis> analyzeEmotionalContent({
    required String text,
    String? mood,
    String? previousContext,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('🔄 Calling backend for AI analysis (${text.length} chars)');
      }

      // Call secure backend function
      final callable = _functions.httpsCallable('analyzeJournalEntry');

      final result = await callable.call({
        'text': text,
        'mood': mood,
        'previousContext': previousContext,
      });

      final data = result.data as Map<String, dynamic>;
      final analysis = data['analysis'] as Map<String, dynamic>;
      final usage = data['usage'] as Map<String, dynamic>;

      if (kDebugMode) {
        debugPrint('✅ Analysis complete!');
        debugPrint('   Tokens used: ${usage['tokensUsed']}');
        debugPrint('   Monthly usage: ${usage['monthlyUsed']}/${usage['monthlyLimit']}');
        debugPrint('   Tier: ${usage['tier']}');
      }

      // Parse response into AIAnalysis model
      return AIAnalysis(
        emotionalTone: analysis['emotionalTone'] as String? ?? 'neutral',
        confidence: (analysis['confidence'] as num?)?.toDouble() ?? 0.8,
        triggers: List<String>.from(analysis['triggers'] as List? ?? []),
        insight: analysis['insight'] as String? ?? '',
        suggestions: List<String>.from(analysis['suggestions'] as List? ?? []),
        emotionScores: _parseEmotionScores(analysis['emotionScores']),
        analyzedAt: DateTime.now(),
      );
    } on FirebaseFunctionsException catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Backend error: ${e.code} - ${e.message}');
      }

      // Handle specific error types
      if (e.code == 'resource-exhausted') {
        throw AIAnalysisException(
          'Usage limit exceeded: ${e.message}\n\n'
          'Free users get 5 analyses per month.\n'
          'Upgrade to Premium for unlimited analyses!',
        );
      }

      if (e.code == 'unauthenticated') {
        throw AIAnalysisException('Please sign in to use AI analysis');
      }

      if (e.code == 'invalid-argument') {
        throw AIAnalysisException('Invalid journal entry: ${e.message}');
      }

      throw AIAnalysisException('Failed to analyze: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Unexpected error: $e');
      }
      throw AIAnalysisException('Failed to analyze journal entry: $e');
    }
  }

  /// Parse emotion scores from backend response
  Map<String, double> _parseEmotionScores(dynamic scores) {
    if (scores == null) return {};

    try {
      return (scores as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to parse emotion scores: $e');
      }
      return {};
    }
  }

  /// Generate summary using backend (respects subscription limits)
  Future<Map<String, dynamic>> generateSummary({
    required List<Map<String, dynamic>> entries,
    required DateTime periodStart,
    required DateTime periodEnd,
    required String frequency,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('🔄 Generating summary for ${entries.length} entries');
      }

      final callable = _functions.httpsCallable('generateSummary');

      final result = await callable.call({
        'entries': entries,
        'periodStart': periodStart.toIso8601String(),
        'periodEnd': periodEnd.toIso8601String(),
        'frequency': frequency,
      });

      final data = result.data as Map<String, dynamic>;
      final summary = data['summary'] as Map<String, dynamic>;
      final usage = data['usage'] as Map<String, dynamic>;

      if (kDebugMode) {
        debugPrint('✅ Summary generated!');
        debugPrint('   Tokens used: ${usage['tokensUsed']}');
        debugPrint('   Monthly usage: ${usage['monthlyUsed']}/${usage['monthlyLimit']}');
      }

      return summary;
    } on FirebaseFunctionsException catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Summary generation error: ${e.code} - ${e.message}');
      }

      if (e.code == 'resource-exhausted') {
        throw AIAnalysisException(
          'Summary limit exceeded: ${e.message}\n\n'
          'Free users get 1 summary per month.\n'
          'Upgrade to Premium for unlimited summaries!',
        );
      }

      throw AIAnalysisException('Failed to generate summary: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Unexpected summary error: $e');
      }
      throw AIAnalysisException('Failed to generate summary: $e');
    }
  }

  /// Get user's AI usage statistics
  Future<UsageStats> getUsageStats() async {
    try {
      final callable = _functions.httpsCallable('getUsageStats');
      final result = await callable.call();

      final data = result.data as Map<String, dynamic>;

      return UsageStats(
        tier: data['tier'] as String,
        analysesUsed: data['analyses']['used'] as int,
        analysesLimit: data['analyses']['limit'] as int,
        analysesUnlimited: data['analyses']['unlimited'] as bool,
        summariesUsed: data['summaries']['used'] as int,
        summariesLimit: data['summaries']['limit'] as int,
        summariesUnlimited: data['summaries']['unlimited'] as bool,
        rateLimit: data['rateLimit'] as int,
        subscriptionExpiry: data['subscriptionExpiry'] != null
            ? DateTime.fromMillisecondsSinceEpoch(data['subscriptionExpiry'] as int)
            : null,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to get usage stats: $e');
      }
      rethrow;
    }
  }
}

/// User's AI usage statistics
class UsageStats {
  final String tier; // "free" or "premium"
  final int analysesUsed;
  final int analysesLimit; // -1 for unlimited
  final bool analysesUnlimited;
  final int summariesUsed;
  final int summariesLimit; // -1 for unlimited
  final bool summariesUnlimited;
  final int rateLimit; // requests per hour
  final DateTime? subscriptionExpiry;

  const UsageStats({
    required this.tier,
    required this.analysesUsed,
    required this.analysesLimit,
    required this.analysesUnlimited,
    required this.summariesUsed,
    required this.summariesLimit,
    required this.summariesUnlimited,
    required this.rateLimit,
    this.subscriptionExpiry,
  });

  bool get isPremium => tier == 'premium';
  bool get isFree => tier == 'free';

  bool get analysesRemaining => analysesUnlimited || analysesUsed < analysesLimit;
  bool get summariesRemaining => summariesUnlimited || summariesUsed < summariesLimit;

  String get analysesDisplay {
    if (analysesUnlimited) return 'Unlimited';
    return '$analysesUsed / $analysesLimit';
  }

  String get summariesDisplay {
    if (summariesUnlimited) return 'Unlimited';
    return '$summariesUsed / $summariesLimit';
  }

  double get analysesPercentage {
    if (analysesUnlimited) return 0.0;
    if (analysesLimit == 0) return 1.0;
    return analysesUsed / analysesLimit;
  }

  @override
  String toString() {
    return 'UsageStats(tier: $tier, analyses: $analysesDisplay, summaries: $summariesDisplay)';
  }
}

/// Custom exception for AI analysis errors
class AIAnalysisException implements Exception {
  final String message;

  AIAnalysisException(this.message);

  @override
  String toString() => message;
}
