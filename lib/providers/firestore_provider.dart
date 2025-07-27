import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/journal_entry.dart';

// Mock firestore service
class FirestoreService {
  final List<JournalEntry> _entries = [];

  Future<void> saveJournalEntry(JournalEntry entry) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final existingIndex = _entries.indexWhere((e) => e.id == entry.id);
    if (existingIndex >= 0) {
      _entries[existingIndex] = entry;
    } else {
      _entries.add(entry);
    }
  }

  Future<List<JournalEntry>> getJournalEntries(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _entries.where((entry) => entry.userId == userId).toList();
  }

  Future<void> deleteJournalEntry(String entryId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    _entries.removeWhere((entry) => entry.id == entryId);
  }

  Future<String> uploadAudioFile(String filePath) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    return 'mock-audio-url-${DateTime.now().millisecondsSinceEpoch}';
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
    await _firestoreService.deleteJournalEntry(entryId);
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