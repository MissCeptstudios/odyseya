import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/ai_analysis.dart';
import 'ai_service_interface.dart';

class GeminiAIService implements AIServiceInterface {
  static final GeminiAIService _instance = GeminiAIService._internal();
  factory GeminiAIService() => _instance;
  GeminiAIService._internal();

  // Google Gemini API configuration (FREE - 1M tokens/month)
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  
  String? _apiKey;

  @override
  String get serviceName => 'Google Gemini Pro';

  void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }

  @override
  bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;

  @override
  double getEstimatedCost(String text) {
    // Gemini is FREE up to 1M tokens/month
    return 0.0;
  }

  @override
  Future<AIAnalysis> analyzeEmotionalContent({
    required String text,
    String? mood,
    String? previousContext,
  }) async {
    if (!isConfigured) {
      throw Exception('Google Gemini API key not configured');
    }

    try {
      if (kDebugMode) {
        debugPrint('Analyzing with Gemini Pro: ${text.length} characters');
      }

      final prompt = _buildEmotionalAnalysisPrompt(text, mood, previousContext);
      
      final response = await http.post(
        Uri.parse('$_baseUrl/models/gemini-pro:generateContent?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'contents': [{
            'parts': [{'text': prompt}]
          }],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1000,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_HARASSMENT',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            },
            {
              'category': 'HARM_CATEGORY_HATE_SPEECH',
              'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final analysisText = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
        
        if (kDebugMode) {
          debugPrint('Gemini analysis completed successfully');
        }
        
        return _parseGeminiResponse(analysisText);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'Unknown error';
        
        if (kDebugMode) {
          debugPrint('Gemini API error (${response.statusCode}): $errorMessage');
        }
        
        throw Exception('Gemini API error: $errorMessage');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Gemini analysis error: $e');
      }
      
      // Return fallback analysis instead of crashing
      return _createFallbackAnalysis(text, mood);
    }
  }

  /// Build comprehensive analysis prompt for Gemini
  String _buildEmotionalAnalysisPrompt(String text, String? mood, String? context) {
    return '''
You are an empathetic emotional wellness AI assistant for a journaling app called Odyseya. Your role is to provide supportive, non-judgmental emotional analysis.

JOURNAL ENTRY: "$text"
${mood != null ? 'USER\'S CURRENT MOOD: $mood' : ''}
${context != null ? 'PREVIOUS CONTEXT: $context' : ''}

Please analyze this journal entry and respond with ONLY a valid JSON object in this exact format:

{
  "emotionalTone": "primary_emotion_detected",
  "confidence": 0.85,
  "triggers": ["trigger1", "trigger2", "trigger3"],
  "insight": "One empathetic, supportive insight (1-2 sentences max)",
  "suggestions": ["actionable_suggestion1", "actionable_suggestion2", "actionable_suggestion3"],
  "emotionScores": {
    "joy": 0.2,
    "sadness": 0.1,
    "anger": 0.0,
    "fear": 0.3,
    "surprise": 0.1,
    "calm": 0.7
  }
}

GUIDELINES:
- emotionalTone: Use one word (joy, sadness, anger, fear, surprise, calm, anxious, hopeful, etc.)
- confidence: Float between 0.0-1.0 based on how clear the emotions are
- triggers: Identify 2-3 specific things that influenced their emotions
- insight: Be warm, validating, and understanding (avoid clinical language)
- suggestions: Provide 3 specific, actionable self-care recommendations
- emotionScores: All 6 emotions must be present, scores 0.0-1.0, should roughly sum to 1.0

TONE: Supportive, warm, non-judgmental, like a caring friend who understands emotions
AVOID: Clinical terms, diagnosis, overwhelming advice, toxic positivity

Respond with ONLY the JSON object, no other text.
''';
  }

  /// Parse Gemini response into AIAnalysis
  AIAnalysis _parseGeminiResponse(String responseText) {
    try {
      // Clean up response text - sometimes Gemini adds markdown formatting
      String cleanedText = responseText.trim();
      
      // Remove markdown code blocks if present
      if (cleanedText.contains('```json')) {
        cleanedText = cleanedText.replaceAll('```json', '');
        cleanedText = cleanedText.replaceAll('```', '');
      }
      
      // Find JSON object boundaries
      final jsonStart = cleanedText.indexOf('{');
      final jsonEnd = cleanedText.lastIndexOf('}') + 1;
      
      if (jsonStart == -1 || jsonEnd == 0) {
        throw Exception('No JSON found in response');
      }
      
      final jsonText = cleanedText.substring(jsonStart, jsonEnd);
      final data = json.decode(jsonText);

      // Validate and extract data with fallbacks
      final emotionalTone = (data['emotionalTone'] ?? 'neutral').toString();
      final confidence = ((data['confidence'] ?? 0.8) as num).toDouble().clamp(0.0, 1.0);
      final triggers = List<String>.from(data['triggers'] ?? ['self-reflection']);
      final insight = (data['insight'] ?? 'Thank you for sharing your thoughts. Your emotions are valid and important.').toString();
      final suggestions = List<String>.from(data['suggestions'] ?? [
        'Take a few deep breaths',
        'Practice self-compassion',
        'Consider what you learned about yourself today'
      ]);
      
      // Parse emotion scores with validation
      final rawEmotionScores = data['emotionScores'] ?? {};
      final emotionScores = <String, double>{};
      
      // Ensure all required emotions are present
      const requiredEmotions = ['joy', 'sadness', 'anger', 'fear', 'surprise', 'calm'];
      for (final emotion in requiredEmotions) {
        final score = ((rawEmotionScores[emotion] ?? 0.1) as num).toDouble().clamp(0.0, 1.0);
        emotionScores[emotion] = score;
      }

      return AIAnalysis(
        emotionalTone: emotionalTone,
        confidence: confidence,
        triggers: triggers,
        insight: insight,
        suggestions: suggestions,
        emotionScores: emotionScores,
        analyzedAt: DateTime.now(),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error parsing Gemini response: $e');
        debugPrint('Raw response: $responseText');
      }
      
      // Return intelligent fallback instead of crashing
      return _createFallbackAnalysis(responseText, null);
    }
  }

  /// Create fallback analysis when API fails or parsing fails
  AIAnalysis _createFallbackAnalysis(String text, String? mood) {
    // Simple but intelligent keyword-based analysis
    final lowerText = text.toLowerCase();
    final words = lowerText.split(RegExp(r'\W+'));
    
    // Emotion detection with keywords
    final emotionKeywords = {
      'joy': ['happy', 'joy', 'excited', 'good', 'great', 'amazing', 'wonderful', 'love', 'fantastic', 'awesome', 'celebrate'],
      'sadness': ['sad', 'depressed', 'down', 'upset', 'hurt', 'lonely', 'disappointed', 'crying', 'tears', 'heartbroken'],
      'anger': ['angry', 'frustrated', 'annoyed', 'mad', 'irritated', 'furious', 'rage', 'hate', 'disgusted'],
      'fear': ['worried', 'anxious', 'scared', 'nervous', 'afraid', 'stressed', 'panic', 'overwhelmed', 'terrified'],
      'surprise': ['surprised', 'shocked', 'unexpected', 'sudden', 'wow', 'amazing', 'incredible'],
      'calm': ['calm', 'peaceful', 'relaxed', 'content', 'serene', 'balanced', 'quiet', 'still', 'meditative']
    };

    Map<String, double> emotions = {
      'joy': 0.1,
      'sadness': 0.1,
      'anger': 0.1,
      'fear': 0.1,
      'surprise': 0.1,
      'calm': 0.3, // Default baseline
    };

    // Count emotion words
    for (final word in words) {
      for (final emotion in emotionKeywords.keys) {
        if (emotionKeywords[emotion]!.contains(word)) {
          emotions[emotion] = emotions[emotion]! + 0.15;
        }
      }
    }

    // Normalize scores to sum roughly to 1.0
    final total = emotions.values.reduce((a, b) => a + b);
    if (total > 0) {
      emotions = emotions.map((key, value) => MapEntry(key, (value / total).clamp(0.0, 1.0)));
    }

    // Find dominant emotion
    final dominantEmotion = emotions.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return AIAnalysis(
      emotionalTone: dominantEmotion,
      confidence: 0.6,
      triggers: _extractBasicTriggers(text),
      insight: _generateBasicInsight(dominantEmotion, mood),
      suggestions: _generateBasicSuggestions(dominantEmotion),
      emotionScores: emotions,
      analyzedAt: DateTime.now(),
    );
  }

  List<String> _extractBasicTriggers(String text) {
    final triggers = <String>[];
    final lowerText = text.toLowerCase();
    
    // Common trigger categories
    final triggerKeywords = {
      'work': ['work', 'job', 'boss', 'colleague', 'office', 'meeting', 'deadline', 'project'],
      'family': ['family', 'parent', 'mom', 'dad', 'sister', 'brother', 'child', 'kids'],
      'relationships': ['relationship', 'partner', 'boyfriend', 'girlfriend', 'spouse', 'marriage', 'love'],
      'health': ['health', 'sick', 'doctor', 'hospital', 'pain', 'tired', 'exhausted'],
      'finances': ['money', 'financial', 'budget', 'expensive', 'cost', 'bill', 'debt'],
      'social': ['friends', 'social', 'party', 'event', 'people', 'crowd'],
      'personal growth': ['future', 'goals', 'dreams', 'change', 'growth', 'learning'],
    };

    for (final category in triggerKeywords.keys) {
      for (final keyword in triggerKeywords[category]!) {
        if (lowerText.contains(keyword)) {
          triggers.add(category);
          break;
        }
      }
    }
    
    return triggers.isEmpty ? ['self-reflection'] : triggers.take(3).toList();
  }

  String _generateBasicInsight(String emotion, String? mood) {
    final insights = {
      'joy': 'Your positive energy shines through your words. These moments of joy are precious and worth celebrating.',
      'sadness': 'It takes courage to acknowledge difficult feelings. Remember that sadness is temporary and you\'re not alone.',
      'anger': 'Your anger might be pointing to something important that needs attention. Take time to understand what\'s underneath.',
      'fear': 'Recognizing your fears is the first step to working through them. You\'re braver than you know.',
      'surprise': 'Life\'s unexpected moments can teach us so much. Stay open to what this experience might reveal.',
      'calm': 'Your sense of peace is a beautiful foundation. This inner calm can guide you through whatever comes next.',
    };
    
    return insights[emotion] ?? 'Thank you for taking time to reflect. Your self-awareness is a gift to your future self.';
  }

  List<String> _generateBasicSuggestions(String emotion) {
    final suggestions = {
      'joy': [
        'Share this happiness with someone you care about',
        'Write down what specifically brought you joy today',
        'Take a moment to fully savor this positive feeling'
      ],
      'sadness': [
        'Practice gentle self-compassion - treat yourself like a good friend',
        'Consider reaching out to someone you trust',
        'Engage in a comforting activity that nurtures your soul'
      ],
      'anger': [
        'Take several deep breaths before responding to the situation',
        'Try physical movement like walking to release tension',
        'Write freely about what triggered this feeling'
      ],
      'fear': [
        'Ground yourself using the 5-4-3-2-1 technique (5 things you see, 4 you hear, etc.)',
        'Break down your worries into smaller, manageable steps',
        'Remind yourself of times you\'ve overcome challenges before'
      ],
      'surprise': [
        'Take time to process this unexpected experience',
        'Consider what you might learn from this surprise',
        'Share your experience with someone who might understand'
      ],
      'calm': [
        'Notice what helped you feel this peace',
        'Practice gratitude for this moment of tranquility',
        'Consider how you might cultivate more of this feeling'
      ],
    };
    
    return suggestions[emotion] ?? [
      'Continue exploring your feelings through journaling',
      'Practice mindfulness to stay connected with yourself', 
      'Be patient and kind as you navigate your emotions'
    ];
  }
}