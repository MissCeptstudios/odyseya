import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/ai_analysis.dart';
import 'ai_service_interface.dart';

/// OpenAI GPT Service for emotional analysis
/// Uses GPT-4o or GPT-4 for high-quality mood analysis
class OpenAIService implements AIServiceInterface {
  static final OpenAIService _instance = OpenAIService._internal();
  factory OpenAIService() => _instance;
  OpenAIService._internal();

  // OpenAI API configuration
  static const String _baseUrl = 'https://api.openai.com/v1';

  String? _apiKey;
  String _model = 'gpt-4o'; // Default to GPT-4o (faster and cheaper than GPT-4)

  @override
  String get serviceName => 'OpenAI ($_model)';

  void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }

  /// Set the model to use (gpt-4o, gpt-4, gpt-4-turbo, gpt-3.5-turbo)
  void setModel(String model) {
    _model = model;
  }

  @override
  bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;

  @override
  double getEstimatedCost(String text) {
    // Rough estimate based on GPT-4o pricing
    // $5/1M input tokens, $15/1M output tokens
    // Average ~4 chars per token
    final inputTokens = text.length / 4;
    final outputTokens = 500; // Average response

    return (inputTokens * 5 / 1000000) + (outputTokens * 15 / 1000000);
  }

  @override
  Future<AIAnalysis> analyzeEmotionalContent({
    required String text,
    String? mood,
    String? previousContext,
  }) async {
    if (!isConfigured) {
      throw Exception('OpenAI API key not configured');
    }

    try {
      if (kDebugMode) {
        debugPrint('Analyzing with OpenAI $_model: ${text.length} characters');
      }

      final prompt = _buildEmotionalAnalysisPrompt(text, mood, previousContext);

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': _getSystemPrompt(),
            },
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
          'top_p': 0.9,
          'response_format': {'type': 'json_object'}, // Request JSON response
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final analysisText = data['choices']?[0]?['message']?['content'] ?? '';

        if (kDebugMode) {
          debugPrint('OpenAI analysis completed successfully');
          debugPrint('Usage: ${data['usage']}');
        }

        return _parseOpenAIResponse(analysisText);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'Unknown error';

        if (kDebugMode) {
          debugPrint('OpenAI API error (${response.statusCode}): $errorMessage');
        }

        throw Exception('OpenAI API error: $errorMessage');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('OpenAI analysis error: $e');
      }

      // Return fallback analysis instead of crashing
      return _createFallbackAnalysis(text, mood);
    }
  }

  String _getSystemPrompt() {
    return '''You are an empathetic emotional intelligence assistant for a mental wellness journaling app called Odyseya. Your role is to:

1. Analyze journal entries with deep emotional understanding
2. Identify emotional patterns, triggers, and underlying themes
3. Provide compassionate, actionable insights
4. Suggest healthy coping strategies and self-care practices
5. Track emotional growth over time

Always be:
- Empathetic and non-judgmental
- Specific and actionable in suggestions
- Mindful of mental health best practices
- Encouraging of professional help when appropriate

Respond ONLY with valid JSON matching this exact structure:
{
  "emotionalTone": "brief overall emotional state",
  "confidence": 0.85,
  "triggers": ["specific trigger 1", "specific trigger 2"],
  "insight": "detailed compassionate insight about their emotional state and patterns",
  "suggestions": ["actionable suggestion 1", "actionable suggestion 2", "actionable suggestion 3"],
  "emotionScores": {
    "joy": 0.3,
    "sadness": 0.6,
    "anxiety": 0.4,
    "calm": 0.2,
    "anger": 0.1,
    "hope": 0.5
  }
}''';
  }

  String _buildEmotionalAnalysisPrompt(
    String text,
    String? mood,
    String? previousContext,
  ) {
    final buffer = StringBuffer();

    buffer.writeln('Analyze this journal entry:');
    buffer.writeln();
    buffer.writeln('Entry: "$text"');

    if (mood != null && mood.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('User-selected mood: $mood');
    }

    if (previousContext != null && previousContext.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Recent context: $previousContext');
    }

    buffer.writeln();
    buffer.writeln('Provide a JSON analysis with:');
    buffer.writeln('- emotionalTone: The primary emotional state');
    buffer.writeln('- confidence: Your confidence (0.0-1.0)');
    buffer.writeln('- triggers: Specific events/thoughts causing emotions');
    buffer.writeln('- insight: Compassionate analysis of patterns');
    buffer.writeln('- suggestions: 3-5 actionable self-care recommendations');
    buffer.writeln('- emotionScores: Scores for joy, sadness, anxiety, calm, anger, hope');

    return buffer.toString();
  }

  AIAnalysis _parseOpenAIResponse(String responseText) {
    try {
      // Try to parse as JSON first (if we got the format right)
      final jsonData = json.decode(responseText) as Map<String, dynamic>;

      return AIAnalysis(
        emotionalTone: jsonData['emotionalTone'] as String? ?? 'neutral',
        confidence: (jsonData['confidence'] as num?)?.toDouble() ?? 0.8,
        triggers: List<String>.from(jsonData['triggers'] as List? ?? []),
        insight: jsonData['insight'] as String? ?? 'Analysis completed',
        suggestions: List<String>.from(jsonData['suggestions'] as List? ?? []),
        emotionScores: (jsonData['emotionScores'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, (v as num).toDouble())) ??
            {},
        analyzedAt: DateTime.now(),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to parse JSON response, attempting text parsing: $e');
      }

      // Fallback to text parsing if JSON fails
      return _parseTextResponse(responseText);
    }
  }

  AIAnalysis _parseTextResponse(String text) {
    // Extract information from text response
    final lines = text.split('\n').where((line) => line.trim().isNotEmpty).toList();

    String emotionalTone = 'contemplative';
    List<String> triggers = [];
    String insight = text.length > 200 ? text.substring(0, 200) : text;
    List<String> suggestions = [];

    // Try to extract structured information
    for (final line in lines) {
      final lower = line.toLowerCase();

      if (lower.contains('trigger')) {
        triggers.add(line.replaceAll(RegExp(r'^[-*•]\s*'), ''));
      } else if (lower.contains('suggest') || lower.contains('recommend')) {
        suggestions.add(line.replaceAll(RegExp(r'^[-*•]\s*'), ''));
      } else if (lower.contains('emotional') || lower.contains('feeling')) {
        emotionalTone = line.split(':').last.trim();
      }
    }

    // Ensure we have at least some suggestions
    if (suggestions.isEmpty) {
      suggestions = [
        'Take time for self-reflection',
        'Practice mindfulness or meditation',
        'Connect with supportive friends or family',
      ];
    }

    return AIAnalysis(
      emotionalTone: emotionalTone,
      confidence: 0.75,
      triggers: triggers,
      insight: insight,
      suggestions: suggestions,
      emotionScores: {
        'contemplative': 0.7,
        'calm': 0.5,
        'hopeful': 0.4,
      },
      analyzedAt: DateTime.now(),
    );
  }

  AIAnalysis _createFallbackAnalysis(String text, String? mood) {
    return AIAnalysis(
      emotionalTone: mood ?? 'reflective',
      confidence: 0.6,
      triggers: ['Unable to analyze - API error'],
      insight: 'Thank you for journaling. Your thoughts are being recorded.',
      suggestions: [
        'Continue regular journaling',
        'Practice self-compassion',
        'Reach out to support if needed',
      ],
      emotionScores: {
        'neutral': 0.7,
      },
      analyzedAt: DateTime.now(),
    );
  }
}
