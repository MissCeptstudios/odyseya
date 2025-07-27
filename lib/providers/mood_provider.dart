import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mood.dart';

class MoodState {
  final Mood? selectedMood;
  final bool isSelecting;
  final String? error;

  const MoodState({this.selectedMood, this.isSelecting = false, this.error});

  MoodState copyWith({
    Mood? selectedMood,
    bool? isSelecting,
    String? error,
    bool clearError = false,
    bool clearMood = false,
  }) {
    return MoodState(
      selectedMood: clearMood ? null : (selectedMood ?? this.selectedMood),
      isSelecting: isSelecting ?? this.isSelecting,
      error: clearError ? null : (error ?? this.error),
    );
  }

  bool get hasMood => selectedMood != null;
}

class MoodNotifier extends StateNotifier<MoodState> {
  MoodNotifier() : super(const MoodState()) {
    // Initializing MoodNotifier
  }

  void selectMood(Mood mood) {
    // Selecting mood: ${mood.label}
    state = state.copyWith(
      selectedMood: mood,
      isSelecting: false,
      clearError: true,
    );
  }

  void startSelection() {
    // Starting mood selection
    state = state.copyWith(isSelecting: true, clearError: true);
  }

  void cancelSelection() {
    // Canceling mood selection
    state = state.copyWith(isSelecting: false, clearError: true);
  }

  void clearMood() {
    // Clearing selected mood
    state = state.copyWith(clearMood: true, clearError: true);
  }
}

final moodProvider = StateNotifierProvider<MoodNotifier, MoodState>((ref) {
  return MoodNotifier();
});
