import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/journal_entry.dart';
import '../models/ai_analysis.dart';

/// Service for managing journal entries in Firestore
/// Collection structure: users/{userId}/journals/{entryId}
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton pattern
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  /// Get reference to user's journal collection
  /// Structure: journals/{userId}/entries/{entryId}
  CollectionReference _getUserJournalCollection(String userId) {
    return _firestore.collection('journals').doc(userId).collection('entries');
  }

  /// Create a new journal entry
  Future<String> createJournalEntry({
    required String userId,
    required JournalEntry entry,
  }) async {
    try {
      final docRef = await _getUserJournalCollection(userId).add({
        'userId': userId,
        'mood': entry.mood,
        'entryText': entry.transcription, // Match existing field name
        'transcription': entry.transcription, // Also keep for compatibility
        'audioPath': entry.audioPath,
        'localAudioPath': entry.localAudioPath,
        'recordingDuration': entry.recordingDuration?.inMilliseconds,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isPrivate': entry.isPrivate,
        'isSynced': true,
        'aiAnalysis': entry.aiAnalysis?.toJson(),
      });

      debugPrint('✅ Journal entry created: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('❌ Error creating journal entry: $e');
      rethrow;
    }
  }

  /// Get journal entries for a user with optional limit for performance
  /// Default limit of 20 entries - use getJournalEntriesInRange() for more specific queries
  Stream<List<JournalEntry>> getJournalEntries(String userId, {int limit = 20}) {
    try {
      return _getUserJournalCollection(userId)
          .orderBy('createdAt', descending: true)
          .limit(limit) // ⚡ Performance: Only load recent entries by default
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return _journalEntryFromFirestore(doc);
        }).toList();
      });
    } catch (e) {
      debugPrint('❌ Error getting journal entries: $e');
      return Stream.value([]);
    }
  }

  /// Get journal entries for a specific date range
  Stream<List<JournalEntry>> getJournalEntriesInRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    try {
      return _getUserJournalCollection(userId)
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return _journalEntryFromFirestore(doc);
        }).toList();
      });
    } catch (e) {
      debugPrint('❌ Error getting journal entries in range: $e');
      return Stream.value([]);
    }
  }

  /// Get a single journal entry
  Future<JournalEntry?> getJournalEntry({
    required String userId,
    required String entryId,
  }) async {
    try {
      final doc = await _getUserJournalCollection(userId).doc(entryId).get();
      if (!doc.exists) return null;
      return _journalEntryFromFirestore(doc);
    } catch (e) {
      debugPrint('❌ Error getting journal entry: $e');
      return null;
    }
  }

  /// Update a journal entry
  Future<void> updateJournalEntry({
    required String userId,
    required String entryId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      await _getUserJournalCollection(userId).doc(entryId).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ Journal entry updated: $entryId');
    } catch (e) {
      debugPrint('❌ Error updating journal entry: $e');
      rethrow;
    }
  }

  /// Delete a journal entry
  Future<void> deleteJournalEntry({
    required String userId,
    required String entryId,
  }) async {
    try {
      await _getUserJournalCollection(userId).doc(entryId).delete();
      debugPrint('✅ Journal entry deleted: $entryId');
    } catch (e) {
      debugPrint('❌ Error deleting journal entry: $e');
      rethrow;
    }
  }

  /// Get journal entries by mood
  Stream<List<JournalEntry>> getJournalEntriesByMood({
    required String userId,
    required String mood,
  }) {
    try {
      return _getUserJournalCollection(userId)
          .where('mood', isEqualTo: mood)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return _journalEntryFromFirestore(doc);
        }).toList();
      });
    } catch (e) {
      debugPrint('❌ Error getting journal entries by mood: $e');
      return Stream.value([]);
    }
  }

  /// Get journal entries count
  Future<int> getJournalEntriesCount(String userId) async {
    try {
      final snapshot = await _getUserJournalCollection(userId).count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      debugPrint('❌ Error getting journal entries count: $e');
      return 0;
    }
  }

  /// Search journal entries by transcription text
  /// ⚡ Performance: Limited to last 50 entries for client-side search
  /// For production full-text search, consider using Algolia or ElasticSearch
  Future<List<JournalEntry>> searchJournalEntries({
    required String userId,
    required String query,
    int limit = 50,
  }) async {
    try {
      final snapshot = await _getUserJournalCollection(userId)
          .orderBy('createdAt', descending: true)
          .limit(limit) // ⚡ Limit search scope for performance
          .get();

      return snapshot.docs
          .map((doc) => _journalEntryFromFirestore(doc))
          .where((entry) =>
              entry.transcription.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      debugPrint('❌ Error searching journal entries: $e');
      return [];
    }
  }

  /// Get entries for a specific date
  Future<List<JournalEntry>> getEntriesForDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final snapshot = await _getUserJournalCollection(userId)
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('createdAt', descending: false)
          .get();

      return snapshot.docs.map((doc) => _journalEntryFromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('❌ Error getting entries for date: $e');
      return [];
    }
  }

  /// Helper method to convert Firestore document to JournalEntry
  JournalEntry _journalEntryFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Handle createdAt - could be Timestamp or null
    DateTime createdAt;
    if (data['createdAt'] != null) {
      createdAt = (data['createdAt'] as Timestamp).toDate();
    } else {
      createdAt = DateTime.now();
    }

    return JournalEntry(
      id: doc.id,
      userId: data['userId'] ?? '', // Read from document
      mood: data['mood'] ?? 'calm',
      transcription: data['entryText'] ?? data['transcription'] ?? '', // Support both field names
      audioPath: data['audioPath'],
      localAudioPath: data['localAudioPath'],
      recordingDuration: data['recordingDuration'] != null
          ? Duration(milliseconds: (data['recordingDuration'] as num).toInt())
          : null,
      createdAt: createdAt,
      isPrivate: data['isPrivate'] ?? true,
      isSynced: data['isSynced'] ?? true,
      aiAnalysis: data['aiAnalysis'] != null
          ? AIAnalysis.fromJson(data['aiAnalysis'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Batch delete entries (for testing/cleanup)
  Future<void> batchDeleteEntries({
    required String userId,
    required List<String> entryIds,
  }) async {
    try {
      final batch = _firestore.batch();
      for (final entryId in entryIds) {
        batch.delete(_getUserJournalCollection(userId).doc(entryId));
      }
      await batch.commit();
      debugPrint('✅ Batch deleted ${entryIds.length} entries');
    } catch (e) {
      debugPrint('❌ Error batch deleting entries: $e');
      rethrow;
    }
  }

  /// Get statistics for user's journal
  /// ⚡ Performance: Limited to 100 most recent entries for stats calculation
  Future<Map<String, dynamic>> getJournalStats(String userId) async {
    try {
      final snapshot = await _getUserJournalCollection(userId)
          .orderBy('createdAt', descending: true)
          .limit(100) // ⚡ Cap at 100 entries for performance
          .get();
      final entries = snapshot.docs.map((doc) => _journalEntryFromFirestore(doc)).toList();

      // Calculate stats
      final moodCounts = <String, int>{};
      int totalDuration = 0;
      int entriesWithAI = 0;

      for (final entry in entries) {
        moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
        if (entry.recordingDuration != null) {
          totalDuration += entry.recordingDuration!.inMilliseconds;
        }
        if (entry.aiAnalysis != null) {
          entriesWithAI++;
        }
      }

      return {
        'totalEntries': entries.length,
        'moodCounts': moodCounts,
        'totalRecordingDurationMs': totalDuration,
        'entriesWithAI': entriesWithAI,
        'averageDurationMs': entries.isEmpty ? 0 : totalDuration / entries.length,
      };
    } catch (e) {
      debugPrint('❌ Error getting journal stats: $e');
      return {};
    }
  }

  /// Save user feedback to Firestore
  /// Collection structure: feedback/{feedbackId}
  Future<void> saveFeedback({
    required String userId,
    required String userName,
    required String feedback,
    String? userEmail,
  }) async {
    try {
      await _firestore.collection('feedback').add({
        'userId': userId,
        'userName': userName,
        'userEmail': userEmail,
        'feedback': feedback,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'new', // new, reviewed, resolved
        'platform': defaultTargetPlatform.name,
      });

      debugPrint('✅ Feedback saved successfully');
    } catch (e) {
      debugPrint('❌ Error saving feedback: $e');
      rethrow;
    }
  }
}
