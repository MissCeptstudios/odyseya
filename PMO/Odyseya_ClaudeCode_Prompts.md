
# Claude Code Prompts for Odyseya MVP1 — Best Practices Task Flow

---

## 1. Initialize Flutter Project (Cross-platform Setup)

```
Create a new Flutter project configured for both iOS and Android platforms.  
Set up platform-specific configuration files and ensure the project supports multiple screen sizes and orientations.  
Include a basic app scaffold with a placeholder home screen.  
Follow Flutter and Dart best practices for project structure and dependencies.
```

---

## 2. Setup Git Repository & CI/CD

```
Generate a `.gitignore` file appropriate for Flutter projects.  
Create a GitHub Actions workflow file that:  
- Runs Flutter format and analyze checks on every pull request  
- Runs Flutter unit and widget tests  
- Builds iOS and Android release versions  
- Uploads artifacts for inspection  
Include caching of dependencies for faster builds.
```

---

## 3. Firebase Integration (Auth, Firestore, Storage)

```
Add Firebase to the Flutter project with secure environment configuration.  
Implement Firebase Authentication supporting email/password and Google sign-in.  
Set up Firestore with secure rules for user data isolation.  
Configure Firebase Storage for voice note uploads.  
Use best practices to keep API keys secure and support multiple build environments (dev/stage/prod).
```

---

## 4. Onboarding Questionnaire UI

```
Build a Flutter UI screen presenting 4–5 onboarding questions.  
Use card-style swipe or radio button selections for answers.  
Collect and validate user responses and save them securely to Firestore under the user profile.  
Make the UI accessible and responsive with smooth animations.
```

---

## 5. Mood Selection Screen (Swipeable Cards)

```
Create a Flutter widget showing 5 swipeable mood cards horizontally.  
Each card should display an emoji, mood label, and use colors from the desert palette.  
Highlight the selected mood clearly.  
Support accessibility features like screen reader labels and sufficient contrast.
```

---

## 6. Voice Recording & Transcription Integration

```
Implement a voice recording UI in Flutter with a prominent microphone button.  
Show live waveform or recording indicator while capturing audio.  
Integrate OpenAI Whisper API to transcribe the recorded voice to text asynchronously.  
Allow user to edit the transcribed text before saving.  
Handle permissions and errors gracefully.
```

---

## 7. Save Mood + Voice Note + Transcription

```
Implement data persistence to Firebase Firestore and Storage.  
Save the user's selected mood, transcription text, and the audio file reference.  
Ensure data consistency and handle offline caching.  
Use structured data models and proper error handling.
```

---

## 8. AI Analysis Integration

```
Write code to send the transcribed text to GPT-4 (or Claude) API.  
Parse the response to extract emotional tone, likely triggers, and personalized reflections.  
Display these insights in a user-friendly Flutter screen with the desert color palette.  
Allow users to save or discard AI-generated feedback.
```

---

## 9. Daily Calendar View with Mood Indicators

```
Create a Flutter calendar widget showing days with color-coded mood indicators.  
Enable tapping on a date to open that day's journal entry and AI insights.  
Support lazy loading and smooth scrolling.  
Ensure performance optimizations for large data sets.
```

---

## 10. Reminder System Implementation

```
Integrate Firebase Cloud Messaging (FCM) for push notifications.  
Build in-app reminder banners that appear if the user hasn’t journaled by a certain time.  
Add settings screen for users to customize reminder frequency and types.  
Follow platform best practices for notification permissions and battery optimization.
```

---

## 11. RevenueCat Subscription Integration & Paywall UI

```
Integrate RevenueCat SDK in Flutter for managing iOS and Android subscriptions.  
Implement UI screens for paywall explaining benefits and pricing tiers.  
Prompt users to upgrade when they reach free tier limits.  
Synchronize subscription status with Firebase and unlock premium features accordingly.  
Ensure smooth user experience and compliance with app store policies.
```

---

## 12. Testing Suite Setup

```
Write Flutter unit tests for core business logic and data models.  
Write widget tests for key UI components (mood selector, voice recorder, AI insights screen).  
Set up integration tests for complete user flows including onboarding, journaling, and payments.  
Configure test coverage reporting and integrate with CI pipeline.
```

---

## 13. Deployment Pipeline Setup

```
Create scripts and GitHub Actions workflows for building and deploying Flutter app to TestFlight and Android Beta.  
Include steps for code signing, provisioning profiles, and artifact upload.  
Add automated changelog generation and release notes template.
```

---

## 14. Error Reporting & Analytics

```
Integrate Firebase Crashlytics for real-time error reporting.  
Add user engagement analytics tracking (e.g., Firebase Analytics) for journaling frequency, mood patterns, and subscription events.  
Build dashboards or reports summarizing key metrics for product team review.
```

---
