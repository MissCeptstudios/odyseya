import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class EnvConfig {
  static bool _isInitialized = false;

  /// Initialize environment configuration
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await dotenv.load(fileName: '.env');
      _isInitialized = true;

      if (kDebugMode) {
        debugPrint('Environment configuration loaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to load .env file: $e');
        debugPrint('Using fallback configuration');
      }
      _isInitialized = true; // Mark as initialized even if .env fails
    }
  }

  /// Get environment variable with optional fallback
  static String? _getEnv(String key, {String? fallback}) {
    if (!_isInitialized) {
      throw StateError('EnvConfig not initialized. Call EnvConfig.initialize() first.');
    }

    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      return fallback;
    }
    return value;
  }

  /// OpenAI API Configuration
  static String? get openaiApiKey => _getEnv('OPENAI_API_KEY');

  /// Groq API Configuration
  static String? get groqApiKey => _getEnv('GROQ_API_KEY');

  /// Anthropic Claude API Configuration
  static String? get claudeApiKey => _getEnv('CLAUDE_API_KEY');

  /// Application Settings
  static bool get useWhisper => (_getEnv('USE_WHISPER', fallback: 'true') ?? 'true').toLowerCase() == 'true';
  static bool get isProduction => (_getEnv('IS_PROD', fallback: 'false') ?? 'false').toLowerCase() == 'true';

  /// RevenueCat Configuration
  static String? get revenueCatIosKey => _getEnv('RC_IOS_KEY_DEV');
  static String? get revenueCatAndroidKey => _getEnv('RC_ANDROID_KEY_DEV');

  /// Subscription Product IDs
  static String get monthlyProductId => _getEnv('MONTHLY_PRODUCT_ID', fallback: 'odyseya_monthly_premium')!;
  static String get annualProductId => _getEnv('ANNUAL_PRODUCT_ID', fallback: 'odyseya_annual_premium')!;

  /// Validation helpers
  static bool get hasOpenaiKey => openaiApiKey != null && openaiApiKey!.isNotEmpty;
  static bool get hasGroqKey => groqApiKey != null && groqApiKey!.isNotEmpty;
  static bool get hasClaudeKey => claudeApiKey != null && claudeApiKey!.isNotEmpty;

  /// Debug information (only in debug mode)
  static Map<String, dynamic> getDebugInfo() {
    if (!kDebugMode) return {};

    return {
      'initialized': _isInitialized,
      'hasOpenaiKey': hasOpenaiKey,
      'hasGroqKey': hasGroqKey,
      'hasClaudeKey': hasClaudeKey,
      'useWhisper': useWhisper,
      'isProduction': isProduction,
    };
  }
}