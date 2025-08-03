import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  static final FirebaseStorageService _instance = FirebaseStorageService._internal();
  factory FirebaseStorageService() => _instance;
  FirebaseStorageService._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload audio file to Firebase Storage
  /// Returns the download URL of the uploaded file
  Future<String> uploadAudioFile({
    required String filePath,
    required String userId,
    required String entryId,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Audio file does not exist: $filePath');
      }

      // Generate a unique file name
      final fileName = '${entryId}_${DateTime.now().millisecondsSinceEpoch}.m4a';
      final ref = _storage.ref().child('audio/$userId/$fileName');

      if (kDebugMode) {
        print('Uploading audio file: $fileName');
      }

      // Upload the file
      final uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: 'audio/mp4',
          customMetadata: {
            'userId': userId,
            'entryId': entryId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        if (kDebugMode) {
          print('Upload progress: ${progress.toStringAsFixed(1)}%');
        }
      });

      // Wait for upload to complete
      final snapshot = await uploadTask;
      
      // Get download URL
      final downloadURL = await snapshot.ref.getDownloadURL();
      
      if (kDebugMode) {
        print('Audio uploaded successfully: $downloadURL');
      }

      return downloadURL;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Firebase Storage error: ${e.code} - ${e.message}');
      }
      throw _handleStorageException(e);
    } catch (e) {
      if (kDebugMode) {
        print('Audio upload error: $e');
      }
      throw 'Failed to upload audio file: $e';
    }
  }

  /// Download audio file from Firebase Storage
  /// Returns the local file path where the audio is saved
  Future<String> downloadAudioFile({
    required String downloadUrl,
    required String localDirectory,
    required String fileName,
  }) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      final localFile = File('$localDirectory/$fileName');

      // Create directory if it doesn't exist
      await localFile.parent.create(recursive: true);

      if (kDebugMode) {
        print('Downloading audio file: $fileName');
      }

      // Download the file
      final downloadTask = ref.writeToFile(localFile);
      
      // Monitor download progress
      downloadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        if (kDebugMode) {
          print('Download progress: ${progress.toStringAsFixed(1)}%');
        }
      });

      await downloadTask;
      
      if (kDebugMode) {
        print('Audio downloaded successfully: ${localFile.path}');
      }

      return localFile.path;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Firebase Storage download error: ${e.code} - ${e.message}');
      }
      throw _handleStorageException(e);
    } catch (e) {
      if (kDebugMode) {
        print('Audio download error: $e');
      }
      throw 'Failed to download audio file: $e';
    }
  }

  /// Delete audio file from Firebase Storage
  Future<void> deleteAudioFile(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
      
      if (kDebugMode) {
        print('Audio file deleted successfully: $downloadUrl');
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Firebase Storage delete error: ${e.code} - ${e.message}');
      }
      throw _handleStorageException(e);
    } catch (e) {
      if (kDebugMode) {
        print('Audio delete error: $e');
      }
      throw 'Failed to delete audio file: $e';
    }
  }

  /// Get metadata for an audio file
  Future<FullMetadata> getAudioFileMetadata(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      return await ref.getMetadata();
    } on FirebaseException catch (e) {
      throw _handleStorageException(e);
    }
  }

  /// List all audio files for a user
  Future<List<Reference>> listUserAudioFiles(String userId) async {
    try {
      final ref = _storage.ref().child('audio/$userId');
      final result = await ref.listAll();
      return result.items;
    } on FirebaseException catch (e) {
      throw _handleStorageException(e);
    }
  }

  /// Get the size of an audio file
  Future<int> getAudioFileSize(String downloadUrl) async {
    try {
      final metadata = await getAudioFileMetadata(downloadUrl);
      return metadata.size ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Check if audio file exists
  Future<bool> audioFileExists(String downloadUrl) async {
    try {
      await getAudioFileMetadata(downloadUrl);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Generate a presigned URL for audio playback (if needed for security)
  Future<String> generatePresignedUrl(
    String downloadUrl, {
    Duration expiration = const Duration(hours: 1),
  }) async {
    try {
      // Note: Firebase Storage doesn't support presigned URLs like AWS S3
      // But we can return the download URL with some validation
      return downloadUrl;
    } catch (e) {
      throw 'Failed to generate presigned URL: $e';
    }
  }

  /// Clean up old audio files (older than specified duration)
  Future<void> cleanupOldAudioFiles({
    required String userId,
    Duration maxAge = const Duration(days: 90),
  }) async {
    try {
      final files = await listUserAudioFiles(userId);
      final cutoffDate = DateTime.now().subtract(maxAge);

      for (final file in files) {
        try {
          final metadata = await file.getMetadata();
          final createdTime = metadata.timeCreated;
          
          if (createdTime != null && createdTime.isBefore(cutoffDate)) {
            await file.delete();
            if (kDebugMode) {
              print('Deleted old audio file: ${file.name}');
            }
          }
        } catch (e) {
          // Skip files that can't be processed
          if (kDebugMode) {
            print('Error processing file ${file.name}: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Cleanup error: $e');
      }
      // Don't throw error for cleanup operations
    }
  }

  /// Calculate total storage used by a user
  Future<int> calculateUserStorageUsage(String userId) async {
    try {
      final files = await listUserAudioFiles(userId);
      int totalSize = 0;

      for (final file in files) {
        try {
          final metadata = await file.getMetadata();
          totalSize += (metadata.size ?? 0);
        } catch (e) {
          // Skip files that can't be processed
        }
      }

      return totalSize;
    } catch (e) {
      if (kDebugMode) {
        print('Storage calculation error: $e');
      }
      return 0;
    }
  }

  String _handleStorageException(FirebaseException e) {
    switch (e.code) {
      case 'object-not-found':
        return 'Audio file not found.';
      case 'unauthorized':
        return 'You don\'t have permission to access this audio file.';
      case 'canceled':
        return 'Audio operation was cancelled.';
      case 'unknown':
        return 'An unknown error occurred with the audio file.';
      case 'invalid-checksum':
        return 'Audio file upload failed due to checksum mismatch.';
      case 'retry-limit-exceeded':
        return 'Audio operation failed after multiple retries.';
      case 'invalid-event-name':
        return 'Invalid audio operation requested.';
      case 'invalid-url':
        return 'Invalid audio file URL.';
      case 'invalid-argument':
        return 'Invalid argument provided for audio operation.';
      case 'no-default-bucket':
        return 'No default storage bucket configured.';
      case 'cannot-slice-blob':
        return 'Cannot process audio file blob.';
      case 'server-file-wrong-size':
        return 'Audio file size mismatch on server.';
      default:
        return e.message ?? 'An error occurred with the audio file operation.';
    }
  }


  /// Validate audio file before upload
  Future<bool> validateAudioFile(String filePath) async {
    try {
      final file = File(filePath);
      
      // Check if file exists
      if (!await file.exists()) {
        return false;
      }

      // Check file size (limit to 50MB)
      final fileSize = await file.length();
      if (fileSize > 50 * 1024 * 1024) {
        throw 'Audio file is too large. Maximum size is 50MB.';
      }

      // Check file extension
      final extension = filePath.toLowerCase().split('.').last;
      const allowedExtensions = ['m4a', 'mp3', 'wav', 'aac'];
      if (!allowedExtensions.contains(extension)) {
        throw 'Unsupported audio format. Supported formats: .${allowedExtensions.join(', .')}';
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Audio validation error: $e');
      }
      rethrow;
    }
  }
}