import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/journal_entry.dart';
import '../models/ai_analysis.dart';
import '../services/voice_recording_service.dart';
import '../services/transcription_service.dart';
import '../services/ai_analysis_service.dart';
import 'auth_provider.dart';
import 'firestore_provider.dart';

// Service providers
final voiceRecordingServiceProvider = Provider<VoiceRecordingService>((ref) {
  return VoiceRecordingService();
});

// Amplitude stream provider for waveform visualization
final amplitudeStreamProvider = StreamProvider<double>((ref) async* {
  final recordingService = ref.watch(voiceRecordingServiceProvider);
  await for (final levels in recordingService.audioLevels) {
    // Get the average amplitude from the levels
    if (levels.isNotEmpty) {
      final average = levels.reduce((a, b) => a + b) / levels.length;
      yield average;
    } else {
      yield 0.0;
    }
  }
});

final transcriptionServiceProvider = Provider<TranscriptionService>((ref) {
  return TranscriptionService();
});

final aiAnalysisServiceProvider = Provider<AIAnalysisService>((ref) {
  return AIAnalysisService();
});

// Voice Journal State
class VoiceJournalState {
  final bool isRecording;
  final bool isPaused;
  final Duration recordingDuration;
  final String? currentRecordingPath;
  final String transcription;
  final bool isTranscribing;
  final AIAnalysis? aiAnalysis;
  final bool isAnalyzing;
  final String? error;
  final JournalEntry? currentEntry;
  final bool isSaving;
  final VoiceJournalStep currentStep;
  final String selectedMood;
  final String inputMethod; // 'voice' or 'text'
  final bool shouldNavigateToCalendar;

  const VoiceJournalState({
    this.isRecording = false,
    this.isPaused = false,
    this.recordingDuration = Duration.zero,
    this.currentRecordingPath,
    this.transcription = '',
    this.isTranscribing = false,
    this.aiAnalysis,
    this.isAnalyzing = false,
    this.error,
    this.currentEntry,
    this.isSaving = false,
    this.currentStep = VoiceJournalStep.moodSelection,
    this.selectedMood = '',
    this.inputMethod = 'voice',
    this.shouldNavigateToCalendar = false,
  });

  VoiceJournalState copyWith({
    bool? isRecording,
    bool? isPaused,
    Duration? recordingDuration,
    String? currentRecordingPath,
    String? transcription,
    bool? isTranscribing,
    AIAnalysis? aiAnalysis,
    bool? isAnalyzing,
    String? error,
    JournalEntry? currentEntry,
    bool? isSaving,
    VoiceJournalStep? currentStep,
    String? selectedMood,
    String? inputMethod,
    bool? shouldNavigateToCalendar,
    bool clearError = false,
    bool clearAnalysis = false,
    bool clearEntry = false,
  }) {
    return VoiceJournalState(
      isRecording: isRecording ?? this.isRecording,
      isPaused: isPaused ?? this.isPaused,
      recordingDuration: recordingDuration ?? this.recordingDuration,
      currentRecordingPath: currentRecordingPath ?? this.currentRecordingPath,
      transcription: transcription ?? this.transcription,
      isTranscribing: isTranscribing ?? this.isTranscribing,
      aiAnalysis: clearAnalysis ? null : (aiAnalysis ?? this.aiAnalysis),
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      error: clearError ? null : (error ?? this.error),
      currentEntry: clearEntry ? null : (currentEntry ?? this.currentEntry),
      isSaving: isSaving ?? this.isSaving,
      currentStep: currentStep ?? this.currentStep,
      selectedMood: selectedMood ?? this.selectedMood,
      inputMethod: inputMethod ?? this.inputMethod,
      shouldNavigateToCalendar: shouldNavigateToCalendar ?? this.shouldNavigateToCalendar,
    );
  }

  bool get hasRecording => currentRecordingPath != null;
  bool get hasTranscription => transcription.isNotEmpty;
  bool get hasAnalysis => aiAnalysis != null;
  bool get canSave => hasRecording && hasTranscription && selectedMood.isNotEmpty;
  bool get isProcessing => isTranscribing || isAnalyzing || isSaving;
}

enum VoiceJournalStep {
  moodSelection,
  journaling,
  review,
  completed,
}

// Voice Journal Provider
class VoiceJournalNotifier extends StateNotifier<VoiceJournalState> {
  final VoiceRecordingService _recordingService;
  final TranscriptionService _transcriptionService;
  final AIAnalysisService _aiService;
  final Ref _ref;

  VoiceJournalNotifier(
    this._recordingService,
    this._transcriptionService,
    this._aiService,
    this._ref,
  ) : super(const VoiceJournalState(currentStep: VoiceJournalStep.moodSelection)) {
    _setupListeners();
  }

  void _setupListeners() {
    // Listen to recording service streams
    _recordingService.isRecording.listen((isRecording) {
      state = state.copyWith(isRecording: isRecording);
    });

    _recordingService.recordingDuration.listen((duration) {
      state = state.copyWith(recordingDuration: duration);
    });

    _recordingService.recordingState.listen((recordingState) {
      state = state.copyWith(
        isRecording: recordingState == RecordingState.recording,
        isPaused: recordingState == RecordingState.paused,
      );
    });
  }

  // Mood Selection
  void selectMood(String mood) {
    state = state.copyWith(
      selectedMood: mood,
      clearError: true,
    );
    // Automatically move to journaling step after mood selection
    if (state.currentStep == VoiceJournalStep.moodSelection) {
      state = state.copyWith(currentStep: VoiceJournalStep.journaling);
    }
  }

  // Recording Methods
  Future<void> startRecording() async {
    try {
      state = state.copyWith(clearError: true);
      await _recordingService.startRecording();
      state = state.copyWith(
        isRecording: true,
      );
    } catch (e) {
      state = state.copyWith(
        error: _getErrorMessage(e),
        isRecording: false,
      );
    }
  }

  Future<void> stopRecording() async {
    try {
      await _recordingService.stopRecording();
      final recordingPath = await _recordingService.getRecordingPath();

      state = state.copyWith(
        isRecording: false,
        currentRecordingPath: recordingPath,
      );

      // Start transcription automatically
      if (recordingPath != null) {
        await _startTranscription(recordingPath);
      }
    } catch (e) {
      state = state.copyWith(
        error: _getErrorMessage(e),
        isRecording: false,
      );
    }
  }

  Future<void> pauseRecording() async {
    try {
      await _recordingService.pauseRecording();
      state = state.copyWith(isPaused: true);
    } catch (e) {
      state = state.copyWith(error: _getErrorMessage(e));
    }
  }

  Future<void> resumeRecording() async {
    try {
      await _recordingService.resumeRecording();
      state = state.copyWith(isPaused: false);
    } catch (e) {
      state = state.copyWith(error: _getErrorMessage(e));
    }
  }

  Future<void> deleteRecording() async {
    try {
      await _recordingService.deleteRecording();
      state = state.copyWith(
        currentRecordingPath: null,
        transcription: '',
        clearAnalysis: true,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(error: _getErrorMessage(e));
    }
  }

  // Transcription Methods
  Future<void> _startTranscription(String audioPath) async {
    try {
      state = state.copyWith(isTranscribing: true, clearError: true);

      final transcription = await _transcriptionService.transcribeAudio(audioPath);

      state = state.copyWith(
        transcription: transcription,
        isTranscribing: false,
      );

    } catch (e) {
      state = state.copyWith(
        error: _getErrorMessage(e),
        isTranscribing: false,
      );
    }
  }

  void updateTranscription(String newTranscription) {
    state = state.copyWith(
      transcription: newTranscription,
      clearAnalysis: true, // Clear analysis when transcription changes
    );
  }

  void setInputMethod(String method) {
    state = state.copyWith(
      inputMethod: method,
      clearError: true,
    );
  }

  void clearNavigationFlag() {
    state = state.copyWith(shouldNavigateToCalendar: false);
  }

  Future<void> retranscribe() async {
    if (state.currentRecordingPath != null) {
      await _startTranscription(state.currentRecordingPath!);
    }
  }

  // AI Analysis Methods
  Future<void> _startAIAnalysis(String text) async {
    try {
      state = state.copyWith(isAnalyzing: true, clearError: true);

      // Pass selected mood to AI analysis for better context
      final analysis = await _aiService.analyzeEmotion(
        text,
        mood: state.selectedMood.isNotEmpty ? state.selectedMood : null,
      );

      state = state.copyWith(
        aiAnalysis: analysis,
        isAnalyzing: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: _getErrorMessage(e),
        isAnalyzing: false,
      );
    }
  }

  Future<void> regenerateAnalysis() async {
    if (state.transcription.isNotEmpty) {
      await _startAIAnalysis(state.transcription);
    }
  }

  // Save Entry
  Future<void> saveEntry() async {
    try {
      if (!state.canSave) {
        state = state.copyWith(error: 'Cannot save incomplete entry');
        return;
      }

      // Check if user is authenticated
      final authState = _ref.read(authStateProvider);
      if (authState.user == null) {
        state = state.copyWith(error: 'Please sign in to save your journal entry');
        return;
      }

      state = state.copyWith(isSaving: true, clearError: true);

      // Get Firestore service
      final firestoreService = _ref.read(firestoreServiceProvider);
      final userId = authState.user!.id;

      // Create entry with temporary ID
      final tempEntry = JournalEntry(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        mood: state.selectedMood,
        localAudioPath: state.currentRecordingPath,
        transcription: state.transcription,
        aiAnalysis: state.aiAnalysis,
        createdAt: DateTime.now(),
        recordingDuration: state.recordingDuration,
        isPrivate: true,
        isSynced: false,
      );

      // Save entry to Firestore first (gets back entryId)
      final entryId = await firestoreService.saveJournalEntry(tempEntry);

      // Upload audio to Firebase Storage if recording exists
      String? cloudAudioPath;
      if (state.currentRecordingPath != null) {
        try {
          cloudAudioPath = await firestoreService.uploadAudioFile(
            state.currentRecordingPath!,
            userId,
            entryId,
          );

          // Update Firestore entry with cloud audio path
          final updatedEntry = tempEntry.copyWith(
            id: entryId,
            audioPath: cloudAudioPath,
            isSynced: true,
          );

          await firestoreService.saveJournalEntry(updatedEntry);
        } catch (uploadError) {
          // Audio upload failed, but entry is still saved
          if (kDebugMode) {
            debugPrint('⚠️ Audio upload failed: $uploadError');
          }
          // Continue without audio - entry is still saved
        }
      }

      // Create the final saved entry
      final savedEntry = tempEntry.copyWith(
        id: entryId,
        audioPath: cloudAudioPath,
        isSynced: cloudAudioPath != null,
      );

      // Reload calendar data to show new entry
      final journalOperations = _ref.read(journalOperationsProvider.notifier);
      await journalOperations.loadEntries(userId);

      state = state.copyWith(
        currentEntry: savedEntry,
        isSaving: false,
        currentStep: VoiceJournalStep.completed,
        shouldNavigateToCalendar: true,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Save entry error: $e');
      }
      state = state.copyWith(
        error: _getErrorMessage(e),
        isSaving: false,
      );
    }
  }

  // Navigation and Reset
  void goToStep(VoiceJournalStep step) {
    state = state.copyWith(currentStep: step, clearError: true);
  }

  void goBack() {
    final currentStepIndex = VoiceJournalStep.values.indexOf(state.currentStep);
    if (currentStepIndex > 0) {
      final previousStep = VoiceJournalStep.values[currentStepIndex - 1];
      state = state.copyWith(currentStep: previousStep, clearError: true);
    }
  }

  void startNewEntry() {
    // Clean up current recording if any
    if (state.currentRecordingPath != null) {
      _recordingService.deleteRecording();
    }

    state = const VoiceJournalState(currentStep: VoiceJournalStep.moodSelection);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('permission')) {
      return 'Microphone permission is needed to record your voice. Please allow access in settings.';
    } else if (error.toString().contains('transcription')) {
      return 'Unable to transcribe your recording right now. You can edit the text manually or try again.';
    } else if (error.toString().contains('analysis')) {
      return 'AI analysis is temporarily unavailable. You can still save your entry.';
    } else {
      return 'Something went wrong. Let\'s try again in a moment.';
    }
  }

  @override
  void dispose() {
    _recordingService.dispose();
    super.dispose();
  }
}

// Main provider
final voiceJournalProvider = StateNotifierProvider<VoiceJournalNotifier, VoiceJournalState>((ref) {
  return VoiceJournalNotifier(
    ref.read(voiceRecordingServiceProvider),
    ref.read(transcriptionServiceProvider),
    ref.read(aiAnalysisServiceProvider),
    ref,
  );
});

// Derived providers for specific UI needs
final canStartRecordingProvider = Provider<bool>((ref) {
  final state = ref.watch(voiceJournalProvider);
  return !state.isRecording && !state.isProcessing && state.selectedMood.isNotEmpty;
});

final canSaveEntryProvider = Provider<bool>((ref) {
  final state = ref.watch(voiceJournalProvider);
  return state.canSave && !state.isProcessing;
});

final recordingProgressProvider = Provider<String>((ref) {
  final duration = ref.watch(voiceJournalProvider).recordingDuration;
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
});