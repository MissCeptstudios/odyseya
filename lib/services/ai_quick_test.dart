import 'package:flutter/foundation.dart';
import 'ai_config_service.dart';
import 'ai_service_factory.dart';

/// Quick test utility for AI services
class AIQuickTest {
  static Future<void> runQuickTest() async {
    if (!kDebugMode) return; // Only run in debug mode
    
    try {
      debugPrint('🧪 Running quick AI service test...');
      
      final config = AIConfigService();
      final factory = AIServiceFactory();
      
      // Test configuration
      final status = config.getConfigurationStatus();
      debugPrint('Current service: ${status.serviceName}');
      debugPrint('Is configured: ${status.isConfigured}');
      
      if (!status.isConfigured) {
        debugPrint('❌ No AI service configured');
        return;
      }
      
      // Test with sample journal text
      final sampleText = 'I feel excited about starting this new project today. It has some challenges but I am ready to learn and grow.';
      final sampleMood = 'optimistic';
      
      debugPrint('Testing AI analysis with sample journal entry...');
      
      final service = factory.getCurrentService();
      final startTime = DateTime.now();
      
      final analysis = await service.analyzeEmotionalContent(
        text: sampleText,
        mood: sampleMood,
      );
      
      final duration = DateTime.now().difference(startTime);
      
      debugPrint('✅ AI Analysis completed in ${duration.inMilliseconds}ms');
      debugPrint('Emotional tone: ${analysis.emotionalTone}');
      debugPrint('Confidence: ${(analysis.confidence * 100).toStringAsFixed(1)}%');
      debugPrint('Triggers: ${analysis.triggers.join(', ')}');
      debugPrint('Suggestions count: ${analysis.suggestions.length}');
      debugPrint('Insight preview: ${analysis.insight.length > 100 ? '${analysis.insight.substring(0, 100)}...' : analysis.insight}');
      
      debugPrint('🎉 AI service test completed successfully!');
      
    } catch (e) {
      debugPrint('❌ AI service test failed: $e');
    }
  }
  
  /// Test specifically with user mood context
  static Future<void> testWithMood(String text, String mood) async {
    if (!kDebugMode) return;
    
    try {
      debugPrint('🧪 Testing AI analysis with mood: $mood');
      
      final factory = AIServiceFactory();
      final service = factory.getCurrentService();
      
      final analysis = await service.analyzeEmotionalContent(
        text: text,
        mood: mood,
      );
      
      debugPrint('Result for "$mood" mood:');
      debugPrint('- Emotional tone: ${analysis.emotionalTone}');
      debugPrint('- Confidence: ${(analysis.confidence * 100).toStringAsFixed(1)}%');
      debugPrint('- Top emotions: ${analysis.emotionScores.entries.where((e) => e.value > 0.2).map((e) => '${e.key}: ${(e.value * 100).toStringAsFixed(0)}%').join(', ')}');
      
    } catch (e) {
      debugPrint('❌ Mood test failed: $e');
    }
  }
}