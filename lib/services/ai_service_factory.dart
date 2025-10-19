import 'package:flutter/foundation.dart';
import 'ai_service_interface.dart';
import 'groq_ai_service.dart';
import 'openai_service.dart';
import 'openai_backend_service.dart';

class AIServiceFactory {
  static final AIServiceFactory _instance = AIServiceFactory._internal();
  factory AIServiceFactory() => _instance;
  AIServiceFactory._internal();

  // Current AI provider configuration
  AIProvider _currentProvider = AIProvider.openai; // Default to OpenAI for best quality

  // Service instances (lazy loaded)
  GroqAIService? _groqService;
  OpenAIService? _openaiService;
  OpenAIBackendService? _openaiBackendService;

  /// Get the current AI service based on configuration
  AIServiceInterface getCurrentService() {
    switch (_currentProvider) {
      case AIProvider.groq:
        return getGroqService();
      case AIProvider.openai:
        return getOpenAIBackendService(); // Use secure backend service
      case AIProvider.claude:
        throw UnimplementedError('Claude service not yet implemented');
    }
  }

  /// Get Groq service instance
  GroqAIService getGroqService() {
    _groqService ??= GroqAIService();
    return _groqService!;
  }

  /// Get OpenAI service instance (direct - for legacy/testing only)
  OpenAIService getOpenAIService() {
    _openaiService ??= OpenAIService();
    return _openaiService!;
  }

  /// Get OpenAI Backend service instance (secure - routes through Firebase)
  OpenAIBackendService getOpenAIBackendService() {
    _openaiBackendService ??= OpenAIBackendService();
    return _openaiBackendService!;
  }

  /// Switch to a different AI provider
  void switchProvider(AIProvider provider) {
    if (kDebugMode) {
      debugPrint('Switching AI provider from ${_currentProvider.displayName} to ${provider.displayName}');
    }
    _currentProvider = provider;
  }

  /// Get current provider
  AIProvider get currentProvider => _currentProvider;

  /// Configure API keys for all services
  void configureServices({
    String? groqApiKey,
    String? openaiApiKey,
    String? claudeApiKey,
  }) {
    if (groqApiKey != null && groqApiKey.isNotEmpty) {
      getGroqService().setApiKey(groqApiKey);
      if (kDebugMode) {
        debugPrint('Groq API key configured');
      }
    }

    // OpenAI configuration - DEPRECATED (now uses backend service)
    // Backend service doesn't need API key configuration from client
    if (openaiApiKey != null && openaiApiKey.isNotEmpty) {
      if (kDebugMode) {
        debugPrint('OpenAI API key provided, but backend service is used (keys stored securely in Firebase)');
      }
    }

    // Future: Claude configuration
    if (claudeApiKey != null && claudeApiKey.isNotEmpty) {
      if (kDebugMode) {
        debugPrint('Claude API key received (service not yet implemented)');
      }
    }
  }

  /// Check if current service is configured
  bool get isCurrentServiceConfigured => getCurrentService().isConfigured;

  /// Get available (configured) services
  List<AIProvider> getAvailableServices() {
    final available = <AIProvider>[];

    // OpenAI backend service is always available (configured on backend)
    if (getOpenAIBackendService().isConfigured) {
      available.add(AIProvider.openai);
    }

    if (getGroqService().isConfigured) {
      available.add(AIProvider.groq);
    }

    // Future: Add Claude when implemented

    return available;
  }

  /// Get the best available service (prefer OpenAI for quality)
  AIProvider getBestAvailableService() {
    final available = getAvailableServices();

    if (available.isEmpty) {
      return AIProvider.openai; // Default fallback
    }

    // Prefer OpenAI for best quality if configured
    if (available.contains(AIProvider.openai)) {
      return AIProvider.openai;
    }

    // Then Groq as free alternative
    if (available.contains(AIProvider.groq)) {
      return AIProvider.groq;
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
          debugPrint('Service ${service.serviceName} is not configured');
        }
        return false;
      }

      // Test with a simple emotional text
      final testAnalysis = await service.analyzeEmotionalContent(
        text: 'I feel happy and grateful today. The weather is beautiful and I had a great conversation with a friend.',
        mood: 'joyful',
      );

      if (kDebugMode) {
        debugPrint('Service test successful: ${service.serviceName}');
        debugPrint('Test result: ${testAnalysis.emotionalTone} (confidence: ${testAnalysis.confidence})');
      }

      return testAnalysis.emotionalTone.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Service test failed: $e');
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
    _currentProvider = AIProvider.openai;
    _groqService = null;
    _openaiService = null;
    _openaiBackendService = null;

    if (kDebugMode) {
      debugPrint('AI service configuration reset');
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
    String? groqApiKey,
    String? openaiApiKey,
    AIProvider? preferredProvider,
  }) async {
    // Configure services
    _factory.configureServices(
      groqApiKey: groqApiKey,
      openaiApiKey: openaiApiKey,
    );

    // Set preferred provider or auto-select best
    if (preferredProvider != null) {
      _factory.switchProvider(preferredProvider);
    } else {
      _factory.autoConfigureBestService();
    }

    if (kDebugMode) {
      debugPrint('AI Service Manager initialized');
      debugPrint(_factory.getServiceStatus().toString());
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