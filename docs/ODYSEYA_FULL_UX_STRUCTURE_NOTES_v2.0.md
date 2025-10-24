# ODYSEYA — FULL APP FRAMEWORK (v2.0)

## 🌙 1. Core Concept

Odyseya is an emotional journaling app — calm, reflective, and minimalist. It represents an inner journey through the desert — **desert calm meets emotional clarity**.

**Main flow:** 🌞 Inspiration → Action → Reflection → Renewal

This cycle defines both the navigation and the emotional logic of the app.

---

## 🩵 2. Visual & UX Foundation

| Element | Specification |
|---------|---------------|
| **Background gradient** | "Desert Dawn" → #DBAC80 → #FFFFFF |
| **Cards / Widgets** | White (#FFFFFF), corner radius 16px, soft shadow `0 4 8 rgba(0,0,0,0.08)` |
| **Typography** | Inter (UI, body text), Cormorant Garamond (affirmations & reflections) |
| **Primary Color** | Caramel #D8A36C |
| **Secondary Color** | Soft Blue #C6D9ED |
| **Text Color** | Deep Brown #57351E |
| **Accent Color** | Light Brown #8B7362 |
| **Animations** | Smooth fade/slide transitions (200–300ms, cubic-bezier 0.4, 0, 0.2, 1) |
| **Tone** | Warm, poetic, minimalist, introspective |
| **Layout** | 24px padding, 8px grid spacing, generous whitespace |

**Style Motto:** "Soft motion, pastel shadows, no clutter, no rush — desert calm meets emotional clarity."

---

## 🧭 3. App Structure Overview

### Main Tabs (Bottom Navigation)

| Icon | Label | Description | Status |
|------|-------|-------------|--------|
| ✨ | Inspiration | Daily affirmation, calm start | ✅ MVP1 |
| 💭 | Action | Mood logging + journaling | ✅ MVP1 |
| 📊 | Reflection | Calendar + insights | ✅ MVP1 |
| 🌿 | Renewal | Self-helper, breathing, feedback | ⏳ MVP2 |

---

## ⚙️ 4. System & Onboarding Area

| Screens | Description |
|---------|-------------|
| **System** | Splash, Auth (login/signup), Paywall already built |
| **Onboarding Flow** | 14 screens (GDPR, preferences, emotional goals, privacy) already built |
| **Navigation** | Each onboarding screen includes ← and → arrows implemented in next build phase |

---

## ✨ 5. INSPIRATION TAB (Calm Start)

| Screen | Purpose | Status |
|--------|---------|--------|
| `affirmation_screen.dart` | Daily affirmation, greeting, [Log Mood] + [Open Journal] buttons | ✅ MVP1 |
| `saved_affirmations_screen.dart` | User's favorite affirmations | ⏳ MVP2 |
| `breathing_screen.dart` | Calm breathing animation | ⏳ MVP2 |

---

## 💭 6. ACTION TAB (Expression)

| Screen | Purpose | Status |
|--------|---------|--------|
| `mood_selection_screen.dart` | Mood check-in with emojis or slider | ✅ MVP1 |
| `voice_journal_screen.dart` | Voice or text journaling | ✅ MVP1 |
| `recording_screen.dart` | Handles audio capture for journal entries | ✅ MVP1 |
| `review_submit_screen.dart` | Optional journal review screen | ⏳ MVP2 |
| *(new)* `photo_upload_widget.dart` | Add image to journal entry | ⏳ MVP3 |

---

## 📊 7. REFLECTION TAB (Awareness)

| Screen | Purpose | Status |
|--------|---------|--------|
| `journal_calendar_screen.dart` | Calendar showing entries with mood dots | ✅ MVP1 |
| `dashboard_screen.dart` | Simple insights (count, streaks, moods) | ✅ MVP1 |
| *(new)* `ai_insights_screen.dart` | Weekly AI summary of emotions | ⏳ MVP2 |
| *(new)* `recommendations_screen.dart` | Book & action suggestions | ⏳ MVP2 |
| *(new)* `journal_book_screen.dart` | Visual "Odyseya Book" timeline | ⏳ MVP2 |

---

## 🌿 8. RENEWAL TAB (Healing & Self-Care)

| Screen | Purpose | Status |
|--------|---------|--------|
| `self_helper_screen.dart` | Rituals hub (breathing, manifestation, letters) | ⏳ MVP2 |
| `feedback_screen.dart` | Whisper to Creator (feedback form) | ⏳ MVP2 |
| `manifestation_screen.dart` | Write affirmation or intention | ⏳ MVP2 |
| `letter_to_future_screen.dart` | Message to future self | ⏳ MVP2 |
| `settings_screen.dart` | Notifications, privacy, export | 🔒 System |

---

## 🪶 9. AI INSIGHTS LIGHT (MVP1)

**Purpose:** Give immediate emotional reflection after saving a journal entry. It's poetic, warm, and non-judgmental — called **Odyseya Mirror**.

### UX Flow:
1️⃣ User writes or records entry
2️⃣ Tap [Save Entry]
3️⃣ Snackbar: "Entry saved 🌙"
4️⃣ AI card fades in: 💭 "Your words carry quiet balance."

### API:
Uses GPT-3.5 with prompt:
*"You are Odyseya, a gentle emotional mirror. Analyze this text and return ONE short poetic reflection. Avoid judgment."*

### Display:
- White card with radius 16px
- Cormorant Garamond Italic 18pt
- Caramel accent
- 💭 icon
- Fade-in animation (300ms)

### Storage:
Saved in Firestore under `aiInsight` field:
```json
{
  "text": "I felt peace today even after stress.",
  "aiInsight": "You sound balanced and grounded."
}
```

### Integration:
- `voice_journal_screen.dart` → generate + display
- `journal_calendar_screen.dart` → show saved insight
- Future (MVP2): weekly AI summary in `dashboard_screen.dart`

---

## 📅 10. MVP1 FOCUS BUILD

| Priority | Feature | Purpose |
|----------|---------|---------|
| 1️⃣ | Daily Affirmation | Calm entry point |
| 2️⃣ | Mood Check-In | Emotion logging |
| 3️⃣ | Journal (voice/text/photo) | Core experience |
| 4️⃣ | AI Insights Light | Emotional reflection |
| 5️⃣ | Calendar | History & motivation |
| 6️⃣ | Dashboard | Feedback & streaks |
| 7️⃣ | ComingSoon (Renewal tab placeholder) | Structure stability |

---

## 📘 11. Folder & File Architecture

```
/lib
├── main.dart
├── screens/
│   ├── inspiration/affirmation_screen.dart
│   ├── action/mood_selection_screen.dart
│   ├── action/voice_journal_screen.dart
│   ├── reflection/journal_calendar_screen.dart
│   ├── reflection/dashboard_screen.dart
│   ├── renewal/coming_soon_screen.dart
│   ├── auth/
│   ├── onboarding/
│   ├── settings/
│   ├── splash_screen.dart
│   ├── main_app_shell.dart
├── services/
│   └── ai_insight_service.dart
├── widgets/
│   ├── affirmation_card.dart
│   ├── mood_slider.dart
│   ├── photo_upload_widget.dart
│   ├── primary_button.dart
│   └── input_card.dart
└── utils/
    ├── theme.dart
    ├── navigation_helpers.dart
    └── constants.dart
```

---

## 🧩 12. Navigation Logic

Every screen includes:

```dart
leading: IconButton(
  icon: Icon(Icons.arrow_back_ios_new, color: Color(0xFF57351E)),
  onPressed: () => Navigator.pop(context),
),
actions: [
  IconButton(
    icon: Icon(Icons.arrow_forward_ios, color: Color(0xFF57351E)),
    onPressed: () => Navigator.push(context, ...),
  ),
],
```

All non-tab screens (onboarding, journal flow, GDPR) follow this arrow structure.

---

## 🌾 13. MVP2 EXPANSION (after launch)

| Category | Features |
|----------|----------|
| **AI** | Weekly summary, mood trend visualization |
| **Renewal tools** | Breathing, Manifestation, Future Letter |
| **Personalization** | Smart affirmations based on past entries |
| **Export** | "My Odyseya Book" PDF generator |
| **Community** | Feedback form + inspiration sharing |
| **Subscription** | 14-day trial → paywall integration |

---

## 🌸 14. Emotional UX Summary

| Phase | Feeling | UX Role |
|-------|---------|---------|
| ✨ Inspiration | Calm entry | grounding & intention |
| 💭 Action | Honest expression | release & clarity |
| 📊 Reflection | Understanding | meaning & self-awareness |
| 🌿 Renewal | Reconnection | healing & peace |

---

## 🪞 15. Odyseya Mirror — Emotional Identity

Odyseya isn't an app — it's a gentle mirror.

Every word, sound, and pause becomes part of your inner landscape.

The desert background represents silence;
The white cards — clarity;
And your reflections — the wind shaping it all.

---

## ✅ Framework Status

**Version:** 2.0
**Created:** 2025-10-23
**Purpose:** Single source of truth for all Odyseya design, architecture, and development decisions

**This document must be referenced before any code changes, UI updates, or feature additions.**
