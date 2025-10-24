# Odyseya App - Complete Screens & Components Overview

## Table of Contents
1. [Screen Categories](#screen-categories)
2. [Detailed Screen Breakdown](#detailed-screen-breakdown)
3. [Custom Components Library](#custom-components-library)
4. [User Journey Flow](#user-journey-flow)

---

## Screen Categories

### 📱 Total Screens: 27

| Category | Count | Screens |
|----------|-------|---------|
| **Authentication & Marketing** | 3 | Splash, First Download, Auth Choice |
| **Authentication** | 2 | Login, Sign Up |
| **Onboarding** | 7 | GDPR, Permissions, Welcome, Q1-Q4, Success |
| **Daily Journaling (ACTION)** | 4 | Affirmation, Mood Selection, Recording, Review |
| **Reflection** | 2 | Dashboard, Calendar |
| **Inspiration** | 1 | Affirmation (separate from daily flow) |
| **Settings & Premium** | 2 | Settings, Paywall |
| **Navigation** | 1 | Main App Shell |
| **Utility** | 5 | Coming Soon, Debug, Marketing, etc. |

---

## Detailed Screen Breakdown

### 1. AUTHENTICATION & MARKETING FLOW

#### 1.1 Splash Screen
**File:** `lib/screens/splash_screen.dart`
**Purpose:** App launch animation with brand identity

**Components:**
- Spinning compass animation (outer ring rotates, inner crown static)
- Background desert image
- "Odyseya" brand text image
- Poetic quote: "Like a desert wanderer, discover your true self..."

**Technical:**
- Uses `AnimationController` for continuous rotation
- 8-second auto-navigation to `/auth`
- `SingleChildScrollView` to prevent overflow
- Local PoiretOne font (optimized, no Google Fonts)

**Navigation:**
- → `/auth` (Auth Choice Screen)

---

#### 1.2 First Download App Screen
**File:** `lib/screens/first_downloadapp_screen.dart`
**Purpose:** Initial marketing screen for new users

**Components:**
- Desert background with overlay
- App logo and tagline
- Two primary action buttons:
  - "Sign in" button (western sunrise gradient)
  - "Create account" button (outlined style)

**Technical:**
- Uses `AppBackground` widget with overlay
- Custom gradient buttons using `DesertColors.gradientWesternSunrise`
- 16px border radius (framework standard)

**Navigation:**
- "Sign in" → `/login`
- "Create account" → `/account-creation`

---

#### 1.3 Auth Choice Screen
**File:** `lib/screens/auth/auth_choice_screen.dart`
**Purpose:** Choose between login and sign up

**Components:**
- Desert background
- App branding
- "Sign In" button
- "Create Account" button
- Social auth options (if enabled)

**Navigation:**
- "Sign In" → `/login`
- "Create Account" → `/signup`

---

### 2. AUTHENTICATION SCREENS

#### 2.1 Login Screen ✅ (FIXED)
**File:** `lib/screens/auth/login_screen.dart`
**Purpose:** User authentication with email/password

**Components:**
- Back button (top-left)
- "Sign In" heading (H1 Large, 40px)
- Email input field (white card with shadow)
- Password input field (with show/hide toggle)
- "SIGN IN" button (western sunrise, 60px height)
- Error message container (red, if errors)

**State Management:**
- `authStateProvider` (Riverpod)
- `emailValidationProvider` for validation

**Technical:**
- Form validation
- Password visibility toggle
- Loading state shows spinner
- ✅ No debug credentials (removed)
- ✅ No auto-login (fixed)

**Navigation:**
- Back → `/first-download`
- Success → Router redirect to `/mood-selection` or onboarding

---

#### 2.2 Sign Up Screen
**File:** `lib/screens/auth/signup_screen.dart`
**Purpose:** New user registration

**Components:**
- Similar to Login Screen
- Email, Password, Confirm Password fields
- Terms acceptance checkbox
- "CREATE ACCOUNT" button

**State Management:**
- `authStateProvider`
- Password strength validation
- Email format validation

**Navigation:**
- Back → `/auth-choice`
- Success → Onboarding flow

---

### 3. ONBOARDING FLOW (7 Screens)

#### 3.1 GDPR Consent Screen
**File:** `lib/screens/onboarding/gdpr_consent_screen.dart`
**Purpose:** GDPR compliance and data consent

**Components:**
- `OnboardingLayout` wrapper
- Consent explanation text
- Checkboxes for:
  - Terms of Service
  - Privacy Policy
  - Marketing communications (optional)
- "Create Account" button (disabled until required checkboxes checked)
- Links to legal documents

**State Management:**
- Local state for checkbox tracking
- `authStateProvider` for account creation

**Navigation:**
- → `/onboarding/permissions`

---

#### 3.2 Permissions Screen
**File:** `lib/screens/onboarding/permissions_screen.dart`
**Purpose:** Request microphone and notification permissions

**Components:**
- `OnboardingLayout` wrapper
- Permission cards:
  - Microphone (required) - icon, title, description, status
  - Notifications (optional) - icon, title, description, status
- "CONTINUE" button (disabled until required permissions granted)

**Technical:**
- Uses `permission_handler` package
- Checks current permission status
- Opens system settings if denied
- Green checkmark when granted

**Navigation:**
- → `/onboarding/welcome`

---

#### 3.3 Welcome Screen
**File:** `lib/screens/onboarding/welcome_screen.dart`
**Purpose:** Welcome message and app introduction

**Components:**
- `OnboardingLayout` wrapper
- Welcome title
- Introduction text
- Feature highlights (3-4 cards):
  - Voice journaling
  - AI insights
  - Daily affirmations
  - Progress tracking
- "CONTINUE" button

**Navigation:**
- → `/onboarding/questionnaire-1`

---

#### 3.4-3.7 Questionnaire Screens (Q1-Q4)
**Files:**
- `lib/screens/onboarding/questionnaire_q1_screen.dart`
- `lib/screens/onboarding/questionnaire_q2_screen.dart`
- `lib/screens/onboarding/questionnaire_q3_screen.dart`
- `lib/screens/onboarding/questionnaire_q4_screen.dart`

**Purpose:** Collect user preferences and goals

**Q1 - Journaling Experience:**
- Options: Never tried, Beginner, Sometimes, Regular, Expert
- Single selection

**Q2 - Primary Goals:**
- Options: Stress relief, Self-discovery, Gratitude, Mental health, etc.
- Multiple selection

**Q3 - Preferred Time:**
- Options: Morning, Afternoon, Evening, Night, Flexible
- Single selection

**Q4 - Reminders:**
- Options: Daily reminder, Weekly check-in, No reminders
- Single selection with "Skip for now" option

**Components (all use):**
- `OnboardingLayout` wrapper
- Question text
- Option cards (selectable)
- Progress indicator (dots)
- "CONTINUE" button (or "Skip for now")

**State Management:**
- Local state for selections
- Data saved to `userProfileProvider` or Firestore

**Navigation Flow:**
- Q1 → Q2 → Q3 → Q4 → Onboarding Success

---

#### 3.8 Onboarding Success Screen
**File:** `lib/screens/onboarding/onboarding_success_screen.dart`
**Purpose:** Completion celebration and transition to app

**Components:**
- Success animation (checkmark or celebration)
- "You're all set!" message
- Personalized welcome message
- "START JOURNALING" button

**Navigation:**
- → `/mood-selection` (first journal entry)

---

### 4. DAILY JOURNALING FLOW (ACTION Phase)

#### 4.1 Affirmation Screen
**File:** `lib/screens/inspiration/affirmation_screen.dart`
**Purpose:** Display daily affirmation before journaling

**Components:**
- Desert background with overlay
- Affirmation card:
  - Quote text (large, elegant typography)
  - Author attribution
  - Fade-in animation
- "CONTINUE" button (bottom)
- Skip option (subtle, top-right)

**State Management:**
- `affirmationProvider` - fetches daily affirmation
- Animation controller for fade-in

**Technical:**
- Affirmations rotate daily
- Stored in Firestore or local JSON
- Smooth transition animations

**Navigation:**
- → `/mood-selection`
- Skip → `/mood-selection`

---

#### 4.2 Mood Selection Screen ⭐
**File:** `lib/screens/action/mood_selection_screen.dart`
**Purpose:** Select current mood before journaling

**Components:**
- Header with back button and settings icon
- "How are you feeling?" title
- `SwipeableMoodCards` widget:
  - 5 mood cards in horizontal PageView
  - Cards: Joyful, Calm, Stressed, Sad, Anxious
  - Each card shows:
    - Emoji or image
    - Mood label
    - Subtle description
  - Active card is larger (scale transform)
  - Dots indicator showing position
  - Counter: "2 of 5"
- "CONTINUE" button (disabled until mood selected)

**Custom Widgets:**
- `SwipeableMoodCards` - horizontal scrolling cards
- `MoodCard` - individual mood card with animation

**State Management:**
- `moodProvider` - tracks selected mood
- Local state for card index

**Technical:**
- PageController for swipe navigation
- AnimatedContainer for scale effects
- HapticFeedback on selection
- Border changes color when selected

**Navigation:**
- → `/recording` (with selected mood in state)

---

#### 4.3 Recording Screen ⭐⭐ (CORE)
**File:** `lib/screens/action/recording_screen.dart`
**Purpose:** Voice recording or text input for journal entry

**Components:**

**Header:**
- Back button (left)
- User greeting: "Hi [Name]" (center)
- Settings icon (right)

**Main Container (cream background):**
- Title: "What's on your mind?"
- Toggle buttons:
  - "Record" mode (selected: waterWash, unselected: white)
  - "Type" mode

**Record Mode:**
- `AudioWaveformWidget` (animated waveform bars)
- Timer display: "00:30" (current) and "2:30" (max)
- Large circular microphone button (waterWash, 100px)
  - Icon changes: mic → stop
  - Tap to start/stop recording

**Type Mode:**
- Large text input area (white background) ✅ FIXED
- Multi-line TextField
- Placeholder: "Share your thoughts..."
- Expands to fill space

**Footer:**
- "CONTINUE" button (western sunrise gradient, 60px)

**State Management:**
- `voiceJournalProvider` - recording state, duration, audio file
- `amplitudeStreamProvider` - real-time audio levels for waveform
- TextEditingController for typed text

**Technical:**
- Uses `record` package for audio
- Waveform visualizes amplitude in real-time
- Max recording: 2:30
- Auto-save to Firestore
- ✅ Text now visible (white background fixed)

**Navigation:**
- "CONTINUE" → `/review` (stops recording if active)
- Back → `/mood-selection` (discards recording)

---

#### 4.4 Review & Submit Screen
**File:** `lib/screens/action/review_submit_screen.dart`
**Purpose:** Review journal entry, transcription, and AI insights

**Components:**

**Header:**
- Back button
- "Review Your Entry" title

**Content (scrollable):**

1. **Mood Card** (top):
   - Selected mood icon/emoji
   - Mood label
   - Timestamp

2. **Audio Player** (if recorded):
   - Waveform visualization
   - Play/pause button
   - Duration: "0:45 / 2:15"
   - Volume slider

3. **Transcription Section:**
   - "Your Words" heading
   - Full transcribed text
   - Edit button (opens modal to edit)

4. **AI Insights Card:**
   - "Insights from Your Entry" heading
   - Emotional tone: "Calm and reflective" (with confidence %)
   - Detected triggers: "work stress, family"
   - Suggestions: 3-4 personalized suggestions
   - Insight preview text

5. **Tags Section:**
   - Auto-generated tags: #gratitude #selfcare
   - Add custom tag button

**Footer:**
- "SUBMIT" button (primary, western sunrise)
- "Save Draft" button (secondary, outlined)

**State Management:**
- `voiceJournalProvider` - audio file, transcription, AI analysis
- `journalEntryProvider` - saves to Firestore

**Technical:**
- Audio transcription via Whisper API
- AI analysis via Claude/GPT (Groq Llama 3)
- Real-time status indicators (processing...)
- Error handling for API failures

**Navigation:**
- "SUBMIT" → `/dashboard` or `/affirmation-complete`
- "Save Draft" → `/dashboard` (marked as draft)
- Back → `/recording` (resume editing)

---

### 5. REFLECTION SCREENS

#### 5.1 Dashboard Screen ⭐
**File:** `lib/screens/reflection/dashboard_screen.dart`
**Purpose:** Main home screen showing journal overview and stats

**Components:**

**Header:**
- User greeting: "Welcome back, [Name]"
- Current date
- Settings icon (top-right)

**Stats Cards Row:**
- Current streak: "🔥 7 days"
- This week: "5 entries"
- Mood trend: Graph icon + "Improving"

**Quick Actions:**
- "Start New Journal" button (large, prominent)
- "View Calendar" button

**Recent Entries List:**
- Last 5 journal entries
- Each card shows:
  - Date and time
  - Mood icon
  - Preview text (first 2 lines)
  - Tap to view full entry

**Insights Section:**
- Weekly summary card
- Most frequent mood
- Common themes/tags
- AI-generated weekly insight

**Bottom Navigation Bar:**
- Dashboard (active)
- Calendar
- Home/New Entry
- Settings

**State Management:**
- `dashboardProvider` - stats, recent entries
- `calendarProvider` - streak calculation
- `journalEntryProvider` - fetch entries

**Technical:**
- Lazy loading for old entries
- Pull-to-refresh
- Skeleton loading states

**Navigation:**
- "Start New Journal" → `/mood-selection`
- Entry card → `/entry-detail/:id`
- Calendar button → `/calendar`

---

#### 5.2 Calendar Screen ⭐
**File:** `lib/screens/reflection/journal_calendar_screen.dart`
**Purpose:** Monthly calendar view of journal entries

**Components:**

**Header:**
- Back button
- "Your Journal" title
- Month/Year: "January 2025"
- Previous/Next month arrows

**Statistics Bar:**
- Current streak: "7 days"
- Completion rate: "80% this month"
- Total entries: "24"
- Most frequent mood: emoji

**Calendar Widget:**
- Grid of dates (7x5 or 7x6)
- Current month highlighted
- Days with entries:
  - Colored dot/border
  - Mood indicator color
- Selected date has border
- Future dates grayed out

**Entry Preview (bottom):**
- Shows when date selected
- Entry count: "3 entries on this date"
- List of entries with mood + preview
- Tap to expand full entry

**Empty State (if date selected has no entries):**
- "No entries on this date"
- If today: "Start Journaling" button

**State Management:**
- `calendarProvider` - month data, entries by date
- Entry loading and caching

**Technical:**
- Custom calendar grid builder
- Efficient date calculation
- ✅ Uses GoRouter for navigation (fixed)

**Navigation:**
- Entry card → `/entry-detail/:id`
- "Start Journaling" → `/mood-selection` ✅ FIXED

---

### 6. SETTINGS & PREMIUM

#### 6.1 Settings Screen
**File:** `lib/screens/settings/settings_screen.dart` (1,392 lines)
**Purpose:** App configuration and account management

**Components:** (Organized in sections)

**1. Profile Section:**
- Avatar/photo
- Name
- Email
- Edit profile button

**2. Notifications:**
- Daily reminder toggle
- Reminder time picker
- Weekly summary toggle
- Push notification permission status

**3. Journal Settings:**
- Auto-transcribe toggle
- Language selection
- Voice quality preference
- Max recording duration

**4. AI & Privacy:**
- AI insights toggle
- Data sharing preferences
- Download my data
- Delete account

**5. Premium Section:**
- Current plan badge (Free/Premium)
- "Upgrade to Premium" button
- Feature comparison list
- Restore purchases

**6. About:**
- App version
- Terms of Service
- Privacy Policy
- Contact support
- Rate app

**State Management:**
- `settingsProvider` - all settings
- `authStateProvider` - account info
- `premiumProvider` - subscription status

**Technical:**
- Form validation
- Platform-specific settings
- Deep links to system settings

**Navigation:**
- "Upgrade" → `/paywall`
- Legal docs → WebView or external
- Profile edit → Modal

---

#### 6.2 Paywall Screen
**File:** `lib/screens/paywall_screen.dart` (892 lines)
**Purpose:** Premium subscription upsell

**Components:**

**Hero Section:**
- "Unlock Premium" title
- Feature highlights (animated):
  - Unlimited recordings
  - Advanced AI insights
  - Export options
  - Priority support
  - Ad-free experience

**Pricing Cards:**
- Monthly plan: $4.99/mo
- Annual plan: $39.99/yr (save 33%)
- Lifetime: $99.99 (one-time)
- Each shows:
  - Price
  - Billing period
  - Feature list
  - "Subscribe" button

**Social Proof:**
- User testimonials
- Rating stars
- "Join 10,000+ users"

**Footer:**
- Terms of Service
- Privacy Policy
- Restore purchases button

**State Management:**
- `revenueCatProvider` - subscription management
- `paywallProvider` - selected plan

**Technical:**
- RevenueCat integration
- iOS/Android StoreKit
- Receipt validation
- Restore purchases flow

**Navigation:**
- Subscribe success → Confirmation modal → Close
- "No thanks" → Back to previous screen

---

### 7. NAVIGATION & SHELL

#### 7.1 Main App Shell
**File:** `lib/screens/main_app_shell.dart`
**Purpose:** Container with bottom navigation for main app screens

**Components:**
- `AppBackground` wrapper with overlay
- Main screen area (changes based on route)
- `OdyseyaBottomNavigationBar`:
  - Dashboard (index 0)
  - Home/New Entry (index 1)
  - Calendar (index 2)
  - Settings (removed from bottom nav)

**State Management:**
- `navigationIndexProvider` - current tab index
- GoRouter location tracking

**Routes Handled:**
- `/dashboard` → Dashboard Screen
- `/home` or `/main` → Mood Selection Screen
- `/journal` → Recording Screen ✅ FIXED (now uses RecordingScreen)
- `/calendar` → Calendar Screen

**Technical:**
- Persistent navigation state
- Smooth transitions between tabs
- SafeArea handling

---

## Custom Components Library

### Core UI Components

#### 1. AppBackground
**File:** `lib/widgets/common/app_background.dart`
**Purpose:** Consistent desert background across app

**Props:**
- `useOverlay` (bool) - add white overlay
- `overlayOpacity` (double) - opacity of overlay (0.0-1.0)
- `child` (Widget) - content to display

**Usage:** Wrap any screen for consistent background

---

#### 2. OdyseyaButton
**File:** `lib/widgets/common/odyseya_button.dart`
**Purpose:** Consistent button styling

**Variants:**
- Primary (western sunrise gradient)
- Secondary (outlined)
- Text button
- Disabled state

**Props:**
- `text` (String)
- `onPressed` (VoidCallback?)
- `variant` (ButtonVariant enum)
- `isLoading` (bool)
- `height` (double?) - default 60px

---

### Mood & Input Components

#### 3. SwipeableMoodCards
**File:** `lib/widgets/common/swipeable_mood_cards.dart`
**Purpose:** Horizontal swipeable mood selector

**Props:**
- `moods` (List<Mood>)
- `onMoodSelected` (Function(Mood))
- `selectedMood` (Mood?)

**Features:**
- PageView with viewportFraction: 0.85
- Scale transform on active card
- Dots indicator
- Counter display
- Haptic feedback

---

#### 4. MoodCard
**File:** `lib/widgets/common/mood_card.dart`
**Purpose:** Individual mood card with selection state

**Props:**
- `mood` (Mood model)
- `isSelected` (bool)
- `onTap` (VoidCallback?)

**Features:**
- Press animation (scale down)
- Border color changes when selected
- Shadow elevation changes
- Optimized image caching (300x300)

---

### Voice Recording Components

#### 5. RecordButton
**File:** `lib/widgets/voice_recording/record_button.dart`
**Purpose:** Animated recording button

**States:**
- Idle (mic icon)
- Recording (stop icon, pulsing)
- Processing (spinner)

**Features:**
- Pulse animation during recording
- Haptic feedback
- Size: 100x100px circle

---

#### 6. AudioWaveformWidget
**File:** `lib/widgets/voice_recording/audio_waveform_widget.dart`
**Purpose:** Real-time audio visualization

**Props:**
- `amplitudeStream` (Stream<double>?)
- `isRecording` (bool)
- `isPaused` (bool)
- `waveColor` (Color)
- `height` (double)
- `barCount` (int)

**Features:**
- 50 animated bars
- Updates 30 times per second
- Smooth interpolation
- Color: waterWash (#A6D8EE)

---

### Calendar Components

#### 7. CalendarWidget
**File:** `lib/widgets/calendar/calendar_widget.dart`
**Purpose:** Monthly calendar grid with entry indicators

**Props:**
- `currentMonth` (DateTime)
- `selectedDate` (DateTime?)
- `entriesByDate` (Map<DateTime, List<JournalEntry>>)
- `onDateSelected` (Function(DateTime))
- `isLoading` (bool)

**Features:**
- 7-column grid (Sun-Sat)
- Entry count badges
- Mood color indicators
- Today highlight
- Selection state

---

#### 8. StatisticsBar
**File:** `lib/widgets/calendar/statistics_bar.dart`
**Purpose:** Display journal statistics

**Props:**
- `streak` (int)
- `completionRate` (double)
- `totalEntries` (int)
- `mostFrequentMood` (String)

---

#### 9. EntryPreviewCard
**File:** `lib/widgets/calendar/entry_preview_card.dart`
**Purpose:** Preview journal entries for selected date

**Props:**
- `entries` (List<JournalEntry>)
- `selectedDate` (DateTime)

---

### Navigation Components

#### 10. OdyseyaBottomNavigationBar
**File:** `lib/widgets/navigation/bottom_navigation_bar.dart`
**Purpose:** App-wide bottom navigation

**Props:**
- `currentIndex` (int)
- `onTap` (Function(int))

**Items:**
- Dashboard (calendar icon)
- Home (home icon)
- Calendar (calendar icon)

**Styling:**
- Cream background
- Active: caramel drizzle color
- Inactive: tree branch color
- Height: 80px
- Top shadow

---

### Onboarding Components

#### 11. OnboardingLayout
**File:** `lib/widgets/onboarding/onboarding_layout.dart`
**Purpose:** Consistent layout for onboarding screens

**Props:**
- `title` (String)
- `subtitle` (String?)
- `content` (Widget)
- `primaryButtonText` (String)
- `onPrimaryButtonPressed` (VoidCallback?)
- `secondaryButtonText` (String?)
- `onSecondaryButtonPressed` (VoidCallback?)
- `showBackButton` (bool)
- `progress` (double?) - 0.0 to 1.0

**Features:**
- Desert background
- Progress bar at top
- Back button (if enabled)
- Scrollable content
- Fixed footer with buttons

---

### AI & Analysis Components

#### 12. InsightCard
**File:** `lib/widgets/ai/insight_card.dart`
**Purpose:** Display AI-generated insights

**Props:**
- `insight` (Insight model)
- `onTap` (VoidCallback?)

**Shows:**
- Icon/emoji
- Title
- Description
- Confidence indicator
- Expand/collapse toggle

---

#### 13. TranscriptionWidget
**File:** `lib/widgets/ai/transcription_widget.dart`
**Purpose:** Editable transcription display

**Props:**
- `transcription` (String)
- `onEdit` (Function(String))
- `isLoading` (bool)

**Features:**
- Read-only view
- Edit mode (tap to edit)
- Auto-save on change
- Loading skeleton

---

### Auth Components

#### 14. AuthForm
**File:** `lib/widgets/auth/auth_form.dart`
**Purpose:** Reusable authentication form fields

**Features:**
- Email field with validation
- Password field with show/hide
- Consistent styling
- Error messages
- Loading states

---

## User Journey Flow

### New User Journey

```
Splash Screen (8s)
    ↓
First Download App
    ↓ "Create account"
GDPR Consent
    ↓
Permissions (Mic + Notifications)
    ↓
Welcome Screen
    ↓
Questionnaire Q1 (Experience)
    ↓
Questionnaire Q2 (Goals)
    ↓
Questionnaire Q3 (Time Preference)
    ↓
Questionnaire Q4 (Reminders)
    ↓
Onboarding Success
    ↓
───────────────────────────
DAILY JOURNALING FLOW:
───────────────────────────
Affirmation Screen
    ↓
Mood Selection
    ↓
Recording Screen (Voice or Type)
    ↓
Review & Submit (with AI insights)
    ↓
Dashboard (entry saved)
```

### Returning User Journey

```
Splash Screen (8s)
    ↓
[Auto-login if session exists]
    ↓
Dashboard
    ↓ "Start New Journal"
Affirmation (optional, daily)
    ↓
Mood Selection
    ↓
Recording
    ↓
Review & Submit
    ↓
Dashboard (updated)
```

### Alternative Flows

**Calendar View:**
```
Dashboard
    ↓ Bottom nav → Calendar
Calendar Screen
    ↓ Tap date
Entry Preview
    ↓ Tap entry
Entry Detail Screen
```

**Settings:**
```
Dashboard
    ↓ Top nav → Settings
Settings Screen
    ↓ "Upgrade to Premium"
Paywall Screen
    ↓ Subscribe
[RevenueCat flow]
    ↓
Settings (updated status)
```

---

## Design System Summary

### Colors (DesertColors)
- **Primary:** westernSunrise (#D8A36C) - buttons, accents
- **Background:** creamBeige (#FAF6F1) - main containers
- **Surface:** cardWhite (#FFFFFF) - cards, inputs
- **Text Primary:** brownBramble (#6B4E3D) - headings, body
- **Text Secondary:** treeBranch (#8B7355) - labels, hints
- **Accent:** waterWash (#A6D8EE) - recording, selected states
- **Gradient:** gradientDesertDawn, gradientWesternSunrise

### Typography (OdyseyaTypography)
- **H1 Large:** 40px, SemiBold (sign in titles)
- **H1:** 28px, SemiBold (screen titles)
- **H2:** 24px, SemiBold (section headings)
- **Body Large:** 18px, Regular (main content)
- **Body:** 16px, Regular (secondary content)
- **Button Large:** 18px, SemiBold, uppercase
- **Hint:** 16px, Regular (placeholders)

### Spacing
- xs: 8px
- sm: 16px
- md: 24px
- lg: 32px
- xl: 40px
- xxl: 48px

### Border Radius
- Standard: 16px (buttons, cards)
- Small: 8px (tags, badges)
- Large: 24px (sheets, modals)

### Shadows
- Light: alpha 0.04-0.08, blur 4-8px
- Medium: alpha 0.08-0.12, blur 8-12px
- Heavy: alpha 0.15-0.20, blur 15-20px

---

## File Structure

```
lib/
├── screens/
│   ├── splash_screen.dart
│   ├── first_downloadapp_screen.dart
│   ├── auth/
│   │   ├── auth_choice_screen.dart
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── onboarding/
│   │   ├── gdpr_consent_screen.dart
│   │   ├── permissions_screen.dart
│   │   ├── welcome_screen.dart
│   │   ├── questionnaire_q1_screen.dart
│   │   ├── questionnaire_q2_screen.dart
│   │   ├── questionnaire_q3_screen.dart
│   │   ├── questionnaire_q4_screen.dart
│   │   └── onboarding_success_screen.dart
│   ├── action/
│   │   ├── mood_selection_screen.dart
│   │   ├── recording_screen.dart
│   │   └── review_submit_screen.dart
│   ├── inspiration/
│   │   └── affirmation_screen.dart
│   ├── reflection/
│   │   ├── dashboard_screen.dart
│   │   └── journal_calendar_screen.dart
│   ├── settings/
│   │   └── settings_screen.dart
│   ├── paywall_screen.dart
│   └── main_app_shell.dart
│
├── widgets/
│   ├── common/
│   │   ├── app_background.dart
│   │   ├── odyseya_button.dart
│   │   ├── mood_card.dart
│   │   └── swipeable_mood_cards.dart
│   ├── voice_recording/
│   │   ├── record_button.dart
│   │   └── audio_waveform_widget.dart
│   ├── calendar/
│   │   ├── calendar_widget.dart
│   │   ├── statistics_bar.dart
│   │   └── entry_preview_card.dart
│   ├── navigation/
│   │   └── bottom_navigation_bar.dart
│   ├── onboarding/
│   │   └── onboarding_layout.dart
│   ├── ai/
│   │   ├── insight_card.dart
│   │   └── transcription_widget.dart
│   └── auth/
│       └── auth_form.dart
│
├── constants/
│   ├── colors.dart
│   ├── typography.dart
│   └── spacing.dart
│
├── providers/
│   ├── auth_provider.dart
│   ├── voice_journal_provider.dart
│   ├── mood_provider.dart
│   ├── calendar_provider.dart
│   ├── dashboard_provider.dart
│   └── settings_provider.dart
│
└── config/
    └── router.dart
```

---

## Key Navigation Routes

| Route | Screen | Access |
|-------|--------|--------|
| `/` | SplashScreen | Public |
| `/first-download` | FirstDownloadAppScreen | Public |
| `/auth` | AuthChoiceScreen | Public |
| `/login` | LoginScreen | Public |
| `/signup` | SignUpScreen | Public |
| `/onboarding/*` | Onboarding flow | Authenticated |
| `/mood-selection` | MoodSelectionScreen | Authenticated |
| `/recording` | RecordingScreen | Authenticated |
| `/review` | ReviewSubmitScreen | Authenticated |
| `/dashboard` | DashboardScreen | Authenticated |
| `/calendar` | JournalCalendarScreen | Authenticated |
| `/settings` | SettingsScreen | Authenticated |
| `/paywall` | PaywallScreen | Authenticated |

---

**Document Generated:** January 23, 2025
**Status:** ✅ All screens compliant with UX framework
**Total Screens:** 27
**Total Components:** 14+
**Total Providers:** 12+
