import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/journal_entry.dart';
import '../services/affirmation_service.dart';
import 'firestore_provider.dart';
import 'auth_provider.dart';

class AffirmationState {
  final String? affirmation;
  final bool isLoading;
  final String? error;
  final JournalEntry? lastEntry;

  const AffirmationState({
    this.affirmation,
    this.isLoading = false,
    this.error,
    this.lastEntry,
  });

  AffirmationState copyWith({
    String? affirmation,
    bool? isLoading,
    String? error,
    JournalEntry? lastEntry,
    bool clearError = false,
  }) {
    return AffirmationState(
      affirmation: affirmation ?? this.affirmation,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      lastEntry: lastEntry ?? this.lastEntry,
    );
  }
}

class AffirmationNotifier extends StateNotifier<AffirmationState> {
  final AffirmationService _affirmationService;
  final FirestoreService _firestoreService;
  final Ref _ref;

  AffirmationNotifier(
    this._affirmationService,
    this._firestoreService,
    this._ref,
  ) : super(const AffirmationState());

  Future<void> loadTodaysAffirmation() async {
    try {
      state = state.copyWith(isLoading: true, clearError: true);

      // Get current user
      final authState = _ref.read(authStateProvider);
      if (!authState.isAuthenticated || authState.user == null) {
        throw Exception('User not authenticated');
      }

      final userId = authState.user!.id;
      
      // Try to get entries, but handle Firestore not being available (e.g., on web)
      List<JournalEntry>? entries;
      try {
        entries = await _firestoreService.getJournalEntries(userId);
      } catch (firestoreError) {
        // Firestore not available (likely on web without proper config)
        // Use empty list for demo purposes
        entries = [];
      }
      
      // Find the most recent entry from yesterday or earlier
      JournalEntry? lastEntry;
      for (final entry in entries) {
        if (entry.createdAt.isBefore(DateTime.now().subtract(const Duration(hours: 6)))) {
          lastEntry = entry;
          break; // entries are already sorted by creation time (newest first)
        }
      }

      // Generate affirmation based on last entry
      final affirmation = await _affirmationService.generateAffirmationFromEntry(lastEntry);

      state = state.copyWith(
        affirmation: affirmation,
        lastEntry: lastEntry,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load affirmation: $e',
      );
    }
  }

  void clearAffirmation() {
    state = const AffirmationState();
  }
}

// Providers
final affirmationServiceProvider = Provider<AffirmationService>((ref) {
  return AffirmationService();
});

final affirmationProvider = StateNotifierProvider<AffirmationNotifier, AffirmationState>((ref) {
  final affirmationService = ref.watch(affirmationServiceProvider);
  final firestoreService = ref.watch(firestoreServiceProvider);
  return AffirmationNotifier(affirmationService, firestoreService, ref);
});