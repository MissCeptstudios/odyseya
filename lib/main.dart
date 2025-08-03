import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/router.dart';
import 'constants/colors.dart';
import 'services/notification_service.dart';
import 'services/ai_config_service.dart';
import 'services/ai_quick_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize notification service
  await NotificationService().initialize();
  
  // Initialize AI services with your API key
  final aiConfig = AIConfigService();
  await aiConfig.initializeFromStorage(); // Load any stored configuration first
  
  // Set your Gemini API key
  await aiConfig.setGeminiApiKey('AIzaSyDXZpbo7LsybroxC6XAAaQyUM1ysiQwiW0');
  
  // Test the AI service on startup (debug mode only)
  if (kDebugMode) {
    final testPassed = await aiConfig.testCurrentService();
    debugPrint(testPassed 
      ? '✅ AI service initialized successfully!' 
      : '⚠️ AI service test failed - will use fallback analysis');
    
    // Run comprehensive test with sample journal entry
    await AIQuickTest.runQuickTest();
  }
  
  runApp(
    const ProviderScope(
      child: OdyseyaApp(),
    ),
  );
}

class OdyseyaApp extends ConsumerWidget {
  const OdyseyaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Odyseya',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: DesertColors.primary,
          brightness: Brightness.light,
        ),
        fontFamily: 'Inter',
        scaffoldBackgroundColor: DesertColors.background,
      ),
      routerConfig: router,
    );
  }
}

