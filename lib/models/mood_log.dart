import 'package:cloud_firestore/cloud_firestore.dart';

/// Mood log entry for daily mood tracking
/// Stored in users/{userId}/moods/{moodId}
class MoodLog {
  final String id;
  final String userId;
  final String moodValue; // "Calm", "Anxious", "Grateful", etc.
  final int intensity; // 1-10
  final String? note; // Optional text note
  final DateTime createdAt;
  final DateTime? updatedAt;
  final MoodSource source; // 'manual' or 'ai'

  const MoodLog({
    required this.id,
    required this.userId,
    required this.moodValue,
    required this.intensity,
    this.note,
    required this.createdAt,
    this.updatedAt,
    required this.source,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'moodValue': moodValue,
      'intensity': intensity,
      'note': note,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'source': source.name,
    };
  }

  factory MoodLog.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MoodLog(
      id: doc.id,
      userId: doc.reference.parent.parent!.id,
      moodValue: data['moodValue'] ?? '',
      intensity: data['intensity'] ?? 5,
      note: data['note'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      source: MoodSource.fromString(data['source'] ?? 'manual'),
    );
  }

  MoodLog copyWith({
    String? id,
    String? userId,
    String? moodValue,
    int? intensity,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
    MoodSource? source,
  }) {
    return MoodLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      moodValue: moodValue ?? this.moodValue,
      intensity: intensity ?? this.intensity,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      source: source ?? this.source,
    );
  }

  /// Get date key for grouping (YYYY-MM-DD)
  String get dateKey {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
  }
}

enum MoodSource {
  manual,
  ai;

  static MoodSource fromString(String value) {
    return MoodSource.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MoodSource.manual,
    );
  }
}

/// Predefined mood options
class MoodOptions {
  static const List<String> all = [
    'Joyful',
    'Calm',
    'Grateful',
    'Melancholy',
    'Anxious',
    'Stressed',
    'Peaceful',
    'Energetic',
    'Tired',
    'Angry',
    'Hopeful',
    'Overwhelmed',
  ];

  static const Map<String, String> emojis = {
    'Joyful': '😄',
    'Calm': '😌',
    'Grateful': '🙏',
    'Melancholy': '😢',
    'Anxious': '😰',
    'Stressed': '😫',
    'Peaceful': '☮️',
    'Energetic': '⚡',
    'Tired': '😴',
    'Angry': '😠',
    'Hopeful': '🌟',
    'Overwhelmed': '🌊',
  };

  static String getEmoji(String mood) {
    return emojis[mood] ?? '😐';
  }
}
