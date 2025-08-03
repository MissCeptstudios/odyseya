import 'dart:async';
import 'dart:io';

class TranscriptionService {
  static const String _baseUrl = 'https://api.openai.com/v1/audio/transcriptions';
  
  // Mock API key - in production, use environment variables or secure storage
  static const String _apiKey = 'your-openai-api-key';

  Future<String> transcribeAudio(String audioPath) async {
    try {
      // For MVP, we'll use a mock transcription service
      // In production, integrate with OpenAI Whisper or similar service
      
      final file = File(audioPath);
      if (!await file.exists()) {
        throw TranscriptionException('Audio file not found');
      }

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock transcription based on file size/duration
      final fileSize = await file.length();
      
      if (fileSize < 1000) {
        return "I'm feeling...";
      } else if (fileSize < 5000) {
        return "I'm feeling a bit overwhelmed today. There's just so much happening and I'm not sure how to process it all.";
      } else {
        return "I'm feeling a bit overwhelmed today. There's just so much happening and I'm not sure how to process it all. Work has been really stressful lately, and I find myself constantly worrying about deadlines and meetings. Sometimes I wonder if I'm taking on too much, but I also feel like I need to prove myself. I think I need to find better ways to manage my stress and maybe talk to someone about these feelings.";
      }

      // Real implementation would look like this:
      // return await _callWhisperAPI(audioPath);
      
    } catch (e) {
      throw TranscriptionException('Failed to transcribe audio: $e');
    }
  }

  Stream<String> getTranscriptionStream(String audioPath) async* {
    try {
      final fullTranscription = await transcribeAudio(audioPath);
      final words = fullTranscription.split(' ');
      
      // Simulate real-time transcription by yielding words progressively
      String currentText = '';
      
      for (int i = 0; i < words.length; i++) {
        await Future.delayed(const Duration(milliseconds: 200));
        currentText += (i == 0 ? '' : ' ') + words[i];
        yield currentText;
      }
    } catch (e) {
      throw TranscriptionException('Failed to stream transcription: $e');
    }
  }

  /* Unused method - commented out to fix warning
  Future<String> _callWhisperAPI(String audioPath) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
      
      request.headers['Authorization'] = 'Bearer $_apiKey';
      request.files.add(await http.MultipartFile.fromPath('file', audioPath));
      request.fields['model'] = 'whisper-1';
      request.fields['language'] = 'en';
      request.fields['response_format'] = 'json';
      
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        return data['text'] ?? '';
      } else {
        throw TranscriptionException('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw TranscriptionException('API call failed: $e');
    }
  }
  */

  Future<void> saveTranscription(String entryId, String transcription) async {
    try {
      // In production, save to Firebase Firestore
      // For now, this is a placeholder
      print('Saving transcription for entry $entryId: $transcription');
    } catch (e) {
      throw TranscriptionException('Failed to save transcription: $e');
    }
  }

  // Helper method to clean up transcription text
  String cleanTranscription(String text) {
    return text
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ') // Replace multiple spaces with single space
        .replaceAll(RegExp(r'[^\w\s.,!?;:]'), '') // Remove special characters except basic punctuation
        .split('.')
        .map((sentence) => sentence.trim())
        .where((sentence) => sentence.isNotEmpty)
        .map((sentence) => sentence[0].toUpperCase() + sentence.substring(1))
        .join('. ');
  }

  // Validate transcription quality
  bool isTranscriptionValid(String transcription) {
    if (transcription.isEmpty) return false;
    if (transcription.length < 5) return false;
    if (transcription.split(' ').length < 2) return false;
    return true;
  }
}

class TranscriptionException implements Exception {
  final String message;
  TranscriptionException(this.message);
  
  @override
  String toString() => 'TranscriptionException: $message';
}