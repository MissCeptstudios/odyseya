# Odyseya App - Complete Screen & Component Architecture Documentation

## Overview
This document provides a comprehensive analysis of all screens, components, and widgets in the Odyseya voice journaling app. The app follows a desert-inspired design system with emotional journey phases: ACTION (recording), REFLECTION (review/calendar), INSPIRATION (affirmations), and RENEWAL (coming soon).

---

## Table of Contents
1. [Screen Categories & Flow](#screen-categories--flow)
2. [Authentication Flow](#authentication-flow)
3. [Onboarding Flow](#onboarding-flow)
4. [Main Application Screens](#main-application-screens)
5. [Action Flow Screens](#action-flow-screens)
6. [Reflection Screens](#reflection-screens)
7. [Inspiration Screens](#inspiration-screens)
8. [Settings & Premium](#settings--premium)
9. [Component/Widget Library](#componentwidget-library)
10. [State Management (Providers)](#state-management-providers)
11. [Design Patterns & Reusable Patterns](#design-patterns--reusable-patterns)

---

## Screen Categories & Flow

### User Journey Map
```
SPLASH → FIRST DOWNLOAD → AUTH → ONBOARDING → HOME → AFFIRMATION → JOURNAL JOURNEY
```

### Screen Organization by Phase
- **Splash & Marketing**: SplashScreen, FirstDownloadAppScreen
- **Authentication**: AuthChoiceScreen, LoginScreen, SignUpScreen
- **Onboarding**: GdprConsentScreen, PermissionsScreen, WelcomeScreen, Questionnaire (Q1-Q4), OnboardingSuccessScreen
- **Daily Flow**: AffirmationScreen → MoodSelectionScreen → RecordingScreen → ReviewSubmitScreen
- **Reflection**: DashboardScreen, JournalCalendarScreen
- **Premium**: PaywallScreen
- **Settings**: SettingsScreen

---

## Authentication Flow

### 1. AuthChoiceScreen
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/auth/auth_choice_screen.dart`
- **Purpose**: First decision point - Sign In vs Create Account
- **Components Used**:
  - Compass logo (static + outer ring overlay)
  - Odyseya word logo
  - Two main action buttons (Sign In / Create Account)
- **Key Features**:
  - App background with desert theme
  - Two prominent buttons with different styles
  - Navigation: → /login or /signup
- **Design System**: Primary button (#D8A36C westernSunrise), secondary outlined button
- **No State Management**: Pure navigation screen

### 2. LoginScreen
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/auth/login_screen.dart`
- **Purpose**: Existing user authentication
- **Components Used**:
  - Email TextFormField with validation
  - Password TextFormField with visibility toggle
  - Sign In button (primary style)
  - Error message container
  - Back navigation button
- **State Management**: 
  - `authStateProvider` (watching for sign in state)
  - `emailValidationProvider` (custom validator)
  - Calls `authStateProvider.notifier.signInWithEmail()`
- **Navigation**: ← /first-download, → /home (via redirect on auth success)
- **Key Features**:
  - Real-time form validation
  - Loading state handling with progress indicator
  - Error display with visual feedback
  - Password visibility toggle
  - Landscape background image

### 3. SignUpScreen
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/auth/signup_screen.dart`
- **Purpose**: New user account creation
- **Components Used**:
  - Name TextFormField
  - Email TextFormField
  - Password TextFormField (with visibility toggle)
  - Confirm Password TextFormField (with visibility toggle)
  - Continue button (primary style)
  - Error message container
  - Back navigation button
- **State Management**: 
  - `authStateProvider` (for error handling)
  - `emailValidationProvider` (email validation)
  - `passwordValidationProvider` (password strength)
  - `confirmPasswordValidationProvider` (password matching)
- **Navigation**: ← /first-download, → /gdpr-consent
- **Key Features**:
  - Multi-field form with validation
  - Password confirmation matching
  - Visual feedback for errors
  - Smooth transitions between screens

---

## Onboarding Flow

### 0. FirstDownloadAppScreen (Pre-Auth Marketing)
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/first_downloadapp_screen.dart`
- **Purpose**: Marketing screen shown after splash
- **Components Used**:
  - Compass logo
  - Odyseya text logo
  - Sign In button
  - Create Account button
- **Navigation**: → /login or /signup
- **Design**: Desert background, prominent CTAs

### 1. GdprConsentScreen
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/onboarding/gdpr_consent_screen.dart`
- **Purpose**: Legal consent for terms and privacy
- **Components Used**:
  - Checkbox groups (Terms, Privacy, Marketing)
  - Custom `_buildConsentItem()` widget
  - Info cards with security assurance message
  - OdyseyaButton for "Create Account"
  - Modal dialogs for full policy documents
- **State Management**: Local state (3 checkboxes)
- **Navigation**: ← /signup, → /welcome
- **Key Features**:
  - Required vs optional consent tracking
  - "Read more" links open full document modals
  - Policy documents embedded with dynamic date stamps
  - EU AI Act transparency information

### 2. PermissionsScreen
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/onboarding/permissions_screen.dart`
- **Purpose**: Request system permissions (microphone, notifications, location)
- **Components Used**:
  - Custom `_buildPermissionCard()` widget
  - Toggle switches
  - Permission icons and descriptions
  - Required/Optional badges
  - OnboardingLayout wrapper
- **State Management**: 
  - `onboardingProvider` (tracks permission state)
  - `notificationProvider` (for notification setup)
  - Uses `permission_handler` package
- **Navigation**: → /welcome
- **Key Features**:
  - Visual toggle switches showing granted status
  - Graceful error handling for permission failures
  - Both required (mic) and optional permissions
  - Settings link for manual permission changes

### 3. WelcomeScreen
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/onboarding/welcome_screen.dart`
- **Purpose**: Feature value proposition before questionnaire
- **Components Used**:
  - OdyseyaScreenLayout wrapper
  - Feature cards (`_buildFeatureCard()`) with icons
  - Trust badges (`_buildTrustBadge()`)
  - Container cards with borders and shadows
- **Features Highlighted**:
  - Voice Journaling
  - AI Insights
  - Privacy First
  - GDPR Compliance badge
  - End-to-End Encryption badge
  - Privacy Focused badge
- **Navigation**: → /onboarding/questionnaire/q1
- **Design System**: Uses DesertColors, proper spacing, accent highlights

### 4. Questionnaire Screens (Q1-Q4)
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/onboarding/questionnaire_q[1-4]_screen.dart`
- **Purpose**: Gather user context for personalization
- **Common Structure**:
  - OdyseyaScreenLayout wrapper
  - Step indicator (e.g., "1 of 4")
  - Multiple choice options in cards
  - Selected state highlighting
  - Continue button (enabled when selection made)

#### Q1: Goals/Hopes
- **Question**: "What do you hope Odyseya will help you with?"
- **Options**: breakup_loss, stress/anxiety, self-reflection, creativity, daily_grounding, habit_building, memory_keeping
- **Selection**: Multiple choice allowed

#### Q2-Q4: Similar multi-choice flows
- User preferences and emotional goals
- Journaling experience level
- Privacy and data preferences

**State Management**: 
- `onboardingProvider` stores responses in q1Goals, q2Preferences, etc.
- Local state in each questionnaire widget

**Navigation**: Sequential flow Q1→Q2→Q3→Q4→success

### 5. OnboardingSuccessScreen
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/onboarding/onboarding_success_screen.dart`
- **Purpose**: Celebration screen after onboarding completion
- **Components Used**:
  - Animated success checkmark (scale animation)
  - Animated text content (fade animation)
  - Info card with encouragement
  - Continue button
  - Auto-navigate after 3 seconds
- **Animations**:
  - Scale animation for checkmark (elasticOut curve)
  - Fade animation for text (easeInOut curve)
  - Staggered timing (300ms delay between animations)
- **Navigation**: Auto-navigates to /home after 3 seconds, manual button also available

---

## Main Application Screens

### MainAppShell (Bottom Navigation Container)
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/main_app_shell.dart`
- **Purpose**: Root container for main app with bottom navigation
- **Components Used**:
  - OdyseyaBottomNavigationBar (custom nav bar)
  - AppBackground wrapper
  - SafeArea container
  - Dynamic screen routing
- **Navigation Structure**:
  - Index 0: /dashboard → DashboardScreen
  - Index 1: /home → MoodSelectionScreen  
  - Index 2: /journal → RecordingScreen
  - Index 3: /calendar → JournalCalendarScreen
- **State Management**: 
  - Reads current location from GoRouter
  - Maps route to appropriate screen
- **Key Feature**: Seamless tab switching with persistent background

---

## Action Flow Screens

### 1. MoodSelectionScreen (Home Tab)
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/action/mood_selection_screen.dart`
- **Purpose**: User selects current mood before journaling
- **Components Used**:
  - SwipeableMoodCards widget
  - AppBar with back/settings buttons
  - Continue button (enabled when mood selected)
  - AppBackground wrapper
- **Mood Options**: Uses Mood.defaultMoods (typically 5 emotion cards)
- **State Management**: 
  - `moodProvider` watches selected mood state
  - Calls `moodProvider.notifier.selectMood()`
  - Router redirect enforces mood selection before journal access
- **Navigation**: ← /dashboard, → /main (after mood selection)
- **Design Pattern**: Swipeable card carousel with dots indicator

### 2. RecordingScreen (Journal Tab)
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/action/recording_screen.dart`
- **Purpose**: Main voice recording and text input interface
- **Components Used**:
  - AudioWaveformWidget (real-time visual feedback)
  - RecordButton (custom circular record button)
  - Toggle buttons (Record/Type mode)
  - TextFormField for typing mode
  - Timer display (current / max duration)
  - Custom navigation bar
- **Dual Modes**:
  - **Record Mode**: 
    - Audio waveform visualization
    - Record/stop button
    - Duration timer (2:30 max)
  - **Type Mode**:
    - Full-screen text input area
    - Multi-line text field
    - Hint: "Share your thoughts..."
- **State Management**: 
  - `voiceJournalProvider` handles recording state
  - Tracks isRecording, isPaused, recordingDuration
  - Amplitude stream for waveform visualization
- **Navigation**: → /review (after recording/typing)
- **Header**: "Hi [User]" greeting with back and settings buttons
- **Design**: Cream/beige content area inside desert background

### 3. ReviewSubmitScreen
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/action/review_submit_screen.dart`
- **Purpose**: Review recording and add mood/final touches before submission
- **Components Used**:
  - Mood selection horizontal list (5 emojis)
  - Entry preview card showing recording details
  - Mood cards with emoji and label
  - Submit button (enabled when mood selected)
  - Desert background
- **Content Review**:
  - Recording duration display
  - "Tap to play and review" prompt
  - Voice icon indicating audio entry
- **Mood Selection**: Horizontal scrollable list of mood chips
- **State Management**: 
  - `voiceJournalProvider` for entry data
  - Local selectedMood state
  - Calls `notifier.selectMood()` then `notifier.saveEntry()`
- **Navigation**: → /calendar (after successful save)
- **Error Handling**: SnackBar messages for validation and save status
- **Key Features**:
  - Visual mood feedback (colored borders on selection)
  - Loading state during save
  - Success/error messaging with appropriate colors

---

## Reflection Screens

### 1. DashboardScreen
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/reflection/dashboard_screen.dart`
- **Purpose**: Overview of user's emotional journey, insights, and statistics
- **Components Used**:
  - `_buildJourneyHeader()` - User's objective + edit button
  - `_buildExportWidget()` - Export journal as PDF
  - `_buildMoodAndStreakCard()` - Statistics card
    - Streak display with fire emoji
    - Most frequent mood display
    - Sparkline graph showing weekly mood trends
    - Refresh button
  - `_buildJournalHighlights()` - Horizontal scrollable recent entries
  - `_buildInsightsCard()` - AI-generated insights
  - `_buildRecommendationCard()` - Book recommendation
  - Inline reusable widgets: `_SectionCard`, `_Pill`, `_MiniStat`, `_Sparkline`, `_JournalCard`, `_OutlinedButton`
- **State Management**: Local state
  - objective (editable user goal)
  - journalEntries (sample data)
  - insight (randomized AI insight)
  - streak tracking
  - mood trends
- **Key Features**:
  - Gradient header with user objective
  - Export functionality modal
  - Refresh insights button
  - Recent journal highlights with swipe
  - Book recommendation based on journey
- **Design Pattern**: Stacked cards with spacing, consistent shadow/radius treatment

### 2. JournalCalendarScreen
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/reflection/journal_calendar_screen.dart`
- **Purpose**: Calendar view of all journal entries with daily details
- **Components Used**:
  - CalendarWidget (custom calendar with entry indicators)
  - StatisticsBar (streak, completion, entries count, mood)
  - EntryPreviewCard (expanded view of selected date's entries)
  - AppBar with title
  - Month navigation buttons
- **State Management**: 
  - `calendarProvider` 
  - Tracks currentMonth, selectedDate
  - Provides entriesByDate, selectedDateEntries
  - monthlyCompletionRate, currentStreak calculations
- **Interactivity**:
  - Click date to view entries
  - Navigate months with arrow buttons
  - Shows only dates with entries (visual indicators)
- **Navigation**: Part of MainAppShell tab system

---

## Inspiration Screens

### AffirmationScreen
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/inspiration/affirmation_screen.dart`
- **Purpose**: Display personalized daily affirmation before journaling
- **Components Used**:
  - Quote icon in circular container
  - Large affirmation text (24px, Inter font)
  - Attribution: "Based on your recent reflections"
  - Continue to Journal button (primary)
  - Skip button (text button)
- **Animations**:
  - Fade-in for header text (250ms)
  - Scale-in for affirmation content (250ms, easeOutBack)
  - Slide-in for buttons with fade (250ms)
  - Staggered timing with delays
- **State Management**: 
  - `affirmationProvider` 
  - Fetches AI-generated affirmation based on recent entries
  - Loading state with spinner
  - Error fallback with motivational quote
  - Tracks lastEntry for context
- **Navigation**: → /home (mood selection screen)
- **Design**: White content card on desert background with proper spacing
- **Loading States**:
  - Loading: "Crafting your personal affirmation..."
  - Error: "Welcome back to your journey..."
  - Success: Displays affirmation text

---

## Settings & Premium

### SettingsScreen
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/settings/settings_screen.dart`
- **Purpose**: User preferences, notifications, subscription, data management
- **Main Sections**:
  - Premium Subscription section
  - Notifications (daily reminders, reminder time, test notification)
  - Privacy (AI analysis toggle, data export, account deletion)
  - About & Help (version, contact, feedback)
  - Legal (terms, privacy policy, open source licenses)
- **Components Used**:
  - Custom `_buildSettingsTile()` for each row
  - Switch toggles for boolean settings
  - Time picker for reminder time
  - Settings grouped by section with `_buildSettingsSection()`
  - AppBackground wrapper
- **State Management**:
  - `settingsProvider` (user preferences)
  - `notificationProvider` (notification permissions and state)
  - `subscriptionProvider` (premium status)
  - `journalProvider` (for data export)
- **Key Features**:
  - Premium badge/banner
  - Toggle daily reminders with time selection
  - Test notification button
  - Data export to JSON
  - Account deletion confirmation
  - Platform-specific settings links (app_settings package)
- **Navigation**: Accessible from top navigation in various screens

### PaywallScreen
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/screens/paywall_screen.dart`
- **Purpose**: Present premium subscription options
- **Components Used**:
  - Feature list highlighting premium features
  - Package selection cards (monthly/annual/lifetime)
  - Price display with savings badge for annual
  - "Subscribe Now" button
  - Terms link at bottom
  - Loading state with spinner
  - Error state fallback
- **State Management**: 
  - `subscriptionProvider`
  - RevenueCat integration for pricing
  - Handles offerings loading and purchase processing
- **Premium Features**:
  - Unlimited journal entries
  - Advanced AI insights
  - Export to PDF
  - Ad-free experience
  - Priority support

---

## Component/Widget Library

### Common UI Components

#### 1. OdyseyaButton
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/common/odyseya_button.dart`
- **Purpose**: Unified button component across entire app
- **Variants**:
  - `.primary`: #D8A36C background, white text (emotional peak CTA)
  - `.secondary`: #FFFDF8 beige background, brown text
  - `.tertiary`: Transparent with border, brown text
- **Dimensions**: 60px height, 16px border radius
- **Features**:
  - Optional icon with text
  - Loading state with spinner
  - Disabled state styling
  - Full-width or custom width
- **Used In**: Nearly every screen for primary actions

#### 2. AppBackground
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/common/app_background.dart`
- **Purpose**: Consistent desert background across screens
- **Features**:
  - Desert-themed image (Background_F.png)
  - Optional overlay with configurable opacity
  - SafeArea aware
- **Props**: useOverlay (bool), overlayOpacity (0.0-1.0)
- **Used In**: Nearly every main app screen

#### 3. OdyseyaScreenLayout
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/common/odyseya_screen_layout.dart`
- **Purpose**: Wrapper for consistent onboarding/questionnaire screens
- **Features**:
  - Title and subtitle
  - Step indicator (current/total)
  - Primary button at bottom
  - Scrollable child content
  - Back navigation
- **Props**: title, subtitle, primaryButtonText, onPrimaryPressed, child, totalSteps, currentStep
- **Used In**: Welcome, Questionnaire Q1-Q4 screens

#### 4. SwipeableMoodCards
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/common/swipeable_mood_cards.dart`
- **Purpose**: Interactive mood selection carousel
- **Features**:
  - PageView with cards
  - Dots indicator + counter ("1 of 5")
  - Scale animation for non-active cards
  - Selection state management
  - Smooth scrolling with physics
- **Props**: moods (List<Mood>), onMoodSelected (callback), selectedMood (Mood?)
- **Used In**: MoodSelectionScreen, Review screens

#### 5. MoodCard
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/common/mood_card.dart`
- **Purpose**: Individual mood option display
- **Features**:
  - Mood emoji (large)
  - Mood label text
  - Selected/unselected state styling
  - Tap callback
  - Color-coded border when selected
- **Props**: mood (Mood), isSelected (bool), onTap (callback)
- **Used In**: SwipeableMoodCards (indirectly), Review screens

#### 6. OdyseyaButton Variants (smaller)
**File**: Contains auth-specific buttons and form inputs
- Custom styled buttons for auth flows
- Form validation visual feedback
- Error state styling

### Audio & Voice Components

#### 1. AudioWaveformWidget
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/voice_recording/audio_waveform_widget.dart`
- **Purpose**: Real-time audio amplitude visualization
- **Features**:
  - Animated bars showing audio levels
  - Configurable bar count and height
  - Recording/paused state indication
  - Color customization
  - Stream-based updates
- **Props**: amplitudeStream, isRecording, isPaused, waveColor, height, barCount
- **Used In**: RecordingScreen (record mode)

#### 2. RecordButton
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/voice_recording/record_button.dart`
- **Purpose**: Primary microphone recording control
- **Features**:
  - Circular button with icon (mic/stop)
  - Recording state visual feedback
  - Tap to toggle recording
  - Shadow effects
- **Props**: onPressed (callback), isRecording (bool)
- **Used In**: RecordingScreen

### Calendar & Timeline Components

#### 1. CalendarWidget
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/calendar/calendar_widget.dart`
- **Purpose**: Month calendar with entry indicators
- **Features**:
  - Traditional calendar layout
  - Dot indicators for days with entries
  - Date selection
  - Month navigation
  - Loading state
- **Props**: currentMonth, selectedDate, entriesByDate, onDateSelected, isLoading
- **Used In**: JournalCalendarScreen

#### 2. StatisticsBar
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/calendar/statistics_bar.dart`
- **Purpose**: Summary statistics display above calendar
- **Shows**: Current streak, completion %, total entries, most frequent mood
- **Design**: Horizontal stat pills with icons and values

#### 3. EntryPreviewCard
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/calendar/entry_preview_card.dart`
- **Purpose**: Expanded view of journal entries for selected date
- **Features**:
  - Entry title, transcription/text
  - Mood indicator
  - Timestamp
  - AI insights preview (if available)
  - Expandable/collapsible

### Navigation Components

#### 1. OdyseyaBottomNavigationBar
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/navigation/bottom_navigation_bar.dart`
- **Purpose**: Main app bottom navigation
- **Tabs**:
  - Dashboard (0)
  - Home/Mood (1)
  - Journal/Recording (2)
  - Calendar (3)
- **Features**:
  - Active/inactive state styling (#D8A36C active, #7A4C25 inactive)
  - Smooth animations
  - Background highlight on active tab
  - 84px height with top radius 24px
- **Design Tokens**: Framework compliant spacing, colors, shadows

#### 2. TopNavigationBar
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/navigation/top_navigation_bar.dart`
- **Purpose**: Header navigation
- **Features**: Back button, title, settings access

### AI & Insights Components

#### 1. InsightPreview
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/ai_insights/insight_preview.dart`
- **Purpose**: Display AI-generated emotional insights
- **Features**:
  - Icon (moon, lightbulb, etc.)
  - Insight text
  - Link to full analysis
  - Subtle styling

#### 2. PremiumBadge
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/common/premium_badge.dart`
- **Purpose**: Visual indicator for premium features
- **Design**: Crown icon + "Premium" text
- **Used In**: Settings, feature cards

### Transcription Components

#### 1. TranscriptionDisplay
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/transcription/transcription_display.dart`
- **Purpose**: Show voice-to-text transcription
- **Features**:
  - Formatted text display
  - Editable mode toggle
  - Copy to clipboard
  - Share functionality

### Onboarding-Specific

#### 1. OnboardingLayout
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/onboarding/onboarding_layout.dart`
- **Purpose**: Standard onboarding screen wrapper
- **Features**:
  - Title and subtitle
  - Scrollable content area
  - Primary button at bottom
  - Skip option
- **Used In**: Permissions, Welcome screens

#### 2. StepIndicator
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/common/step_indicator.dart`
- **Purpose**: Show progress through multi-step process
- **Features**:
  - Progress bar or dots
  - Current step highlighting
  - Step count display

#### 3. PrivacyNotice
**File**: `/Users/joannacholas/CursorProjects/odyseya/lib/widgets/auth/privacy_notice.dart`
- **Purpose**: Display privacy-related information
- **Used In**: Auth and consent screens

---

## State Management (Providers)

### Authentication Providers

#### authStateProvider
**File**: `lib/providers/auth_provider.dart`
- **Type**: StateNotifier<AuthState>
- **State Properties**:
  - isAuthenticated: bool
  - isInitialized: bool
  - isLoading: bool
  - user: AuthUser?
  - error: String?
  - lastAction: AuthAction (signUp/signIn/none)
- **Methods**:
  - signInWithEmail(email, password)
  - signUpWithEmail(email, password, name)
  - signOut()
  - checkAuthStatus()
- **Used By**: AuthChoiceScreen, LoginScreen, SignUpScreen, router

#### firebaseAuthProvider
**File**: `lib/providers/firebase_auth_provider.dart`
- **Purpose**: Firebase authentication service
- **Type**: Provider (stateless)
- **Functionality**: Direct Firebase Auth integration

#### emailValidationProvider
**File**: `lib/providers/auth_provider.dart`
- **Type**: Provider<String>
- **Purpose**: Validate email format and uniqueness
- **Returns**: Error message or null if valid

#### passwordValidationProvider
- **Type**: Provider<String>
- **Purpose**: Validate password strength
- **Returns**: Error message or null if valid

### User Journey Providers

#### moodProvider
**File**: `lib/providers/mood_provider.dart`
- **Type**: StateNotifier<MoodState>
- **State Properties**:
  - selectedMood: Mood?
  - hasMood: bool
  - isLoading: bool
- **Methods**:
  - selectMood(Mood)
  - startSelection()
  - clearMood()
- **Used By**: MoodSelectionScreen, router (redirect enforcement), ReviewSubmitScreen

#### voiceJournalProvider
**File**: `lib/providers/voice_journal_provider.dart`
- **Type**: StateNotifier<VoiceJournalState>
- **State Properties**:
  - isRecording: bool
  - isPaused: bool
  - recordingDuration: Duration
  - recordedAudio: File?
  - transcription: String?
  - selectedMood: String?
  - error: String?
- **Methods**:
  - startRecording()
  - stopRecording()
  - pauseRecording()
  - resumeRecording()
  - selectMood(String)
  - saveEntry()
- **Streams**:
  - amplitudeStreamProvider: Real-time audio level stream
- **Used By**: RecordingScreen, ReviewSubmitScreen

#### affirmationProvider
**File**: `lib/providers/affirmation_provider.dart`
- **Type**: StateNotifier<AffirmationState>
- **State Properties**:
  - affirmation: String?
  - isLoading: bool
  - error: String?
  - lastEntry: JournalEntry?
- **Methods**:
  - loadTodaysAffirmation()
  - clearAffirmation()
- **Used By**: AffirmationScreen

### Data Management Providers

#### journalProvider
**File**: `lib/providers/journal_provider.dart`
- **Type**: StateNotifier<JournalState>
- **State Properties**:
  - entries: List<JournalEntry>
  - isLoading: bool
  - error: String?
- **Methods**:
  - fetchEntries()
  - getEntryById(id)
  - deleteEntry(id)
  - exportToJson()

#### calendarProvider
**File**: `lib/providers/calendar_provider.dart`
- **Type**: StateNotifier<CalendarState>
- **State Properties**:
  - currentMonth: DateTime
  - selectedDate: DateTime?
  - entriesByDate: Map<DateTime, List<JournalEntry>>
  - selectedDateEntries: List<JournalEntry>
  - currentStreak: int
  - monthlyCompletionRate: double
  - totalEntriesThisMonth: int
  - mostFrequentMood: String?
- **Methods**:
  - nextMonth()
  - previousMonth()
  - selectDate(DateTime)
  - calculateStats()
- **Used By**: JournalCalendarScreen

#### onboardingProvider
**File**: `lib/providers/onboarding_provider.dart`
- **Type**: StateNotifier<OnboardingState>
- **State Properties**:
  - q1Goals: List<String>
  - q2Preferences: List<String>
  - q3Experience: String
  - microphonePermission: bool
  - notificationPermission: bool
  - locationPermission: bool
  - gdprAccepted: bool
- **Methods**:
  - updateQ1Goals(List<String>)
  - updateQ2Preferences(List<String>)
  - updateQ3Experience(String)
  - updateMicrophonePermission(bool)
  - updateNotificationPermission(bool)
  - updateLocationPermission(bool)
  - updateGdprAccepted(bool)
- **Used By**: Questionnaire screens, PermissionsScreen

### Preferences & Settings Providers

#### settingsProvider
**File**: `lib/providers/settings_provider.dart`
- **Type**: StateNotifier<SettingsState>
- **State Properties**:
  - dailyRemindersEnabled: bool
  - reminderTime: TimeOfDay
  - aiAnalysisEnabled: bool
  - darkModeEnabled: bool
  - language: String
- **Methods**:
  - updateDailyReminders(bool)
  - setReminderTime(TimeOfDay)
  - updateAiAnalysis(bool)
  - toggleDarkMode()
- **Persistence**: SharedPreferences integration
- **Used By**: SettingsScreen

#### notificationProvider
**File**: `lib/providers/notification_provider.dart`
- **Type**: StateNotifier<NotificationState>
- **State Properties**:
  - hasPermission: bool
  - isLoading: bool
  - lastNotificationTime: DateTime?
- **Methods**:
  - requestPermissions()
  - scheduleReminder(TimeOfDay)
  - testNotification()
  - cancelReminders()
- **Used By**: SettingsScreen, PermissionsScreen

#### subscriptionProvider
**File**: `lib/providers/subscription_provider.dart`
- **Type**: StateNotifier<SubscriptionState>
- **State Properties**:
  - isPremium: bool
  - isLoading: bool
  - offerings: Offerings?
  - currentPackage: Package?
- **Methods**:
  - loadOfferings()
  - purchasePackage(Package)
  - restorePurchases()
  - checkSubscriptionStatus()
- **Integration**: RevenueCat
- **Used By**: PaywallScreen, SettingsScreen, various feature access checks

### Derived Providers

#### amplitudeStreamProvider
- **Type**: StreamProvider<double>
- **Purpose**: Real-time audio amplitude for waveform visualization
- **Used By**: RecordingScreen (AudioWaveformWidget)

---

## Design Patterns & Reusable Patterns

### 1. Screen Layout Patterns

#### Pattern A: Content Card Inside Background
```
AppBackground(background image)
  └─ Scaffold
     └─ Column
        ├─ Header (title, icons)
        └─ Container(card style)
           └─ ScrollView
              └─ Content
```
**Used In**: RecordingScreen, ReviewSubmitScreen

#### Pattern B: OdyseyaScreenLayout (Onboarding)
```
OdyseyaScreenLayout(title, subtitle, button)
  └─ child: Column
     └─ Content options
```
**Used In**: Questionnaire, PermissionsScreen, WelcomeScreen

#### Pattern C: Full Background with Modal Content
```
AppBackground(full screen)
  └─ Scaffold
     └─ SafeArea
        └─ Single/MultiChildScrollView
           └─ Content
```
**Used In**: AffirmationScreen, PaywallScreen

#### Pattern D: Tab Navigation with Swapped Content
```
MainAppShell
  └─ AppBackground
     └─ Column
        ├─ dynamic Screen (based on route)
        └─ OdyseyaBottomNavigationBar
```
**Used In**: All main app tabs

### 2. Component Composition Patterns

#### Pattern: Card + Icon + Text Stack
```dart
Container(
  decoration: BoxDecoration(
    color: surface,
    borderRadius: circular(16),
    boxShadow: [...],
  ),
  child: Row(
    children: [
      Container(icon),
      Column(text),
    ],
  ),
)
```
**Used In**: PermissionCard, InsightCard, FeatureCard, MoodCard

#### Pattern: Horizontal Scrollable List
```dart
SizedBox(
  height: fixedHeight,
  child: ListView.separated(
    scrollDirection: Axis.horizontal,
    itemBuilder: (context, index) => ItemCard(),
  ),
)
```
**Used In**: JournalHighlights (DashboardScreen), MoodSelection (ReviewScreen)

#### Pattern: Modal Dialog with Scrollable Content
```dart
showDialog(
  builder: (context) => AlertDialog(
    backgroundColor: surface,
    shape: RoundedRectangleBorder(borderRadius: circular(16)),
    content: SingleChildScrollView(
      child: Column(...),
    ),
  ),
)
```
**Used In**: GDPR policy dialogs, BookRecommendation dialog

### 3. State Management Patterns

#### Pattern: Local State for UI Toggles
```dart
StatefulWidget → setState(() { _toggleMode = !_toggleMode; })
```
**Used In**: RecordingScreen (record/type toggle), DashboardScreen (edit mode)

#### Pattern: Provider + Consumer for Complex State
```dart
ConsumerWidget/ConsumerStatefulWidget
  → ref.watch(provider)
  → ref.read(provider.notifier).method()
```
**Used In**: All screens with complex state (auth, onboarding, journal)

#### Pattern: Listen for Navigation Triggers
```dart
ref.listen(provider, (previous, next) {
  if (next.isAuthenticated) {
    context.go('/home');
  }
});
```
**Used In**: LoginScreen, SignUpScreen, auth redirects

### 4. Animation Patterns

#### Pattern A: Fade + Scale (Entrance)
```dart
ScaleTransition(scale: _scaleAnimation,
  child: FadeTransition(opacity: _fadeAnimation,
    child: Content(),
  ),
)
```
**Used In**: OnboardingSuccessScreen, AffirmationScreen

#### Pattern B: Staggered Animations (Multi-element)
```dart
// Animate element 1
_controller1.forward();
// After delay, animate element 2
Future.delayed(Duration(ms: 300)) {
  _controller2.forward();
}
```
**Used In**: AffirmationScreen (fade→scale→button)

#### Pattern C: Transform on Scroll/Selection
```dart
AnimatedContainer(
  duration: Duration(ms: 300),
  transform: Matrix4.identity()..scale(isSelected ? 1.0 : 0.92),
  child: MoodCard(),
)
```
**Used In**: SwipeableMoodCards (individual card scale)

### 5. Form Input Patterns

#### Pattern: Validation with Inline Error
```dart
TextFormField(
  validator: (value) => provider.validate(value),
  decoration: InputDecoration(
    border: InputBorder.none,
    contentPadding: ...,
  ),
)
```
**Used In**: LoginScreen, SignUpScreen

#### Pattern: Visibility Toggle for Password
```dart
suffix Icon: Icons.visibility / Icons.visibility_off
onPressed: setState(() => _obscure = !_obscure)
```
**Used In**: LoginScreen, SignUpScreen password fields

#### Pattern: Checkbox with Descriptive Text
```dart
Row(
  children: [
    Checkbox(value, onChanged),
    Column(
      children: [
        Text(title),
        Text(subtitle),
        GestureDetector("Read more"),
      ],
    ),
  ],
)
```
**Used In**: GdprConsentScreen

### 6. Color & Styling Consistency

#### Design System Implementation
- **Primary Colors**: DesertColors.westernSunrise (#D8A36C), brownBramble (#57351E)
- **Secondary Colors**: waterWash (#2B8AB8), arcticRain (#4BA3C3)
- **Neutral/Backgrounds**: creamBeige (#FFFDF8), surface (#F5F5F5)
- **Text Colors**: onSurface, onSecondary, treeBranch
- **Accent Colors**: caramelDrizzle, roseSand, dustyBlue

#### Spacing System
```
xs: 8, sm: 12, md: 16, lg: 20, xl: 24, xxl: 32
```

#### Border Radius System
```
radiusButton: 16, radiusCard: 16, radiusMedium: 12, radiusSmall: 8
```

#### Shadow System
```
Level 1 (light): blur 8, offset (0,4), alpha 0.08
Level 2 (medium): blur 12, offset (0,8), alpha 0.12
Level 3 (deep): blur 24, offset (0,12), alpha 0.15
```

---

## Navigation Graph

```
SPLASH (splash)
  ↓ (8 seconds auto, 3 seconds success screen)
FIRST DOWNLOAD (/first-download)
  ├→ LOGIN (/login)
  │   ├← back → FIRST DOWNLOAD
  │   └→ ONBOARDING SUCCESS (via auth redirect)
  │       └→ HOME (/home)
  │
  └→ SIGNUP (/signup)
      ├← back → FIRST DOWNLOAD
      └→ GDPR CONSENT (/gdpr-consent)
          └→ PERMISSIONS (/permissions)
              └→ WELCOME (/welcome)
                  └→ Q1 (/onboarding/questionnaire/q1)
                      └→ Q2 (/onboarding/questionnaire/q2)
                          └→ Q3 (/onboarding/questionnaire/q3)
                              └→ Q4 (/onboarding/questionnaire/q4)
                                  └→ ONBOARDING SUCCESS (/onboarding-success)
                                      └→ HOME (/home, auto-nav)
                                          └→ AFFIRMATION (/affirmation)
                                              └→ HOME (/home → mood selection)

AUTHENTICATED USER FLOW:
HOME/AFFIRMATION (/affirmation)
  └→ HOME (/home) — MOOD SELECTION
      └→ JOURNAL (/journal) — RECORDING SCREEN
          └→ REVIEW (/review) — REVIEW & SUBMIT
              └→ CALENDAR (/calendar) — JOURNAL CALENDAR

MAIN APP TABS (via MainAppShell):
├─ DASHBOARD (/dashboard)
├─ HOME (/home) — Mood Selection
├─ JOURNAL (/journal) — Recording
├─ CALENDAR (/calendar) — Journal Calendar

SIDE ROUTES (accessible from tabs):
├─ SETTINGS (/settings)
├─ PAYWALL (/paywall)
└─ CALENDAR → Entry Details

ROUTE REDIRECTS:
- Unauthenticated + protected route → /auth
- Authenticated + /auth/login/signup → /onboarding-success or /home
- Authenticated + /onboarding (non-new) → /affirmation
- /journal without mood selected → /home
```

---

## Screen Implementation Checklist

Use this checklist when reviewing or creating new screens:

### Pre-Implementation
- [ ] Define screen purpose and position in user journey
- [ ] Identify required state (Riverpod providers)
- [ ] List all child components/widgets needed
- [ ] Plan navigation flow (to/from routes)
- [ ] Determine if stateless or stateful (Consumer vs StatelessWidget)

### Implementation
- [ ] Add AppBackground if needed
- [ ] Create AppBar with appropriate style
- [ ] Implement main content with proper spacing (OdyseyaSpacing constants)
- [ ] Use DesertColors for all color properties
- [ ] Add proper error handling (try/catch, validation)
- [ ] Implement loading states with spinners
- [ ] Add form validation if applicable
- [ ] Use OdyseyaButton for primary actions
- [ ] Add proper SafeArea handling

### Testing Checklist
- [ ] Test on light/dark modes
- [ ] Test responsive behavior (different screen sizes)
- [ ] Test navigation flows
- [ ] Test error states
- [ ] Test loading states
- [ ] Test form validation
- [ ] Test accessibility (color contrast, touch targets)
- [ ] Verify all DesertColors usage
- [ ] Verify consistent spacing
- [ ] Test animations (smooth, not jarring)

---

## Summary Statistics

- **Total Screens**: 27 (excluding debug/test screens)
- **Total Widgets**: 20+ custom widgets
- **State Providers**: 12 major providers
- **Design System Colors**: 15+ semantic colors
- **Animation Patterns**: 5+ reusable patterns
- **Component Patterns**: 6+ layout patterns

---

## Key Takeaways

1. **Consistent Component Library**: OdyseyaButton, AppBackground, OdyseyaScreenLayout provide foundation
2. **Emotional Color Palette**: Warm, desert-inspired colors (#D8A36C primary, #57351E brown)
3. **Phased User Journey**: AUTH → ONBOARDING → AFFIRMATION → ACTION → REFLECTION
4. **Responsive Layouts**: All screens use flexible layouts with proper SafeArea handling
5. **Smooth Animations**: Entrance animations use scale/fade with proper timing
6. **Accessible Forms**: Clear validation, helpful errors, proper labeling
7. **State Management**: Riverpod provides reactive, testable state handling
8. **Navigation**: GoRouter with redirects enforces app flow and auth requirements

---

**Last Updated**: 2025-10-23
**Framework Version**: UX_odyseya_framework v1.4-1.5
**Design System**: Desert-inspired emotional journey app
