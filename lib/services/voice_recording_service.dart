import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecordingService {
  final AudioRecorder _recorder = AudioRecorder();
  Timer? _timer;
  Duration _recordingDuration = Duration.zero;
  
  // Stream controllers
  final StreamController<Duration> _durationController = StreamController<Duration>.broadcast();
  final StreamController<bool> _isRecordingController = StreamController<bool>.broadcast();
  final StreamController<List<double>> _audioLevelsController = StreamController<List<double>>.broadcast();
  final StreamController<RecordingState> _stateController = StreamController<RecordingState>.broadcast();

  // State variables
  bool _isRecording = false;
  bool _isPaused = false;
  String? _currentRecordingPath;

  // Getters for streams
  Stream<Duration> get recordingDuration => _durationController.stream;
  Stream<bool> get isRecording => _isRecordingController.stream;
  Stream<List<double>> get audioLevels => _audioLevelsController.stream;
  Stream<RecordingState> get recordingState => _stateController.stream;

  // Current state getters
  bool get isCurrentlyRecording => _isRecording;
  bool get isCurrentlyPaused => _isPaused;
  Duration get currentDuration => _recordingDuration;
  String? get currentRecordingPath => _currentRecordingPath;

  Future<bool> checkPermissions() async {
    final permission = await Permission.microphone.status;
    
    if (permission == PermissionStatus.granted) {
      return true;
    }
    
    if (permission == PermissionStatus.denied) {
      final result = await Permission.microphone.request();
      return result == PermissionStatus.granted;
    }
    
    return false;
  }

  Future<void> startRecording() async {
    try {
      // Check permissions first
      final hasPermission = await checkPermissions();
      if (!hasPermission) {
        throw RecordingException('Microphone permission not granted');
      }

      // Generate unique file path
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentRecordingPath = '${directory.path}/recording_$timestamp.m4a';

      // Start recording
      await _recorder.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _currentRecordingPath!,
      );

      _isRecording = true;
      _isPaused = false;
      _recordingDuration = Duration.zero;

      // Start timer for duration tracking
      _startTimer();

      // Notify listeners
      _isRecordingController.add(true);
      _stateController.add(RecordingState.recording);

      // Start amplitude monitoring
      _startAmplitudeMonitoring();

    } catch (e) {
      throw RecordingException('Failed to start recording: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      if (!_isRecording) return;

      await _recorder.stop();
      
      _isRecording = false;
      _isPaused = false;
      _stopTimer();

      // Notify listeners
      _isRecordingController.add(false);
      _stateController.add(RecordingState.stopped);

    } catch (e) {
      throw RecordingException('Failed to stop recording: $e');
    }
  }

  Future<void> pauseRecording() async {
    try {
      if (!_isRecording || _isPaused) return;

      await _recorder.pause();
      _isPaused = true;
      _stopTimer();

      // Notify listeners
      _stateController.add(RecordingState.paused);

    } catch (e) {
      throw RecordingException('Failed to pause recording: $e');
    }
  }

  Future<void> resumeRecording() async {
    try {
      if (!_isRecording || !_isPaused) return;

      await _recorder.resume();
      _isPaused = false;
      _startTimer();

      // Notify listeners
      _stateController.add(RecordingState.recording);

    } catch (e) {
      throw RecordingException('Failed to resume recording: $e');
    }
  }

  Future<String?> getRecordingPath() async {
    if (_isRecording) {
      await stopRecording();
    }
    return _currentRecordingPath;
  }

  Future<void> deleteRecording([String? path]) async {
    try {
      final filePath = path ?? _currentRecordingPath;
      if (filePath != null) {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
      }
      
      if (path == null) {
        _currentRecordingPath = null;
      }
    } catch (e) {
      // Log error but don't throw - file might already be deleted
      debugPrint('Error deleting recording: $e');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _recordingDuration = Duration(milliseconds: _recordingDuration.inMilliseconds + 100);
      _durationController.add(_recordingDuration);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _startAmplitudeMonitoring() {
    // Simulate audio levels for waveform visualization
    // In a real implementation, you'd get actual amplitude data
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_isRecording || _isPaused) {
        timer.cancel();
        return;
      }

      // Generate mock audio levels (replace with real amplitude data)
      final levels = List.generate(10, (index) => 
        (0.1 + (0.9 * (index % 3 == 0 ? 0.8 : 0.3))));
      
      _audioLevelsController.add(levels);
    });
  }

  void dispose() {
    _timer?.cancel();
    _durationController.close();
    _isRecordingController.close();
    _audioLevelsController.close();
    _stateController.close();
    _recorder.dispose();
  }
}

enum RecordingState {
  idle,
  recording,
  paused,
  stopped,
}

class RecordingException implements Exception {
  final String message;
  RecordingException(this.message);
  
  @override
  String toString() => 'RecordingException: $message';
}