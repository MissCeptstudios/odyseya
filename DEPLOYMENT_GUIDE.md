# Firebase Cloud Functions Deployment Guide

This guide walks you through deploying the secure OpenAI backend proxy with subscription tier support.

## Overview

The backend proxy:
- Secures your OpenAI API key (never exposed to clients)
- Implements subscription tiers (Free: 5 analyses/month, Premium: unlimited)
- Rate limits requests (10/hour free, 60/hour premium)
- Tracks usage in Firestore
- Validates Firebase Authentication

## Prerequisites

1. **Firebase CLI** installed globally
2. **Node.js** 18+ installed
3. **Firebase project** with Blaze (pay-as-you-go) plan
4. **OpenAI API key** from https://platform.openai.com/api-keys

## Step 1: Install Firebase CLI

If not already installed:

```bash
npm install -g firebase-tools
```

Verify installation:

```bash
firebase --version
```

## Step 2: Login to Firebase

```bash
firebase login
```

This will open a browser for authentication.

## Step 3: Initialize Firebase Project

From your project root (`/Users/joannacholas/CursorProjects/odyseya`):

```bash
firebase init
```

**Select these options:**
- Functions: Configure Cloud Functions
- Firestore: Configure Firestore (if not already done)
- Use existing project (select your Odyseya project)
- Language: TypeScript
- Use ESLint: Yes
- Install dependencies: Yes

**Important:** The `functions/` folder already contains the required code. If prompted to overwrite, choose:
- `index.ts`: **NO** (keep existing)
- `package.json`: **NO** (keep existing)
- `tsconfig.json`: **NO** (keep existing)

## Step 4: Install Dependencies

Navigate to functions directory:

```bash
cd functions
npm install
```

This installs:
- `firebase-functions`
- `firebase-admin`
- `axios` (for OpenAI API calls)

## Step 5: Configure OpenAI API Key

Store your OpenAI API key securely in Firebase config:

```bash
firebase functions:config:set openai.key="YOUR_OPENAI_API_KEY_HERE"
```

Replace `YOUR_OPENAI_API_KEY_HERE` with your actual key from https://platform.openai.com/api-keys

**Verify configuration:**

```bash
firebase functions:config:get
```

Should show:
```json
{
  "openai": {
    "key": "sk-..."
  }
}
```

## Step 6: Deploy Cloud Functions

From the project root:

```bash
firebase deploy --only functions
```

This will:
1. Compile TypeScript to JavaScript
2. Upload functions to Firebase
3. Deploy two functions:
   - `analyzeJournalEntry` - For individual entry analysis
   - `generateJournalSummary` - For biweekly/monthly summaries

**Expected output:**
```
✔  functions[analyzeJournalEntry(us-central1)] Successful create operation.
✔  functions[generateJournalSummary(us-central1)] Successful create operation.

✔  Deploy complete!
```

## Step 7: Set Up Firestore Security Rules

Update your Firestore rules to allow the backend to write usage data:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection - readable by owner
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;

      // Allow Cloud Functions to read subscription status
      allow read: if request.auth != null;

      // Usage tracking subcollection
      match /usage/{document=**} {
        allow read: if request.auth.uid == userId;
        // Allow Cloud Functions to write usage
        allow write: if request.auth != null;
      }
    }

    // Journals - standard rules
    match /journals/{userId}/entries/{entry} {
      allow read, write: if request.auth.uid == userId;
    }

    // Summaries - standard rules
    match /summaries/{userId}/reports/{report} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

Deploy rules:

```bash
firebase deploy --only firestore:rules
```

## Step 8: Set Up User Subscription Status

Ensure your Firestore has user documents with subscription info. The backend expects:

```
users/{userId}
  - isPremium: boolean (true for premium, false for free)
  - email: string
  - createdAt: timestamp
```

**Option A: Manual Setup (Testing)**

In Firebase Console > Firestore:
1. Create `users` collection
2. Add document with your test user ID
3. Set fields:
   - `isPremium`: false (for testing free tier)
   - `email`: "test@example.com"
   - `createdAt`: (current timestamp)

**Option B: RevenueCat Integration (Production)**

If using RevenueCat for subscriptions, ensure your subscription webhook or purchase flow updates:

```dart
// When subscription status changes
await FirebaseFirestore.instance
  .collection('users')
  .doc(userId)
  .set({
    'isPremium': customerInfo.entitlements.all['premium']?.isActive ?? false,
  }, SetOptions(merge: true));
```

## Step 9: Test the Backend

Run the Flutter app and try creating a journal entry. The app will automatically call the backend function.

**Check Firebase Console:**
1. Go to Functions tab - see invocation count
2. View Logs - see function execution logs
3. Check Firestore > users > {userId} > usage - see usage tracking

**Expected behavior:**
- Free users: Can make 5 analyses per month
- Premium users: Unlimited analyses
- Rate limiting enforced (10/hour free, 60/hour premium)

## Step 10: Monitor and Set Limits

### A. Set OpenAI Usage Limits

Prevent surprise bills by setting hard limits:

1. Go to https://platform.openai.com/settings/organization/limits
2. Set **Hard limit**: $10/month (or your preferred amount)
3. Set **Soft limit**: $5/month (get warning email)

### B. Monitor Firebase Usage

Firebase Console > Usage and Billing:
- **Cloud Functions**: Free tier is 125K invocations/month
- **Firestore**: Free tier is 50K reads/20K writes per day
- **Expected costs** (after free tier):
  - Functions: ~$0.40 per million invocations
  - GPT-4o: ~$0.0025 per analysis (500 tokens avg)

### C. Set Firebase Budget Alerts

1. Firebase Console > Project Settings > Usage and Billing
2. Set up budget alerts at $5, $10, $20

## Troubleshooting

### Error: "Functions not configured"

Check that you deployed functions:
```bash
firebase functions:list
```

Should show `analyzeJournalEntry` and `generateJournalSummary`.

### Error: "OpenAI API key not configured"

Re-run:
```bash
firebase functions:config:set openai.key="YOUR_KEY"
firebase deploy --only functions
```

### Error: "Unauthenticated"

Ensure user is logged in with Firebase Auth:
```dart
final user = FirebaseAuth.instance.currentUser;
if (user == null) {
  // Redirect to login
}
```

### Error: "Resource exhausted - monthly limit reached"

Free user hit their 5 analyses/month limit. Options:
1. Wait for next month (usage resets)
2. Upgrade to premium
3. Increase free tier limit in `functions/src/index.ts`

### Error: "Rate limit exceeded"

User made too many requests per hour. Wait and try again, or upgrade to premium for higher limits.

## Production Considerations

### 1. Enable Retry Logic

Update `openai_backend_service.dart` to retry on transient failures:

```dart
Future<AIAnalysis> analyzeEmotionalContent(...) async {
  int retries = 3;
  while (retries > 0) {
    try {
      final result = await callable.call({...});
      return parseResult(result);
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'resource-exhausted') {
        throw Exception('Monthly limit reached');
      }
      if (retries == 1) rethrow;
      retries--;
      await Future.delayed(Duration(seconds: 2));
    }
  }
}
```

### 2. Add Background Summary Generation

Set up Cloud Scheduler to auto-generate summaries:

```bash
firebase deploy --only functions:scheduledSummaryGeneration
```

Create a scheduled function in `functions/src/index.ts`:

```typescript
export const scheduledSummaryGeneration = functions
  .pubsub.schedule('0 0 * * 0') // Every Sunday at midnight
  .onRun(async (context) => {
    // Query users who need summaries
    // Generate and save summaries
  });
```

### 3. Add Analytics

Track usage with Firebase Analytics:

```dart
await FirebaseAnalytics.instance.logEvent(
  name: 'ai_analysis_completed',
  parameters: {
    'is_premium': isPremium,
    'usage_count': monthlyUsage,
  },
);
```

### 4. Optimize Cold Starts

Keep functions warm with scheduled pings:

```typescript
export const keepWarm = functions
  .pubsub.schedule('every 5 minutes')
  .onRun(async (context) => {
    console.log('Keeping function warm');
  });
```

## Updating Functions

When you modify function code:

```bash
cd functions
npm run build  # Compile TypeScript
cd ..
firebase deploy --only functions
```

## Cost Estimation

**Free Tier User (5 analyses/month):**
- Firebase: FREE (well within limits)
- OpenAI: 5 × $0.0025 = **$0.0125/month**

**Premium User (avg 60 analyses/month):**
- Firebase Functions: FREE (if <125K total invocations)
- OpenAI: 60 × $0.0025 = **$0.15/month**

**1000 Premium Users:**
- Firebase: ~$50/month (functions + Firestore)
- OpenAI: 1000 × $0.15 = **$150/month**
- **Total: ~$200/month**

## Next Steps

1. ✅ Deploy functions
2. ✅ Configure OpenAI key
3. ✅ Set up Firestore rules
4. ✅ Test with Flutter app
5. ⏭️ Implement subscription upgrade flow
6. ⏭️ Add UI to show usage stats
7. ⏭️ Set up monitoring and alerts
8. ⏭️ Deploy to production

## Support

If you encounter issues:
1. Check Firebase Console > Functions > Logs
2. Check Flutter logs for error messages
3. Verify Firestore rules are correct
4. Ensure OpenAI API key is valid and has credits

For Firebase support: https://firebase.google.com/support
For OpenAI support: https://help.openai.com
