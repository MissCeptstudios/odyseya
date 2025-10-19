# Secure OpenAI Backend Proxy Setup

This guide shows how to set up a secure Firebase Cloud Function to proxy OpenAI API calls, protecting your API key from exposure.

## Why You Need This

🚨 **CRITICAL**: Never put OpenAI API keys directly in your Flutter app!
- Users can decompile your app and steal the key
- Stolen keys can rack up thousands in charges
- This is the #1 security mistake developers make

## Architecture

```
Flutter App → Firebase Auth → Cloud Function → OpenAI API
               (user token)    (secure key)
```

---

## Step 1: Initialize Firebase Cloud Functions

### Install Firebase CLI

```bash
npm install -g firebase-tools
```

### Login to Firebase

```bash
firebase login
```

### Initialize Functions

```bash
cd /Users/joannacholas/CursorProjects/odyseya
firebase init functions
```

Select:
- ✅ Use existing project (select your Odyseya Firebase project)
- ✅ TypeScript (recommended)
- ✅ ESLint (yes)
- ✅ Install dependencies (yes)

---

## Step 2: Create the Cloud Function

Create `functions/src/index.ts`:

```typescript
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import axios from "axios";

admin.initializeApp();

// Store OpenAI key in Firebase environment config
const OPENAI_API_KEY = functions.config().openai.key;

/**
 * Analyze journal entry using OpenAI
 * Secured with Firebase Authentication
 */
export const analyzeJournalEntry = functions
  .region("us-central1")
  .https.onCall(async (data, context) => {
    // 1. Verify user is authenticated
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated to use AI analysis"
      );
    }

    const userId = context.auth.uid;

    // 2. Rate limiting check (prevent abuse)
    const rateLimitOk = await checkRateLimit(userId);
    if (!rateLimitOk) {
      throw new functions.https.HttpsError(
        "resource-exhausted",
        "Rate limit exceeded. Please try again later."
      );
    }

    // 3. Extract request data
    const {text, mood, previousContext} = data;

    if (!text || text.length < 10) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Journal entry text is required"
      );
    }

    try {
      // 4. Call OpenAI API (key is secure on backend)
      const response = await axios.post(
        "https://api.openai.com/v1/chat/completions",
        {
          model: "gpt-4o",
          messages: [
            {
              role: "system",
              content: getSystemPrompt(),
            },
            {
              role: "user",
              content: buildPrompt(text, mood, previousContext),
            },
          ],
          temperature: 0.7,
          max_tokens: 1000,
          response_format: {type: "json_object"},
        },
        {
          headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${OPENAI_API_KEY}`,
          },
        }
      );

      const result = response.data.choices[0].message.content;
      const usage = response.data.usage;

      // 5. Log usage for billing/monitoring
      await logUsage(userId, usage.total_tokens);

      // 6. Return analysis to app
      return {
        success: true,
        analysis: JSON.parse(result),
        tokensUsed: usage.total_tokens,
      };
    } catch (error: any) {
      console.error("OpenAI API error:", error.response?.data || error.message);

      throw new functions.https.HttpsError(
        "internal",
        "Failed to analyze journal entry",
        error.message
      );
    }
  });

/**
 * Generate periodic summary
 */
export const generateSummary = functions
  .region("us-central1")
  .https.onCall(async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError("unauthenticated", "Authentication required");
    }

    const userId = context.auth.uid;
    const {entries, periodStart, periodEnd, frequency} = data;

    try {
      const response = await axios.post(
        "https://api.openai.com/v1/chat/completions",
        {
          model: "gpt-4o",
          messages: [
            {
              role: "system",
              content: "You are an empathetic emotional intelligence assistant...",
            },
            {
              role: "user",
              content: buildSummaryPrompt(entries, frequency),
            },
          ],
          temperature: 0.7,
          max_tokens: 2000,
          response_format: {type: "json_object"},
        },
        {
          headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${OPENAI_API_KEY}`,
          },
        }
      );

      const result = response.data.choices[0].message.content;
      await logUsage(userId, response.data.usage.total_tokens);

      return {
        success: true,
        summary: JSON.parse(result),
      };
    } catch (error: any) {
      console.error("Summary generation error:", error);
      throw new functions.https.HttpsError("internal", "Failed to generate summary");
    }
  });

// Helper: Rate limiting (10 requests per hour per user)
async function checkRateLimit(userId: string): Promise<boolean> {
  const db = admin.firestore();
  const now = Date.now();
  const oneHourAgo = now - (60 * 60 * 1000);

  const recentRequests = await db
    .collection("ai_usage")
    .where("userId", "==", userId)
    .where("timestamp", ">", oneHourAgo)
    .count()
    .get();

  return recentRequests.data().count < 10;
}

// Helper: Log usage for monitoring
async function logUsage(userId: string, tokens: number): Promise<void> {
  const db = admin.firestore();
  await db.collection("ai_usage").add({
    userId,
    tokens,
    timestamp: Date.now(),
  });
}

// Helper: System prompt
function getSystemPrompt(): string {
  return `You are an empathetic emotional intelligence assistant for a mental wellness journaling app called Odyseya. Your role is to:

1. Analyze journal entries with deep emotional understanding
2. Identify emotional patterns, triggers, and underlying themes
3. Provide compassionate, actionable insights
4. Suggest healthy coping strategies and self-care practices
5. Track emotional growth over time

Always be:
- Empathetic and non-judgmental
- Specific and actionable in suggestions
- Mindful of mental health best practices
- Encouraging of professional help when appropriate

Respond ONLY with valid JSON matching this exact structure:
{
  "emotionalTone": "brief overall emotional state",
  "confidence": 0.85,
  "triggers": ["specific trigger 1", "specific trigger 2"],
  "insight": "detailed compassionate insight",
  "suggestions": ["actionable suggestion 1", "actionable suggestion 2"],
  "emotionScores": {
    "joy": 0.3,
    "sadness": 0.6,
    "anxiety": 0.4,
    "calm": 0.2,
    "anger": 0.1,
    "hope": 0.5
  }
}`;
}

// Helper: Build analysis prompt
function buildPrompt(text: string, mood?: string, context?: string): string {
  let prompt = `Analyze this journal entry:\n\nEntry: "${text}"`;

  if (mood) {
    prompt += `\n\nUser-selected mood: ${mood}`;
  }

  if (context) {
    prompt += `\n\nRecent context: ${context}`;
  }

  return prompt;
}

// Helper: Build summary prompt
function buildSummaryPrompt(entries: any[], frequency: string): string {
  // Simplified - see summary_generation_service.dart for full implementation
  return `Analyze these ${entries.length} journal entries and provide a ${frequency} summary...`;
}
```

---

## Step 3: Install Dependencies

```bash
cd functions
npm install axios
npm install firebase-functions@latest firebase-admin@latest
```

---

## Step 4: Configure OpenAI API Key

Set the API key as a Firebase environment variable (SECURE):

```bash
firebase functions:config:set openai.key="sk-your-actual-openai-key-here"
```

This key is stored securely on Firebase servers, never in your app!

---

## Step 5: Deploy to Firebase

```bash
firebase deploy --only functions
```

You'll get URLs like:
```
https://us-central1-odyseya-abc123.cloudfunctions.net/analyzeJournalEntry
https://us-central1-odyseya-abc123.cloudfunctions.net/generateSummary
```

---

## Step 6: Update Flutter App to Use Backend

Create `lib/services/openai_backend_service.dart`:

```dart
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import '../models/ai_analysis.dart';
import 'ai_service_interface.dart';

/// OpenAI Service using secure backend proxy
/// API key is never exposed to the client
class OpenAIBackendService implements AIServiceInterface {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  @override
  String get serviceName => 'OpenAI (Secure Backend)';

  @override
  bool get isConfigured => true; // Always configured if backend is deployed

  @override
  double getEstimatedCost(String text) => 0.0; // You handle billing

  @override
  Future<AIAnalysis> analyzeEmotionalContent({
    required String text,
    String? mood,
    String? previousContext,
  }) async {
    try {
      // Call your secure backend function
      final callable = _functions.httpsCallable('analyzeJournalEntry');

      final result = await callable.call({
        'text': text,
        'mood': mood,
        'previousContext': previousContext,
      });

      final data = result.data;
      final analysis = data['analysis'];

      if (kDebugMode) {
        debugPrint('✅ Analysis complete. Tokens used: ${data['tokensUsed']}');
      }

      // Parse response into AIAnalysis model
      return AIAnalysis(
        emotionalTone: analysis['emotionalTone'] ?? 'neutral',
        confidence: (analysis['confidence'] ?? 0.8).toDouble(),
        triggers: List<String>.from(analysis['triggers'] ?? []),
        insight: analysis['insight'] ?? '',
        suggestions: List<String>.from(analysis['suggestions'] ?? []),
        emotionScores: Map<String, double>.from(
          analysis['emotionScores']?.map(
            (k, v) => MapEntry(k, (v as num).toDouble())
          ) ?? {}
        ),
        analyzedAt: DateTime.now(),
      );
    } on FirebaseFunctionsException catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Backend error: ${e.code} - ${e.message}');
      }

      if (e.code == 'resource-exhausted') {
        throw Exception('Rate limit exceeded. Please try again later.');
      }

      throw Exception('Failed to analyze: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Unexpected error: $e');
      }
      rethrow;
    }
  }
}
```

Add to `pubspec.yaml`:
```yaml
dependencies:
  cloud_functions: ^4.7.0
```

Update `ai_service_factory.dart`:
```dart
import 'openai_backend_service.dart';

// In getCurrentService():
case AIProvider.openai:
  return getOpenAIBackendService(); // Use backend instead

OpenAIBackendService getOpenAIBackendService() {
  _openaiBackendService ??= OpenAIBackendService();
  return _openaiBackendService!;
}
```

---

## Step 7: Firebase Security Rules

Update Firestore rules to protect usage logs:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /ai_usage/{document} {
      // Only allow reading your own usage
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow write: if false; // Only backend can write
    }
  }
}
```

---

## Cost Breakdown

### Firebase Costs (Free Tier):
- Cloud Functions: 125K invocations/month FREE
- After free tier: ~$0.40 per million invocations

### OpenAI Costs (GPT-4o):
- $5 per 1M input tokens
- $15 per 1M output tokens
- ~$0.01 per journal analysis

### Example Monthly Cost (1000 active users):
- Users journal 3x/week average = ~12 entries/month
- 1000 users × 12 entries = 12,000 API calls
- 12,000 × $0.01 = **$120/month** (OpenAI only)
- Firebase: Still in free tier
- **Total: ~$120/month**

---

## Monitoring & Limits

### Set OpenAI Usage Limits

1. Go to: https://platform.openai.com/account/limits
2. Set **Hard Limit**: $100/month (or your budget)
3. Set **Soft Limit**: $80/month (get email warning)

### Monitor Usage

```typescript
// Add to Cloud Function
export const getUsageStats = functions.https.onCall(async (data, context) => {
  if (!context.auth) throw new functions.https.HttpsError("unauthenticated", "Auth required");

  const userId = context.auth.uid;
  const db = admin.firestore();

  // Get last 30 days
  const thirtyDaysAgo = Date.now() - (30 * 24 * 60 * 60 * 1000);

  const snapshot = await db
    .collection("ai_usage")
    .where("userId", "==", userId)
    .where("timestamp", ">", thirtyDaysAgo)
    .get();

  const totalTokens = snapshot.docs.reduce((sum, doc) => sum + doc.data().tokens, 0);
  const estimatedCost = (totalTokens / 1000000) * 10; // Rough estimate

  return {
    requestsLast30Days: snapshot.size,
    tokensUsed: totalTokens,
    estimatedCost: estimatedCost.toFixed(4),
  };
});
```

---

## Summary: What Should You Do?

### For Development (Now):
✅ Use your personal API key in the app
✅ Test with yourself and a few friends
✅ Set OpenAI usage limits ($50/month max)

### For Production (Before App Store Release):
✅ Set up Firebase Cloud Functions (this guide)
✅ Move API key to backend
✅ Implement rate limiting
✅ Monitor costs per user
✅ Consider premium tier for unlimited AI

### Long Term:
✅ Charge users for AI features (premium subscription)
✅ Or offer limited free analyses (5/month)
✅ Scale based on revenue

---

## Questions?

1. **Do I need a service account?**
   - No, your personal OpenAI account is fine
   - Just move the key to backend for security

2. **What's the monthly cost?**
   - Development: $0-10/month (just you testing)
   - Production (1K users): ~$120/month
   - Can monetize via premium subscriptions

3. **When should I deploy backend?**
   - Before submitting to App Store
   - Before sharing with >10 people
   - When you want rate limiting

Would you like me to help you set up the Firebase Cloud Functions now?
