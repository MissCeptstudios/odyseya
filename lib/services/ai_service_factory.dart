import 'package:flutter/foundation.dart';
import 'ai_service_interface.dart';
import 'gemini_ai_service.dart';
import 'groq_ai_service.dart';

class AIServiceFactory {
  static final AIServiceFactory _instance = AIServiceFactory._internal();
  factory AIServiceFactory() => _instance;
  AIServiceFactory._internal();

  // Current AI provider configuration
  AIProvider _currentProvider = AIProvider.gemini; // Default to Gemini (free)
  
  // Service instances (lazy loaded)
  GeminiAIService? _geminiService;
  GroqAIService? _groqService;

  /// Get the current AI service based on configuration
  AIServiceInterface getCurrentService() {
    switch (_currentProvider) {
      case AIProvider.gemini:
        return getGeminiService();
      case AIProvider.groq:
        return getGroqService();
      case AIProvider.openai:
        throw UnimplementedError('OpenAI service not yet implemented');
      case AIProvider.claude:
        throw UnimplementedError('Claude service not yet implemented');
    }
  }

  /// Get Gemini service instance
  GeminiAIService getGeminiService() {
    _geminiService ??= GeminiAIService();
    return _geminiService!;
  }

  /// Get Groq service instance
  GroqAIService getGroqService() {
    _groqService ??= GroqAIService();
    return _groqService!;
  }

  /// Switch to a different AI provider
  void switchProvider(AIProvider provider) {
    if (kDebugMode) {
      print('Switching AI provider from ${_currentProvider.displayName} to ${provider.displayName}');
    }
    _currentProvider = provider;
  }

  /// Get current provider
  AIProvider get currentProvider => _currentProvider;

  /// Configure API keys for all services
  void configureServices({
    String? geminiApiKey,
    String? groqApiKey,
    String? openaiApiKey,
    String? claudeApiKey,
  }) {
    if (geminiApiKey != null && geminiApiKey.isNotEmpty) {
      getGeminiService().setApiKey(geminiApiKey);
      if (kDebugMode) {
        print('Gemini API key configured');
      }
    }

    if (groqApiKey != null && groqApiKey.isNotEmpty) {
      getGroqService().setApiKey(groqApiKey);
      if (kDebugMode) {
        print('Groq API key configured');
      }
    }

    // Future: OpenAI and Claude configuration
    if (openaiApiKey != null && openaiApiKey.isNotEmpty) {
      if (kDebugMode) {
        print('OpenAI API key received (service not yet implemented)');
      }
    }

    if (claudeApiKey != null && claudeApiKey.isNotEmpty) {
      if (kDebugMode) {
        print('Claude API key received (service not yet implemented)');
      }
    }
  }

  /// Check if current service is configured
  bool get isCurrentServiceConfigured => getCurrentService().isConfigured;

  /// Get available (configured) services
  List<AIProvider> getAvailableServices() {
    final available = <AIProvider>[];
    
    if (getGeminiService().isConfigured) {
      available.add(AIProvider.gemini);
    }
    
    if (getGroqService().isConfigured) {
      available.add(AIProvider.groq);
    }
    
    // Future: Add OpenAI and Claude when implemented
    
    return available;
  }

  /// Get the best available service (configured and free)
  AIProvider getBestAvailableService() {
    final available = getAvailableServices();
    
    if (available.isEmpty) {
      return AIProvider.gemini; // Default fallback
    }

    // Prefer free services
    for (final provider in [AIProvider.gemini, AIProvider.groq]) {
      if (available.contains(provider)) {
        return provider;
      }
    }
    
    return available.first;
  }

  /// Auto-configure to best available service
  void autoConfigureBestService() {
    final bestService = getBestAvailableService();
    if (bestService != _currentProvider) {
      switchProvider(bestService);
    }
  }

  /// Get service status information
  ServiceStatus getServiceStatus() {
    final current = getCurrentService();
    final available = getAvailableServices();
    
    return ServiceStatus(
      currentProvider: _currentProvider,
      isConfigured: current.isConfigured,
      availableProviders: available,
      serviceName: current.serviceName,
      estimatedCost: current.getEstimatedCost('sample text for estimation'),
    );
  }

  /// Test current service with a simple analysis
  Future<bool> testCurrentService() async {
    try {
      final service = getCurrentService();
      
      if (!service.isConfigured) {
        if (kDebugMode) {
          print('Service ${service.serviceName} is not configured');
        }
        return false;
      }

      // Test with a simple emotional text
      final testAnalysis = await service.analyzeEmotionalContent(
        text: 'I feel happy and grateful today. The weather is beautiful and I had a great conversation with a friend.',
        mood: 'joyful',
      );

      if (kDebugMode) {
        print('Service test successful: ${service.serviceName}');
        print('Test result: ${testAnalysis.emotionalTone} (confidence: ${testAnalysis.confidence})');
      }

      return testAnalysis.emotionalTone.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Service test failed: $e');
      }
      return false;
    }
  }

  /// Get service usage recommendations
  String getServiceRecommendation() {
    final status = getServiceStatus();
    
    if (!status.isConfigured) {
      return 'Please configure an API key to enable AI analysis.';
    }

    if (status.currentProvider.isFree) {
      return 'Using ${status.serviceName} - FREE service with excellent quality.';
    } else {
      return 'Using ${status.serviceName} - Premium service with estimated cost: \$${status.estimatedCost.toStringAsFixed(4)} per analysis.';
    }
  }

  /// Reset all configurations (for testing or troubleshooting)
  void resetConfiguration() {
    _currentProvider = AIProvider.gemini;
    _geminiService = null;
    _groqService = null;
    
    if (kDebugMode) {
      print('AI service configuration reset');
    }
  }
}

/// Service status information
class ServiceStatus {
  final AIProvider currentProvider;
  final bool isConfigured;
  final List<AIProvider> availableProviders;
  final String serviceName;
  final double estimatedCost;

  const ServiceStatus({
    required this.currentProvider,
    required this.isConfigured,
    required this.availableProviders,
    required this.serviceName,
    required this.estimatedCost,
  });

  @override
  String toString() {
    return 'ServiceStatus(current: ${currentProvider.displayName}, configured: $isConfigured, available: ${availableProviders.length})';
  }
}

/// Convenience class for managing AI service configuration
class AIServiceManager {
  static final AIServiceFactory _factory = AIServiceFactory();

  /// Initialize AI services with configuration
  static Future<void> initialize({
    String? geminiApiKey,
    String? groqApiKey,
    AIProvider? preferredProvider,
  }) async {
    // Configure services
    _factory.configureServices(
      geminiApiKey: geminiApiKey,
      groqApiKey: groqApiKey,
    );

    // Set preferred provider or auto-select best
    if (preferredProvider != null) {
      _factory.switchProvider(preferredProvider);
    } else {
      _factory.autoConfigureBestService();
    }

    if (kDebugMode) {
      print('AI Service Manager initialized');
      print(_factory.getServiceStatus());
    }
  }

  /// Get current AI service
  static AIServiceInterface get currentService => _factory.getCurrentService();

  /// Switch provider
  static void switchProvider(AIProvider provider) => _factory.switchProvider(provider);

  /// Get factory instance for advanced usage
  static AIServiceFactory get factory => _factory;

  /// Quick service test
  static Future<bool> testService() => _factory.testCurrentService();
}