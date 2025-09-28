import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/ai_analysis.dart';
import 'ai_service_factory.dart';

class AIAnalysisService {
  static const String _claudeUrl = 'https://api.anthropic.com/v1/messages';

  // Mock API keys - in production, use environment variables or secure storage
  static const String _claudeKey = 'your-claude-api-key';

  // Use new AI service factory for real analysis
  final AIServiceFactory _aiFactory = AIServiceFactory();

  Future<AIAnalysis> analyzeEmotion(String text, {String? mood}) async {
    try {
      if (text.isEmpty) {
        throw AIAnalysisException('Text cannot be empty');
      }

      // Try to use real AI service first
      if (_aiFactory.isCurrentServiceConfigured) {
        if (kDebugMode) {
          print(
            'Using real AI service: ${_aiFactory.getCurrentService().serviceName}',
          );
        }

        try {
          return await _aiFactory.getCurrentService().analyzeEmotionalContent(
            text: text,
            mood: mood,
          );
        } catch (e) {
          if (kDebugMode) {
            print('Real AI service failed, falling back to mock: $e');
          }
          // Fall back to mock if real service fails
        }
      }

      if (kDebugMode) {
        print('Using mock AI analysis (no API configured)');
      }

      // Simulate API delay for mock
      await Future.delayed(const Duration(seconds: 2));

      // Enhanced mock analysis
      return _generateMockAnalysis(text, mood);
    } catch (e) {
      throw AIAnalysisException('Failed to analyze emotion: $e');
    }
  }

  Future<List<String>> detectTriggers(String text) async {
    try {
      final analysis = await analyzeEmotion(text);
      return analysis.triggers;
    } catch (e) {
      throw AIAnalysisException('Failed to detect triggers: $e');
    }
  }

  Future<String> generateInsight(String text, String mood) async {
    try {
      final analysis = await analyzeEmotion(text);
      return analysis.insight;
    } catch (e) {
      throw AIAnalysisException('Failed to generate insight: $e');
    }
  }

  Future<List<String>> generateSuggestions(String text, String mood) async {
    try {
      final analysis = await analyzeEmotion(text);
      return analysis.suggestions;
    } catch (e) {
      throw AIAnalysisException('Failed to generate suggestions: $e');
    }
  }

  AIAnalysis _generateMockAnalysis(String text, String? mood) {
    final random = Random();
    final words = text.toLowerCase().split(' ');

    // Analyze emotional tone based on keywords and mood
    String emotionalTone;
    Map<String, double> emotionScores = {};
    double confidence;

    // Detect emotional keywords
    final positiveWords = [
      'happy',
      'joy',
      'good',
      'great',
      'wonderful',
      'excited',
      'love',
      'amazing',
      'peaceful',
      'calm',
    ];
    final negativeWords = [
      'sad',
      'angry',
      'frustrated',
      'worried',
      'anxious',
      'stressed',
      'overwhelmed',
      'hurt',
      'upset',
      'tired',
    ];

    int positiveCount = words
        .where((word) => positiveWords.contains(word))
        .length;
    int negativeCount = words
        .where((word) => negativeWords.contains(word))
        .length;

    // Consider mood input if provided
    if (mood != null) {
      final moodLower = mood.toLowerCase();
      if (positiveWords.any((word) => moodLower.contains(word))) {
        positiveCount++;
      } else if (negativeWords.any((word) => moodLower.contains(word))) {
        negativeCount++;
      }
    }

    if (negativeCount > positiveCount) {
      emotionalTone = 'Reflective and Processing';
      emotionScores = {
        'contemplative': 0.7 + random.nextDouble() * 0.2,
        'processing': 0.6 + random.nextDouble() * 0.3,
        'introspective': 0.5 + random.nextDouble() * 0.4,
      };
      confidence = 0.75 + random.nextDouble() * 0.2;
    } else if (positiveCount > negativeCount) {
      emotionalTone = 'Positive and Hopeful';
      emotionScores = {
        'hopeful': 0.8 + random.nextDouble() * 0.15,
        'content': 0.7 + random.nextDouble() * 0.25,
        'optimistic': 0.6 + random.nextDouble() * 0.3,
      };
      confidence = 0.8 + random.nextDouble() * 0.15;
    } else {
      emotionalTone = 'Balanced and Thoughtful';
      emotionScores = {
        'balanced': 0.7 + random.nextDouble() * 0.2,
        'thoughtful': 0.6 + random.nextDouble() * 0.3,
        'steady': 0.5 + random.nextDouble() * 0.4,
      };
      confidence = 0.7 + random.nextDouble() * 0.2;
    }

    // Generate triggers based on content
    List<String> triggers = [];
    if (words.any(
      (word) => ['work', 'job', 'deadline', 'meeting', 'boss'].contains(word),
    )) {
      triggers.add('Work-related stress');
    }
    if (words.any(
      (word) => ['relationship', 'family', 'friend', 'partner'].contains(word),
    )) {
      triggers.add('Interpersonal dynamics');
    }
    if (words.any(
      (word) => ['time', 'busy', 'schedule', 'rushing'].contains(word),
    )) {
      triggers.add('Time pressure');
    }
    if (words.any(
      (word) => ['money', 'financial', 'bills', 'budget'].contains(word),
    )) {
      triggers.add('Financial concerns');
    }

    // Generate supportive insight
    String insight = _generateInsightBasedOnTone(emotionalTone, text.length);

    // Generate helpful suggestions
    List<String> suggestions = _generateSuggestions(emotionalTone, triggers);

    return AIAnalysis(
      emotionalTone: emotionalTone,
      confidence: confidence,
      triggers: triggers,
      insight: insight,
      suggestions: suggestions,
      emotionScores: emotionScores,
      analyzedAt: DateTime.now(),
    );
  }

  String _generateInsightBasedOnTone(String tone, int textLength) {
    if (tone.contains('Reflective')) {
      return "You're taking time to process your experiences, which shows emotional awareness. It's natural to work through complex feelings, and giving yourself space to reflect is a healthy way to understand what you're experiencing.";
    } else if (tone.contains('Positive')) {
      return "There's a sense of lightness and hope in your words. You're connecting with positive emotions, which can be a source of strength. Notice how these feelings emerge and what nurtures them in your life.";
    } else {
      return "You're expressing yourself thoughtfully and with balance. This kind of measured reflection often leads to deeper self-understanding and can help you navigate whatever you're experiencing with greater clarity.";
    }
  }

  List<String> _generateSuggestions(String tone, List<String> triggers) {
    List<String> suggestions = [
      "Take a few moments for deep breathing or gentle movement",
      "Consider journaling about this experience to explore it further",
      "Connect with someone you trust about your feelings",
    ];

    if (triggers.contains('Work-related stress')) {
      suggestions.add("Set small, achievable goals to reduce work overwhelm");
      suggestions.add("Consider taking short breaks throughout your day");
    }

    if (triggers.contains('Time pressure')) {
      suggestions.add("Practice saying no to non-essential commitments");
      suggestions.add("Try time-blocking to create structure in your schedule");
    }

    if (triggers.contains('Interpersonal dynamics')) {
      suggestions.add("Reflect on healthy boundaries in your relationships");
      suggestions.add(
        "Consider having an open conversation with those involved",
      );
    }

    if (tone.contains('Positive')) {
      suggestions.add("Notice what brought about these positive feelings");
      suggestions.add("Consider how to cultivate more of these experiences");
    }

    return suggestions.take(4).toList(); // Limit to 4 suggestions
  }

  /* Unused method - commented out to fix warning
  Future<AIAnalysis> _callClaudeAPI(String text) async {
    try {
      final prompt = _buildEmotionalAnalysisPrompt(text);
      
      final response = await http.post(
        Uri.parse(_claudeUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _claudeKey,
          'anthropic-version': '2023-06-01',
        },
        body: json.encode({
          'model': 'claude-3-sonnet-20240229',
          'max_tokens': 1000,
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseClaudeResponse(data['content'][0]['text']);
      } else {
        throw AIAnalysisException('Claude API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw AIAnalysisException('Claude API call failed: $e');
    }
  }
  */

  String _buildEmotionalAnalysisPrompt(String text) {
    return '''
Please analyze the emotional content of this journal entry with warmth and understanding. Provide:

1. Overall emotional tone (be specific and nuanced)
2. Confidence level (0-1)
3. Potential emotional triggers mentioned
4. A supportive, non-judgmental insight (2-3 sentences)
5. 3-4 gentle, actionable suggestions for emotional well-being
6. Emotion scores for detected emotions (0-1)

Journal entry:
"$text"

Please respond in JSON format with these exact keys: emotionalTone, confidence, triggers, insight, suggestions, emotionScores.

Remember to be supportive, non-judgmental, and focus on emotional growth and well-being.
''';
  }

  AIAnalysis _parseClaudeResponse(String response) {
    try {
      final data = json.decode(response);
      return AIAnalysis(
        emotionalTone: data['emotionalTone'] ?? 'Neutral',
        confidence: (data['confidence'] ?? 0.5).toDouble(),
        triggers: List<String>.from(data['triggers'] ?? []),
        insight: data['insight'] ?? '',
        suggestions: List<String>.from(data['suggestions'] ?? []),
        emotionScores: Map<String, double>.from(
          data['emotionScores']?.map(
                (key, value) => MapEntry(key, (value ?? 0.0).toDouble()),
              ) ??
              {},
        ),
        analyzedAt: DateTime.now(),
      );
    } catch (e) {
      throw AIAnalysisException('Failed to parse AI response: $e');
    }
  }
}

class AIAnalysisException implements Exception {
  final String message;
  AIAnalysisException(this.message);

  @override
  String toString() => 'AIAnalysisException: $message';
}
