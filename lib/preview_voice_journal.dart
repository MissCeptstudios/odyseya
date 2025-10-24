import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/action/recording_screen.dart';

void main() {
  runApp(const ProviderScope(child: VoiceJournalPreviewApp()));
}

class VoiceJournalPreviewApp extends StatelessWidget {
  const VoiceJournalPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Journal Preview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const RecordingScreen(),
    );
  }
}
