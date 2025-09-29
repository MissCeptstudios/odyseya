import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/ai_analysis.dart';
import 'ai_service_interface.dart';

class GroqAIService implements AIServiceInterface {
  static final GroqAIService _instance = GroqAIService._internal();
  factory GroqAIService() => _instance;
  GroqAIService._internal();

  // Groq API configuration (FREE & Very Fast)
  static const String _baseUrl = 'https://api.groq.com/openai/v1';
  
  String? _apiKey;

  @override
  String get serviceName => 'Groq (Llama 3)';

  void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }

  @override
  bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;

  @override
  double getEstimatedCost(String text) {
    // Groq is FREE with generous limits
    return 0.0;
  }

  @override
  Future<AIAnalysis> analyzeEmotionalContent({
    required String text,
    String? mood,
    String? previousContext,
  }) async {
    if (!isConfigured) {
      throw Exception('Groq API key not configured');
    }

    try {
      if (kDebugMode) {
        debugPrint('Analyzing with Groq Llama 3: ${text.length} characters');
      }

      final prompt = _buildEmotionalAnalysisPrompt(text, mood, previousContext);
      
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': 'llama3-8b-8192', // Fast and capable model
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
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final analysisText = data['choices']?[0]?['message']?['content'] ?? '';
        
        if (kDebugMode) {
          debugPrint('Groq analysis completed successfully');
        }
        
        return _parseGroqResponse(analysisText);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'Unknown error';
        
        if (kDebugMode) {
          debugPrint('Groq API error (${response.statusCode}): $errorMessage');
        }
        
        throw Exception('Groq API error: $errorMessage');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Groq analysis error: $e');
      }
      
      // Return fallback analysis instead of crashing
      return _createFallbackAnalysis(text, mood);
    }
  }

  /// System prompt for Groq to establish context and behavior
  String _getSystemPrompt() {
    return '''
You are an empathetic AI wellness assistant for Odyseya, a journaling app focused on emotional well-being. Your role is to provide supportive, non-judgmental emotional analysis.

Key principles:
- Be warm, understanding, and supportive
- Avoid clinical or diagnostic language
- Focus on emotional validation and growth
- Provide actionable, gentle suggestions
- Use encouraging, hopeful language
- Respect the user's emotional experience

Always respond with valid JSON only, no additional text or formatting.
''';
  }

  /// Build analysis prompt for Groq
  String _buildEmotionalAnalysisPrompt(String text, String? mood, String? context) {
    return '''
Please analyze this journal entry and provide emotional insights:

JOURNAL ENTRY: "$text"
${mood != null ? 'CURRENT MOOD: $mood' : ''}
${context != null ? 'CONTEXT: $context' : ''}

Respond with ONLY this JSON structure:

{
  "emotionalTone": "primary_emotion_one_word",
  "confidence": confidence_float_0_to_1,
  "triggers": ["specific_trigger1", "specific_trigger2", "specific_trigger3"],
  "insight": "One supportive insight about their emotional state (1-2 sentences)",
  "suggestions": ["actionable_suggestion1", "actionable_suggestion2", "actionable_suggestion3"],
  "emotionScores": {
    "joy": score_0_to_1,
    "sadness": score_0_to_1,
    "anger": score_0_to_1,
    "fear": score_0_to_1,
    "surprise": score_0_to_1,
    "calm": score_0_to_1
  }
}

Requirements:
- emotionalTone: single word (joy, sadness, anger, fear, surprise, calm, anxious, hopeful, etc.)
- confidence: 0.0 to 1.0 based on clarity of emotions
- triggers: 2-3 specific things that influenced their emotions
- insight: warm, validating message (avoid clinical terms)
- suggestions: 3 specific, achievable self-care actions
- emotionScores: all 6 emotions required, values 0.0-1.0

Respond with JSON only, no markdown or extra text.
''';
  }

  /// Parse Groq response into AIAnalysis
  AIAnalysis _parseGroqResponse(String responseText) {
    try {
      // Clean up response text
      String cleanedText = responseText.trim();
      
      // Remove any markdown formatting that might be present
      cleanedText = cleanedText.replaceAll('```json', '').replaceAll('```', '');
      
      // Find JSON boundaries
      final jsonStart = cleanedText.indexOf('{');
      final jsonEnd = cleanedText.lastIndexOf('}') + 1;
      
      if (jsonStart == -1 || jsonEnd == 0) {
        throw Exception('No JSON found in Groq response');
      }
      
      final jsonText = cleanedText.substring(jsonStart, jsonEnd);
      final data = json.decode(jsonText);

      // Extract and validate data
      final emotionalTone = (data['emotionalTone'] ?? 'neutral').toString();
      final confidence = ((data['confidence'] ?? 0.8) as num).toDouble().clamp(0.0, 1.0);
      
      final triggers = List<String>.from(data['triggers'] ?? ['emotional reflection']);
      final insight = (data['insight'] ?? 'Your emotional awareness shows great self-compassion.').toString();
      final suggestions = List<String>.from(data['suggestions'] ?? [
        'Take a moment to breathe deeply',
        'Practice self-kindness today',
        'Acknowledge your feelings without judgment'
      ]);
      
      // Parse emotion scores with validation
      final rawEmotionScores = data['emotionScores'] ?? {};
      final emotionScores = <String, double>{};
      
      const requiredEmotions = ['joy', 'sadness', 'anger', 'fear', 'surprise', 'calm'];
      for (final emotion in requiredEmotions) {
        final score = ((rawEmotionScores[emotion] ?? 0.15) as num).toDouble().clamp(0.0, 1.0);
        emotionScores[emotion] = score;
      }

      return AIAnalysis(
        emotionalTone: emotionalTone,
        confidence: confidence,
        triggers: triggers.take(3).toList(),
        insight: insight,
        suggestions: suggestions.take(3).toList(),
        emotionScores: emotionScores,
        analyzedAt: DateTime.now(),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error parsing Groq response: $e');
        debugPrint('Raw response: $responseText');
      }
      
      return _createFallbackAnalysis(responseText, null);
    }
  }

  /// Create intelligent fallback analysis
  AIAnalysis _createFallbackAnalysis(String text, String? mood) {
    final lowerText = text.toLowerCase();
    final words = lowerText.split(RegExp(r'\W+'));
    
    // Enhanced emotion detection
    final emotionPatterns = {
      'joy': ['happy', 'joy', 'excited', 'good', 'great', 'amazing', 'wonderful', 'love', 'fantastic', 'proud', 'grateful', 'blessed'],
      'sadness': ['sad', 'depressed', 'down', 'upset', 'hurt', 'lonely', 'disappointed', 'crying', 'heartbroken', 'lost', 'empty'],
      'anger': ['angry', 'frustrated', 'annoyed', 'mad', 'irritated', 'furious', 'rage', 'hate', 'disgusted', 'outraged'],
      'fear': ['worried', 'anxious', 'scared', 'nervous', 'afraid', 'stressed', 'panic', 'overwhelmed', 'terrified', 'uncertain'],
      'surprise': ['surprised', 'shocked', 'unexpected', 'sudden', 'wow', 'unbelievable', 'stunned'],
      'calm': ['calm', 'peaceful', 'relaxed', 'content', 'serene', 'balanced', 'quiet', 'centered', 'tranquil']
    };

    Map<String, double> emotions = {
      'joy': 0.1,
      'sadness': 0.1,
      'anger': 0.05,
      'fear': 0.1,
      'surprise': 0.05,
      'calm': 0.4, // Higher baseline for calm
    };

    // Advanced pattern matching
    for (final word in words) {
      for (final emotion in emotionPatterns.keys) {
        if (emotionPatterns[emotion]!.contains(word)) {
          emotions[emotion] = emotions[emotion]! + 0.2;
        }
      }
    }

    // Consider text length and complexity for confidence
    final textLength = text.length;
    final wordCount = words.length;
    final hasEmotionalWords = emotions.values.any((score) => score > 0.3);
    
    // Normalize emotion scores
    final total = emotions.values.reduce((a, b) => a + b);
    if (total > 0) {
      emotions = emotions.map((key, value) => MapEntry(key, (value / total).clamp(0.0, 1.0)));
    }

    final dominantEmotion = emotions.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    final confidence = hasEmotionalWords ? 0.7 : 0.5;

    return AIAnalysis(
      emotionalTone: dominantEmotion,
      confidence: confidence,
      triggers: _identifyTriggers(text),
      insight: _generateInsight(dominantEmotion, textLength, wordCount),
      suggestions: _generateSuggestions(dominantEmotion),
      emotionScores: emotions,
      analyzedAt: DateTime.now(),
    );
  }

  List<String> _identifyTriggers(String text) {
    final triggers = <String>[];
    final lowerText = text.toLowerCase();
    
    final triggerCategories = {
      'work stress': ['work', 'job', 'boss', 'colleague', 'deadline', 'meeting', 'project', 'office'],
      'family dynamics': ['family', 'parent', 'mom', 'dad', 'sister', 'brother', 'child', 'kids', 'home'],
      'relationships': ['relationship', 'partner', 'boyfriend', 'girlfriend', 'spouse', 'friend', 'love'],
      'health concerns': ['health', 'sick', 'tired', 'exhausted', 'doctor', 'pain', 'sleep'],
      'financial pressure': ['money', 'financial', 'budget', 'expensive', 'bill', 'debt', 'cost'],
      'personal growth': ['future', 'goals', 'dreams', 'change', 'growth', 'learning', 'self'],
      'social situations': ['social', 'party', 'people', 'crowd', 'friends', 'alone'],
    };

    for (final category in triggerCategories.keys) {
      for (final keyword in triggerCategories[category]!) {
        if (lowerText.contains(keyword)) {
          triggers.add(category);
          break;
        }
      }
    }
    
    return triggers.isEmpty ? ['daily reflection'] : triggers.take(3).toList();
  }

  String _generateInsight(String emotion, int textLength, int wordCount) {
    final insights = {
      'joy': 'Your joy radiates through your words. These positive moments are gifts that can fuel your resilience.',
      'sadness': 'Acknowledging sadness takes courage. This feeling is temporary, and you\'re showing strength by expressing it.',
      'anger': 'Your anger signals that something important needs attention. Understanding its source can lead to positive change.',
      'fear': 'Recognizing fear is the first step toward courage. You have the strength to face what concerns you.',
      'surprise': 'Life\'s surprises can be teachers. Stay curious about what this unexpected moment might reveal.',
      'calm': 'Your inner peace is a powerful foundation. This tranquility can guide you through life\'s challenges.',
    };
    
    final baseInsight = insights[emotion] ?? 'Your emotional awareness is a sign of wisdom and self-compassion.';
    
    // Add context based on entry characteristics
    if (textLength > 200) {
      return '$baseInsight Your detailed reflection shows deep self-awareness.';
    } else if (wordCount < 10) {
      return '$baseInsight Sometimes few words carry the most meaning.';
    }
    
    return baseInsight;
  }

  List<String> _generateSuggestions(String emotion) {
    final suggestionMap = {
      'joy': [
        'Share this positive energy with someone who matters to you',
        'Write down what specifically brought you joy today',
        'Take a photo or create a memory of this happy moment'
      ],
      'sadness': [
        'Practice gentle self-compassion - speak to yourself like a dear friend',
        'Consider calling someone who makes you feel understood',
        'Engage in a nurturing activity like a warm bath or favorite music'
      ],
      'anger': [
        'Take 10 deep breaths before taking any action',
        'Try vigorous exercise like walking or dancing to release tension',
        'Write out your frustrations without censoring yourself'
      ],
      'fear': [
        'Use the 5-4-3-2-1 grounding technique to stay present',
        'Break down your concerns into small, manageable steps',
        'Remind yourself of past times you overcame difficult situations'
      ],
      'surprise': [
        'Give yourself time to process this unexpected development',
        'Journal about how this surprise might lead to growth',
        'Talk to a trusted friend about your experience'
      ],
      'calm': [
        'Notice what contributed to this peaceful feeling',
        'Practice gratitude for this moment of serenity',
        'Consider creating more space for calmness in your routine'
      ],
    };
    
    return suggestionMap[emotion] ?? [
      'Continue exploring your emotions through writing',
      'Practice mindful breathing when feelings feel overwhelming',
      'Remember that all emotions are temporary and valid'
    ];
  }
}