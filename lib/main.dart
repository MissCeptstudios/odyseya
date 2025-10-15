import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'config/router.dart';
import 'config/env_config.dart';
import 'constants/colors.dart';
import 'constants/typography.dart';
import 'services/notification_service.dart';
import 'services/ai_config_service.dart';
import 'services/ai_quick_test.dart';
import 'services/revenue_cat_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment configuration first
  await EnvConfig.initialize();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize notification service
  await NotificationService().initialize();

  // Initialize RevenueCat for subscriptions
  await RevenueCatService().initialize();

  // Initialize AI services with environment-based API keys
  final aiConfig = AIConfigService();
  await aiConfig.initializeFromStorage(); // Load any stored configuration first

  // Set API keys from environment variables
  if (EnvConfig.hasGeminiKey) {
    await aiConfig.setGeminiApiKey(EnvConfig.geminiApiKey!);
  }

  if (EnvConfig.hasGroqKey) {
    await aiConfig.setGroqApiKey(EnvConfig.groqApiKey!);
  }
  
  // Test the AI service on startup (debug mode only)
  if (kDebugMode) {
    // Print environment configuration status
    final envInfo = EnvConfig.getDebugInfo();
    debugPrint('Environment configuration: $envInfo');

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
        fontFamily: OdyseyaTypography.inter,
        scaffoldBackgroundColor: DesertColors.background,
        textTheme: TextTheme(
          // Headlines - Cormorant Garamond
          displayLarge: OdyseyaTypography.h1Large,
          displayMedium: OdyseyaTypography.h1,
          headlineLarge: OdyseyaTypography.h2Large,
          headlineMedium: OdyseyaTypography.h2,

          // Body - Nunito Sans
          bodyLarge: OdyseyaTypography.bodyLarge,
          bodyMedium: OdyseyaTypography.body,

          // Labels - Inter
          labelLarge: OdyseyaTypography.buttonLarge,
          labelMedium: OdyseyaTypography.button,
          labelSmall: OdyseyaTypography.navInactive,

          // Titles - Inter
          titleLarge: OdyseyaTypography.uiLarge,
          titleMedium: OdyseyaTypography.ui,
          titleSmall: OdyseyaTypography.captionSmall,
        ),
      ),
      routerConfig: router,
    );
  }
}

