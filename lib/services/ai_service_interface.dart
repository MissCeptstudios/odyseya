import '../models/ai_analysis.dart';

/// Abstract interface for AI analysis services
/// This allows us to easily switch between different AI providers
abstract class AIServiceInterface {
  /// Analyze emotional content and return structured analysis
  Future<AIAnalysis> analyzeEmotionalContent({
    required String text,
    String? mood,
    String? previousContext,
  });

  /// Check if the service is properly configured with API keys
  bool get isConfigured;

  /// Get the name of the AI service
  String get serviceName;

  /// Get estimated cost for analysis (0.0 for free services)
  double getEstimatedCost(String text);
}

/// Supported AI providers
enum AIProvider {
  groq,
  openai,  // For future use
  claude,  // For future use
  gemini,  // DEPRECATED - Removed from app
}

extension AIProviderExtension on AIProvider {
  String get displayName {
    switch (this) {
      case AIProvider.groq:
        return 'Groq';
      case AIProvider.openai:
        return 'OpenAI';
      case AIProvider.claude:
        return 'Claude';
      case AIProvider.gemini:
        return 'Gemini (Removed)';
    }
  }

  String get description {
    switch (this) {
      case AIProvider.groq:
        return 'FREE - Groq Llama Models (Very Fast)';
      case AIProvider.openai:
        return 'PAID - OpenAI GPT-4 (High Quality)';
      case AIProvider.claude:
        return 'PAID - Anthropic Claude (Excellent Analysis)';
      case AIProvider.gemini:
        return 'DEPRECATED - Service removed';
    }
  }

  bool get isFree {
    switch (this) {
      case AIProvider.groq:
        return true;
      case AIProvider.openai:
      case AIProvider.claude:
      case AIProvider.gemini:
        return false;
    }
  }
}

/// Progress tracking for AI analysis
class AIAnalysisProgress {
  final AIAnalysisStatus status;
  final double progress;
  final String message;
  final AIAnalysis? result;

  const AIAnalysisProgress({
    required this.status,
    required this.progress,
    required this.message,
    this.result,
  });
}

enum AIAnalysisStatus {
  preparing,
  analyzing,
  completed,
  error,
}