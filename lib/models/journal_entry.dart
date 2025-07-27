import 'ai_analysis.dart';

class JournalEntry {
  final String id;
  final String userId;
  final String mood;
  final String? audioPath;
  final String? localAudioPath;
  final String transcription;
  final AIAnalysis? aiAnalysis;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isPrivate;
  final Duration? recordingDuration;
  final bool isSynced;

  const JournalEntry({
    required this.id,
    required this.userId,
    required this.mood,
    this.audioPath,
    this.localAudioPath,
    required this.transcription,
    this.aiAnalysis,
    required this.createdAt,
    this.updatedAt,
    this.isPrivate = true,
    this.recordingDuration,
    this.isSynced = false,
  });

  JournalEntry copyWith({
    String? id,
    String? userId,
    String? mood,
    String? audioPath,
    String? localAudioPath,
    String? transcription,
    AIAnalysis? aiAnalysis,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPrivate,
    Duration? recordingDuration,
    bool? isSynced,
    bool clearAiAnalysis = false,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mood: mood ?? this.mood,
      audioPath: audioPath ?? this.audioPath,
      localAudioPath: localAudioPath ?? this.localAudioPath,
      transcription: transcription ?? this.transcription,
      aiAnalysis: clearAiAnalysis ? null : (aiAnalysis ?? this.aiAnalysis),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPrivate: isPrivate ?? this.isPrivate,
      recordingDuration: recordingDuration ?? this.recordingDuration,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'mood': mood,
      'audioPath': audioPath,
      'localAudioPath': localAudioPath,
      'transcription': transcription,
      'aiAnalysis': aiAnalysis?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isPrivate': isPrivate,
      'recordingDuration': recordingDuration?.inMilliseconds,
      'isSynced': isSynced,
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      userId: json['userId'],
      mood: json['mood'],
      audioPath: json['audioPath'],
      localAudioPath: json['localAudioPath'],
      transcription: json['transcription'] ?? '',
      aiAnalysis: json['aiAnalysis'] != null 
          ? AIAnalysis.fromJson(json['aiAnalysis'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'])
          : null,
      isPrivate: json['isPrivate'] ?? true,
      recordingDuration: json['recordingDuration'] != null
          ? Duration(milliseconds: json['recordingDuration'])
          : null,
      isSynced: json['isSynced'] ?? false,
    );
  }

  // Helper getters
  bool get hasAudio => audioPath != null || localAudioPath != null;
  bool get hasTranscription => transcription.isNotEmpty;
  bool get hasAIAnalysis => aiAnalysis != null;
  bool get needsSync => !isSynced && hasAudio;
  
  String get displayDuration {
    if (recordingDuration == null) return '0:00';
    final minutes = recordingDuration!.inMinutes;
    final seconds = recordingDuration!.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}