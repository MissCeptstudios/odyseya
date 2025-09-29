import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ai_service_factory.dart';
import 'ai_service_interface.dart';

class AIConfigService {
  static final AIConfigService _instance = AIConfigService._internal();
  factory AIConfigService() => _instance;
  AIConfigService._internal();

  // API key storage keys
  static const String _geminiApiKeyKey = 'gemini_api_key';
  static const String _groqApiKeyKey = 'groq_api_key';
  static const String _selectedProviderKey = 'selected_ai_provider';

  final AIServiceFactory _aiFactory = AIServiceFactory();

  /// Initialize AI configuration from stored preferences
  Future<void> initializeFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load stored API keys
      final geminiKey = prefs.getString(_geminiApiKeyKey);
      final groqKey = prefs.getString(_groqApiKeyKey);
      final selectedProvider = prefs.getString(_selectedProviderKey);

      if (kDebugMode) {
        debugPrint('Loading AI configuration from storage...');
        debugPrint('Gemini key configured: ${geminiKey?.isNotEmpty ?? false}');
        debugPrint('Groq key configured: ${groqKey?.isNotEmpty ?? false}');
        debugPrint('Selected provider: $selectedProvider');
      }

      // Configure services with stored keys
      _aiFactory.configureServices(
        geminiApiKey: geminiKey,
        groqApiKey: groqKey,
      );

      // Set selected provider if available
      if (selectedProvider != null) {
        final provider = AIProvider.values.firstWhere(
          (p) => p.name == selectedProvider,
          orElse: () => AIProvider.gemini,
        );
        _aiFactory.switchProvider(provider);
      } else {
        // Auto-select best available service
        _aiFactory.autoConfigureBestService();
      }

      if (kDebugMode) {
        debugPrint('AI configuration initialized');
        debugPrint(_aiFactory.getServiceStatus().toString());
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error initializing AI configuration: $e');
      }
    }
  }

  /// Set and store Gemini API key
  Future<bool> setGeminiApiKey(String apiKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (apiKey.trim().isEmpty) {
        await prefs.remove(_geminiApiKeyKey);
        _aiFactory.getGeminiService().setApiKey('');
        if (kDebugMode) {
          debugPrint('Gemini API key removed');
        }
        return true;
      }

      await prefs.setString(_geminiApiKeyKey, apiKey.trim());
      _aiFactory.getGeminiService().setApiKey(apiKey.trim());
      
      if (kDebugMode) {
        debugPrint('Gemini API key configured and stored');
      }
      
      // Auto-switch to Gemini if it's now configured
      if (_aiFactory.currentProvider != AIProvider.gemini) {
        _aiFactory.switchProvider(AIProvider.gemini);
        await _setSelectedProvider(AIProvider.gemini);
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error setting Gemini API key: $e');
      }
      return false;
    }
  }

  /// Set and store Groq API key
  Future<bool> setGroqApiKey(String apiKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (apiKey.trim().isEmpty) {
        await prefs.remove(_groqApiKeyKey);
        _aiFactory.getGroqService().setApiKey('');
        if (kDebugMode) {
          debugPrint('Groq API key removed');
        }
        return true;
      }

      await prefs.setString(_groqApiKeyKey, apiKey.trim());
      _aiFactory.getGroqService().setApiKey(apiKey.trim());
      
      if (kDebugMode) {
        debugPrint('Groq API key configured and stored');
      }
      
      // Auto-switch to Groq if no other service is configured
      if (!_aiFactory.isCurrentServiceConfigured) {
        _aiFactory.switchProvider(AIProvider.groq);
        await _setSelectedProvider(AIProvider.groq);
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error setting Groq API key: $e');
      }
      return false;
    }
  }

  /// Switch AI provider and store preference
  Future<bool> switchProvider(AIProvider provider) async {
    try {
      _aiFactory.switchProvider(provider);
      await _setSelectedProvider(provider);
      
      if (kDebugMode) {
        debugPrint('Switched to ${provider.displayName}');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error switching provider: $e');
      }
      return false;
    }
  }

  /// Store selected provider preference
  Future<void> _setSelectedProvider(AIProvider provider) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_selectedProviderKey, provider.name);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error storing selected provider: $e');
      }
    }
  }

  /// Get stored API keys (for display purposes only)
  Future<Map<String, String?>> getStoredApiKeys() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'gemini': prefs.getString(_geminiApiKeyKey),
        'groq': prefs.getString(_groqApiKeyKey),
      };
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting stored API keys: $e');
      }
      return {'gemini': null, 'groq': null};
    }
  }

  /// Get masked API keys for UI display
  Future<Map<String, String?>> getMaskedApiKeys() async {
    final keys = await getStoredApiKeys();
    return keys.map((service, key) {
      if (key == null || key.isEmpty) {
        return MapEntry(service, null);
      }
      
      // Show first 8 and last 4 characters
      if (key.length > 12) {
        return MapEntry(service, '${key.substring(0, 8)}...${key.substring(key.length - 4)}');
      } else {
        return MapEntry(service, '${key.substring(0, 4)}...');
      }
    });
  }

  /// Test current AI service configuration
  Future<bool> testCurrentService() async {
    return await _aiFactory.testCurrentService();
  }

  /// Get current configuration status
  AIConfigStatus getConfigurationStatus() {
    final factory = _aiFactory;
    final status = factory.getServiceStatus();
    
    return AIConfigStatus(
      currentProvider: status.currentProvider,
      isConfigured: status.isConfigured,
      availableProviders: status.availableProviders,
      serviceName: status.serviceName,
      recommendation: factory.getServiceRecommendation(),
    );
  }

  /// Clear all stored configuration
  Future<void> clearAllConfiguration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_geminiApiKeyKey);
      await prefs.remove(_groqApiKeyKey);
      await prefs.remove(_selectedProviderKey);
      
      _aiFactory.resetConfiguration();
      
      if (kDebugMode) {
        debugPrint('All AI configuration cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error clearing configuration: $e');
      }
    }
  }

  /// Quick setup with API keys
  Future<bool> quickSetup({
    String? geminiApiKey,
    String? groqApiKey,
    AIProvider? preferredProvider,
  }) async {
    try {
      if (geminiApiKey != null && geminiApiKey.isNotEmpty) {
        await setGeminiApiKey(geminiApiKey);
      }
      
      if (groqApiKey != null && groqApiKey.isNotEmpty) {
        await setGroqApiKey(groqApiKey);
      }
      
      if (preferredProvider != null) {
        await switchProvider(preferredProvider);
      } else {
        _aiFactory.autoConfigureBestService();
        await _setSelectedProvider(_aiFactory.currentProvider);
      }
      
      if (kDebugMode) {
        debugPrint('Quick setup completed');
        debugPrint(getConfigurationStatus().toString());
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error in quick setup: $e');
      }
      return false;
    }
  }

  /// Get setup instructions for users
  String getSetupInstructions() {
    return '''
To enable AI analysis, configure at least one free API service:

📱 GOOGLE GEMINI (Recommended - FREE):
1. Visit https://makersuite.google.com/app/apikey
2. Sign in with your Google account
3. Click "Create API key"
4. Copy the key and paste it in the app

⚡ GROQ (Alternative - FREE):
1. Visit https://console.groq.com/keys
2. Sign up for a free account
3. Create a new API key
4. Copy the key and paste it in the app

Both services are completely FREE with generous limits!
    ''';
  }
}

/// Configuration status information
class AIConfigStatus {
  final AIProvider currentProvider;
  final bool isConfigured;
  final List<AIProvider> availableProviders;
  final String serviceName;
  final String recommendation;

  const AIConfigStatus({
    required this.currentProvider,
    required this.isConfigured,
    required this.availableProviders,
    required this.serviceName,
    required this.recommendation,
  });

  @override
  String toString() {
    return 'AIConfigStatus(service: $serviceName, configured: $isConfigured, available: ${availableProviders.length})';
  }
}