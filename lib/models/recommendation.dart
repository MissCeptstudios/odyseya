import 'package:cloud_firestore/cloud_firestore.dart';

/// Recommendation model for books, podcasts, courses, etc.
/// Stored in users/{userId}/recommendations/{recommendationId}
class Recommendation {
  final String id;
  final String userId;
  final RecommendationType type;
  final String title;
  final String? author;
  final String? link;
  final String reason; // Why this was recommended (e.g., "based on mood trend")
  final String month; // "2025-10"
  final DateTime createdAt;
  final bool isViewed;
  final bool isFavorited;
  final Map<String, dynamic>? metadata;

  const Recommendation({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.author,
    this.link,
    required this.reason,
    required this.month,
    required this.createdAt,
    this.isViewed = false,
    this.isFavorited = false,
    this.metadata,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'type': type.name,
      'title': title,
      'author': author,
      'link': link,
      'reason': reason,
      'month': month,
      'createdAt': Timestamp.fromDate(createdAt),
      'isViewed': isViewed,
      'isFavorited': isFavorited,
      'metadata': metadata,
    };
  }

  factory Recommendation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Recommendation(
      id: doc.id,
      userId: doc.reference.parent.parent!.id,
      type: RecommendationType.fromString(data['type'] ?? 'book'),
      title: data['title'] ?? '',
      author: data['author'],
      link: data['link'],
      reason: data['reason'] ?? '',
      month: data['month'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isViewed: data['isViewed'] ?? false,
      isFavorited: data['isFavorited'] ?? false,
      metadata: data['metadata'],
    );
  }

  Recommendation copyWith({
    String? id,
    String? userId,
    RecommendationType? type,
    String? title,
    String? author,
    String? link,
    String? reason,
    String? month,
    DateTime? createdAt,
    bool? isViewed,
    bool? isFavorited,
    Map<String, dynamic>? metadata,
  }) {
    return Recommendation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      author: author ?? this.author,
      link: link ?? this.link,
      reason: reason ?? this.reason,
      month: month ?? this.month,
      createdAt: createdAt ?? this.createdAt,
      isViewed: isViewed ?? this.isViewed,
      isFavorited: isFavorited ?? this.isFavorited,
      metadata: metadata ?? this.metadata,
    );
  }
}

enum RecommendationType {
  book,
  podcast,
  course,
  article,
  video,
  app,
  technique; // e.g., meditation technique

  static RecommendationType fromString(String value) {
    return RecommendationType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => RecommendationType.book,
    );
  }

  String get displayName {
    switch (this) {
      case RecommendationType.book:
        return 'Book';
      case RecommendationType.podcast:
        return 'Podcast';
      case RecommendationType.course:
        return 'Course';
      case RecommendationType.article:
        return 'Article';
      case RecommendationType.video:
        return 'Video';
      case RecommendationType.app:
        return 'App';
      case RecommendationType.technique:
        return 'Technique';
    }
  }

  String get icon {
    switch (this) {
      case RecommendationType.book:
        return '📚';
      case RecommendationType.podcast:
        return '🎙️';
      case RecommendationType.course:
        return '🎓';
      case RecommendationType.article:
        return '📰';
      case RecommendationType.video:
        return '🎬';
      case RecommendationType.app:
        return '📱';
      case RecommendationType.technique:
        return '🧘';
    }
  }
}

/// Sample recommendations library
class RecommendationLibrary {
  static const List<Map<String, String>> booksForAnxiety = [
    {
      'title': 'The Anxiety Toolkit',
      'author': 'Alice Boyes',
      'reason': 'Practical strategies for managing anxiety',
    },
    {
      'title': 'Dare: The New Way to End Anxiety',
      'author': 'Barry McDonagh',
      'reason': 'Evidence-based approach to anxiety relief',
    },
  ];

  static const List<Map<String, String>> booksForCalm = [
    {
      'title': 'Peace Is Every Step',
      'author': 'Thich Nhat Hanh',
      'reason': 'Mindfulness practices for daily peace',
    },
    {
      'title': 'The Book of Joy',
      'author': 'Dalai Lama & Desmond Tutu',
      'reason': 'Finding lasting happiness despite challenges',
    },
  ];

  static const List<Map<String, String>> booksForGrowth = [
    {
      'title': 'Atomic Habits',
      'author': 'James Clear',
      'reason': 'Building better habits for personal growth',
    },
    {
      'title': 'The Gifts of Imperfection',
      'author': 'Brené Brown',
      'reason': 'Embracing vulnerability and authenticity',
    },
  ];
}
