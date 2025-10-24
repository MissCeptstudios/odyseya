# Quick Start Guide - Deploy in 10 Minutes

This is the fastest path to get your secure OpenAI backend running.

## Prerequisites Checklist

- [ ] Firebase project created with Blaze (pay-as-you-go) plan
- [ ] OpenAI API key from https://platform.openai.com/api-keys
- [ ] Node.js 18+ installed (`node --version`)
- [ ] Firebase CLI installed (`npm install -g firebase-tools`)

## Step 1: Login to Firebase (1 min)

```bash
firebase login
```

## Step 2: Initialize Project (2 min)

```bash
cd /Users/joannacholas/CursorProjects/odyseya
firebase init
```

**Selections:**
- ✅ Functions
- ✅ Firestore
- Use existing project → Select your Odyseya project
- TypeScript → Yes
- ESLint → Yes
- Install dependencies → Yes
- **IMPORTANT:** When asked to overwrite files → Choose **NO** for all

## Step 3: Install Dependencies (1 min)

```bash
cd functions
npm install
cd ..
```

## Step 4: Configure OpenAI Key (1 min)

```bash
firebase functions:config:set openai.key="sk-YOUR_ACTUAL_KEY_HERE"
```

Replace `sk-YOUR_ACTUAL_KEY_HERE` with your real OpenAI API key.

## Step 5: Deploy Functions (3 min)

```bash
firebase deploy --only functions
```

Wait for:
```
✔ functions[analyzeJournalEntry] Successful create operation.
✔ functions[generateJournalSummary] Successful create operation.
Deploy complete!
```

## Step 6: Deploy Firestore Rules (1 min)

Create `firestore.rules` in project root:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      allow read: if request.auth != null;

      match /usage/{document=**} {
        allow read: if request.auth.uid == userId;
        allow write: if request.auth != null;
      }
    }

    match /journals/{userId}/entries/{entry} {
      allow read, write: if request.auth.uid == userId;
    }

    match /summaries/{userId}/reports/{report} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

Deploy:
```bash
firebase deploy --only firestore:rules
```

## Step 7: Initialize User Document (1 min)

In Firebase Console → Firestore:
1. Create collection: `users`
2. Add document with your test user ID (from Firebase Auth)
3. Add fields:
   - `isPremium`: false
   - `email`: your-email@example.com
   - `createdAt`: (click "timestamp" and "now")

## Step 8: Test on Mobile (1 min)

Run your Flutter app on iOS or Android:

**iOS Simulator:**
```bash
open -a Simulator
flutter run -d ios
```

**Android Emulator:**
```bash
flutter run -d android
```

**Physical Device:**
```bash
flutter devices  # List connected devices
flutter run -d <device-id>
```

Create a journal entry and verify:
1. AI analysis appears
2. Firebase Console → Functions shows invocation
3. Firestore → users → {userId} → usage → shows count

**Note:** Odyseya is mobile-only (iOS and Android). Web, macOS, Windows, and Linux are not supported.

## Done! 🎉

Your secure backend is live.

## Verify Setup

Check Firebase Console:
- ✅ Functions tab shows 2 functions
- ✅ Logs show successful invocations
- ✅ Firestore has usage tracking data

## Common Issues

**"Functions not found"**
- Run: `firebase deploy --only functions` again

**"OpenAI API error"**
- Verify key: `firebase functions:config:get`
- Update: `firebase functions:config:set openai.key="sk-..."`
- Redeploy: `firebase deploy --only functions`

**"Unauthenticated"**
- Ensure user is logged in with Firebase Auth
- Check Firebase Console → Authentication

**"Monthly limit reached" (testing)**
- Update Firestore: users → {userId} → usage → delete current month document
- Or set `isPremium: true` for testing

## Next Steps

1. **Set OpenAI limits:** https://platform.openai.com/settings/organization/limits
   - Hard limit: $10/month
   - Soft limit: $5/month

2. **Add Firebase budget alerts:**
   - Firebase Console → Project Settings → Usage and Billing
   - Set alerts at $5, $10, $20

3. **Implement upgrade UI:**
   - See `SUBSCRIPTION_TIERS.md` for details
   - Integrate RevenueCat for payments

## Reference Documentation

- Full deployment: [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- Subscription system: [SUBSCRIPTION_TIERS.md](SUBSCRIPTION_TIERS.md)
- Implementation details: [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)

## Support

Issues? Check:
1. Firebase Console → Functions → Logs
2. Flutter console for errors
3. Verify all steps completed

Still stuck? Review the full [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for detailed troubleshooting.
