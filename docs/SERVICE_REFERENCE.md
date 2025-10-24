# ⚙️ ODYSEYA SERVICE REFERENCE

**Generated:** 2025-10-23
**Framework Version:** v2.0
**Purpose:** Documentation of all backend, AI, and infrastructure services

---

## 📚 Service Categories

1. [Authentication Services](#-authentication-services)
2. [Firebase Services](#-firebase-services)
3. [AI & Machine Learning Services](#-ai--machine-learning-services)
4. [Audio & Transcription Services](#-audio--transcription-services)
5. [Data Services](#-data-services)
6. [Monetization Services](#-monetization-services)
7. [Notification Services](#-notification-services)
8. [Background Services](#-background-services)

---

## 🔐 Authentication Services

### 1. AuthService (Interface)
**Path:** `lib/services/auth_service.dart`

**Purpose:** Abstract authentication interface for dependency injection

**Methods:**
- `Future<User?> signInWithEmail(String email, String password)`
- `Future<User?> signUpWithEmail(String email, String password)`
- `Future<User?> signInWithGoogle()`
- `Future<User?> signInWithApple()`
- `Future<void> signOut()`
- `User? getCurrentUser()`
- `Stream<User?> authStateChanges()`

**Implementation:** Implemented by `FirebaseAuthService` (production) and `MockAuthService` (testing)

---

### 2. FirebaseAuthService
**Path:** `lib/services/firebase_auth_service.dart`

**Purpose:** Production authentication using Firebase Auth

**Features:**
- Email/password authentication
- Google Sign-In (via google_sign_in package)
- Apple Sign-In (iOS only, via sign_in_with_apple)
- Session persistence
- Auth state monitoring

**Dependencies:**
- `firebase_auth`
- `google_sign_in`
- `sign_in_with_apple`

**Error Handling:**
- `FirebaseAuthException` → user-friendly error messages
- Network error detection
- Invalid credential handling

---

### 3. MockAuthService
**Path:** `lib/services/mock_auth_service.dart`

**Purpose:** Development/testing auth bypass

**Features:**
- Instant "authentication" without Firebase
- Fake user generation
- State simulation

**Usage:** Only enabled in debug mode via feature flags

---

## 🔥 Firebase Services

### 4. FirestoreService
**Path:** `lib/services/firestore_service.dart`

**Purpose:** Central database service for all user data

**Collections:**
- `users/{userId}` — User profiles
- `users/{userId}/journal_entries/{entryId}` — Journal entries
- `users/{userId}/settings` — User preferences
- `users/{userId}/subscription` — RevenueCat sync data

**Key Methods:**

#### Journal Entries
```dart
Future<void> saveJournalEntry(JournalEntry entry)
Future<JournalEntry?> getJournalEntry(String entryId)
Future<List<JournalEntry>> getUserJournalEntries(String userId)
Future<List<JournalEntry>> getEntriesByDateRange(DateTime start, DateTime end)
Future<void> deleteJournalEntry(String entryId)
```

#### User Data
```dart
Future<void> createUserProfile(UserProfile profile)
Future<UserProfile?> getUserProfile(String userId)
Future<void> updateUserSettings(Map<String, dynamic> settings)
```

#### Statistics
```dart
Future<int> getTotalEntryCount(String userId)
Future<int> getCurrentStreak(String userId)
Future<Map<String, int>> getMoodDistribution(String userId)
```

**Security:** All queries scoped to authenticated user via Firestore Rules

---

### 5. FirebaseStorageService
**Path:** `lib/services/firebase_storage_service.dart`

**Purpose:** Audio file and photo upload management

**Storage Structure:**
- `users/{userId}/audio/{entryId}.m4a` — Voice recordings
- `users/{userId}/photos/{entryId}/{photoId}.jpg` — Journal photos

**Methods:**
```dart
Future<String> uploadAudioFile(String userId, String entryId, File audioFile)
Future<String> uploadPhoto(String userId, String entryId, File photoFile)
Future<void> deleteAudioFile(String userId, String entryId)
Future<void> deletePhoto(String userId, String entryId, String photoId)
Future<File?> downloadAudioFile(String userId, String entryId)
```

**Features:**
- Automatic compression for photos
- Progress callbacks for uploads
- Retry logic for failed uploads
- Local caching of downloaded files

---

## 🤖 AI & Machine Learning Services

### 6. AIServiceInterface
**Path:** `lib/services/ai_service_interface.dart`

**Purpose:** Abstract interface for AI providers

**Methods:**
```dart
Future<String> generateAffirmation(String userName, DateTime date)
Future<String> analyzeEntry(String transcription, String mood)
Future<String> generateInsight(String transcription)
Future<Map<String, dynamic>> analyzeEmotion(String text)
```

**Implementations:**
- `OpenAIService` (primary)
- `GroqAIService` (fallback/testing)
- `AITestService` (mocked responses)

---

### 7. OpenAIService
**Path:** `lib/services/openai_service.dart`

**Purpose:** Primary AI service using GPT-4 & GPT-3.5

**Models Used:**
- `gpt-4` — Complex emotional analysis (MVP2)
- `gpt-3.5-turbo` — Quick insights & affirmations (MVP1)

**Prompts:**

#### Affirmation Generation
```
You are Odyseya, a calm emotional companion. Generate a personalized,
poetic affirmation for [userName] to start their day with intention.
```

#### Entry Analysis (Odyseya Mirror)
```
You are Odyseya, a gentle emotional mirror. Analyze this journal entry
and return ONE short poetic reflection (max 2 sentences). Avoid judgment.

Entry: [transcription]
Mood: [mood]
```

**Configuration:**
- Temperature: 0.7 (creative but consistent)
- Max tokens: 150 (affirmations), 80 (insights)
- Timeout: 10s with retry

---

### 8. GroqAIService
**Path:** `lib/services/groq_ai_service.dart`

**Purpose:** Alternative AI service using Groq (faster inference)

**Features:**
- Llama 3 model support
- Lower latency than OpenAI
- Cost-effective for high-volume users

**Usage:** Enabled via `AIConfigService` feature flags

---

### 9. AIConfigService
**Path:** `lib/services/ai_config_service.dart`

**Purpose:** AI provider selection and failover logic

**Methods:**
```dart
AIServiceInterface getActiveAIService()
Future<void> setPreferredProvider(AIProvider provider)
Future<bool> testProviderConnection(AIProvider provider)
```

**Failover Chain:**
1. OpenAI (primary)
2. Groq (fallback)
3. Cached responses (offline mode)

---

### 10. AIServiceFactory
**Path:** `lib/services/ai_service_factory.dart`

**Purpose:** Dependency injection for AI services

**Pattern:** Factory pattern for creating AI service instances based on environment

---

### 11. AITestService
**Path:** `lib/services/ai_test_service.dart`

**Purpose:** Mocked AI responses for testing and development

**Features:**
- Instant responses (no API calls)
- Deterministic output
- Configurable delay simulation

---

### 12. AIAnalysisService
**Path:** `lib/services/ai_analysis_service.dart`

**Purpose:** Orchestrates AI analysis workflows

**Methods:**
```dart
Future<EntryAnalysis> analyzeJournalEntry(JournalEntry entry)
Future<WeeklySummary> generateWeeklySummary(List<JournalEntry> entries)
Future<List<Recommendation>> generateRecommendations(UserProfile profile)
```

**Entry Analysis Includes:**
- Emotional tone detection
- Trigger identification
- Sentiment score (-1 to 1)
- Poetic reflection (Odyseya Mirror)

---

## 🎙️ Audio & Transcription Services

### 13. VoiceRecordingService
**Path:** `lib/services/voice_recording_service.dart`

**Purpose:** Audio capture and management

**Dependencies:**
- `record` package (audio recording)
- `path_provider` (local storage)
- `permission_handler` (microphone access)

**Methods:**
```dart
Future<bool> requestMicrophonePermission()
Future<void> startRecording()
Future<String?> stopRecording() // Returns file path
Future<void> pauseRecording()
Future<void> resumeRecording()
Stream<double> getAmplitudeStream() // For waveform visualization
Future<void> cancelRecording()
```

**Audio Format:**
- Codec: AAC
- Sample rate: 44.1kHz
- Bitrate: 128kbps
- File format: .m4a

---

### 14. TranscriptionService
**Path:** `lib/services/transcription_service.dart`

**Purpose:** Speech-to-text conversion

**Provider:** OpenAI Whisper API (via openai_backend_service)

**Methods:**
```dart
Future<String> transcribeAudio(File audioFile)
Future<String> transcribeAudioFromPath(String filePath)
```

**Features:**
- Multi-language support (auto-detect)
- Punctuation restoration
- Speaker diarization (MVP2)
- Timestamp generation

**Error Handling:**
- Audio format validation
- File size limits (25MB max for Whisper)
- Network retry logic

---

### 15. OpenAIBackendService
**Path:** `lib/services/openai_backend_service.dart`

**Purpose:** Direct OpenAI API integration (Whisper, GPT)

**Endpoints Used:**
- `/v1/audio/transcriptions` (Whisper)
- `/v1/chat/completions` (GPT)

---

## 💾 Data Services

### 16. DataExportService
**Path:** `lib/services/data_export_service.dart`

**Purpose:** GDPR-compliant data export

**Methods:**
```dart
Future<File> exportAllData(String userId)
Future<File> exportJournalEntries(String userId, {DateTime? startDate, DateTime? endDate})
Future<File> exportUserProfile(String userId)
Future<String> generateGDPRReport(String userId)
```

**Export Formats:**
- JSON (machine-readable)
- PDF (human-readable "Odyseya Book")
- CSV (spreadsheet-friendly)

**Includes:**
- All journal entries
- User profile & settings
- Mood history
- AI insights
- Subscription data

---

### 17. SummaryGenerationService
**Path:** `lib/services/summary_generation_service.dart`

**Purpose:** Generate periodic emotional summaries (weekly, monthly)

**Methods:**
```dart
Future<WeeklySummary> generateWeeklySummary(String userId, DateTime weekStart)
Future<MonthlySummary> generateMonthlySummary(String userId, int month, int year)
```

**Summary Includes:**
- Mood trends
- Most common emotions
- Entry frequency
- AI-generated reflective paragraph
- Recommended affirmations

---

### 18. SummaryStorageService
**Path:** `lib/services/summary_storage_service.dart`

**Purpose:** Cache and retrieve generated summaries

**Storage:** Firestore subcollection `users/{userId}/summaries/{summaryId}`

---

## 💰 Monetization Services

### 19. RevenueCatService
**Path:** `lib/services/revenue_cat_service.dart`

**Purpose:** In-app purchase and subscription management

**Dependencies:**
- `purchases_flutter` (RevenueCat SDK)

**Methods:**
```dart
Future<void> initialize()
Future<List<Package>> getAvailablePackages()
Future<bool> purchasePackage(Package package)
Future<void> restorePurchases()
Future<bool> checkSubscriptionStatus()
Stream<CustomerInfo> customerInfoStream()
```

**Subscription Tiers (Planned):**
- **Free:** 7 entries/month, basic affirmations
- **Premium:** Unlimited entries, AI insights, export, all features

**Features:**
- Cross-platform subscription sync
- Receipt validation
- Promotional offers
- Trial period management (14 days)

---

## 🔔 Notification Services

### 20. NotificationService
**Path:** `lib/services/notification_service.dart`

**Purpose:** Local notifications for reminders

**Dependencies:**
- `flutter_local_notifications`
- `timezone` (for scheduled notifications)

**Methods:**
```dart
Future<void> initialize()
Future<bool> requestPermission()
Future<void> scheduleDaily Reminder(TimeOfDay time)
Future<void> cancelAllNotifications()
Future<void> showInstantNotification(String title, String body)
```

**Notification Types:**
- Daily journal reminder (user-set time)
- Streak reminder (if user misses 2+ days)
- Weekly summary available notification

**UX:**
- Title: "Time for your Odyseya 🌙"
- Body: Randomized gentle prompts ("How are you feeling today?")

---

## 🔄 Background Services

### 21. BackgroundService
**Path:** `lib/services/background_service.dart`

**Purpose:** Background task management (summary generation, data sync)

**Methods:**
```dart
Future<void> registerBackgroundTasks()
Future<void> syncOfflineEntries()
Future<void> generatePendingSummaries()
```

**Tasks:**
- Weekly summary generation (Sunday nights)
- Offline entry upload when online
- Subscription status refresh

**Dependencies:**
- `workmanager` (Android)
- `background_fetch` (iOS)

---

## 🎨 Other Services

### 22. AffirmationService
**Path:** `lib/services/affirmation_service.dart`

**Purpose:** Generate and cache daily affirmations

**Methods:**
```dart
Future<String> getDailyAffirmation(String userId)
Future<void> saveAffirmation(String userId, String affirmation)
Future<List<String>> getSavedAffirmations(String userId)
```

**Logic:**
- Cache today's affirmation (regenerate at midnight)
- AI-generated based on user name and recent mood
- Fallback to curated list if AI unavailable

---

### 23. AIQuickTest
**Path:** `lib/services/ai_quick_test.dart`

**Purpose:** Debug tool to test AI service connectivity

**Usage:** Development only, not included in production builds

---

## 📊 Service Architecture Diagram

```
┌─────────────────────────────────────────────┐
│           UI Layer (Screens/Widgets)         │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│          State Management (Riverpod)         │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│              Service Layer                   │
├──────────────────────────────────────────────┤
│  Auth Services                               │
│  ├─ AuthService (interface)                 │
│  ├─ FirebaseAuthService                     │
│  └─ MockAuthService                          │
│                                              │
│  Firebase Services                           │
│  ├─ FirestoreService                        │
│  └─ FirebaseStorageService                  │
│                                              │
│  AI Services                                 │
│  ├─ AIServiceInterface                      │
│  ├─ OpenAIService                           │
│  ├─ GroqAIService                           │
│  ├─ AIConfigService                         │
│  └─ AIAnalysisService                       │
│                                              │
│  Audio Services                              │
│  ├─ VoiceRecordingService                   │
│  └─ TranscriptionService                    │
│                                              │
│  Data Services                               │
│  ├─ DataExportService                       │
│  └─ SummaryGenerationService                │
│                                              │
│  Other Services                              │
│  ├─ RevenueCatService                       │
│  ├─ NotificationService                     │
│  ├─ BackgroundService                       │
│  └─ AffirmationService                      │
└──────────────────┬───────────────────────────┘
                   │
┌──────────────────▼───────────────────────────┐
│         External APIs & SDKs                 │
├──────────────────────────────────────────────┤
│  - Firebase (Auth, Firestore, Storage, FCM) │
│  - OpenAI (GPT, Whisper)                    │
│  - Groq (Llama)                             │
│  - RevenueCat (Subscriptions)               │
│  - Google Sign-In                           │
│  - Apple Sign-In                            │
└──────────────────────────────────────────────┘
```

---

## 🔑 Environment Variables & Configuration

All services use environment variables for API keys:

```dart
// .env file (not committed to Git)
OPENAI_API_KEY=sk-...
GROQ_API_KEY=gsk_...
FIREBASE_WEB_API_KEY=AIza...
REVENUECAT_PUBLIC_KEY=appl_...
```

**Loading:** Via `flutter_dotenv` package in `main.dart`

---

## 🧪 Service Testing Strategy

| Service | Test Type | Coverage |
|---------|-----------|----------|
| FirestoreService | Integration tests with Firebase Emulator | 85%+ |
| AuthService | Unit tests with MockAuthService | 90%+ |
| AIService | Mocked with AITestService | 75%+ |
| VoiceRecordingService | Manual testing on real devices | Manual |
| NotificationService | Manual testing with scheduled reminders | Manual |

---

## 🚀 Service Initialization Order

In `main.dart`:
1. Load environment variables (`dotenv`)
2. Initialize Firebase (`Firebase.initializeApp()`)
3. Initialize RevenueCat
4. Initialize notification service
5. Register background tasks
6. Configure AI service provider
7. Set up dependency injection (Riverpod providers)

---

## 📝 Notes

- **MVP1 Services:** All core services (Auth, Firestore, AI, Voice, Transcription) are production-ready
- **MVP2 Additions:** Enhanced AI summaries, background sync, data export
- **Error Handling:** All services implement try-catch with user-friendly error messages
- **Offline Support:** Firestore and Storage services cache data for offline access

---

**Last Updated:** 2025-10-23
**Maintained by:** Odyseya Documentation Agent
**Related Docs:** [SCREEN_MAP.md](./SCREEN_MAP.md), [ARCHITECTURE_OVERVIEW.md](./ARCHITECTURE_OVERVIEW.md)
