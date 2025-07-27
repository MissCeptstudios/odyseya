import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: OdyseyaTestApp(),
    ),
  );
}

class OdyseyaTestApp extends ConsumerWidget {
  const OdyseyaTestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Odyseya Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: DesertColors.primary,
          brightness: Brightness.light,
        ),
        fontFamily: 'Inter',
        scaffoldBackgroundColor: DesertColors.background,
      ),
      home: const TestHomeScreen(),
    );
  }
}

class TestHomeScreen extends StatelessWidget {
  const TestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesertColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '🌿 Odyseya',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: DesertColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Emotional Voice Journaling',
                    style: TextStyle(
                      fontSize: 18,
                      color: DesertColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'iOS Simulator Test',
                    style: TextStyle(
                      fontSize: 16,
                      color: DesertColors.treeBranch,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: DesertColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '✅ App is running successfully!',
                      style: TextStyle(
                        color: DesertColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}