import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/journal_entry.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';

/// Provider for FirestoreService singleton
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

/// Stream provider for all journal entries
final journalEntriesProvider = StreamProvider<List<JournalEntry>>((ref) {
  final authState = ref.watch(authStateProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);

  if (authState.user == null) {
    return Stream.value([]);
  }

  return firestoreService.getJournalEntries(authState.user!.id);
});

/// Provider for journal entries count
final journalEntriesCountProvider = FutureProvider<int>((ref) async {
  final authState = ref.watch(authStateProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);

  if (authState.user == null) {
    return 0;
  }

  return await firestoreService.getJournalEntriesCount(authState.user!.id);
});

/// Provider for journal statistics
final journalStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final authState = ref.watch(authStateProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);

  if (authState.user == null) {
    return {};
  }

  return await firestoreService.getJournalStats(authState.user!.id);
});

/// Provider for entries on a specific date
final entriesForDateProvider = FutureProvider.family<List<JournalEntry>, DateTime>((ref, date) async {
  final authState = ref.watch(authStateProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);

  if (authState.user == null) {
    return [];
  }

  return await firestoreService.getEntriesForDate(
    userId: authState.user!.id,
    date: date,
  );
});

/// Provider for entries in a date range
final entriesInRangeProvider = StreamProvider.family<List<JournalEntry>, DateRange>((ref, dateRange) {
  final authState = ref.watch(authStateProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);

  if (authState.user == null) {
    return Stream.value([]);
  }

  return firestoreService.getJournalEntriesInRange(
    userId: authState.user!.id,
    startDate: dateRange.startDate,
    endDate: dateRange.endDate,
  );
});

/// Helper class for date range queries
class DateRange {
  final DateTime startDate;
  final DateTime endDate;

  const DateRange({
    required this.startDate,
    required this.endDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateRange &&
          runtimeType == other.runtimeType &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode => startDate.hashCode ^ endDate.hashCode;
}

/// Notifier for managing journal entries state
class JournalNotifier extends StateNotifier<AsyncValue<List<JournalEntry>>> {
  final FirestoreService _firestoreService;
  final String userId;

  JournalNotifier(this._firestoreService, this.userId) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    _firestoreService.getJournalEntries(userId).listen(
      (entries) {
        state = AsyncValue.data(entries);
      },
      onError: (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      },
    );
  }

  /// Create a new journal entry
  Future<String?> createEntry(JournalEntry entry) async {
    try {
      final entryId = await _firestoreService.createJournalEntry(
        userId: userId,
        entry: entry,
      );
      return entryId;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return null;
    }
  }

  /// Update an existing entry
  Future<void> updateEntry(String entryId, Map<String, dynamic> updates) async {
    try {
      await _firestoreService.updateJournalEntry(
        userId: userId,
        entryId: entryId,
        updates: updates,
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Delete an entry
  Future<void> deleteEntry(String entryId) async {
    try {
      await _firestoreService.deleteJournalEntry(
        userId: userId,
        entryId: entryId,
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Search entries
  Future<List<JournalEntry>> searchEntries(String query) async {
    try {
      return await _firestoreService.searchJournalEntries(
        userId: userId,
        query: query,
      );
    } catch (e) {
      return [];
    }
  }
}

/// Provider for journal notifier
final journalNotifierProvider = StateNotifierProvider.family<JournalNotifier, AsyncValue<List<JournalEntry>>, String>(
  (ref, userId) {
    final firestoreService = ref.watch(firestoreServiceProvider);
    return JournalNotifier(firestoreService, userId);
  },
);
