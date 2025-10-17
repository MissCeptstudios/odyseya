import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/journal_entry.dart';
import 'firestore_provider.dart';
import 'auth_provider.dart';

class CalendarState {
  final DateTime selectedDate;
  final DateTime currentMonth;
  final Map<DateTime, List<JournalEntry>> entriesByDate;
  final bool isLoading;
  final String? error;
  final int currentStreak;
  final double monthlyCompletionRate;
  final String? mostFrequentMood;
  final int totalEntriesThisMonth;

  const CalendarState({
    required this.selectedDate,
    required this.currentMonth,
    required this.entriesByDate,
    this.isLoading = false,
    this.error,
    this.currentStreak = 0,
    this.monthlyCompletionRate = 0.0,
    this.mostFrequentMood,
    this.totalEntriesThisMonth = 0,
  });

  CalendarState copyWith({
    DateTime? selectedDate,
    DateTime? currentMonth,
    Map<DateTime, List<JournalEntry>>? entriesByDate,
    bool? isLoading,
    String? error,
    int? currentStreak,
    double? monthlyCompletionRate,
    String? mostFrequentMood,
    int? totalEntriesThisMonth,
    bool clearError = false,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      currentMonth: currentMonth ?? this.currentMonth,
      entriesByDate: entriesByDate ?? this.entriesByDate,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      currentStreak: currentStreak ?? this.currentStreak,
      monthlyCompletionRate: monthlyCompletionRate ?? this.monthlyCompletionRate,
      mostFrequentMood: mostFrequentMood ?? this.mostFrequentMood,
      totalEntriesThisMonth: totalEntriesThisMonth ?? this.totalEntriesThisMonth,
    );
  }

  // Helper getters
  List<JournalEntry> get selectedDateEntries {
    final dateKey = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    return entriesByDate[dateKey] ?? [];
  }

  bool hasEntriesForDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return entriesByDate.containsKey(dateKey) && entriesByDate[dateKey]!.isNotEmpty;
  }

  String? getMoodForDate(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    final entries = entriesByDate[dateKey];
    if (entries == null || entries.isEmpty) return null;
    
    // Return the mood from the most recent entry
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries.first.mood;
  }
}

class CalendarNotifier extends StateNotifier<CalendarState> {
  final FirestoreService _firestoreService;
  final Ref _ref;

  CalendarNotifier(this._firestoreService, this._ref) : super(CalendarState(
    selectedDate: DateTime.now(),
    currentMonth: DateTime.now(),
    entriesByDate: {},
  )) {
    _loadEntriesForMonth(DateTime.now());
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void changeMonth(DateTime month) {
    state = state.copyWith(currentMonth: month, isLoading: true);
    _loadEntriesForMonth(month);
  }

  void nextMonth() {
    final nextMonth = DateTime(state.currentMonth.year, state.currentMonth.month + 1);
    changeMonth(nextMonth);
  }

  void previousMonth() {
    final prevMonth = DateTime(state.currentMonth.year, state.currentMonth.month - 1);
    changeMonth(prevMonth);
  }

  Future<void> _loadEntriesForMonth(DateTime month) async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      // Get authenticated user ID
      final userId = _ref.read(userIdProvider);

      // If no user is authenticated, clear entries and return
      if (userId == null) {
        if (kDebugMode) {
          debugPrint('📅 No authenticated user - calendar empty');
        }
        state = state.copyWith(
          entriesByDate: {},
          isLoading: false,
          currentStreak: 0,
          monthlyCompletionRate: 0.0,
          mostFrequentMood: null,
          totalEntriesThisMonth: 0,
        );
        return;
      }

      // Get start and end dates for the month
      final startDate = DateTime(month.year, month.month, 1);
      final endDate = DateTime(month.year, month.month + 1, 0);

      if (kDebugMode) {
        debugPrint('📅 Loading calendar entries for user: $userId');
      }

      // Load entries from Firestore
      final allEntries = await _firestoreService.getJournalEntries(userId);

      if (kDebugMode) {
        debugPrint('   Loaded ${allEntries.length} total entries');
      }

      // Filter entries for the current month
      final monthEntries = allEntries.where((entry) {
        return entry.createdAt.isAfter(startDate.subtract(const Duration(days: 1))) &&
               entry.createdAt.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();

      if (kDebugMode) {
        debugPrint('   ${monthEntries.length} entries in current month');
      }

      // Group entries by date
      final entriesByDate = _groupEntriesByDate(monthEntries);

      // Calculate statistics
      final stats = _calculateStatistics(allEntries, month);

      state = state.copyWith(
        entriesByDate: entriesByDate,
        isLoading: false,
        currentStreak: stats.streak,
        monthlyCompletionRate: stats.completionRate,
        mostFrequentMood: stats.mostFrequentMood,
        totalEntriesThisMonth: stats.totalEntries,
      );

      if (kDebugMode) {
        debugPrint('   ✅ Calendar loaded - ${entriesByDate.length} days with entries');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('   ❌ Failed to load calendar: $e');
      }
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load entries: $e',
      );
    }
  }

  Map<DateTime, List<JournalEntry>> _groupEntriesByDate(List<JournalEntry> entries) {
    final Map<DateTime, List<JournalEntry>> grouped = {};
    
    for (final entry in entries) {
      final dateKey = DateTime(entry.createdAt.year, entry.createdAt.month, entry.createdAt.day);
      if (grouped[dateKey] == null) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(entry);
    }

    // Sort entries within each day by creation time (newest first)
    for (final entries in grouped.values) {
      entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return grouped;
  }

  CalendarStatistics _calculateStatistics(List<JournalEntry> allEntries, DateTime month) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Calculate current streak
    int streak = 0;
    DateTime checkDate = today;
    
    while (true) {
      final hasEntry = allEntries.any((entry) {
        final entryDate = DateTime(entry.createdAt.year, entry.createdAt.month, entry.createdAt.day);
        return entryDate.isAtSameMomentAs(checkDate);
      });
      
      if (hasEntry) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    // Calculate monthly completion rate
    final monthStart = DateTime(month.year, month.month, 1);
    final monthEnd = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = monthEnd.day;
    
    final monthEntries = allEntries.where((entry) {
      return entry.createdAt.isAfter(monthStart.subtract(const Duration(days: 1))) &&
             entry.createdAt.isBefore(monthEnd.add(const Duration(days: 1)));
    }).toList();

    final uniqueDaysWithEntries = monthEntries.map((entry) {
      return DateTime(entry.createdAt.year, entry.createdAt.month, entry.createdAt.day);
    }).toSet().length;

    final completionRate = uniqueDaysWithEntries / daysInMonth;

    // Find most frequent mood this month
    final moodCounts = <String, int>{};
    for (final entry in monthEntries) {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
    }
    
    String? mostFrequentMood;
    int maxCount = 0;
    for (final entry in moodCounts.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        mostFrequentMood = entry.key;
      }
    }

    return CalendarStatistics(
      streak: streak,
      completionRate: completionRate,
      mostFrequentMood: mostFrequentMood,
      totalEntries: monthEntries.length,
    );
  }

  Future<void> refreshCurrentMonth() async {
    await _loadEntriesForMonth(state.currentMonth);
  }
}

class CalendarStatistics {
  final int streak;
  final double completionRate;
  final String? mostFrequentMood;
  final int totalEntries;

  const CalendarStatistics({
    required this.streak,
    required this.completionRate,
    this.mostFrequentMood,
    required this.totalEntries,
  });
}

final calendarProvider = StateNotifierProvider<CalendarNotifier, CalendarState>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return CalendarNotifier(firestoreService, ref);
});