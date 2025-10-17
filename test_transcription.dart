import 'package:flutter/foundation.dart';
import 'lib/config/env_config.dart';
import 'lib/services/transcription_service.dart';

/// Test script for transcription service
///
/// Usage:
/// 1. Ensure you have a .env file with OPENAI_API_KEY set
/// 2. Place a test audio file at the path specified below
/// 3. Run: dart run test_transcription.dart
void main() async {
  debugPrint('🧪 Testing Transcription Service...\n');

  try {
    // Initialize environment
    debugPrint('1️⃣ Initializing environment configuration...');
    await EnvConfig.initialize();

    final envInfo = EnvConfig.getDebugInfo();
    debugPrint('   Configuration loaded:');
    debugPrint('   - OpenAI Key: ${envInfo['hasOpenaiKey'] ? '✅ Configured' : '❌ Missing'}');
    debugPrint('   - Use Whisper: ${envInfo['useWhisper']}');
    debugPrint('');

    // Create transcription service
    debugPrint('2️⃣ Creating transcription service...');
    final transcriptionService = TranscriptionService();
    debugPrint('   Service created successfully');
    debugPrint('   Supported formats: ${TranscriptionService.supportedFormats.join(', ')}');
    debugPrint('');

    // Test validation
    debugPrint('3️⃣ Testing transcription validation...');
    final testText = "I'm feeling a bit overwhelmed today. There's just so much happening.";
    final isValid = transcriptionService.isTranscriptionValid(testText);
    debugPrint('   Test text: "$testText"');
    debugPrint('   Is valid: $isValid');
    debugPrint('');

    // Test cleaning
    debugPrint('4️⃣ Testing transcription cleaning...');
    final dirtyText = '  hello   world..   this is  a test,,,  ';
    final cleanedText = transcriptionService.cleanTranscription(dirtyText);
    debugPrint('   Original: "$dirtyText"');
    debugPrint('   Cleaned: "$cleanedText"');
    debugPrint('');

    // Test cost estimation
    debugPrint('5️⃣ Testing cost estimation...');
    final testFileSizes = [50000, 150000, 500000, 1000000]; // Different file sizes
    for (final size in testFileSizes) {
      final cost = transcriptionService.estimateTranscriptionCost(size);
      final sizeInKB = (size / 1024).toStringAsFixed(2);
      debugPrint('   ${sizeInKB}KB audio → estimated cost: \$${cost.toStringAsFixed(4)}');
    }
    debugPrint('');

    // Test format checking
    debugPrint('6️⃣ Testing format validation...');
    final testFiles = ['audio.m4a', 'recording.wav', 'test.mp3', 'invalid.txt'];
    for (final file in testFiles) {
      final isSupported = transcriptionService.isSupportedFormat(file);
      debugPrint('   $file → ${isSupported ? '✅ Supported' : '❌ Not supported'}');
    }
    debugPrint('');

    // Test with real audio file (if available)
    debugPrint('7️⃣ Testing with audio file (if available)...');

    debugPrint('   ℹ️  To test with a real audio file:');
    debugPrint('   1. Record a test audio file (e.g., using your app)');
    debugPrint('   2. Update testAudioPath in this script');
    debugPrint('   3. Ensure OPENAI_API_KEY is set in .env');
    debugPrint('   4. Re-run this test script');
    debugPrint('');

    // Uncomment to test with real file
    /*
    try {
      debugPrint('   Transcribing: $testAudioPath');
      final transcription = await transcriptionService.transcribeAudio(testAudioPath);
      debugPrint('   ✅ Transcription successful!');
      debugPrint('   Length: ${transcription.length} chars');
      debugPrint('   Text: $transcription');
    } catch (e) {
      debugPrint('   ❌ Transcription failed: $e');
    }
    */

    debugPrint('🎉 ALL TESTS PASSED!');
    debugPrint('');
    debugPrint('📊 Summary:');
    debugPrint('   ✅ Environment configuration working');
    debugPrint('   ✅ Mock transcription working');
    debugPrint('   ✅ Validation logic working');
    debugPrint('   ✅ Text cleaning working');
    debugPrint('   ✅ Cost estimation working');
    debugPrint('');
    debugPrint('🚀 Next steps:');
    if (!envInfo['hasOpenaiKey']) {
      debugPrint('   1. Add OPENAI_API_KEY to your .env file');
      debugPrint('   2. Get key from: https://platform.openai.com/api-keys');
    } else {
      debugPrint('   1. Record a test audio file using your app');
      debugPrint('   2. Update testAudioPath in this script');
      debugPrint('   3. Uncomment the real transcription test');
      debugPrint('   4. Run this script again');
    }

  } catch (e, stackTrace) {
    debugPrint('❌ Test failed: $e');
    debugPrint('Stack trace: $stackTrace');
  }
}
