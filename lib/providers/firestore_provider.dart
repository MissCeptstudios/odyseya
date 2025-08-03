import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/journal_entry.dart';
import '../models/ai_analysis.dart';
import '../services/firebase_storage_service.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  FirestoreService() {
    if (kDebugMode) {
      print('Firestore service initialized');
    }
  }

  // Save journal entry with proper Firestore structure
  Future<String> saveJournalEntry(JournalEntry entry) async {
    try {
      // Create document reference
      final docRef = _firestore
          .collection('journals')
          .doc(entry.userId)
          .collection('entries')
          .doc();

      // Prepare data with the required structure
      final data = {
        'userId': entry.userId,
        'date': _formatDate(entry.createdAt),
        'mood': entry.mood,
        'entryText': entry.transcription,
        'createdAt': Timestamp.fromDate(entry.createdAt),
        'updatedAt': entry.updatedAt != null ? Timestamp.fromDate(entry.updatedAt!) : null,
        'isPrivate': entry.isPrivate,
        'audioPath': entry.audioPath,
        'localAudioPath': entry.localAudioPath,
        'recordingDuration': entry.recordingDuration?.inMilliseconds,
        'isSynced': true,
        // AI Analysis data
        'aiAnalysis': entry.aiAnalysis != null ? {
          'emotionalTone': entry.aiAnalysis!.emotionalTone,
          'confidence': entry.aiAnalysis!.confidence,
          'triggers': entry.aiAnalysis!.triggers,
          'insight': entry.aiAnalysis!.insight,
          'suggestions': entry.aiAnalysis!.suggestions,
          'emotionScores': entry.aiAnalysis!.emotionScores,
          'analyzedAt': Timestamp.fromDate(entry.aiAnalysis!.analyzedAt),
        } : null,
      };

      // Check for duplicate entry (same day)
      final existingQuery = await _firestore
          .collection('journals')
          .doc(entry.userId)
          .collection('entries')
          .where('date', isEqualTo: _formatDate(entry.createdAt))
          .limit(1)
          .get();

      if (existingQuery.docs.isNotEmpty) {
        // Update existing entry instead of creating duplicate
        final existingDoc = existingQuery.docs.first;
        await existingDoc.reference.update(data);
        return existingDoc.id;
      } else {
        // Create new entry
        await docRef.set(data);
        return docRef.id;
      }
    } catch (e) {
      throw Exception('Failed to save journal entry: $e');
    }
  }

  Future<List<JournalEntry>> getJournalEntries(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('journals')
          .doc(userId)
          .collection('entries')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return JournalEntry(
          id: doc.id,
          userId: data['userId'] ?? '',
          mood: data['mood'] ?? '',
          transcription: data['entryText'] ?? '',
          createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
          isPrivate: data['isPrivate'] ?? true,
          audioPath: data['audioPath'],
          localAudioPath: data['localAudioPath'],
          recordingDuration: data['recordingDuration'] != null 
              ? Duration(milliseconds: data['recordingDuration'] as int)
              : null,
          isSynced: data['isSynced'] ?? false,
          aiAnalysis: data['aiAnalysis'] != null ? AIAnalysis(
            emotionalTone: data['aiAnalysis']['emotionalTone'] ?? '',
            confidence: (data['aiAnalysis']['confidence'] ?? 0.0).toDouble(),
            triggers: List<String>.from(data['aiAnalysis']['triggers'] ?? []),
            insight: data['aiAnalysis']['insight'] ?? '',
            suggestions: List<String>.from(data['aiAnalysis']['suggestions'] ?? []),
            emotionScores: Map<String, double>.from(
              data['aiAnalysis']['emotionScores']?.map((key, value) => 
                MapEntry(key, (value ?? 0.0).toDouble())) ?? {}
            ),
            analyzedAt: (data['aiAnalysis']['analyzedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          ) : null,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to load journal entries: $e');
    }
  }

  Future<void> deleteJournalEntry(String userId, String entryId) async {
    try {
      await _firestore
          .collection('journals')
          .doc(userId)
          .collection('entries')
          .doc(entryId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete journal entry: $e');
    }
  }

  Future<String> uploadAudioFile(String filePath, String userId, String entryId) async {
    try {
      final storageService = FirebaseStorageService();
      
      // Validate audio file before upload
      await storageService.validateAudioFile(filePath);
      
      // Upload to Firebase Storage
      return await storageService.uploadAudioFile(
        filePath: filePath,
        userId: userId,
        entryId: entryId,
      );
    } catch (e) {
      throw Exception('Failed to upload audio file: $e');
    }
  }

  // Helper method to format date as YYYY-MM-DD
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

// Mock journal operations notifier
class JournalOperationsNotifier extends StateNotifier<List<JournalEntry>> {
  final FirestoreService _firestoreService;

  JournalOperationsNotifier(this._firestoreService) : super([]);

  Future<void> loadEntries(String userId) async {
    final entries = await _firestoreService.getJournalEntries(userId);
    state = entries;
  }

  Future<String> saveEntry(JournalEntry entry) async {
    await _firestoreService.saveJournalEntry(entry);
    await loadEntries(entry.userId);
    return entry.id;
  }

  Future<void> deleteEntry(String entryId, String userId) async {
    await _firestoreService.deleteJournalEntry(userId, entryId);
    await loadEntries(userId);
  }
}

// Providers
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final journalOperationsProvider = StateNotifierProvider<JournalOperationsNotifier, List<JournalEntry>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return JournalOperationsNotifier(firestoreService);
}); 