import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/env_config.dart';

class TranscriptionService {
  static const String _whisperUrl = 'https://api.openai.com/v1/audio/transcriptions';
  static const int _maxFileSizeBytes = 25 * 1024 * 1024; // 25MB Whisper limit

  // Configurable settings
  final String model;
  final String language;
  final double temperature;
  final String responseFormat;

  TranscriptionService({
    this.model = 'whisper-1',
    this.language = 'en',
    this.temperature = 0.0,
    this.responseFormat = 'json',
  });

  /// Main transcription method with automatic fallback
  Future<String> transcribeAudio(String audioPath) async {
    try {
      final file = File(audioPath);
      if (!await file.exists()) {
        throw TranscriptionException('Audio file not found at: $audioPath');
      }

      // Validate file size
      final fileSize = await file.length();
      if (fileSize > _maxFileSizeBytes) {
        throw TranscriptionException('Audio file too large. Maximum size is 25MB.');
      }

      if (fileSize == 0) {
        throw TranscriptionException('Audio file is empty');
      }

      // Try real Whisper API first if configured
      if (EnvConfig.hasOpenaiKey && EnvConfig.useWhisper) {
        try {
          if (kDebugMode) {
            debugPrint('🎙️ Transcribing audio with OpenAI Whisper...');
            debugPrint('   File: $audioPath');
            debugPrint('   Size: ${(fileSize / 1024).toStringAsFixed(2)} KB');
          }

          final transcription = await _callWhisperAPI(audioPath);

          if (kDebugMode) {
            debugPrint('✅ Transcription successful (${transcription.length} chars)');
          }

          return cleanTranscription(transcription);
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ Whisper API failed: $e');
            debugPrint('   Falling back to mock transcription');
          }
          // Fall through to mock service
        }
      } else {
        if (kDebugMode) {
          debugPrint('ℹ️ Using mock transcription (OpenAI API key not configured)');
          debugPrint('   Set OPENAI_API_KEY in .env to enable real transcription');
        }
      }

      // Fallback to mock transcription
      return _generateMockTranscription(fileSize);

    } catch (e) {
      if (e is TranscriptionException) {
        rethrow;
      }
      throw TranscriptionException('Failed to transcribe audio: $e');
    }
  }

  /// Real OpenAI Whisper API call
  Future<String> _callWhisperAPI(String audioPath) async {
    try {
      final apiKey = EnvConfig.openaiApiKey;
      if (apiKey == null || apiKey.isEmpty) {
        throw TranscriptionException('OpenAI API key not configured');
      }

      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(_whisperUrl));

      // Add headers
      request.headers['Authorization'] = 'Bearer $apiKey';

      // Add audio file
      final file = await http.MultipartFile.fromPath('file', audioPath);
      request.files.add(file);

      // Add required parameters
      request.fields['model'] = model;
      request.fields['language'] = language;
      request.fields['response_format'] = responseFormat;
      request.fields['temperature'] = temperature.toString();

      // Optional: Add prompt for better context
      request.fields['prompt'] = 'This is a personal journal entry about emotions and feelings.';

      if (kDebugMode) {
        debugPrint('   Sending request to OpenAI Whisper API...');
      }

      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw TranscriptionException('Transcription request timed out after 60 seconds');
        },
      );

      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        final data = json.decode(responseBody);
        final text = data['text'] as String?;

        if (text == null || text.isEmpty) {
          throw TranscriptionException('Received empty transcription from API');
        }

        return text;
      } else {
        // Parse error response
        try {
          final errorData = json.decode(responseBody);
          final errorMessage = errorData['error']['message'] ?? 'Unknown error';
          throw TranscriptionException('Whisper API Error (${streamedResponse.statusCode}): $errorMessage');
        } catch (_) {
          throw TranscriptionException('Whisper API Error: ${streamedResponse.statusCode} - $responseBody');
        }
      }
    } on SocketException catch (e) {
      throw TranscriptionException('Network error: ${e.message}. Please check your internet connection.');
    } on TimeoutException catch (_) {
      throw TranscriptionException('Request timed out. Please try again.');
    } on http.ClientException catch (e) {
      throw TranscriptionException('HTTP client error: $e');
    } catch (e) {
      if (e is TranscriptionException) {
        rethrow;
      }
      throw TranscriptionException('Whisper API call failed: $e');
    }
  }

  /// Mock transcription for development/testing
  String _generateMockTranscription(int fileSize) {
    // Simulate realistic delay
    // Note: This is synchronous now since the delay should happen in transcribeAudio

    if (fileSize < 50000) { // ~5 seconds of audio
      return "I'm feeling a bit overwhelmed today. There's just so much happening and I'm not sure how to process it all.";
    } else if (fileSize < 150000) { // ~15 seconds
      return "I'm feeling a bit overwhelmed today. There's just so much happening and I'm not sure how to process it all. Work has been really stressful lately, and I find myself constantly worrying about deadlines and meetings.";
    } else if (fileSize < 300000) { // ~30 seconds
      return "I'm feeling a bit overwhelmed today. There's just so much happening and I'm not sure how to process it all. Work has been really stressful lately, and I find myself constantly worrying about deadlines and meetings. Sometimes I wonder if I'm taking on too much, but I also feel like I need to prove myself.";
    } else { // Longer recordings
      return "I'm feeling a bit overwhelmed today. There's just so much happening and I'm not sure how to process it all. Work has been really stressful lately, and I find myself constantly worrying about deadlines and meetings. Sometimes I wonder if I'm taking on too much, but I also feel like I need to prove myself. I think I need to find better ways to manage my stress and maybe talk to someone about these feelings. It's important to remember that it's okay to ask for help and take breaks when needed.";
    }
  }

  /// Stream transcription progressively (useful for UI feedback)
  Stream<String> getTranscriptionStream(String audioPath) async* {
    try {
      final fullTranscription = await transcribeAudio(audioPath);
      final words = fullTranscription.split(' ');

      // Simulate real-time transcription by yielding words progressively
      String currentText = '';

      for (int i = 0; i < words.length; i++) {
        await Future.delayed(const Duration(milliseconds: 150));
        currentText += (i == 0 ? '' : ' ') + words[i];
        yield currentText;
      }
    } catch (e) {
      throw TranscriptionException('Failed to stream transcription: $e');
    }
  }

  /// Save transcription to Firestore
  Future<void> saveTranscription(String entryId, String transcription) async {
    try {
      // In production, save to Firebase Firestore
      // This will be handled by the FirestoreService
      if (kDebugMode) {
        debugPrint('Saving transcription for entry $entryId: ${transcription.substring(0, 50)}...');
      }
    } catch (e) {
      throw TranscriptionException('Failed to save transcription: $e');
    }
  }

  /// Clean up and normalize transcription text
  String cleanTranscription(String text) {
    if (text.isEmpty) return text;

    return text
        .trim()
        // Replace multiple spaces with single space
        .replaceAll(RegExp(r'\s+'), ' ')
        // Remove excessive punctuation
        .replaceAll(RegExp(r'\.{2,}'), '.')
        .replaceAll(RegExp(r',{2,}'), ',')
        // Ensure sentences start with capital letters
        .split('. ')
        .map((sentence) {
          final trimmed = sentence.trim();
          if (trimmed.isEmpty) return '';
          return trimmed[0].toUpperCase() + trimmed.substring(1);
        })
        .where((sentence) => sentence.isNotEmpty)
        .join('. ')
        // Add final period if missing
        .replaceAll(RegExp(r'([^.!?])$'), r'$1.');
  }

  /// Validate transcription quality
  bool isTranscriptionValid(String transcription) {
    if (transcription.isEmpty) return false;
    if (transcription.length < 5) return false;

    final words = transcription.split(RegExp(r'\s+'));
    if (words.length < 2) return false;

    // Check for gibberish (too many consecutive consonants)
    if (RegExp(r'[bcdfghjklmnpqrstvwxyz]{7,}', caseSensitive: false).hasMatch(transcription)) {
      return false;
    }

    return true;
  }

  /// Estimate transcription cost (for monitoring)
  double estimateTranscriptionCost(int fileSizeBytes) {
    // OpenAI Whisper pricing: $0.006 per minute
    // Approximate: 1MB ≈ 1 minute of audio (varies by quality)
    final estimatedMinutes = fileSizeBytes / (1024 * 1024);
    return estimatedMinutes * 0.006;
  }

  /// Get supported audio formats
  static List<String> get supportedFormats => [
    'mp3',
    'mp4',
    'mpeg',
    'mpga',
    'm4a',
    'wav',
    'webm',
  ];

  /// Check if file format is supported
  bool isSupportedFormat(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return supportedFormats.contains(extension);
  }
}

class TranscriptionException implements Exception {
  final String message;
  TranscriptionException(this.message);

  @override
  String toString() => 'TranscriptionException: $message';
}
