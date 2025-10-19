import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/journal_entry.dart';
import '../models/journal_summary.dart';
import 'openai_service.dart';

/// Service for generating periodic journal summaries using ChatGPT
/// Creates biweekly or monthly analysis reports
class SummaryGenerationService {
  final OpenAIService _openAIService = OpenAIService();

  /// Generate a summary for a period of journal entries
  Future<JournalSummary> generateSummary({
    required String userId,
    required List<JournalEntry> entries,
    required DateTime periodStart,
    required DateTime periodEnd,
    required String frequency,
  }) async {
    if (!_openAIService.isConfigured) {
      throw Exception('OpenAI API key not configured. Cannot generate summary.');
    }

    if (entries.isEmpty) {
      return _createEmptySummary(
        userId: userId,
        periodStart: periodStart,
        periodEnd: periodEnd,
        frequency: frequency,
      );
    }

    try {
      if (kDebugMode) {
        debugPrint('🔄 Generating summary for ${entries.length} entries');
      }

      // Calculate statistics
      final stats = _calculateStatistics(entries, periodStart, periodEnd);

      // Build comprehensive prompt for ChatGPT
      final prompt = _buildSummaryPrompt(entries, stats, frequency);

      // Call OpenAI with structured output
      final response = await _openAIService.analyzeEmotionalContent(
        text: prompt,
      );

      // Parse the response and create summary
      final summary = await _parseSummaryResponse(
        userId: userId,
        entries: entries,
        response: response.insight,
        stats: stats,
        periodStart: periodStart,
        periodEnd: periodEnd,
        frequency: frequency,
      );

      if (kDebugMode) {
        debugPrint('✅ Summary generated successfully');
      }

      return summary;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error generating summary: $e');
      }
      rethrow;
    }
  }

  /// Calculate statistics from journal entries
  Map<String, dynamic> _calculateStatistics(
    List<JournalEntry> entries,
    DateTime periodStart,
    DateTime periodEnd,
  ) {
    // Count moods
    final moodCounts = <String, int>{};
    var totalConfidence = 0.0;
    var totalDuration = Duration.zero;
    final uniqueDays = <String>{};
    final allTriggers = <String>[];
    final allEmotions = <String, List<double>>{};

    for (final entry in entries) {
      // Mood distribution
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;

      // Track unique journaling days
      final dayKey = '${entry.createdAt.year}-${entry.createdAt.month}-${entry.createdAt.day}';
      uniqueDays.add(dayKey);

      // Recording duration
      if (entry.recordingDuration != null) {
        totalDuration += entry.recordingDuration!;
      }

      // AI analysis stats
      if (entry.aiAnalysis != null) {
        totalConfidence += entry.aiAnalysis!.confidence;
        allTriggers.addAll(entry.aiAnalysis!.triggers);

        // Track emotion scores
        entry.aiAnalysis!.emotionScores.forEach((emotion, score) {
          allEmotions[emotion] = [...(allEmotions[emotion] ?? []), score];
        });
      }
    }

    // Calculate averages
    final avgConfidence = entries.isEmpty ? 0.0 : totalConfidence / entries.length;

    // Average emotion scores
    final avgEmotions = <String, double>{};
    allEmotions.forEach((emotion, scores) {
      avgEmotions[emotion] = scores.reduce((a, b) => a + b) / scores.length;
    });

    // Find dominant mood
    String? dominantMood;
    var maxCount = 0;
    moodCounts.forEach((mood, count) {
      if (count > maxCount) {
        maxCount = count;
        dominantMood = mood;
      }
    });

    return {
      'moodCounts': moodCounts,
      'totalEntries': entries.length,
      'daysJournaled': uniqueDays.length,
      'totalDuration': totalDuration,
      'avgConfidence': avgConfidence,
      'dominantMood': dominantMood,
      'allTriggers': allTriggers,
      'avgEmotions': avgEmotions,
      'periodDays': periodEnd.difference(periodStart).inDays + 1,
    };
  }

  /// Build comprehensive prompt for ChatGPT
  String _buildSummaryPrompt(
    List<JournalEntry> entries,
    Map<String, dynamic> stats,
    String frequency,
  ) {
    final buffer = StringBuffer();
    final periodType = frequency == 'twoWeeks' ? 'biweekly' : 'monthly';

    buffer.writeln('You are analyzing a $periodType journal summary. Generate a comprehensive emotional wellness report.');
    buffer.writeln();
    buffer.writeln('PERIOD STATISTICS:');
    buffer.writeln('- Total entries: ${stats['totalEntries']}');
    buffer.writeln('- Days journaled: ${stats['daysJournaled']}/${stats['periodDays']}');
    buffer.writeln('- Consistency: ${((stats['daysJournaled'] / stats['periodDays']) * 100).toStringAsFixed(1)}%');
    buffer.writeln('- Dominant mood: ${stats['dominantMood']}');
    buffer.writeln();

    buffer.writeln('MOOD DISTRIBUTION:');
    (stats['moodCounts'] as Map<String, int>).forEach((mood, count) {
      buffer.writeln('- $mood: $count entries');
    });
    buffer.writeln();

    buffer.writeln('JOURNAL ENTRIES (chronological):');
    for (var i = 0; i < entries.length && i < 30; i++) {
      final entry = entries[i];
      buffer.writeln('${i + 1}. [${entry.mood}] ${entry.transcription.substring(0, entry.transcription.length > 150 ? 150 : entry.transcription.length)}...');

      if (entry.aiAnalysis != null) {
        buffer.writeln('   Insight: ${entry.aiAnalysis!.insight}');
        if (entry.aiAnalysis!.triggers.isNotEmpty) {
          buffer.writeln('   Triggers: ${entry.aiAnalysis!.triggers.join(", ")}');
        }
      }
      buffer.writeln();
    }

    if (entries.length > 30) {
      buffer.writeln('... and ${entries.length - 30} more entries');
    }

    buffer.writeln();
    buffer.writeln('REQUIRED OUTPUT (JSON format):');
    buffer.writeln('''{
  "overallMoodTrend": "describe the overall emotional trajectory",
  "keyThemes": ["theme1", "theme2", "theme3"],
  "emotionalHighlights": ["positive moment 1", "positive moment 2"],
  "challengingMoments": ["difficulty 1", "difficulty 2"],
  "growthAreas": ["progress 1", "progress 2"],
  "suggestedFocus": ["recommendation 1", "recommendation 2"],
  "executiveSummary": "brief 2-3 sentence overview",
  "detailedInsight": "comprehensive analysis (3-4 paragraphs)",
  "actionableSteps": ["step 1", "step 2", "step 3"]
}''');

    return buffer.toString();
  }

  /// Parse ChatGPT response and create summary
  Future<JournalSummary> _parseSummaryResponse({
    required String userId,
    required List<JournalEntry> entries,
    required String response,
    required Map<String, dynamic> stats,
    required DateTime periodStart,
    required DateTime periodEnd,
    required String frequency,
  }) async {
    try {
      // Try to parse as JSON
      final jsonData = json.decode(response) as Map<String, dynamic>;

      return JournalSummary(
        id: 'summary_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        periodStart: periodStart,
        periodEnd: periodEnd,
        frequency: frequency,
        createdAt: DateTime.now(),
        overallMoodTrend: jsonData['overallMoodTrend'] as String? ?? 'Varied',
        moodDistribution: Map<String, int>.from(stats['moodCounts'] as Map),
        keyThemes: List<String>.from(jsonData['keyThemes'] as List? ?? []),
        emotionalHighlights: List<String>.from(jsonData['emotionalHighlights'] as List? ?? []),
        challengingMoments: List<String>.from(jsonData['challengingMoments'] as List? ?? []),
        growthAreas: List<String>.from(jsonData['growthAreas'] as List? ?? []),
        suggestedFocus: List<String>.from(jsonData['suggestedFocus'] as List? ?? []),
        totalEntries: stats['totalEntries'] as int,
        daysJournaled: stats['daysJournaled'] as int,
        totalRecordingTime: stats['totalDuration'] as Duration,
        averageConfidence: stats['avgConfidence'] as double,
        executiveSummary: jsonData['executiveSummary'] as String? ?? response.substring(0, response.length > 200 ? 200 : response.length),
        detailedInsight: jsonData['detailedInsight'] as String? ?? response,
        actionableSteps: List<String>.from(jsonData['actionableSteps'] as List? ?? []),
        dominantEmotion: stats['dominantMood'] as String?,
        commonTriggers: _extractTopTriggers(stats['allTriggers'] as List<String>),
        emotionTrends: Map<String, double>.from(stats['avgEmotions'] as Map? ?? {}),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to parse JSON, using text fallback: $e');
      }

      // Fallback if JSON parsing fails
      return _createFallbackSummary(
        userId: userId,
        response: response,
        stats: stats,
        periodStart: periodStart,
        periodEnd: periodEnd,
        frequency: frequency,
      );
    }
  }

  /// Extract most common triggers
  List<String> _extractTopTriggers(List<String> allTriggers, {int limit = 5}) {
    if (allTriggers.isEmpty) return [];

    final triggerCounts = <String, int>{};
    for (final trigger in allTriggers) {
      triggerCounts[trigger] = (triggerCounts[trigger] ?? 0) + 1;
    }

    final sorted = triggerCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(limit).map((e) => e.key).toList();
  }

  /// Create fallback summary when JSON parsing fails
  JournalSummary _createFallbackSummary({
    required String userId,
    required String response,
    required Map<String, dynamic> stats,
    required DateTime periodStart,
    required DateTime periodEnd,
    required String frequency,
  }) {
    return JournalSummary(
      id: 'summary_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      periodStart: periodStart,
      periodEnd: periodEnd,
      frequency: frequency,
      createdAt: DateTime.now(),
      overallMoodTrend: 'Mixed emotional journey',
      moodDistribution: Map<String, int>.from(stats['moodCounts'] as Map),
      keyThemes: ['Self-reflection', 'Personal growth'],
      emotionalHighlights: ['Continued journaling practice'],
      challengingMoments: ['Various life stressors'],
      growthAreas: ['Emotional awareness'],
      suggestedFocus: ['Continue regular journaling', 'Practice self-compassion'],
      totalEntries: stats['totalEntries'] as int,
      daysJournaled: stats['daysJournaled'] as int,
      totalRecordingTime: stats['totalDuration'] as Duration,
      averageConfidence: stats['avgConfidence'] as double,
      executiveSummary: response.substring(0, response.length > 200 ? 200 : response.length),
      detailedInsight: response,
      actionableSteps: ['Keep journaling', 'Seek support when needed'],
      dominantEmotion: stats['dominantMood'] as String?,
      commonTriggers: _extractTopTriggers(stats['allTriggers'] as List<String>),
      emotionTrends: Map<String, double>.from(stats['avgEmotions'] as Map? ?? {}),
    );
  }

  /// Create empty summary when no entries exist
  JournalSummary _createEmptySummary({
    required String userId,
    required DateTime periodStart,
    required DateTime periodEnd,
    required String frequency,
  }) {
    return JournalSummary(
      id: 'summary_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      periodStart: periodStart,
      periodEnd: periodEnd,
      frequency: frequency,
      createdAt: DateTime.now(),
      overallMoodTrend: 'No entries recorded',
      moodDistribution: {},
      keyThemes: [],
      emotionalHighlights: [],
      challengingMoments: [],
      growthAreas: [],
      suggestedFocus: ['Start journaling regularly', 'Set daily reminders'],
      totalEntries: 0,
      daysJournaled: 0,
      totalRecordingTime: Duration.zero,
      averageConfidence: 0.0,
      executiveSummary: 'No journal entries were recorded during this period.',
      detailedInsight: 'We encourage you to start journaling regularly to track your emotional wellness journey.',
      actionableSteps: [
        'Set a daily journaling reminder',
        'Start with 2-3 entries per week',
        'Reflect on your day for just 5 minutes',
      ],
    );
  }

  /// Check if a summary should be generated based on frequency
  bool shouldGenerateSummary({
    required String frequency,
    DateTime? lastSummaryDate,
  }) {
    if (lastSummaryDate == null) return true;

    final now = DateTime.now();
    final daysSinceLastSummary = now.difference(lastSummaryDate).inDays;

    if (frequency == 'twoWeeks') {
      return daysSinceLastSummary >= 14;
    } else if (frequency == 'monthly') {
      return daysSinceLastSummary >= 30;
    }

    return false;
  }

  /// Calculate the next summary generation date
  DateTime getNextSummaryDate({
    required String frequency,
    DateTime? lastSummaryDate,
  }) {
    final baseDate = lastSummaryDate ?? DateTime.now();

    if (frequency == 'twoWeeks') {
      return baseDate.add(const Duration(days: 14));
    } else {
      // Monthly - add 30 days
      return baseDate.add(const Duration(days: 30));
    }
  }
}
