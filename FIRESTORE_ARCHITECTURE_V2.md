# 🏗️ Firestore Architecture V2 - Modular & Future-Proof

## Overview

This document describes the **production-ready, modular Firestore architecture** for Odyseya. This structure is designed to be:

- ✅ **GDPR-compliant** with explicit consent tracking
- ✅ **Scalable** for future features (photos, AI agents, book recommendations)
- ✅ **Efficient** with optimized queries and indexes
- ✅ **Secure** with comprehensive security rules
- ✅ **Maintainable** with clear data organization

---

## 📊 Data Architecture

### Root Collection: `users`

Each document represents one authenticated user (document ID = Firebase UID).

```
users/{userId}
  ├─ email: string
  ├─ displayName: string
  ├─ createdAt: timestamp
  ├─ lastLoginAt: timestamp
  ├─ gdprConsent: {
  │    accepted: boolean
  │    acceptedAt: timestamp
  │    ip: string (optional)
  │    version: string (e.g., "v1.0")
  │  }
  ├─ subscriptionStatus: {
  │    isPremium: boolean
  │    tier: "free" | "monthly" | "annual"
  │    expiresAt: timestamp
  │    trialEndsAt: timestamp
  │    willRenew: boolean
  │    revenueCatId: string
  │  }
  ├─ settings: {
  │    notificationsEnabled: boolean
  │    language: string
  │    theme: "light" | "dark" | "system"
  │    featureToggles: map
  │    preferences: map
  │  }
  ├─ statsCache: {  // Precomputed for fast dashboard loading
  │    totalEntries: number
  │    currentStreak: number
  │    longestStreak: number
  │    dominantMood: string
  │    lastUpdated: timestamp
  │    moodCounts: map<string, number>
  │  }
  └─ metadata: {
       appVersion: string
       deviceId: string
       platform: "ios" | "android"
       fcmToken: string
     }
```

**Why this structure:**
- All user data is isolated under their UID
- GDPR consent is explicit and versioned
- Subscription status synced with RevenueCat
- Stats cache for instant dashboard load
- Device metadata for analytics and push notifications

---

## 📁 Subcollections

### A) Collection: `moods`

**Path:** `users/{userId}/moods/{moodId}`

Stores daily mood logs with intensity ratings.

```
{
  moodValue: "Calm" | "Anxious" | "Grateful" | ...
  intensity: 1-10
  note: string (optional)
  createdAt: timestamp
  updatedAt: timestamp
  source: "manual" | "ai"
}
```

**Use Cases:**
- Daily mood tracking
- Mood trends over time
- AI-powered mood prediction
- Calendar visualization

**Queries:**
```dart
// Get today's moods
final today = DateTime.now();
final startOfDay = DateTime(today.year, today.month, today.day);

moods
  .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
  .orderBy('createdAt', descending: true)
  .get();

// Get mood trend for last 30 days
moods
  .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(thirtyDaysAgo))
  .orderBy('createdAt')
  .get();
```

---

### B) Collection: `journals`

**Path:** `users/{userId}/journals/{entryId}`

Voice journal entries with transcription, AI analysis, audio, and photos.

```
{
  title: string (optional, e.g., "Sunday Reflection")
  transcription: string
  aiAnalysis: {
    emotionalTone: string
    confidence: number
    triggers: array<string>
    insight: string
    suggestions: array<string>
    emotionScores: map<string, number>
    analyzedAt: timestamp
  }
  moodSnapshot: string  // Mood at time of journaling
  audioPath: string  // Firebase Storage URL
  photoPaths: array<string>  // Array of Firebase Storage URLs
  createdAt: timestamp
  updatedAt: timestamp
  overwriteFlag: boolean  // True if overwrites same-day entry
  tags: array<string>  // ["gratitude", "stress", "self-growth"]
  recordingDuration: number (milliseconds)
  isPrivate: boolean
  isSynced: boolean
}
```

**Use Cases:**
- Daily journaling
- Voice recording with transcription
- Photo attachments (future)
- AI emotional analysis
- Tag-based filtering
- Search by mood or keywords

**Queries:**
```dart
// Get all entries for current month
journals
  .where('createdAt', isGreaterThanOrEqualTo: monthStart)
  .where('createdAt', isLessThanOrEqualTo: monthEnd)
  .orderBy('createdAt', descending: true)
  .get();

// Get entries by mood
journals
  .where('moodSnapshot', isEqualTo: 'Calm')
  .orderBy('createdAt', descending: true)
  .limit(20)
  .get();

// Get entries with specific tag
journals
  .where('tags', arrayContains: 'gratitude')
  .orderBy('createdAt', descending: true)
  .get();
```

---

### C) Collection: `affirmations`

**Path:** `users/{userId}/affirmations/{affirmationId}`

System-generated or AI-curated daily affirmations.

```
{
  text: string
  source: "system" | "ai" | "custom"
  shownAt: timestamp
  liked: boolean | null  // true = liked, false = skipped, null = not rated
  moodContext: string  // Mood when affirmation was shown
}
```

**Use Cases:**
- Daily affirmation delivery
- User feedback (like/skip)
- Mood-based affirmation selection
- Custom affirmations (future)

**Queries:**
```dart
// Get today's affirmation
affirmations
  .where('shownAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
  .limit(1)
  .get();

// Get liked affirmations
affirmations
  .where('liked', isEqualTo: true)
  .orderBy('shownAt', descending: true)
  .get();
```

---

### D) Collection: `analysis`

**Path:** `users/{userId}/analysis/{analysisId}`

AI-generated bi-monthly or monthly analysis reports.

```
{
  type: "bi-monthly" | "monthly" | "trend" | "custom"
  generatedAt: timestamp
  summaryText: string  // AI-generated summary
  dominantMood: string
  insights: {
    wordCount: number
    toneStats: map<string, number>  // {"positive": 0.7, "neutral": 0.2}
    emotionTrends: map<string, number>  // {"calm": 0.6, "anxious": 0.3}
    topKeywords: array<string>
    commonThemes: array<string>
    overallSentiment: number  // -1.0 to 1.0
  }
  aiVersion: string  // e.g., "gpt-4-2025-10"
}
```

**Use Cases:**
- Bi-monthly emotional summaries
- Long-term trend analysis
- AI agent reports (Matthew, Sadia)
- Subscription unlock feature

**Queries:**
```dart
// Get latest bi-monthly report
analysis
  .where('type', isEqualTo: 'bi-monthly')
  .orderBy('generatedAt', descending: true)
  .limit(1)
  .get();

// Get all reports for this year
analysis
  .where('generatedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(yearStart))
  .orderBy('generatedAt', descending: true)
  .get();
```

---

### E) Collection: `recommendations`

**Path:** `users/{userId}/recommendations/{recommendationId}`

Book, podcast, and course recommendations.

```
{
  type: "book" | "podcast" | "course" | "article" | "video"
  title: string
  author: string (optional)
  link: string (optional)
  reason: string  // "Based on your mood trend"
  month: string  // "2025-10"
  createdAt: timestamp
  isViewed: boolean
  isFavorited: boolean
}
```

**Use Cases:**
- Monthly book recommendations
- Podcast suggestions
- Mood-based content curation
- User feedback (viewed/favorited)

**Queries:**
```dart
// Get recommendations for current month
recommendations
  .where('month', isEqualTo: '2025-10')
  .orderBy('createdAt', descending: true)
  .get();

// Get favorited recommendations
recommendations
  .where('isFavorited', isEqualTo: true)
  .orderBy('createdAt', descending: true)
  .get();

// Get books only
recommendations
  .where('type', isEqualTo: 'book')
  .orderBy('createdAt', descending: true)
  .get();
```

---

## 📦 Firebase Storage Structure

```
storage/
  ├─ audio/{userId}/{entryId}.m4a
  │   └─ Metadata: contentType, userId, entryId, uploadedAt
  │
  ├─ photos/{userId}/{entryId}_{index}.jpg
  │   └─ Metadata: contentType, userId, entryId, index
  │
  ├─ backups/{userId}/export_{date}.json
  │   └─ GDPR data export (JSON format)
  │
  └─ profiles/{userId}/avatar.jpg
      └─ User profile picture
```

**File Size Limits:**
- Audio: 50MB max
- Photos: 10MB max each
- Profile pictures: 5MB max
- Backups: No limit (server-generated)

---

## 🔐 Security Rules

### Firestore Rules (`firestore.rules`)

**Key Principles:**
1. **User isolation:** Users can only access their own data (`request.auth.uid == userId`)
2. **Field validation:** Enforced data types and string lengths
3. **Rate limiting:** Prevent abuse (via Cloud Functions)
4. **Immutability:** Some fields cannot be changed after creation
5. **Server-side writes:** Affirmations/analysis only created by Cloud Functions

**Example Rules:**
```javascript
// Users can only read/write their own data
match /users/{userId}/journals/{entryId} {
  allow read: if request.auth.uid == userId;

  allow create: if request.auth.uid == userId &&
                   hasRequiredFields(['transcription', 'moodSnapshot']) &&
                   isValidStringLength(request.resource.data.transcription, 1, 10000) &&
                   request.resource.data.isPrivate == true;

  allow update: if request.auth.uid == userId &&
                   // Cannot change creation date
                   request.resource.data.createdAt == resource.data.createdAt;

  allow delete: if request.auth.uid == userId;
}
```

### Storage Rules (`storage.rules`)

**Key Principles:**
1. **User isolation:** Users can only access their own files
2. **File type validation:** Only allowed MIME types
3. **File size limits:** Prevent storage abuse
4. **Path restrictions:** Users cannot access other folders

**Example Rules:**
```javascript
match /audio/{userId}/{fileName} {
  allow read: if request.auth.uid == userId;

  allow create: if request.auth.uid == userId &&
                   request.resource.size <= 50 * 1024 * 1024 &&  // 50MB
                   request.resource.contentType.matches('audio/.*');

  allow delete: if request.auth.uid == userId;
}
```

---

## 📈 Firestore Indexes

### Required Indexes (`firestore.indexes.json`)

```json
{
  "indexes": [
    // Moods by date
    {
      "collectionGroup": "moods",
      "fields": [
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },

    // Journals by date
    {
      "collectionGroup": "journals",
      "fields": [
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },

    // Journals by mood and date
    {
      "collectionGroup": "journals",
      "fields": [
        { "fieldPath": "moodSnapshot", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },

    // Journals by tag and date
    {
      "collectionGroup": "journals",
      "fields": [
        { "fieldPath": "tags", "arrayConfig": "CONTAINS" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },

    // Analysis by type and date
    {
      "collectionGroup": "analysis",
      "fields": [
        { "fieldPath": "type", "order": "ASCENDING" },
        { "fieldPath": "generatedAt", "order": "DESCENDING" }
      ]
    },

    // Recommendations by month and date
    {
      "collectionGroup": "recommendations",
      "fields": [
        { "fieldPath": "month", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    }
  ]
}
```

---

## 🚀 Deployment Instructions

### 1. Deploy Firestore Rules

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in project (if not done)
firebase init firestore

# Deploy rules
firebase deploy --only firestore:rules

# Verify deployment
firebase firestore:rules
```

### 2. Deploy Firestore Indexes

```bash
# Deploy indexes
firebase deploy --only firestore:indexes

# This will create all indexes defined in firestore.indexes.json
# Note: Index creation can take several minutes
```

### 3. Deploy Storage Rules

```bash
# Deploy storage rules
firebase deploy --only storage

# Verify deployment
firebase storage:rules
```

### 4. Verify Security

**Test with Firebase Console:**
1. Go to Firestore → Rules tab
2. Click "Rules Playground"
3. Test read/write operations with different user IDs
4. Verify access is properly restricted

---

## 📊 Data Models in Code

All models are defined in `/lib/models/`:

- ✅ `user_profile.dart` - UserProfile, GdprConsent, SubscriptionStatus, etc.
- ✅ `mood_log.dart` - MoodLog with intensity and source tracking
- ✅ `journal_entry_v2.dart` - Enhanced with photos and tags
- ✅ `affirmation.dart` - Daily affirmations with feedback
- ✅ `analysis_report.dart` - AI-generated insights
- ✅ `recommendation.dart` - Books, podcasts, courses

**Example Usage:**
```dart
// Create user profile
final profile = UserProfile(
  uid: user.uid,
  email: user.email,
  displayName: user.displayName,
  createdAt: DateTime.now(),
  gdprConsent: GdprConsent(
    accepted: true,
    acceptedAt: DateTime.now(),
    version: 'v1.0',
  ),
  subscriptionStatus: SubscriptionStatus(
    isPremium: false,
    tier: 'free',
    willRenew: false,
  ),
  settings: UserSettings.defaults,
  metadata: UserMetadata(
    appVersion: '1.0.0',
    platform: 'ios',
  ),
);

// Save to Firestore
await FirebaseFirestore.instance
  .collection('users')
  .doc(user.uid)
  .set(profile.toFirestore());
```

---

## 🔄 Migration from V1 to V2

### Migration Strategy

**Option 1: Fresh Start (Recommended for MVP)**
- Start using V2 structure for all new users
- Old data stays in legacy structure
- Gradually migrate active users via Cloud Function

**Option 2: Full Migration**
- Run one-time migration script
- Copy data from old to new structure
- Validate data integrity
- Deprecate old collections

### Migration Script Outline

```dart
// Pseudo-code for migration
Future<void> migrateUserData(String userId) async {
  // 1. Create new user profile
  final oldUser = await getOldUserDoc(userId);
  final newProfile = UserProfile.fromOldStructure(oldUser);
  await saveNewProfile(newProfile);

  // 2. Migrate journal entries
  final oldJournals = await getOldJournals(userId);
  for (final oldEntry in oldJournals) {
    final newEntry = JournalEntryV2.fromOldEntry(oldEntry);
    await saveNewJournalEntry(userId, newEntry);
  }

  // 3. Create mood logs from journal moods
  for (final entry in oldJournals) {
    final moodLog = MoodLog.fromJournalEntry(entry);
    await saveMoodLog(userId, moodLog);
  }

  // 4. Mark migration complete
  await markMigrated(userId);
}
```

---

## 🌟 Future Enhancements

### Ready for:

1. **Photo Journaling**
   - `photoPaths` field already in journals
   - Storage rules already support photos
   - Just add UI upload flow

2. **AI Agents (Matthew & Sadia)**
   - Reports go in `analysis` collection
   - Separate document per agent analysis
   - Link to specific journal entry IDs

3. **Bi-Monthly Summaries**
   - Trigger Cloud Function every 60 days
   - Generate report from journal history
   - Save to `analysis` collection
   - Unlock for premium users

4. **Book Recommendations**
   - AI analyzes mood trends
   - Generates recommendations
   - Saves to `recommendations` collection
   - User can like/skip

5. **Data Export (GDPR)**
   - Cloud Function to generate JSON export
   - Save to `backups/{userId}/export.json`
   - User can download from app

6. **Streak Gamification**
   - `statsCache` has `currentStreak` and `longestStreak`
   - Update on each journal entry
   - Show badges/achievements

---

## 📚 Summary

### ✅ What You Get:

- **Modular Structure:** Each feature has its own subcollection
- **GDPR Compliant:** Explicit consent tracking and data export ready
- **Secure:** Comprehensive rules for Firestore and Storage
- **Scalable:** Optimized indexes for fast queries
- **Future-Proof:** Ready for photos, AI agents, recommendations
- **Maintainable:** Clear data organization and documentation

### 📁 Files Created:

1. **Data Models:** `/lib/models/`
   - `user_profile.dart`
   - `mood_log.dart`
   - `journal_entry_v2.dart`
   - `affirmation.dart`
   - `analysis_report.dart`
   - `recommendation.dart`

2. **Security Rules:**
   - `firestore.rules`
   - `storage.rules`

3. **Indexes:**
   - `firestore.indexes.json`

4. **Documentation:**
   - `FIRESTORE_ARCHITECTURE_V2.md` (this file)

### 🚀 Next Steps:

1. Deploy rules: `firebase deploy --only firestore:rules`
2. Deploy indexes: `firebase deploy --only firestore:indexes`
3. Deploy storage rules: `firebase deploy --only storage`
4. Update providers to use new models
5. Test with real data

---

**🎉 You now have a production-ready, modular, GDPR-compliant Firestore architecture!**
