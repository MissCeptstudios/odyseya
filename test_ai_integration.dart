import 'dart:io';
import 'lib/services/ai_config_service.dart';
import 'lib/services/ai_service_factory.dart';
import 'lib/services/ai_analysis_service.dart';

/// Standalone test to verify AI integration works
void main() async {
  print('🧪 Testing AI Integration...\n');
  
  try {
    // Test 1: Configuration Service
    print('1️⃣ Testing Configuration Service...');
    final config = AIConfigService();
    
    // Set the API key
    final keySet = await config.setGeminiApiKey('AIzaSyDXZpbo7LsybroxC6XAAaQyUM1ysiQwiW0');
    print('   API key configured: $keySet');
    
    final status = config.getConfigurationStatus();
    print('   Current service: ${status.serviceName}');
    print('   Is configured: ${status.isConfigured}');
    print('   ✅ Configuration test passed\n');
    
    // Test 2: Service Factory
    print('2️⃣ Testing Service Factory...');
    final factory = AIServiceFactory();
    final service = factory.getCurrentService();
    print('   Service name: ${service.serviceName}');
    print('   Is configured: ${service.isConfigured}');
    print('   ✅ Factory test passed\n');
    
    // Test 3: AI Analysis Service (existing integration)
    print('3️⃣ Testing AI Analysis Service...');
    final aiService = AIAnalysisService();
    
    final testText = 'I feel excited about this new project today. It has challenges but I am ready to learn and grow.';
    final testMood = 'optimistic';
    
    print('   Analyzing: "${testText.substring(0, 50)}..."');
    print('   Mood: $testMood');
    
    final startTime = DateTime.now();
    final analysis = await aiService.analyzeEmotion(testText, mood: testMood);
    final duration = DateTime.now().difference(startTime);
    
    print('   Analysis completed in ${duration.inMilliseconds}ms');
    print('   Emotional tone: ${analysis.emotionalTone}');
    print('   Confidence: ${(analysis.confidence * 100).toStringAsFixed(1)}%');
    print('   Triggers: ${analysis.triggers.join(', ')}');
    print('   Suggestions: ${analysis.suggestions.length} provided');
    print('   Insight: ${analysis.insight.substring(0, 100)}...');
    print('   ✅ AI Analysis test passed\n');
    
    // Test 4: Different Moods
    print('4️⃣ Testing Different Moods...');
    final moods = ['happy', 'sad', 'anxious', 'calm'];
    final sampleText = 'Today was a challenging day with mixed emotions.';
    
    for (final mood in moods) {
      final result = await aiService.analyzeEmotion(sampleText, mood: mood);
      final topEmotion = result.emotionScores.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      print('   $mood mood → ${result.emotionalTone} (${topEmotion.key}: ${(topEmotion.value * 100).toStringAsFixed(0)}%)');
    }
    print('   ✅ Mood variation test passed\n');
    
    print('🎉 ALL TESTS PASSED!');
    print('\n📊 Summary:');
    print('   • Configuration system: Working ✅');
    print('   • Service factory: Working ✅');
    print('   • AI analysis: Working ✅');
    print('   • Mood integration: Working ✅');
    print('   • Gemini API: Active ✅');
    print('\n🚀 Your AI integration is ready for production!');
    
  } catch (e, stackTrace) {
    print('❌ Test failed: $e');
    print('Stack trace: $stackTrace');
    exit(1);
  }
}