// Enforce design consistency based on UX_odyseya_framework.md
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/journal_entry.dart';
import '../models/journal_entry_v2.dart';

/// Service for exporting user data in various formats (GDPR compliant)
class DataExportService {
  /// Export journal entries as JSON
  Future<File> exportJournalEntriesAsJSON(List<JournalEntry> entries) async {
    try {
      final jsonData = entries.map((entry) => entry.toJson()).toList();
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final file = File('${directory.path}/odyseya_journal_export_$timestamp.json');

      await file.writeAsString(jsonString);

      if (kDebugMode) {
        debugPrint('📝 Journal entries exported: ${file.path}');
      }

      return file;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error exporting journal entries: $e');
      }
      rethrow;
    }
  }

  /// Export journal entries V2 as JSON
  Future<File> exportJournalEntriesV2AsJSON(List<JournalEntryV2> entries) async {
    try {
      final jsonData = entries.map((entry) => entry.toFirestore()).toList();
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final file = File('${directory.path}/odyseya_journal_v2_export_$timestamp.json');

      await file.writeAsString(jsonString);

      if (kDebugMode) {
        debugPrint('📝 Journal entries V2 exported: ${file.path}');
      }

      return file;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error exporting journal entries V2: $e');
      }
      rethrow;
    }
  }

  /// Export journal entries as CSV
  Future<File> exportJournalEntriesAsCSV(List<JournalEntry> entries) async {
    try {
      final buffer = StringBuffer();

      // CSV Header
      buffer.writeln('Date,Time,Mood,Transcription,Emotional Tone,Confidence,Triggers,Insight,Duration (seconds)');

      // CSV Rows
      for (final entry in entries) {
        final date = _formatDate(entry.createdAt);
        final time = _formatTime(entry.createdAt);
        final mood = entry.mood;
        final transcription = _escapeCsvField(entry.transcription);
        final emotionalTone = entry.aiAnalysis?.emotionalTone ?? '';
        final confidence = entry.aiAnalysis?.confidence.toStringAsFixed(2) ?? '';
        final triggers = _escapeCsvField(entry.aiAnalysis?.triggers.join(', ') ?? '');
        final insight = _escapeCsvField(entry.aiAnalysis?.insight ?? '');
        final duration = entry.recordingDuration?.inSeconds ?? 0;

        buffer.writeln('$date,$time,$mood,$transcription,$emotionalTone,$confidence,$triggers,$insight,$duration');
      }

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final file = File('${directory.path}/odyseya_journal_export_$timestamp.csv');

      await file.writeAsString(buffer.toString());

      if (kDebugMode) {
        debugPrint('📊 Journal entries exported as CSV: ${file.path}');
      }

      return file;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error exporting journal entries as CSV: $e');
      }
      rethrow;
    }
  }

  /// Export AI insights summary as JSON
  Future<File> exportAIInsights(List<JournalEntry> entries) async {
    try {
      final insights = entries
          .where((entry) => entry.aiAnalysis != null)
          .map((entry) => {
                'date': entry.createdAt.toIso8601String(),
                'mood': entry.mood,
                'analysis': entry.aiAnalysis!.toJson(),
              })
          .toList();

      final summary = {
        'total_entries': entries.length,
        'entries_with_ai_analysis': insights.length,
        'export_date': DateTime.now().toIso8601String(),
        'insights': insights,
        'statistics': _calculateAIStatistics(entries),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(summary);

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final file = File('${directory.path}/odyseya_ai_insights_$timestamp.json');

      await file.writeAsString(jsonString);

      if (kDebugMode) {
        debugPrint('🤖 AI insights exported: ${file.path}');
      }

      return file;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error exporting AI insights: $e');
      }
      rethrow;
    }
  }

  /// Export mood data as JSON
  Future<File> exportMoodData(List<JournalEntry> entries) async {
    try {
      final moodData = entries.map((entry) => {
            'date': entry.createdAt.toIso8601String(),
            'mood': entry.mood,
            'emotional_tone': entry.aiAnalysis?.emotionalTone,
            'confidence': entry.aiAnalysis?.confidence,
            'emotion_scores': entry.aiAnalysis?.emotionScores,
          }).toList();

      final summary = {
        'total_entries': entries.length,
        'export_date': DateTime.now().toIso8601String(),
        'mood_data': moodData,
        'statistics': _calculateMoodStatistics(entries),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(summary);

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final file = File('${directory.path}/odyseya_mood_data_$timestamp.json');

      await file.writeAsString(jsonString);

      if (kDebugMode) {
        debugPrint('😊 Mood data exported: ${file.path}');
      }

      return file;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error exporting mood data: $e');
      }
      rethrow;
    }
  }

  /// Export complete user data package
  Future<List<File>> exportCompleteDataPackage({
    required List<JournalEntry> journalEntries,
  }) async {
    try {
      final files = <File>[];

      // Export journal entries (JSON & CSV)
      files.add(await exportJournalEntriesAsJSON(journalEntries));
      files.add(await exportJournalEntriesAsCSV(journalEntries));

      // Export AI insights
      files.add(await exportAIInsights(journalEntries));

      // Export mood data
      files.add(await exportMoodData(journalEntries));

      if (kDebugMode) {
        debugPrint('📦 Complete data package exported: ${files.length} files');
      }

      return files;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error exporting complete data package: $e');
      }
      rethrow;
    }
  }

  /// Share exported file via system share sheet
  Future<void> shareFile(File file) async {
    try {
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Odyseya Data Export',
        text: 'Your Odyseya journal data export',
      );

      if (kDebugMode) {
        debugPrint('📤 File shared: ${file.path}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error sharing file: $e');
      }
      rethrow;
    }
  }

  /// Share multiple files
  Future<void> shareFiles(List<File> files) async {
    try {
      await Share.shareXFiles(
        files.map((f) => XFile(f.path)).toList(),
        subject: 'Odyseya Data Export Package',
        text: 'Your complete Odyseya data export',
      );

      if (kDebugMode) {
        debugPrint('📤 Files shared: ${files.length} files');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error sharing files: $e');
      }
      rethrow;
    }
  }

  // Helper methods

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  Map<String, dynamic> _calculateAIStatistics(List<JournalEntry> entries) {
    final entriesWithAI = entries.where((e) => e.aiAnalysis != null).toList();

    if (entriesWithAI.isEmpty) {
      return {
        'average_confidence': 0.0,
        'most_common_emotional_tone': 'N/A',
        'most_common_triggers': [],
      };
    }

    // Average confidence
    final avgConfidence = entriesWithAI
            .map((e) => e.aiAnalysis!.confidence)
            .reduce((a, b) => a + b) /
        entriesWithAI.length;

    // Most common emotional tone
    final toneCounts = <String, int>{};
    for (final entry in entriesWithAI) {
      final tone = entry.aiAnalysis!.emotionalTone;
      toneCounts[tone] = (toneCounts[tone] ?? 0) + 1;
    }
    final mostCommonTone = toneCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    // Most common triggers
    final triggerCounts = <String, int>{};
    for (final entry in entriesWithAI) {
      for (final trigger in entry.aiAnalysis!.triggers) {
        triggerCounts[trigger] = (triggerCounts[trigger] ?? 0) + 1;
      }
    }
    final topTriggers = triggerCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return {
      'average_confidence': avgConfidence.toStringAsFixed(2),
      'most_common_emotional_tone': mostCommonTone,
      'most_common_triggers': topTriggers.take(5).map((e) => e.key).toList(),
    };
  }

  Map<String, dynamic> _calculateMoodStatistics(List<JournalEntry> entries) {
    if (entries.isEmpty) {
      return {
        'most_common_mood': 'N/A',
        'mood_distribution': {},
        'total_entries': 0,
      };
    }

    // Mood distribution
    final moodCounts = <String, int>{};
    for (final entry in entries) {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
    }

    // Most common mood
    final mostCommonMood = moodCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return {
      'most_common_mood': mostCommonMood,
      'mood_distribution': moodCounts,
      'total_entries': entries.length,
    };
  }
}
