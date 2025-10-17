import 'package:cloud_firestore/cloud_firestore.dart';
import 'ai_analysis.dart';

/// Enhanced journal entry model with support for photos and tags
/// Stored in users/{userId}/journals/{entryId}
class JournalEntryV2 {
  final String id;
  final String userId;
  final String? title; // Optional title (e.g., "Sunday Reflection")
  final String transcription;
  final AIAnalysis? aiAnalysis;
  final String moodSnapshot; // Mood at the time of journaling
  final String? audioPath; // Firebase Storage URL
  final List<String> photoPaths; // Array of Firebase Storage URLs for photos
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool overwriteFlag; // If true, this overwrites a previous entry for the same day
  final List<String> tags; // ["gratitude", "stress", "self-growth"]
  final Duration? recordingDuration;
  final bool isPrivate;
  final bool isSynced;

  const JournalEntryV2({
    required this.id,
    required this.userId,
    this.title,
    required this.transcription,
    this.aiAnalysis,
    required this.moodSnapshot,
    this.audioPath,
    this.photoPaths = const [],
    required this.createdAt,
    this.updatedAt,
    this.overwriteFlag = false,
    this.tags = const [],
    this.recordingDuration,
    this.isPrivate = true,
    this.isSynced = false,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'transcription': transcription,
      'aiAnalysis': aiAnalysis?.toJson(),
      'moodSnapshot': moodSnapshot,
      'audioPath': audioPath,
      'photoPaths': photoPaths,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'overwriteFlag': overwriteFlag,
      'tags': tags,
      'recordingDuration': recordingDuration?.inMilliseconds,
      'isPrivate': isPrivate,
      'isSynced': isSynced,
    };
  }

  factory JournalEntryV2.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return JournalEntryV2(
      id: doc.id,
      userId: doc.reference.parent.parent!.id,
      title: data['title'],
      transcription: data['transcription'] ?? '',
      aiAnalysis: data['aiAnalysis'] != null
          ? AIAnalysis.fromJson(data['aiAnalysis'])
          : null,
      moodSnapshot: data['moodSnapshot'] ?? '',
      audioPath: data['audioPath'],
      photoPaths: List<String>.from(data['photoPaths'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      overwriteFlag: data['overwriteFlag'] ?? false,
      tags: List<String>.from(data['tags'] ?? []),
      recordingDuration: data['recordingDuration'] != null
          ? Duration(milliseconds: data['recordingDuration'])
          : null,
      isPrivate: data['isPrivate'] ?? true,
      isSynced: data['isSynced'] ?? false,
    );
  }

  JournalEntryV2 copyWith({
    String? id,
    String? userId,
    String? title,
    String? transcription,
    AIAnalysis? aiAnalysis,
    String? moodSnapshot,
    String? audioPath,
    List<String>? photoPaths,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? overwriteFlag,
    List<String>? tags,
    Duration? recordingDuration,
    bool? isPrivate,
    bool? isSynced,
    bool clearAiAnalysis = false,
  }) {
    return JournalEntryV2(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      transcription: transcription ?? this.transcription,
      aiAnalysis: clearAiAnalysis ? null : (aiAnalysis ?? this.aiAnalysis),
      moodSnapshot: moodSnapshot ?? this.moodSnapshot,
      audioPath: audioPath ?? this.audioPath,
      photoPaths: photoPaths ?? this.photoPaths,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      overwriteFlag: overwriteFlag ?? this.overwriteFlag,
      tags: tags ?? this.tags,
      recordingDuration: recordingDuration ?? this.recordingDuration,
      isPrivate: isPrivate ?? this.isPrivate,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  /// Get date key for grouping (YYYY-MM-DD)
  String get dateKey {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
  }

  /// Helper getters
  bool get hasAudio => audioPath != null;
  bool get hasPhotos => photoPaths.isNotEmpty;
  bool get hasTranscription => transcription.isNotEmpty;
  bool get hasAIAnalysis => aiAnalysis != null;
  bool get needsSync => !isSynced && (hasAudio || hasPhotos);

  String get displayDuration {
    if (recordingDuration == null) return '0:00';
    final minutes = recordingDuration!.inMinutes;
    final seconds = recordingDuration!.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Check if entry is from today
  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }
}

/// Common journal tags for categorization
class JournalTags {
  static const List<String> all = [
    'gratitude',
    'stress',
    'self-growth',
    'relationships',
    'work',
    'health',
    'mindfulness',
    'anxiety',
    'joy',
    'reflection',
    'goals',
    'challenges',
  ];

  static const Map<String, String> icons = {
    'gratitude': '🙏',
    'stress': '😰',
    'self-growth': '🌱',
    'relationships': '💑',
    'work': '💼',
    'health': '🏥',
    'mindfulness': '🧘',
    'anxiety': '😨',
    'joy': '😊',
    'reflection': '🤔',
    'goals': '🎯',
    'challenges': '⚡',
  };

  static String getIcon(String tag) {
    return icons[tag] ?? '📝';
  }
}
