import 'package:cloud_firestore/cloud_firestore.dart';

/// Affirmation model for daily positive messages
/// Stored in users/{userId}/affirmations/{affirmationId}
class Affirmation {
  final String id;
  final String userId;
  final String text;
  final AffirmationSource source;
  final DateTime shownAt;
  final bool? liked; // true = liked, false = skipped, null = not rated
  final String? moodContext; // Mood at the time affirmation was shown
  final Map<String, dynamic>? metadata; // Additional context

  const Affirmation({
    required this.id,
    required this.userId,
    required this.text,
    required this.source,
    required this.shownAt,
    this.liked,
    this.moodContext,
    this.metadata,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'source': source.name,
      'shownAt': Timestamp.fromDate(shownAt),
      'liked': liked,
      'moodContext': moodContext,
      'metadata': metadata,
    };
  }

  factory Affirmation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Affirmation(
      id: doc.id,
      userId: doc.reference.parent.parent!.id,
      text: data['text'] ?? '',
      source: AffirmationSource.fromString(data['source'] ?? 'system'),
      shownAt: (data['shownAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      liked: data['liked'],
      moodContext: data['moodContext'],
      metadata: data['metadata'],
    );
  }

  Affirmation copyWith({
    String? id,
    String? userId,
    String? text,
    AffirmationSource? source,
    DateTime? shownAt,
    bool? liked,
    String? moodContext,
    Map<String, dynamic>? metadata,
  }) {
    return Affirmation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      source: source ?? this.source,
      shownAt: shownAt ?? this.shownAt,
      liked: liked ?? this.liked,
      moodContext: moodContext ?? this.moodContext,
      metadata: metadata ?? this.metadata,
    );
  }
}

enum AffirmationSource {
  system, // Pre-defined affirmations
  ai, // AI-generated based on user's journal
  custom; // User-created

  static AffirmationSource fromString(String value) {
    return AffirmationSource.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AffirmationSource.system,
    );
  }
}

/// Pre-defined affirmations library
class AffirmationLibrary {
  static const List<String> calm = [
    "Inner peace is my natural state.",
    "I breathe in calm, I breathe out tension.",
    "My mind is clear and peaceful.",
    "I am grounded in this moment.",
  ];

  static const List<String> anxious = [
    "I release what I cannot control.",
    "This feeling is temporary, and I am safe.",
    "I trust in my ability to handle challenges.",
    "One breath at a time, I find my center.",
  ];

  static const List<String> grateful = [
    "I appreciate the abundance in my life.",
    "Gratitude fills my heart and my days.",
    "I notice and celebrate small joys.",
    "Every day brings new reasons to be thankful.",
  ];

  static const List<String> stressed = [
    "I give myself permission to pause.",
    "I am doing my best, and that is enough.",
    "I prioritize my wellbeing.",
    "I release the need to be perfect.",
  ];

  static const List<String> general = [
    "I am worthy of love and respect.",
    "My emotions are valid and important.",
    "I grow stronger through challenges.",
    "I trust my journey.",
    "I am exactly where I need to be.",
  ];

  /// Get affirmation based on mood context
  static String getForMood(String mood) {
    switch (mood.toLowerCase()) {
      case 'calm':
      case 'peaceful':
        return (calm..shuffle()).first;
      case 'anxious':
      case 'worried':
        return (anxious..shuffle()).first;
      case 'grateful':
      case 'joyful':
        return (grateful..shuffle()).first;
      case 'stressed':
      case 'overwhelmed':
        return (stressed..shuffle()).first;
      default:
        return (general..shuffle()).first;
    }
  }
}
