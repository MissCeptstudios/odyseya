# Transcription Service Setup Guide

## Overview

Odyseya uses OpenAI's Whisper API for high-quality voice-to-text transcription. This guide will help you set up and configure the transcription service.

## Features

### Real Whisper API Integration
- ✅ Automatic audio file validation (format, size)
- ✅ Intelligent error handling with fallback
- ✅ Support for 7 audio formats (mp3, m4a, wav, mp4, mpeg, mpga, webm)
- ✅ 25MB file size limit (OpenAI Whisper constraint)
- ✅ 60-second timeout protection
- ✅ Contextual prompt for better emotional content transcription
- ✅ Network error detection and user-friendly messages
- ✅ Cost estimation per transcription
- ✅ Mock transcription fallback for development

### Text Processing
- ✅ Automatic transcription cleaning and normalization
- ✅ Quality validation (gibberish detection)
- ✅ Proper capitalization and punctuation
- ✅ Sentence structure correction

---

## Setup Instructions

### 1. Get Your OpenAI API Key

1. Go to [OpenAI Platform](https://platform.openai.com/api-keys)
2. Sign in or create an account
3. Navigate to **API Keys** section
4. Click **Create new secret key**
5. Copy the key (starts with `sk-...`)
6. **Important:** Save this key securely - you won't see it again!

### 2. Configure Your Environment

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Open `.env` file and add your API key:
   ```env
   # OpenAI Configuration
   OPENAI_API_KEY=sk-your-actual-api-key-here

   # Enable Whisper transcription
   USE_WHISPER=true
   ```

3. **Never commit `.env` to git!** (Already in `.gitignore`)

### 3. Verify Configuration

Run the test script to verify everything is working:

```bash
dart run test_transcription.dart
```

Expected output:
```
🧪 Testing Transcription Service...

1️⃣ Initializing environment configuration...
   Configuration loaded:
   - OpenAI Key: ✅ Configured
   - Use Whisper: true

2️⃣ Creating transcription service...
   Service created successfully
   Supported formats: mp3, mp4, mpeg, mpga, m4a, wav, webm

3️⃣ Testing transcription validation...
   ✅ Tests passed

🎉 ALL TESTS PASSED!
```

---

## Usage in Your App

### Basic Transcription

```dart
import 'package:odyseya/services/transcription_service.dart';

// Create service instance
final transcriptionService = TranscriptionService();

// Transcribe audio file
try {
  final text = await transcriptionService.transcribeAudio('/path/to/audio.m4a');
  print('Transcription: $text');
} catch (e) {
  print('Error: $e');
}
```

### Streaming Transcription (Progressive Display)

```dart
// Display transcription word-by-word as it processes
await for (final partialText in transcriptionService.getTranscriptionStream(audioPath)) {
  setState(() {
    transcription = partialText;
  });
}
```

### Validate Audio File Before Upload

```dart
// Check if file format is supported
if (!transcriptionService.isSupportedFormat('/path/to/audio.txt')) {
  print('Unsupported format! Use: ${TranscriptionService.supportedFormats}');
}

// Estimate transcription cost
final fileSizeBytes = await File(audioPath).length();
final estimatedCost = transcriptionService.estimateTranscriptionCost(fileSizeBytes);
print('Estimated cost: \$${estimatedCost.toStringAsFixed(4)}');
```

### Clean Transcription Text

```dart
// Automatically clean and normalize text
final cleaned = transcriptionService.cleanTranscription(rawText);
```

---

## How It Works

### Automatic Fallback System

The service intelligently handles different scenarios:

```
┌─────────────────────────────────────┐
│  User records voice journal entry   │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│  Check: Is OpenAI API key set?      │
└────────┬───────────────┬────────────┘
         │ YES           │ NO
         ▼               ▼
    ┌────────────┐  ┌──────────────┐
    │ Call       │  │ Use Mock     │
    │ Whisper    │  │ Transcription│
    │ API        │  └──────────────┘
    └────┬───────┘
         │
         ▼
    ┌────────────┐
    │ API Success?│
    └────┬───┬───┘
         │YES│NO
         ▼   ▼
    ┌────────────┐
    │ Return     │
    │ Real Text  │
    └────────────┘
         │
         ▼
    ┌────────────────────┐
    │ Clean & Validate   │
    └────────────────────┘
```

### Error Handling

The service provides user-friendly error messages:

| Error Type | User Message |
|-----------|--------------|
| No API Key | "ℹ️ Using mock transcription (OpenAI API key not configured)" |
| Network Error | "Network error: Please check your internet connection." |
| Timeout | "Request timed out. Please try again." |
| File Too Large | "Audio file too large. Maximum size is 25MB." |
| Empty File | "Audio file is empty" |
| Invalid Format | TranscriptionException with specific format list |

---

## Pricing & Cost Management

### OpenAI Whisper Pricing
- **$0.006 per minute** of audio transcribed
- Example costs:
  - 5-second recording: ~$0.0005 (less than 1 cent)
  - 30-second recording: ~$0.003 (less than 1 cent)
  - 5-minute recording: ~$0.03 (3 cents)
  - 60-minute recording: ~$0.36 (36 cents)

### Cost Estimation

```dart
final service = TranscriptionService();
final fileSizeBytes = await File(audioPath).length();
final cost = service.estimateTranscriptionCost(fileSizeBytes);
print('This transcription will cost approximately: \$${cost.toStringAsFixed(4)}');
```

### Budget Recommendations

For a journaling app with typical usage:
- Average entry: 1-2 minutes
- Cost per entry: ~$0.006 - $0.012
- 100 users × 30 entries/month = **$18-36/month**
- 1,000 users × 30 entries/month = **$180-360/month**

**Tip:** Monitor usage via [OpenAI Usage Dashboard](https://platform.openai.com/usage)

---

## Advanced Configuration

### Custom Whisper Settings

```dart
// Create service with custom settings
final service = TranscriptionService(
  model: 'whisper-1',           // Model version
  language: 'en',               // Target language (auto-detected if not set)
  temperature: 0.0,             // 0.0 = more deterministic, 1.0 = more creative
  responseFormat: 'json',       // Response format (json, text, srt, vtt)
);
```

### Supported Languages

Whisper supports **99 languages** including:
- English (`en`)
- Spanish (`es`)
- French (`fr`)
- German (`de`)
- Italian (`it`)
- Portuguese (`pt`)
- Japanese (`ja`)
- Korean (`ko`)
- Chinese (`zh`)
- And many more!

**Auto-detection:** Set `language: 'auto'` for automatic language detection.

---

## Troubleshooting

### "OpenAI API key not configured"

**Problem:** Environment variable not loaded correctly.

**Solution:**
1. Check `.env` file exists in project root
2. Verify `OPENAI_API_KEY=sk-...` is set correctly
3. Restart your app/server after changing `.env`
4. Run `flutter clean && flutter pub get`

### "Network error"

**Problem:** No internet connection or firewall blocking OpenAI API.

**Solution:**
1. Check internet connection
2. Try accessing `https://api.openai.com` in browser
3. Check corporate firewall/proxy settings
4. Verify API key is valid at [platform.openai.com](https://platform.openai.com)

### "Request timed out"

**Problem:** Large file or slow connection.

**Solution:**
1. Reduce audio file size (compress before upload)
2. Check internet speed
3. Increase timeout in service (currently 60 seconds)

### Mock Transcription Always Used

**Problem:** Real API not being called even with key set.

**Solution:**
1. Check `USE_WHISPER=true` in `.env`
2. Verify API key starts with `sk-`
3. Check console logs for error messages
4. Run test script: `dart run test_transcription.dart`

---

## Security Best Practices

### DO ✅
- Store API keys in `.env` file (never in code)
- Add `.env` to `.gitignore`
- Use environment variables for production deployments
- Rotate API keys periodically
- Monitor API usage for unusual activity
- Set up billing alerts on OpenAI dashboard

### DON'T ❌
- Commit `.env` files to git
- Share API keys via email/chat
- Hardcode API keys in source code
- Use production keys in development
- Expose keys in client-side code
- Leave API keys in public repositories

---

## Testing Guide

### 1. Unit Tests (Automated)

Run the included test script:
```bash
dart run test_transcription.dart
```

### 2. Integration Test (Manual)

1. **Record a test audio:**
   - Use your device's voice recorder
   - Record 10-20 seconds of speech
   - Save as `.m4a` or `.wav` format

2. **Update test script:**
   ```dart
   // In test_transcription.dart, uncomment and update:
   final testAudioPath = '/path/to/your/test.m4a';
   ```

3. **Run test:**
   ```bash
   dart run test_transcription.dart
   ```

4. **Verify output:**
   - Check transcription accuracy
   - Verify proper capitalization
   - Check for proper punctuation

### 3. App Integration Test

1. Launch app in debug mode
2. Navigate to voice journaling screen
3. Record a 15-second test entry
4. Check console for transcription logs:
   ```
   🎙️ Transcribing audio with OpenAI Whisper...
      File: /path/to/recording.m4a
      Size: 156.34 KB
      Sending request to OpenAI Whisper API...
   ✅ Transcription successful (234 chars)
   ```

---

## Migration from Mock to Production

When ready to switch from mock transcription to production:

1. **Update `.env`:**
   ```env
   OPENAI_API_KEY=sk-your-production-key
   USE_WHISPER=true
   IS_PROD=true
   ```

2. **No code changes needed!** The service automatically detects configuration.

3. **Monitor costs:**
   - Set up billing alerts
   - Track usage patterns
   - Optimize recording length recommendations

---

## Support & Resources

### Documentation
- [OpenAI Whisper API Docs](https://platform.openai.com/docs/guides/speech-to-text)
- [Whisper Model Details](https://openai.com/research/whisper)
- [API Reference](https://platform.openai.com/docs/api-reference/audio)

### Need Help?
- Check console logs for detailed error messages
- Run diagnostic test script
- Review this setup guide
- Check OpenAI status: [status.openai.com](https://status.openai.com)

---

## Changelog

### v1.0.0 (Current)
- ✅ Real Whisper API integration
- ✅ Intelligent fallback system
- ✅ Comprehensive error handling
- ✅ Mock transcription for development
- ✅ Audio format validation
- ✅ Cost estimation
- ✅ Text cleaning and normalization
- ✅ Quality validation
- ✅ Streaming transcription support

---

**🎉 You're all set!** Your transcription service is now configured and ready to use.
