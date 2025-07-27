class AIAnalysis {
  final String emotionalTone;
  final double confidence;
  final List<String> triggers;
  final String insight;
  final List<String> suggestions;
  final Map<String, double> emotionScores;
  final DateTime analyzedAt;

  const AIAnalysis({
    required this.emotionalTone,
    required this.confidence,
    required this.triggers,
    required this.insight,
    required this.suggestions,
    required this.emotionScores,
    required this.analyzedAt,
  });

  AIAnalysis copyWith({
    String? emotionalTone,
    double? confidence,
    List<String>? triggers,
    String? insight,
    List<String>? suggestions,
    Map<String, double>? emotionScores,
    DateTime? analyzedAt,
  }) {
    return AIAnalysis(
      emotionalTone: emotionalTone ?? this.emotionalTone,
      confidence: confidence ?? this.confidence,
      triggers: triggers ?? this.triggers,
      insight: insight ?? this.insight,
      suggestions: suggestions ?? this.suggestions,
      emotionScores: emotionScores ?? this.emotionScores,
      analyzedAt: analyzedAt ?? this.analyzedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emotionalTone': emotionalTone,
      'confidence': confidence,
      'triggers': triggers,
      'insight': insight,
      'suggestions': suggestions,
      'emotionScores': emotionScores,
      'analyzedAt': analyzedAt.toIso8601String(),
    };
  }

  factory AIAnalysis.fromJson(Map<String, dynamic> json) {
    return AIAnalysis(
      emotionalTone: json['emotionalTone'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      triggers: List<String>.from(json['triggers'] ?? []),
      insight: json['insight'] ?? '',
      suggestions: List<String>.from(json['suggestions'] ?? []),
      emotionScores: Map<String, double>.from(
        json['emotionScores']?.map((key, value) => 
          MapEntry(key, (value ?? 0.0).toDouble())) ?? {}
      ),
      analyzedAt: json['analyzedAt'] != null 
          ? DateTime.parse(json['analyzedAt'])
          : DateTime.now(),
    );
  }

  // Helper getters
  bool get hasPositiveTone => emotionalTone.toLowerCase().contains(RegExp(r'positive|happy|joy|content|calm|peaceful'));
  bool get hasNegativeTone => emotionalTone.toLowerCase().contains(RegExp(r'negative|sad|angry|anxious|stressed|worried'));
  bool get hasNeutralTone => !hasPositiveTone && !hasNegativeTone;
  
  String get primaryEmotion {
    if (emotionScores.isEmpty) return emotionalTone;
    
    final sortedEmotions = emotionScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedEmotions.first.key;
  }
  
  double get primaryEmotionScore {
    if (emotionScores.isEmpty) return confidence;
    
    final sortedEmotions = emotionScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedEmotions.first.value;
  }

  bool get hasHighConfidence => confidence >= 0.8;
  bool get hasMediumConfidence => confidence >= 0.6 && confidence < 0.8;
  bool get hasLowConfidence => confidence < 0.6;
}