# Transcription Prompt Customization Guide

## Overview

This guide shows you exactly where and how to customize the AI prompts used in Odyseya's transcription service to improve accuracy for emotional journaling content.

---

## 🎯 Location 1: Whisper API Context Prompt

### File: `lib/services/transcription_service.dart`
### Lines: 108-109

```dart
// Optional: Add prompt for better context
request.fields['prompt'] = 'This is a personal journal entry about emotions and feelings.';
```

### What This Does
The `prompt` parameter provides context to Whisper about the expected content, which helps with:
- Emotion-related vocabulary accuracy
- Proper handling of sensitive topics
- Better punctuation for emotional expressions
- Improved handling of pauses and filler words

### How to Customize

**Current (Basic):**
```dart
request.fields['prompt'] = 'This is a personal journal entry about emotions and feelings.';
```

**Better (Contextual):**
```dart
request.fields['prompt'] = 'This is a personal emotional journal entry. The speaker may discuss feelings like anxiety, joy, sadness, stress, overwhelm, calm, anger, or hope. They may mention work, relationships, self-care, mental health, or daily experiences.';
```

**Advanced (With Keywords):**
```dart
request.fields['prompt'] = '''
This is a voice journal entry about emotions and mental wellbeing.
Common topics: feelings, anxiety, stress, joy, sadness, relationships, work, self-care, mindfulness, overwhelm, calm, therapy, meditation, gratitude, worry, hope, fear, anger, peace.
The speaker is reflecting on their emotional state and personal experiences.
''';
```

**Multilingual Support:**
```dart
// If user's language is Spanish
request.fields['prompt'] = 'Esta es una entrada de diario personal sobre emociones y sentimientos.';

// If user's language is French
request.fields['prompt'] = 'Ceci est une entrée de journal personnel sur les émotions et les sentiments.';
```

### 💡 Pro Tips for Whisper Prompts

1. **Keep it under 224 tokens** (about 150 words)
2. **Include expected vocabulary** (emotion words, therapy terms)
3. **Mention speaking style** ("reflective", "conversational", "stream of consciousness")
4. **Add punctuation hints** if needed (though Whisper handles this well)

---

## 🎯 Location 2: Dynamic Mood-Based Prompts

### Current Implementation
The prompt is static (same for all recordings).

### Recommended Enhancement
Customize the prompt based on the user's selected mood **before** recording.

### File to Modify: `lib/services/transcription_service.dart`

**Add this method:**

```dart
/// Generate context-aware prompt based on user's mood selection
String _buildContextualPrompt({String? mood}) {
  // Base prompt
  String basePrompt = 'This is a personal emotional journal entry.';

  // Add mood-specific context
  if (mood != null) {
    switch (mood.toLowerCase()) {
      case 'joy':
      case 'joyful':
      case 'happy':
        basePrompt += ' The speaker is feeling joyful and positive. They may discuss gratitude, accomplishments, happiness, or positive experiences.';
        break;

      case 'calm':
      case 'peaceful':
        basePrompt += ' The speaker is feeling calm and peaceful. They may discuss relaxation, mindfulness, contentment, or inner peace.';
        break;

      case 'sad':
      case 'melancholy':
        basePrompt += ' The speaker is feeling sad or melancholic. They may discuss loss, disappointment, grief, or difficult emotions.';
        break;

      case 'anxious':
      case 'worried':
        basePrompt += ' The speaker is feeling anxious or worried. They may discuss stress, concerns, fears, or overwhelming situations.';
        break;

      case 'angry':
      case 'frustrated':
        basePrompt += ' The speaker is feeling angry or frustrated. They may discuss conflicts, injustice, irritation, or challenging situations.';
        break;

      default:
        basePrompt += ' The speaker is reflecting on their emotions and experiences.';
    }
  }

  return basePrompt;
}
```

**Then update the API call (line 109):**

```dart
// BEFORE:
request.fields['prompt'] = 'This is a personal journal entry about emotions and feelings.';

// AFTER:
request.fields['prompt'] = _buildContextualPrompt(mood: mood);
```

**And update the method signature (line 25):**

```dart
// BEFORE:
Future<String> transcribeAudio(String audioPath) async {

// AFTER:
Future<String> transcribeAudio(String audioPath, {String? mood}) async {
```

---

## 🎯 Location 3: Integration with Voice Journal Provider

### File to Modify: `lib/providers/voice_journal_provider.dart`

Find where transcription is called (search for `transcribeAudio`) and update it:

**Current (estimated):**
```dart
final transcription = await _transcriptionService.transcribeAudio(audioPath);
```

**Updated with mood context:**
```dart
final transcription = await _transcriptionService.transcribeAudio(
  audioPath,
  mood: state.selectedMood, // Pass the user's selected mood
);
```

This ensures the transcription service receives the mood context for better accuracy.

---

## 🎯 Location 4: Custom Vocabulary & Domain Terms

### Purpose
Train Whisper to recognize specific terminology used in emotional journaling.

### Implementation

Add this to your enhanced prompt:

```dart
String _buildEnhancedPrompt({String? mood, List<String>? customVocab}) {
  String prompt = _buildContextualPrompt(mood: mood);

  // Add custom vocabulary hints
  if (customVocab != null && customVocab.isNotEmpty) {
    prompt += ' Expected terms: ${customVocab.join(', ')}.';
  } else {
    // Default emotional vocabulary
    prompt += ' Expected terms: mindfulness, self-care, therapy, meditation, '
              'anxiety, depression, wellness, boundaries, triggers, coping, '
              'resilience, gratitude, journaling, reflection.';
  }

  return prompt;
}
```

### Custom Vocabulary Examples

**For Mental Health Focus:**
```dart
final mentalHealthVocab = [
  'therapy', 'therapist', 'counseling', 'CBT', 'DBT',
  'medication', 'diagnosis', 'symptoms', 'treatment',
  'mental health', 'wellbeing', 'self-care'
];
```

**For Mindfulness Focus:**
```dart
final mindfulnessVocab = [
  'meditation', 'breathing', 'mindfulness', 'presence',
  'awareness', 'chakra', 'yoga', 'zen', 'mantra',
  'grounding', 'centering', 'intention'
];
```

**For Work-Life Balance:**
```dart
final workLifeVocab = [
  'work-life balance', 'burnout', 'boundaries',
  'remote work', 'productivity', 'deadlines',
  'workload', 'delegation', 'time management'
];
```

---

## 🎯 Location 5: User-Specific Learning

### Advanced Feature: Learn from User's Past Entries

Build a personalized vocabulary list based on frequently used words:

```dart
/// Build user-specific prompt based on their journaling history
Future<String> _buildPersonalizedPrompt({
  required String userId,
  String? mood,
}) async {
  // Get user's most common words from past entries
  final commonWords = await _getUserCommonWords(userId, limit: 20);

  String prompt = _buildContextualPrompt(mood: mood);

  if (commonWords.isNotEmpty) {
    prompt += ' The speaker commonly uses terms like: ${commonWords.join(', ')}.';
  }

  return prompt;
}

/// Extract common words from user's journal history
Future<List<String>> _getUserCommonWords(String userId, {int limit = 20}) async {
  // TODO: Query Firestore for user's past entries
  // TODO: Extract and count word frequency
  // TODO: Return top N most common emotion/topic words
  // For now, return empty list
  return [];
}
```

---

## 📋 Complete Example: Full Enhanced Implementation

### File: `lib/services/transcription_service.dart`

Here's how to add all enhancements:

```dart
class TranscriptionService {
  // ... existing code ...

  /// Main transcription method with mood context
  Future<String> transcribeAudio(
    String audioPath, {
    String? mood,
    List<String>? customVocabulary,
  }) async {
    try {
      // ... existing validation code ...

      // Try real Whisper API first if configured
      if (EnvConfig.hasOpenaiKey && EnvConfig.useWhisper) {
        try {
          final transcription = await _callWhisperAPI(
            audioPath,
            mood: mood,
            customVocabulary: customVocabulary,
          );
          return cleanTranscription(transcription);
        } catch (e) {
          // ... existing fallback code ...
        }
      }

      return _generateMockTranscription(fileSize);
    } catch (e) {
      // ... existing error handling ...
    }
  }

  /// Real OpenAI Whisper API call with enhanced prompts
  Future<String> _callWhisperAPI(
    String audioPath, {
    String? mood,
    List<String>? customVocabulary,
  }) async {
    try {
      // ... existing request setup ...

      // Enhanced contextual prompt
      request.fields['prompt'] = _buildEnhancedPrompt(
        mood: mood,
        customVocab: customVocabulary,
      );

      // ... rest of existing code ...
    }
  }

  /// Build mood-aware contextual prompt
  String _buildContextualPrompt({String? mood}) {
    String basePrompt = 'This is a personal emotional journal entry.';

    if (mood != null) {
      switch (mood.toLowerCase()) {
        case 'joy':
        case 'joyful':
        case 'happy':
          basePrompt += ' The speaker is feeling joyful and may discuss gratitude, accomplishments, or positive experiences.';
          break;
        case 'calm':
        case 'peaceful':
          basePrompt += ' The speaker is feeling calm and may discuss relaxation, mindfulness, or contentment.';
          break;
        case 'sad':
        case 'melancholy':
          basePrompt += ' The speaker is feeling sad and may discuss loss, disappointment, or difficult emotions.';
          break;
        case 'anxious':
        case 'worried':
          basePrompt += ' The speaker is feeling anxious and may discuss stress, concerns, or overwhelming situations.';
          break;
        case 'angry':
        case 'frustrated':
          basePrompt += ' The speaker is feeling angry and may discuss conflicts, irritation, or challenging situations.';
          break;
        default:
          basePrompt += ' The speaker is reflecting on their emotions and experiences.';
      }
    }

    return basePrompt;
  }

  /// Build enhanced prompt with vocabulary hints
  String _buildEnhancedPrompt({
    String? mood,
    List<String>? customVocab,
  }) {
    String prompt = _buildContextualPrompt(mood: mood);

    // Add emotional vocabulary
    final emotionalTerms = customVocab ?? _getDefaultEmotionalVocabulary();

    if (emotionalTerms.isNotEmpty) {
      prompt += ' Expected terms: ${emotionalTerms.take(15).join(', ')}.';
    }

    return prompt;
  }

  /// Default emotional vocabulary for journaling
  List<String> _getDefaultEmotionalVocabulary() {
    return [
      'anxiety', 'stress', 'overwhelm', 'calm', 'peace',
      'joy', 'gratitude', 'sadness', 'grief', 'anger',
      'therapy', 'self-care', 'mindfulness', 'meditation',
      'boundaries', 'triggers', 'coping', 'resilience',
      'depression', 'wellbeing', 'mental health',
      'relationships', 'work-life balance', 'burnout',
    ];
  }

  // ... rest of existing code ...
}
```

---

## 🎨 Prompt Templates Library

### Template 1: General Emotional Journaling
```dart
'This is a personal emotional journal entry. The speaker is reflecting on their feelings, experiences, and mental state. They may discuss emotions like anxiety, joy, sadness, stress, calm, or anger.'
```

### Template 2: Therapy-Focused
```dart
'This is a therapeutic journal entry. The speaker may discuss their therapy sessions, mental health treatment, coping strategies, progress, setbacks, or insights from counseling.'
```

### Template 3: Gratitude Journaling
```dart
'This is a gratitude journal entry. The speaker is reflecting on positive experiences, things they are thankful for, accomplishments, blessings, or moments of joy and appreciation.'
```

### Template 4: Work-Related Stress
```dart
'This is a work-related journal entry. The speaker may discuss job stress, workplace challenges, deadlines, productivity, work-life balance, burnout, or career concerns.'
```

### Template 5: Relationship Reflection
```dart
'This is a relationship journal entry. The speaker may discuss their connections with family, friends, partners, or colleagues. Topics may include communication, boundaries, conflicts, or emotional support.'
```

### Template 6: Daily Reflection
```dart
'This is a daily reflection journal entry. The speaker is reviewing their day, discussing events, interactions, feelings, lessons learned, or plans for tomorrow.'
```

---

## 🔄 Testing Your Custom Prompts

### Method 1: A/B Testing

Test different prompts with the same audio file:

```dart
// Test Script
final testAudio = '/path/to/test/recording.m4a';

// Test different prompts
final prompts = [
  'This is a journal entry.',
  'This is a personal emotional journal entry about feelings.',
  'This is a therapeutic journal entry discussing anxiety and stress.',
];

for (final prompt in prompts) {
  final service = TranscriptionService(customPrompt: prompt);
  final result = await service.transcribeAudio(testAudio);

  print('Prompt: $prompt');
  print('Result: $result');
  print('Accuracy: ${calculateAccuracy(result, expectedText)}%');
  print('---');
}
```

### Method 2: User Feedback Loop

Track transcription accuracy over time:

```dart
// After showing transcription to user
await showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Was this transcription accurate?'),
    actions: [
      TextButton(
        onPressed: () {
          // Log: Prompt worked well
          _logTranscriptionFeedback(accurate: true);
        },
        child: Text('Yes, accurate'),
      ),
      TextButton(
        onPressed: () {
          // Log: Prompt needs improvement
          _logTranscriptionFeedback(accurate: false);
        },
        child: Text('No, needs improvement'),
      ),
    ],
  ),
);
```

---

## 📊 Prompt Performance Metrics

Track these metrics to optimize your prompts:

1. **Word Error Rate (WER)**
   - Compare transcription to expected text
   - Lower is better

2. **Emotional Vocabulary Accuracy**
   - % of emotion words correctly transcribed
   - Critical for journaling accuracy

3. **User Edit Rate**
   - How often users edit transcriptions
   - Lower means better accuracy

4. **Mood-Specific Accuracy**
   - Track accuracy per mood category
   - Optimize prompts for each mood

---

## 🚀 Quick Reference: Where to Make Changes

| What You Want to Do | File | Line(s) | Method |
|---------------------|------|---------|--------|
| **Update base prompt** | `lib/services/transcription_service.dart` | ~109 | Edit `request.fields['prompt']` |
| **Add mood-based prompts** | `lib/services/transcription_service.dart` | Add new method | `_buildContextualPrompt()` |
| **Add custom vocabulary** | `lib/services/transcription_service.dart` | Add new method | `_getDefaultEmotionalVocabulary()` |
| **Pass mood to transcription** | `lib/providers/voice_journal_provider.dart` | Find `transcribeAudio` call | Add `mood: state.selectedMood` |
| **Use prompt templates** | `lib/services/transcription_service.dart` | Add constant | `static const Map<String, String> PROMPT_TEMPLATES` |

---

## 💡 Best Practices

### ✅ DO:
- Keep prompts under 224 tokens (~150 words)
- Include expected vocabulary relevant to emotional journaling
- Test prompts with real user recordings
- Update prompts based on user feedback
- Use mood context when available
- Include common emotion words

### ❌ DON'T:
- Make prompts too long (degrades performance)
- Include irrelevant information
- Use overly technical language
- Hardcode user-specific info in prompts
- Forget to sanitize user input if using dynamic prompts
- Override Whisper's natural punctuation too aggressively

---

## 📝 Summary

**Three levels of prompt customization:**

1. **Basic** (Current): Static prompt for all transcriptions
   - Location: `lib/services/transcription_service.dart:109`
   - Effort: 5 minutes

2. **Intermediate** (Recommended): Mood-based dynamic prompts
   - Locations: Add methods to `transcription_service.dart`, update `voice_journal_provider.dart`
   - Effort: 30-60 minutes

3. **Advanced** (Future): User-learning personalized prompts
   - Locations: Multiple files, Firestore integration
   - Effort: 2-4 hours

Start with level 1, test thoroughly, then progress to level 2 for best results! 🎯
