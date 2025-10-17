import 'package:cloud_firestore/cloud_firestore.dart';

/// AI-generated analysis report (bi-monthly, monthly, or trend analysis)
/// Stored in users/{userId}/analysis/{analysisId}
class AnalysisReport {
  final String id;
  final String userId;
  final AnalysisType type;
  final DateTime generatedAt;
  final String summaryText;
  final String? dominantMood;
  final AnalysisInsights insights;
  final String aiVersion; // e.g., "gpt-4-2025-10", "groq-llama-3.1"
  final Map<String, dynamic>? metadata;

  const AnalysisReport({
    required this.id,
    required this.userId,
    required this.type,
    required this.generatedAt,
    required this.summaryText,
    this.dominantMood,
    required this.insights,
    required this.aiVersion,
    this.metadata,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'type': type.name,
      'generatedAt': Timestamp.fromDate(generatedAt),
      'summaryText': summaryText,
      'dominantMood': dominantMood,
      'insights': insights.toMap(),
      'aiVersion': aiVersion,
      'metadata': metadata,
    };
  }

  factory AnalysisReport.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AnalysisReport(
      id: doc.id,
      userId: doc.reference.parent.parent!.id,
      type: AnalysisType.fromString(data['type'] ?? 'monthly'),
      generatedAt: (data['generatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      summaryText: data['summaryText'] ?? '',
      dominantMood: data['dominantMood'],
      insights: AnalysisInsights.fromMap(data['insights'] ?? {}),
      aiVersion: data['aiVersion'] ?? 'unknown',
      metadata: data['metadata'],
    );
  }

  AnalysisReport copyWith({
    String? id,
    String? userId,
    AnalysisType? type,
    DateTime? generatedAt,
    String? summaryText,
    String? dominantMood,
    AnalysisInsights? insights,
    String? aiVersion,
    Map<String, dynamic>? metadata,
  }) {
    return AnalysisReport(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      generatedAt: generatedAt ?? this.generatedAt,
      summaryText: summaryText ?? this.summaryText,
      dominantMood: dominantMood ?? this.dominantMood,
      insights: insights ?? this.insights,
      aiVersion: aiVersion ?? this.aiVersion,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Get month key (YYYY-MM)
  String get monthKey {
    return '${generatedAt.year}-${generatedAt.month.toString().padLeft(2, '0')}';
  }
}

enum AnalysisType {
  biMonthly, // Every 2 months (60 days)
  monthly, // Every month
  trend, // Ongoing trend analysis
  custom; // Custom date range

  static AnalysisType fromString(String value) {
    return AnalysisType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AnalysisType.monthly,
    );
  }
}

/// Detailed insights from AI analysis
class AnalysisInsights {
  final int wordCount;
  final Map<String, double> toneStats; // e.g., {"positive": 0.7, "neutral": 0.2, "negative": 0.1}
  final Map<String, double> emotionTrends; // e.g., {"calm": 0.6, "anxious": 0.3}
  final List<String> topKeywords;
  final List<String> commonThemes;
  final double overallSentiment; // -1.0 to 1.0
  final Map<String, dynamic>? additionalData;

  const AnalysisInsights({
    required this.wordCount,
    required this.toneStats,
    required this.emotionTrends,
    required this.topKeywords,
    required this.commonThemes,
    required this.overallSentiment,
    this.additionalData,
  });

  Map<String, dynamic> toMap() {
    return {
      'wordCount': wordCount,
      'toneStats': toneStats,
      'emotionTrends': emotionTrends,
      'topKeywords': topKeywords,
      'commonThemes': commonThemes,
      'overallSentiment': overallSentiment,
      'additionalData': additionalData,
    };
  }

  factory AnalysisInsights.fromMap(Map<String, dynamic> map) {
    return AnalysisInsights(
      wordCount: map['wordCount'] ?? 0,
      toneStats: Map<String, double>.from(map['toneStats'] ?? {}),
      emotionTrends: Map<String, double>.from(map['emotionTrends'] ?? {}),
      topKeywords: List<String>.from(map['topKeywords'] ?? []),
      commonThemes: List<String>.from(map['commonThemes'] ?? []),
      overallSentiment: (map['overallSentiment'] ?? 0.0).toDouble(),
      additionalData: map['additionalData'],
    );
  }
}
