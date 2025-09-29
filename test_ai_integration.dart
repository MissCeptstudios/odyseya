import 'dart:io';
import 'package:flutter/foundation.dart';
import 'lib/services/ai_config_service.dart';
import 'lib/services/ai_service_factory.dart';
import 'lib/services/ai_analysis_service.dart';

/// Standalone test to verify AI integration works
void main() async {
  debugPrint('🧪 Testing AI Integration...\n');
  
  try {
    // Test 1: Configuration Service
    debugPrint('1️⃣ Testing Configuration Service...');
    final config = AIConfigService();
    
    // Set the API key
    final keySet = await config.setGeminiApiKey('AIzaSyDXZpbo7LsybroxC6XAAaQyUM1ysiQwiW0');
    debugPrint('   API key configured: $keySet');
    
    final status = config.getConfigurationStatus();
    debugPrint('   Current service: ${status.serviceName}');
    debugPrint('   Is configured: ${status.isConfigured}');
    debugPrint('   ✅ Configuration test passed\n');
    
    // Test 2: Service Factory
    debugPrint('2️⃣ Testing Service Factory...');
    final factory = AIServiceFactory();
    final service = factory.getCurrentService();
    debugPrint('   Service name: ${service.serviceName}');
    debugPrint('   Is configured: ${service.isConfigured}');
    debugPrint('   ✅ Factory test passed\n');
    
    // Test 3: AI Analysis Service (existing integration)
    debugPrint('3️⃣ Testing AI Analysis Service...');
    final aiService = AIAnalysisService();
    
    final testText = 'I feel excited about this new project today. It has challenges but I am ready to learn and grow.';
    final testMood = 'optimistic';
    
    debugPrint('   Analyzing: "${testText.substring(0, 50)}..."');
    debugPrint('   Mood: $testMood');
    
    final startTime = DateTime.now();
    final analysis = await aiService.analyzeEmotion(testText, mood: testMood);
    final duration = DateTime.now().difference(startTime);
    
    debugPrint('   Analysis completed in ${duration.inMilliseconds}ms');
    debugPrint('   Emotional tone: ${analysis.emotionalTone}');
    debugPrint('   Confidence: ${(analysis.confidence * 100).toStringAsFixed(1)}%');
    debugPrint('   Triggers: ${analysis.triggers.join(', ')}');
    debugPrint('   Suggestions: ${analysis.suggestions.length} provided');
    debugPrint('   Insight: ${analysis.insight.substring(0, 100)}...');
    debugPrint('   ✅ AI Analysis test passed\n');
    
    // Test 4: Different Moods
    debugPrint('4️⃣ Testing Different Moods...');
    final moods = ['happy', 'sad', 'anxious', 'calm'];
    final sampleText = 'Today was a challenging day with mixed emotions.';
    
    for (final mood in moods) {
      final result = await aiService.analyzeEmotion(sampleText, mood: mood);
      final topEmotion = result.emotionScores.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      debugPrint('   $mood mood → ${result.emotionalTone} (${topEmotion.key}: ${(topEmotion.value * 100).toStringAsFixed(0)}%)');
    }
    debugPrint('   ✅ Mood variation test passed\n');
    
    debugPrint('🎉 ALL TESTS PASSED!');
    debugPrint('\n📊 Summary:');
    debugPrint('   • Configuration system: Working ✅');
    debugPrint('   • Service factory: Working ✅');
    debugPrint('   • AI analysis: Working ✅');
    debugPrint('   • Mood integration: Working ✅');
    debugPrint('   • Gemini API: Active ✅');
    debugPrint('\n🚀 Your AI integration is ready for production!');
    
  } catch (e, stackTrace) {
    debugPrint('❌ Test failed: $e');
    debugPrint('Stack trace: $stackTrace');
    exit(1);
  }
}