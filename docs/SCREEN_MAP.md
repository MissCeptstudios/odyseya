# 📱 ODYSEYA SCREEN MAP

**Generated:** 2025-10-23
**Framework Version:** v2.0
**Purpose:** Complete navigation map of all screens in the Odyseya app

---

## 🗂️ Screen Organization

### System Screens (Pre-Auth)

| Screen | Path | Purpose | Status |
|--------|------|---------|--------|
| **Splash** | `lib/screens/splash_screen.dart` | App initialization & branding | ✅ Built |
| **Marketing** | `lib/screens/marketing_screen.dart` | Pre-auth landing page | ✅ Built |
| **First Download** | `lib/screens/first_downloadapp_screen.dart` | First-time user welcome | ✅ Built |

---

### Authentication Screens

| Screen | Path | Purpose | Status |
|--------|------|---------|--------|
| **Auth Choice** | `lib/screens/auth/auth_choice_screen.dart` | Login vs Sign Up selector | ✅ Built |
| **Sign Up** | `lib/screens/auth/signup_screen.dart` | New user registration | ✅ Built |
| **Login** | `lib/screens/auth/login_screen.dart` | Existing user authentication | ✅ Built |
| **Paywall** | `lib/screens/paywall_screen.dart` | Subscription gate (RevenueCat) | ✅ Built |

---

### Onboarding Flow (14 Screens)

| # | Screen | Path | Purpose | Status |
|---|--------|------|---------|--------|
| 1 | **Welcome** | `lib/screens/onboarding/welcome_screen.dart` | App intro & value proposition | ✅ Built |
| 2 | **GDPR Consent** | `lib/screens/onboarding/gdpr_consent_screen.dart` | Privacy & data consent | ✅ Built |
| 3 | **Privacy Preferences** | `lib/screens/onboarding/privacy_preferences_screen.dart` | Customize privacy settings | ✅ Built |
| 4 | **Permissions** | `lib/screens/onboarding/permissions_screen.dart` | Microphone & notification access | ✅ Built |
| 5 | **Account Creation** | `lib/screens/onboarding/account_creation_screen.dart` | Email/password setup | ✅ Built |
| 6 | **Emotional Goals** | `lib/screens/onboarding/emotional_goals_screen.dart` | Select user intentions | ✅ Built |
| 7 | **Journaling Experience** | `lib/screens/onboarding/journaling_experience_screen.dart` | Prior journaling background | ✅ Built |
| 8 | **Questionnaire Q1** | `lib/screens/onboarding/questionnaire_q1_screen.dart` | Emotional self-assessment #1 | ✅ Built |
| 9 | **Questionnaire Q2** | `lib/screens/onboarding/questionnaire_q2_screen.dart` | Emotional self-assessment #2 | ✅ Built |
| 10 | **Questionnaire Q3** | `lib/screens/onboarding/questionnaire_q3_screen.dart` | Emotional self-assessment #3 | ✅ Built |
| 11 | **Questionnaire Q4** | `lib/screens/onboarding/questionnaire_q4_screen.dart` | Emotional self-assessment #4 | ✅ Built |
| 12 | **Feature Demo** | `lib/screens/onboarding/feature_demo_screen.dart` | Interactive tutorial | ✅ Built |
| 13 | **Preferred Time** | `lib/screens/onboarding/preferred_time_screen.dart` | Set daily reminder time | ✅ Built |
| 14 | **Onboarding Success** | `lib/screens/onboarding/onboarding_success_screen.dart` | Completion celebration | ✅ Built |

**Onboarding Flow Controller:**
`lib/screens/onboarding/onboarding_flow.dart` — manages screen progression with ← → arrows

---

### First Journal Experience

| Screen | Path | Purpose | Status |
|--------|------|---------|--------|
| **First Journal** | `lib/screens/onboarding/first_journal_screen.dart` | Guided first entry creation | ✅ Built |

---

## 🏠 Main App Shell

| Component | Path | Purpose |
|-----------|------|---------|
| **Main App Shell** | `lib/screens/main_app_shell.dart` | Bottom navigation container + tab management |

---

## 🌙 Bottom Navigation Tabs

### ✨ Tab 1: INSPIRATION (Calm Start)

| Screen | Path | Purpose | Status |
|--------|------|---------|--------|
| **Affirmation** | `lib/screens/inspiration/affirmation_screen.dart` | Daily affirmation + [Log Mood] + [Open Journal] | ✅ MVP1 |

**Planned (MVP2):**
- `saved_affirmations_screen.dart` — User's favorite affirmations
- `breathing_screen.dart` — Calm breathing animation

---

### 💭 Tab 2: ACTION (Expression)

| Screen | Path | Purpose | Status |
|--------|------|---------|--------|
| **Mood Selection** | `lib/screens/action/mood_selection_screen.dart` | Emoji mood check-in | ✅ MVP1 |
| **Voice Journal** | `lib/screens/action/voice_journal_screen.dart` | Voice/text entry (photo upload in MVP3) | ✅ MVP1 |
| **Recording** | `lib/screens/action/recording_screen.dart` | Audio capture interface | ✅ MVP1 |
| **Review & Submit** | `lib/screens/action/review_submit_screen.dart` | Optional entry review before saving | ✅ MVP1 |

**Flow:**
Mood Selection → Voice Journal → (Recording modal) → Review & Submit → Saved

---

### 📊 Tab 3: REFLECTION (Awareness)

| Screen | Path | Purpose | Status |
|--------|------|---------|--------|
| **Dashboard** | `lib/screens/reflection/dashboard_screen.dart` | Entry stats, streaks, mood insights | ✅ MVP1 |
| **Journal Calendar** | `lib/screens/reflection/journal_calendar_screen.dart` | Calendar grid with mood dots | ✅ MVP1 |

**Planned (MVP2):**
- `ai_insights_screen.dart` — Weekly AI emotional summaries
- `recommendations_screen.dart` — Book & action suggestions
- `journal_book_screen.dart` — Visual timeline of all entries

---

### 🌿 Tab 4: RENEWAL (Healing)

| Screen | Path | Purpose | Status |
|--------|------|---------|--------|
| **Coming Soon** | `lib/screens/renewal/coming_soon_screen.dart` | Placeholder for MVP2 features | ✅ MVP1 |

**Planned (MVP2):**
- `self_helper_screen.dart` — Rituals hub (breathing, manifestation, letters)
- `feedback_screen.dart` — User feedback form ("Whisper to Creator")
- `manifestation_screen.dart` — Write affirmation or intention
- `letter_to_future_screen.dart` — Message to future self
- `breathing_exercise_screen.dart` — Guided breathing animation

---

### ⚙️ Settings (Accessed from Navigation)

| Screen | Path | Purpose | Status |
|--------|------|---------|--------|
| **Settings** | `lib/screens/settings/settings_screen.dart` | Notifications, privacy, export, account | ✅ Built |

---

## 🛠️ Development & Debug Screens

| Screen | Path | Purpose | Status |
|--------|------|---------|--------|
| **Debug Screen** | `lib/screens/debug_screen.dart` | Development tools & testing | 🔧 Dev Only |
| **Debug Navigation** | `lib/screens/debug_navigation_test.dart` | Navigation testing interface | 🔧 Dev Only |

---

## 🗺️ Navigation Flow Diagram

```
Splash
  ↓
Marketing / First Download
  ↓
Auth Choice → Login / Sign Up
  ↓
Paywall (if needed)
  ↓
Onboarding Flow (14 screens with ← →)
  ↓
First Journal Experience
  ↓
Main App Shell
  ├─ ✨ Inspiration (Affirmation)
  ├─ 💭 Action (Mood → Voice Journal → Review)
  ├─ 📊 Reflection (Dashboard / Calendar)
  └─ 🌿 Renewal (Coming Soon)
```

---

## 📊 Screen Count Summary

| Category | Count | Status |
|----------|-------|--------|
| System/Pre-Auth | 3 | ✅ Built |
| Authentication | 4 | ✅ Built |
| Onboarding | 14 | ✅ Built |
| First Journal | 1 | ✅ Built |
| Main App Shell | 1 | ✅ Built |
| Inspiration Tab | 1 | ✅ MVP1 |
| Action Tab | 4 | ✅ MVP1 |
| Reflection Tab | 2 | ✅ MVP1 |
| Renewal Tab | 1 | 🔜 MVP2 |
| Settings | 1 | ✅ Built |
| Debug/Dev | 2 | 🔧 Dev Only |
| **TOTAL SCREENS** | **34** | **30 Built, 4 Planned** |

---

## 🎨 UX Patterns Across Screens

### Navigation Arrows
All non-tab screens include:
- **← Back Arrow** (top left): `Navigator.pop(context)`
- **→ Next Arrow** (top right): Advances to next screen

### Layout Consistency
- **Background:** Desert gradient (#DBAC80 → #FFFFFF)
- **Cards:** White (#FFFFFF), 16px corner radius, shadow `0 4 8 rgba(0,0,0,0.08)`
- **Padding:** 24px screen margins, 8px grid spacing
- **Typography:** Inter (UI), Cormorant Garamond (reflective content)
- **Colors:** `DesertColors` constants (from `lib/constants/colors.dart`)

---

## 🔄 Screen State Management

Most screens use:
- `StatefulWidget` for local UI state
- `Riverpod` / `Provider` for shared state (auth, user data, journal entries)
- `FirestoreService` for backend data sync
- `NavigationService` for programmatic routing

---

## 📝 Notes

- **MVP1 Focus:** Authentication → Onboarding → Daily Affirmation → Mood + Voice Journal → Calendar/Dashboard
- **MVP2 Expansion:** AI weekly summaries, Renewal tools (breathing, manifestation, future letters)
- **Platform:** iOS & Android only (mobile-first)

---

**Last Updated:** 2025-10-23
**Maintained by:** Odyseya Documentation Agent
**Related Docs:** [WIDGET_REFERENCE.md](./WIDGET_REFERENCE.md), [ARCHITECTURE_OVERVIEW.md](./ARCHITECTURE_OVERVIEW.md)
