/// Model for periodic journal summaries (biweekly/monthly)
class JournalSummary {
  final String id;
  final String userId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final String frequency; // 'twoWeeks' or 'monthly'
  final DateTime createdAt;

  // Summary content
  final String overallMoodTrend;
  final Map<String, int> moodDistribution; // mood -> count
  final List<String> keyThemes; // Main topics/patterns
  final List<String> emotionalHighlights; // Positive moments
  final List<String> challengingMoments; // Difficult periods
  final List<String> growthAreas; // Areas of progress
  final List<String> suggestedFocus; // Recommendations for next period

  // Statistics
  final int totalEntries;
  final int daysJournaled;
  final Duration totalRecordingTime;
  final double averageConfidence; // AI analysis confidence

  // AI-generated insights
  final String executiveSummary; // Brief overview
  final String detailedInsight; // Deep analysis
  final List<String> actionableSteps; // Concrete next steps

  // Optional fields
  final String? dominantEmotion;
  final List<String>? commonTriggers;
  final Map<String, double>? emotionTrends; // emotion -> average score

  const JournalSummary({
    required this.id,
    required this.userId,
    required this.periodStart,
    required this.periodEnd,
    required this.frequency,
    required this.createdAt,
    required this.overallMoodTrend,
    required this.moodDistribution,
    required this.keyThemes,
    required this.emotionalHighlights,
    required this.challengingMoments,
    required this.growthAreas,
    required this.suggestedFocus,
    required this.totalEntries,
    required this.daysJournaled,
    required this.totalRecordingTime,
    required this.averageConfidence,
    required this.executiveSummary,
    required this.detailedInsight,
    required this.actionableSteps,
    this.dominantEmotion,
    this.commonTriggers,
    this.emotionTrends,
  });

  // Helper getters
  String get periodDescription {
    final formatter = _dateFormatter();
    return '${formatter.format(periodStart)} - ${formatter.format(periodEnd)}';
  }

  String get frequencyDisplay => frequency == 'twoWeeks' ? 'Biweekly' : 'Monthly';

  bool get isRecent {
    final now = DateTime.now();
    return now.difference(createdAt).inDays < 30;
  }

  double get journalingConsistency {
    final periodDays = periodEnd.difference(periodStart).inDays + 1;
    if (periodDays == 0) return 0.0;
    return daysJournaled / periodDays;
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'periodStart': periodStart.toIso8601String(),
      'periodEnd': periodEnd.toIso8601String(),
      'frequency': frequency,
      'createdAt': createdAt.toIso8601String(),
      'overallMoodTrend': overallMoodTrend,
      'moodDistribution': moodDistribution,
      'keyThemes': keyThemes,
      'emotionalHighlights': emotionalHighlights,
      'challengingMoments': challengingMoments,
      'growthAreas': growthAreas,
      'suggestedFocus': suggestedFocus,
      'totalEntries': totalEntries,
      'daysJournaled': daysJournaled,
      'totalRecordingTimeMs': totalRecordingTime.inMilliseconds,
      'averageConfidence': averageConfidence,
      'executiveSummary': executiveSummary,
      'detailedInsight': detailedInsight,
      'actionableSteps': actionableSteps,
      'dominantEmotion': dominantEmotion,
      'commonTriggers': commonTriggers,
      'emotionTrends': emotionTrends,
    };
  }

  factory JournalSummary.fromJson(Map<String, dynamic> json) {
    return JournalSummary(
      id: json['id'] as String,
      userId: json['userId'] as String,
      periodStart: DateTime.parse(json['periodStart'] as String),
      periodEnd: DateTime.parse(json['periodEnd'] as String),
      frequency: json['frequency'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      overallMoodTrend: json['overallMoodTrend'] as String,
      moodDistribution: Map<String, int>.from(json['moodDistribution'] as Map),
      keyThemes: List<String>.from(json['keyThemes'] as List),
      emotionalHighlights: List<String>.from(json['emotionalHighlights'] as List),
      challengingMoments: List<String>.from(json['challengingMoments'] as List),
      growthAreas: List<String>.from(json['growthAreas'] as List),
      suggestedFocus: List<String>.from(json['suggestedFocus'] as List),
      totalEntries: json['totalEntries'] as int,
      daysJournaled: json['daysJournaled'] as int,
      totalRecordingTime: Duration(milliseconds: json['totalRecordingTimeMs'] as int),
      averageConfidence: (json['averageConfidence'] as num).toDouble(),
      executiveSummary: json['executiveSummary'] as String,
      detailedInsight: json['detailedInsight'] as String,
      actionableSteps: List<String>.from(json['actionableSteps'] as List),
      dominantEmotion: json['dominantEmotion'] as String?,
      commonTriggers: json['commonTriggers'] != null
          ? List<String>.from(json['commonTriggers'] as List)
          : null,
      emotionTrends: json['emotionTrends'] != null
          ? Map<String, double>.from(
              (json['emotionTrends'] as Map).map(
                (k, v) => MapEntry(k as String, (v as num).toDouble()),
              ),
            )
          : null,
    );
  }

  JournalSummary copyWith({
    String? id,
    String? userId,
    DateTime? periodStart,
    DateTime? periodEnd,
    String? frequency,
    DateTime? createdAt,
    String? overallMoodTrend,
    Map<String, int>? moodDistribution,
    List<String>? keyThemes,
    List<String>? emotionalHighlights,
    List<String>? challengingMoments,
    List<String>? growthAreas,
    List<String>? suggestedFocus,
    int? totalEntries,
    int? daysJournaled,
    Duration? totalRecordingTime,
    double? averageConfidence,
    String? executiveSummary,
    String? detailedInsight,
    List<String>? actionableSteps,
    String? dominantEmotion,
    List<String>? commonTriggers,
    Map<String, double>? emotionTrends,
  }) {
    return JournalSummary(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      frequency: frequency ?? this.frequency,
      createdAt: createdAt ?? this.createdAt,
      overallMoodTrend: overallMoodTrend ?? this.overallMoodTrend,
      moodDistribution: moodDistribution ?? this.moodDistribution,
      keyThemes: keyThemes ?? this.keyThemes,
      emotionalHighlights: emotionalHighlights ?? this.emotionalHighlights,
      challengingMoments: challengingMoments ?? this.challengingMoments,
      growthAreas: growthAreas ?? this.growthAreas,
      suggestedFocus: suggestedFocus ?? this.suggestedFocus,
      totalEntries: totalEntries ?? this.totalEntries,
      daysJournaled: daysJournaled ?? this.daysJournaled,
      totalRecordingTime: totalRecordingTime ?? this.totalRecordingTime,
      averageConfidence: averageConfidence ?? this.averageConfidence,
      executiveSummary: executiveSummary ?? this.executiveSummary,
      detailedInsight: detailedInsight ?? this.detailedInsight,
      actionableSteps: actionableSteps ?? this.actionableSteps,
      dominantEmotion: dominantEmotion ?? this.dominantEmotion,
      commonTriggers: commonTriggers ?? this.commonTriggers,
      emotionTrends: emotionTrends ?? this.emotionTrends,
    );
  }

  // Helper to format dates
  static _SimpleDateFormat _dateFormatter() {
    return _SimpleDateFormat();
  }
}

// Simple date formatter
class _SimpleDateFormat {
  String format(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
