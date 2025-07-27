import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'config/router.dart';
import 'constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase - temporarily disabled
  // await Firebase.initializeApp();
  
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

