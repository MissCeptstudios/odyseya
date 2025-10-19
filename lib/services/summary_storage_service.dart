import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/journal_summary.dart';

/// Service for storing and retrieving journal summaries from Firestore
/// Collection structure: summaries/{userId}/reports/{summaryId}
class SummaryStorageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton pattern
  static final SummaryStorageService _instance = SummaryStorageService._internal();
  factory SummaryStorageService() => _instance;
  SummaryStorageService._internal();

  /// Get reference to user's summaries collection
  CollectionReference _getUserSummariesCollection(String userId) {
    return _firestore.collection('summaries').doc(userId).collection('reports');
  }

  /// Save a summary to Firestore
  Future<String> saveSummary(JournalSummary summary) async {
    try {
      final docRef = _getUserSummariesCollection(summary.userId).doc();

      await docRef.set({
        'userId': summary.userId,
        'periodStart': Timestamp.fromDate(summary.periodStart),
        'periodEnd': Timestamp.fromDate(summary.periodEnd),
        'frequency': summary.frequency,
        'createdAt': FieldValue.serverTimestamp(),
        'overallMoodTrend': summary.overallMoodTrend,
        'moodDistribution': summary.moodDistribution,
        'keyThemes': summary.keyThemes,
        'emotionalHighlights': summary.emotionalHighlights,
        'challengingMoments': summary.challengingMoments,
        'growthAreas': summary.growthAreas,
        'suggestedFocus': summary.suggestedFocus,
        'totalEntries': summary.totalEntries,
        'daysJournaled': summary.daysJournaled,
        'totalRecordingTimeMs': summary.totalRecordingTime.inMilliseconds,
        'averageConfidence': summary.averageConfidence,
        'executiveSummary': summary.executiveSummary,
        'detailedInsight': summary.detailedInsight,
        'actionableSteps': summary.actionableSteps,
        'dominantEmotion': summary.dominantEmotion,
        'commonTriggers': summary.commonTriggers,
        'emotionTrends': summary.emotionTrends,
      });

      if (kDebugMode) {
        debugPrint('✅ Summary saved: ${docRef.id}');
      }

      return docRef.id;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error saving summary: $e');
      }
      rethrow;
    }
  }

  /// Get all summaries for a user
  Stream<List<JournalSummary>> getSummaries(String userId) {
    try {
      return _getUserSummariesCollection(userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return _summaryFromFirestore(doc);
        }).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting summaries: $e');
      }
      return Stream.value([]);
    }
  }

  /// Get the most recent summary
  Future<JournalSummary?> getLatestSummary(String userId) async {
    try {
      final snapshot = await _getUserSummariesCollection(userId)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return _summaryFromFirestore(snapshot.docs.first);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting latest summary: $e');
      }
      return null;
    }
  }

  /// Get a specific summary by ID
  Future<JournalSummary?> getSummary({
    required String userId,
    required String summaryId,
  }) async {
    try {
      final doc = await _getUserSummariesCollection(userId).doc(summaryId).get();
      if (!doc.exists) return null;

      return _summaryFromFirestore(doc);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting summary: $e');
      }
      return null;
    }
  }

  /// Get summaries for a specific frequency
  Stream<List<JournalSummary>> getSummariesByFrequency({
    required String userId,
    required String frequency,
  }) {
    try {
      return _getUserSummariesCollection(userId)
          .where('frequency', isEqualTo: frequency)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return _summaryFromFirestore(doc);
        }).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting summaries by frequency: $e');
      }
      return Stream.value([]);
    }
  }

  /// Delete a summary
  Future<void> deleteSummary({
    required String userId,
    required String summaryId,
  }) async {
    try {
      await _getUserSummariesCollection(userId).doc(summaryId).delete();

      if (kDebugMode) {
        debugPrint('✅ Summary deleted: $summaryId');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error deleting summary: $e');
      }
      rethrow;
    }
  }

  /// Get summaries count
  Future<int> getSummariesCount(String userId) async {
    try {
      final snapshot = await _getUserSummariesCollection(userId).count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting summaries count: $e');
      }
      return 0;
    }
  }

  /// Check if user has any summaries
  Future<bool> hasSummaries(String userId) async {
    final count = await getSummariesCount(userId);
    return count > 0;
  }

  /// Get summaries within a date range
  Future<List<JournalSummary>> getSummariesInRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final snapshot = await _getUserSummariesCollection(userId)
          .where('periodStart', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('periodStart', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('periodStart', descending: true)
          .get();

      return snapshot.docs.map((doc) => _summaryFromFirestore(doc)).toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting summaries in range: $e');
      }
      return [];
    }
  }

  /// Helper method to convert Firestore document to JournalSummary
  JournalSummary _summaryFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return JournalSummary(
      id: doc.id,
      userId: data['userId'] as String,
      periodStart: (data['periodStart'] as Timestamp).toDate(),
      periodEnd: (data['periodEnd'] as Timestamp).toDate(),
      frequency: data['frequency'] as String,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      overallMoodTrend: data['overallMoodTrend'] as String,
      moodDistribution: Map<String, int>.from(data['moodDistribution'] as Map),
      keyThemes: List<String>.from(data['keyThemes'] as List),
      emotionalHighlights: List<String>.from(data['emotionalHighlights'] as List),
      challengingMoments: List<String>.from(data['challengingMoments'] as List),
      growthAreas: List<String>.from(data['growthAreas'] as List),
      suggestedFocus: List<String>.from(data['suggestedFocus'] as List),
      totalEntries: data['totalEntries'] as int,
      daysJournaled: data['daysJournaled'] as int,
      totalRecordingTime: Duration(milliseconds: data['totalRecordingTimeMs'] as int),
      averageConfidence: (data['averageConfidence'] as num).toDouble(),
      executiveSummary: data['executiveSummary'] as String,
      detailedInsight: data['detailedInsight'] as String,
      actionableSteps: List<String>.from(data['actionableSteps'] as List),
      dominantEmotion: data['dominantEmotion'] as String?,
      commonTriggers: data['commonTriggers'] != null
          ? List<String>.from(data['commonTriggers'] as List)
          : null,
      emotionTrends: data['emotionTrends'] != null
          ? Map<String, double>.from(
              (data['emotionTrends'] as Map).map(
                (k, v) => MapEntry(k as String, (v as num).toDouble()),
              ),
            )
          : null,
    );
  }

  /// Batch delete old summaries (cleanup)
  Future<void> deleteOldSummaries({
    required String userId,
    required DateTime olderThan,
  }) async {
    try {
      final snapshot = await _getUserSummariesCollection(userId)
          .where('createdAt', isLessThan: Timestamp.fromDate(olderThan))
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      if (kDebugMode) {
        debugPrint('✅ Deleted ${snapshot.docs.length} old summaries');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error deleting old summaries: $e');
      }
      rethrow;
    }
  }
}
