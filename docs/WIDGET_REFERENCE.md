# 🧩 ODYSEYA WIDGET REFERENCE

**Generated:** 2025-10-23
**Framework Version:** v2.0
**Purpose:** Documentation of all reusable UI components

---

## 📚 Widget Categories

1. [Common Widgets](#-common-widgets)
2. [Authentication Widgets](#-authentication-widgets)
3. [Onboarding Widgets](#-onboarding-widgets)
4. [Voice Recording Widgets](#-voice-recording-widgets)
5. [Calendar Widgets](#-calendar-widgets)
6. [Navigation Widgets](#-navigation-widgets)
7. [AI Insights Widgets](#-ai-insights-widgets)
8. [Transcription Widgets](#-transcription-widgets)

---

## 🌟 Common Widgets

### 1. OdyseyaButton
**Path:** `lib/widgets/common/odyseya_button.dart`

**Purpose:** Primary button component with desert theme styling

**Properties:**
- `text` (String) — Button label
- `onPressed` (VoidCallback) — Tap handler
- `isEnabled` (bool) — Active/disabled state
- `width` (double?) — Optional custom width
- `height` (double?) — Optional custom height
- `backgroundColor` (Color?) — Custom background (default: westernSunrise)
- `textColor` (Color?) — Custom text color (default: brownBramble)

**UX Specs:**
- Corner radius: 16px
- Height: 56px (default)
- Typography: Inter SemiBold 16pt
- Disabled opacity: 0.5
- Animation: 200ms fade

**Usage:**
```dart
OdyseyaButton(
  text: 'Continue',
  onPressed: () => navigateNext(),
  backgroundColor: DesertColors.westernSunrise,
)
```

---

### 2. AppBackground
**Path:** `lib/widgets/common/app_background.dart`

**Purpose:** Desert gradient background for all screens

**Properties:**
- `child` (Widget) — Screen content

**UX Specs:**
- Gradient: #DBAC80 → #FFFFFF (top to bottom)
- Full screen coverage

**Usage:**
```dart
AppBackground(
  child: Column(children: [...]),
)
```

---

### 3. DesertBackground
**Path:** `lib/widgets/common/desert_background.dart`

**Purpose:** Alternative desert background with optional decorative elements

**Properties:**
- `child` (Widget) — Content overlay
- `showDunes` (bool) — Show sand dune graphics (default: false)

---

### 4. OdyseyaScreenLayout
**Path:** `lib/widgets/common/odyseya_screen_layout.dart`

**Purpose:** Standardized screen wrapper with padding, background, and safe area

**Properties:**
- `child` (Widget) — Screen content
- `showBackButton` (bool) — Display back arrow
- `showForwardButton` (bool) — Display next arrow
- `onBackPressed` (VoidCallback?) — Custom back action
- `onForwardPressed` (VoidCallback?) — Custom forward action
- `title` (String?) — Optional top bar title

**UX Specs:**
- Padding: 24px horizontal, 16px vertical
- Safe area insets respected
- Arrow buttons: brownBramble color

---

### 5. StepIndicator
**Path:** `lib/widgets/common/step_indicator.dart`

**Purpose:** Progress dots for multi-step flows (onboarding, questionnaires)

**Properties:**
- `currentStep` (int) — Active step index
- `totalSteps` (int) — Total number of steps
- `activeColor` (Color?) — Color for current step
- `inactiveColor` (Color?) — Color for pending steps

**UX Specs:**
- Dot size: 8px diameter
- Active dot: caramelDrizzle
- Inactive dot: 30% opacity
- Spacing: 8px between dots

---

### 6. MoodCard
**Path:** `lib/widgets/common/mood_card.dart`

**Purpose:** Individual mood selection card with emoji

**Properties:**
- `emoji` (String) — Emoji character
- `label` (String) — Mood name
- `color` (Color) — Accent color
- `isSelected` (bool) — Selection state
- `onTap` (VoidCallback) — Selection handler

**UX Specs:**
- Size: 80px × 100px
- Corner radius: 16px
- Shadow: `0 4 8 rgba(0,0,0,0.08)`
- Background: cardWhite
- Animation: 200ms scale + color transition

**Moods (Standard Set):**
- 😊 Happy — westernSunrise
- 😢 Sad — arcticRain
- 😰 Anxious — caramelDrizzle
- 😌 Calm — arcticRain
- 😠 Angry — westernSunrise

---

### 7. SwipeableMoodCards
**Path:** `lib/widgets/common/swipeable_mood_cards.dart`

**Purpose:** Horizontal swipeable carousel of mood cards

**Properties:**
- `onMoodSelected` (Function(String)) — Callback with selected mood
- `initialMood` (String?) — Pre-selected mood

**UX Specs:**
- PageView with snap scrolling
- 5 mood cards (standard set)
- Centered card scaling (1.1x)
- 250ms animation between cards

---

### 8. PremiumBadge
**Path:** `lib/widgets/common/premium_badge.dart`

**Purpose:** Small badge indicating premium-only features

**Properties:**
- `size` (double) — Badge size (default: 20px)

**UX Specs:**
- Icon: ✨ or crown
- Background: westernSunrise
- Text: "PRO" (Inter Bold 10pt)
- Corner radius: 4px

---

## 🔐 Authentication Widgets

### 9. AuthForm
**Path:** `lib/widgets/auth/auth_form.dart`

**Purpose:** Reusable email/password input form

**Properties:**
- `emailController` (TextEditingController)
- `passwordController` (TextEditingController)
- `formKey` (GlobalKey<FormState>)
- `isSignUp` (bool) — Determines validation rules

**UX Specs:**
- Input height: 56px
- Corner radius: 16px
- Error text: red (treeBranch)
- Focus border: arcticRain

---

### 10. AuthButton
**Path:** `lib/widgets/auth/auth_button.dart`

**Purpose:** Styled button for auth screens (Google, Apple, Email)

**Properties:**
- `provider` (String) — "google", "apple", "email"
- `onPressed` (VoidCallback)

**UX Specs:**
- Icons: Provider logos
- Height: 56px
- Border: 1px solid treeBranch (for outlined variants)

---

### 11. PrivacyNotice
**Path:** `lib/widgets/auth/privacy_notice.dart`

**Purpose:** GDPR-compliant privacy notice with links

**Properties:**
- `onPrivacyTap` (VoidCallback) — Opens privacy policy
- `onTermsTap` (VoidCallback) — Opens terms of use

**UX Specs:**
- Typography: Inter Regular 12pt
- Color: treeBranch
- Links: underlined, arcticRain

---

## 🚀 Onboarding Widgets

### 12. OnboardingLayout
**Path:** `lib/widgets/onboarding/onboarding_layout.dart`

**Purpose:** Standardized layout for onboarding screens

**Properties:**
- `title` (String) — Screen heading
- `subtitle` (String?) — Optional description
- `child` (Widget) — Screen content
- `showStepIndicator` (bool) — Display progress dots
- `currentStep` (int?)
- `totalSteps` (int?)
- `onBack` (VoidCallback?)
- `onNext` (VoidCallback?)

**UX Specs:**
- Title: Cormorant Garamond Bold 28pt
- Subtitle: Inter Regular 16pt, treeBranch
- Consistent padding & spacing

---

## 🎙️ Voice Recording Widgets

### 13. RecordButton
**Path:** `lib/widgets/voice_recording/record_button.dart`

**Purpose:** Animated microphone button for voice recording

**Properties:**
- `isRecording` (bool) — Active state
- `onPressed` (VoidCallback) — Start/stop recording
- `size` (double) — Button diameter (default: 80px)

**UX Specs:**
- Icon: Microphone
- Background: westernSunrise (idle) / arcticRain (recording)
- Animation: Pulsing circle (200ms loop)
- Shadow: `0 8 16 rgba(0,0,0,0.12)`

---

### 14. AudioWaveformWidget
**Path:** `lib/widgets/voice_recording/audio_waveform_widget.dart`

**Purpose:** Real-time audio waveform visualization

**Properties:**
- `isRecording` (bool)
- `amplitude` (double) — Current audio level (0.0 - 1.0)
- `color` (Color?) — Waveform color (default: arcticRain)

**UX Specs:**
- Height: 60px
- Bars: 40 vertical bars
- Animation: 50ms update rate
- Color: arcticRain with opacity gradient

---

## 📅 Calendar Widgets

### 15. CalendarWidget
**Path:** `lib/widgets/calendar/calendar_widget.dart`

**Purpose:** Monthly calendar grid with mood dot indicators

**Properties:**
- `selectedDate` (DateTime) — Currently selected day
- `entries` (Map<DateTime, JournalEntry>) — Journal entries by date
- `onDateSelected` (Function(DateTime)) — Date tap handler

**UX Specs:**
- Grid: 7 columns (days of week)
- Day cell: 48px × 48px
- Mood dot: 6px diameter, positioned bottom center
- Selected day: arcticRain background
- Today: westernSunrise border

---

### 16. StatisticsBar
**Path:** `lib/widgets/calendar/statistics_bar.dart`

**Purpose:** Summary stats above calendar (streak, total entries, etc.)

**Properties:**
- `currentStreak` (int)
- `totalEntries` (int)
- `averageMood` (String?)

**UX Specs:**
- Layout: Row of 3 stat cards
- Card background: cardWhite
- Corner radius: 12px
- Typography: Inter SemiBold 20pt (number), Regular 12pt (label)

---

### 17. EntryPreviewCard
**Path:** `lib/widgets/calendar/entry_preview_card.dart`

**Purpose:** Preview card showing journal entry excerpt

**Properties:**
- `entry` (JournalEntry) — Entry data
- `onTap` (VoidCallback) — Opens full entry view

**UX Specs:**
- Background: cardWhite
- Corner radius: 16px
- Shadow: `0 4 8 rgba(0,0,0,0.08)`
- Max height: 120px
- Text truncation: 3 lines with ellipsis

---

## 🧭 Navigation Widgets

### 18. BottomNavigationBar
**Path:** `lib/widgets/navigation/bottom_navigation_bar.dart`

**Purpose:** Main app tab navigation (4 tabs)

**Properties:**
- `currentIndex` (int) — Active tab index
- `onTabSelected` (Function(int)) — Tab change handler

**UX Specs:**
- Height: 80px
- Background: cardWhite
- Top corner radius: 24px
- Icons: 24px size
- Active color: westernSunrise
- Inactive color: treeBranch (50% opacity)
- Typography: Inter Regular 11pt

**Tabs:**
1. ✨ Inspiration
2. 💭 Action
3. 📊 Reflection
4. 🌿 Renewal

---

### 19. TopNavigationBar
**Path:** `lib/widgets/navigation/top_navigation_bar.dart`

**Purpose:** Custom app bar with back/forward arrows

**Properties:**
- `title` (String?)
- `showBackButton` (bool)
- `showForwardButton` (bool)
- `onBackPressed` (VoidCallback?)
- `onForwardPressed` (VoidCallback?)

**UX Specs:**
- Height: 56px
- Background: transparent
- Arrow icons: brownBramble
- Title: Inter SemiBold 18pt

---

## 🤖 AI Insights Widgets

### 20. InsightPreview
**Path:** `lib/widgets/ai_insights/insight_preview.dart`

**Purpose:** Display AI-generated emotional reflection (Odyseya Mirror)

**Properties:**
- `insightText` (String) — AI-generated message
- `isLoading` (bool) — Shows loading state

**UX Specs:**
- Background: cardWhite
- Corner radius: 16px
- Typography: Cormorant Garamond Italic 18pt
- Icon: 💭 (left aligned)
- Color: brownBramble
- Fade-in animation: 300ms
- Padding: 20px

---

## 📝 Transcription Widgets

### 21. TranscriptionDisplay
**Path:** `lib/widgets/transcription/transcription_display.dart`

**Purpose:** Shows transcribed text from voice recordings

**Properties:**
- `transcription` (String) — Transcribed text
- `isEditable` (bool) — Allow user editing
- `onTextChanged` (Function(String)?) — Edit callback

**UX Specs:**
- Background: cardWhite
- Corner radius: 16px
- Typography: Inter Regular 16pt
- Min height: 120px
- Max height: 400px (scrollable)
- Edit mode: Shows keyboard with save/cancel

---

## 🎨 Design System Constants

All widgets reference `lib/constants/`:
- `colors.dart` — DesertColors palette
- `spacing.dart` — Standardized padding/margins
- `typography.dart` — Font families & sizes
- `shadows.dart` — Elevation & shadow presets

### Color Usage Map

| Widget Type | Primary Color | Secondary Color | Text Color |
|-------------|---------------|-----------------|------------|
| Buttons (primary) | westernSunrise | — | cardWhite |
| Buttons (secondary) | cardWhite | arcticRain (border) | brownBramble |
| Cards | cardWhite | — | brownBramble |
| Backgrounds | backgroundSand | — | — |
| Icons (active) | westernSunrise | — | — |
| Icons (inactive) | treeBranch | — | — |
| Links | arcticRain | — | arcticRain |

---

## 📊 Widget Reusability Matrix

| Widget | Screens Using It | Reusability Score |
|--------|------------------|-------------------|
| OdyseyaButton | 28+ screens | ⭐⭐⭐⭐⭐ |
| AppBackground | All screens | ⭐⭐⭐⭐⭐ |
| StepIndicator | Onboarding, questionnaires | ⭐⭐⭐⭐ |
| MoodCard | Mood selection, review | ⭐⭐⭐⭐ |
| RecordButton | Voice journal, recording | ⭐⭐⭐ |
| CalendarWidget | Calendar, dashboard | ⭐⭐⭐ |
| InsightPreview | Entry review, dashboard | ⭐⭐⭐ |

---

## 🛠️ Widget Development Guidelines

### Creating a New Widget

1. **Location:** Place in appropriate category folder under `lib/widgets/`
2. **Naming:** Use descriptive names (`mood_card.dart`, not `mc.dart`)
3. **Documentation:** Include doc comments for all public properties
4. **Theming:** Always use `DesertColors` constants, never hardcoded colors
5. **Accessibility:** Add `Semantics` labels for screen readers
6. **Responsiveness:** Test on multiple screen sizes (iPhone SE → iPad Pro)

### Widget Checklist

- [ ] Uses const constructors where possible
- [ ] All colors from `DesertColors`
- [ ] All spacing from `DesertSpacing`
- [ ] Includes key parameter for testing
- [ ] Has meaningful Semantics labels
- [ ] Animations are 200-300ms
- [ ] Corner radii match UX framework (16px default)
- [ ] Shadows use standard preset (`0 4 8 rgba(0,0,0,0.08)`)

---

## 📝 Notes

- **MVP1 Widgets:** All listed widgets are built and in use
- **MVP2 Additions:** Breathing animation widget, manifestation card, future letter widget
- **Testing:** All widgets have corresponding widget tests in `test/widgets/`

---

**Last Updated:** 2025-10-23
**Maintained by:** Odyseya Documentation Agent
**Related Docs:** [SCREEN_MAP.md](./SCREEN_MAP.md), [ARCHITECTURE_OVERVIEW.md](./ARCHITECTURE_OVERVIEW.md)
