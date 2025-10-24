# Odyseya - Screens & Components Quick Reference

## All Screens (27 Total)

### Authentication & Onboarding (7 screens)
1. **SplashScreen** - Animated compass, auto-navigate after 8 seconds
2. **FirstDownloadAppScreen** - Marketing screen with Sign In/Create Account buttons
3. **AuthChoiceScreen** - Initial auth decision (Sign In vs Create Account)
4. **LoginScreen** - Email/password login form
5. **SignUpScreen** - Name/email/password registration form
6. **GdprConsentScreen** - Privacy/terms consent with policy modals
7. **PermissionsScreen** - Microphone, notifications, location requests

### Onboarding Flow (4 screens)
8. **WelcomeScreen** - Feature value proposition cards
9. **QuestionnaireQ1Screen** - "What do you hope Odyseya will help with?"
10. **QuestionnaireQ2Screen** - User preferences questions
11. **QuestionnaireQ3Screen** - Journaling experience level
12. **QuestionnaireQ4Screen** - Privacy preferences
13. **OnboardingSuccessScreen** - Celebration with animated checkmark

### Main App Navigation
14. **MainAppShell** - Bottom nav container (not a screen, but root)

### Daily Journaling Flow (3 screens)
15. **AffirmationScreen** - Daily personalized affirmation (standalone)
16. **MoodSelectionScreen** - Pick mood before journaling (Home tab)
17. **RecordingScreen** - Voice record or type journal entry (Journal tab)
18. **ReviewSubmitScreen** - Review entry and select mood before submit

### Reflection & Analysis (2 screens)
19. **DashboardScreen** - Journey overview, stats, insights (Dashboard tab)
20. **JournalCalendarScreen** - Calendar view of all entries (Calendar tab)

### Inspiration (1 screen)
21. **AffirmationScreen** - Shows daily affirmation

### Settings & Premium (2 screens)
22. **SettingsScreen** - User preferences, notifications, data management
23. **PaywallScreen** - Premium subscription options

### Renewal (1 screen - placeholder)
24. **ComingSoonScreen** - Renewal features (future)

### Debug/Test (3 screens)
25. **DebugScreen** - Development testing
26. **MarketingScreen** - Marketing/onboarding variants
27. **FeatureDemoScreen** - Feature showcase

---

## Widget Components (20+)

### Buttons & Input
- **OdyseyaButton** - Primary/secondary/tertiary button (60px, 16px radius)
- **OdyseyaButton.primary()** - #D8A36C background, white text
- **OdyseyaButton.secondary()** - Beige background, brown text
- **OdyseyaButton.tertiary()** - Outlined, transparent

### Layout Wrappers
- **AppBackground** - Desert background with optional overlay
- **OdyseyaScreenLayout** - Onboarding screen wrapper with title/button
- **OnboardingLayout** - Simpler onboarding wrapper

### Mood Selection
- **SwipeableMoodCards** - PageView carousel with 5 moods
- **MoodCard** - Individual mood card (emoji + label)

### Voice Recording
- **AudioWaveformWidget** - Real-time amplitude visualization (bars)
- **RecordButton** - Circular record/stop button

### Calendar & Timeline
- **CalendarWidget** - Month calendar with entry dots
- **StatisticsBar** - Streak/completion/entries stats display
- **EntryPreviewCard** - Expanded journal entry view

### Navigation
- **OdyseyaBottomNavigationBar** - 4-tab bottom nav (Dashboard/Home/Journal/Calendar)
- **TopNavigationBar** - Header navigation

### AI & Insights
- **InsightPreview** - AI-generated insight display
- **PremiumBadge** - Premium feature indicator

### Transcription
- **TranscriptionDisplay** - Voice-to-text display with edit/share

### Other
- **StepIndicator** - Progress through multi-step flows
- **PrivacyNotice** - Privacy/consent notice

---

## State Providers (12)

### Authentication
- `authStateProvider` - Auth state + actions
- `firebaseAuthProvider` - Firebase Auth service
- `emailValidationProvider` - Email validation
- `passwordValidationProvider` - Password strength
- `confirmPasswordValidationProvider` - Password match

### User Journey
- `moodProvider` - Current mood selection
- `voiceJournalProvider` - Recording state + audio data
- `affirmationProvider` - Daily affirmation

### Data
- `journalProvider` - All journal entries
- `calendarProvider` - Calendar state + stats
- `onboardingProvider` - Onboarding progress

### Settings & Premium
- `settingsProvider` - User preferences
- `notificationProvider` - Notification permissions
- `subscriptionProvider` - Premium status

---

## Color System (DesertColors)

### Primary
- **westernSunrise** #D8A36C - Primary action color
- **brownBramble** #57351E - Primary text color

### Secondary
- **waterWash** #2B8AB8 - Secondary highlight
- **arcticRain** #4BA3C3 - Info/secondary action

### Neutral
- **creamBeige** #FFFDF8 - Background/cards
- **cardWhite** #FFFFFF - Card backgrounds
- **surface** #F5F5F5 - Surfaces
- **background** - Main background

### Accent
- **caramelDrizzle** - Warm accent
- **roseSand** - Warm accent
- **dustyBlue** - Cool accent
- **sageGreen** - Success indicator

### Text
- **treeBranch** - Secondary text
- **warmBrown** #7A4C25 - Navigation inactive
- **onSurface** - Main text color
- **onSecondary** - Secondary text

---

## Navigation Routes

### Public Routes
- `/splash` → SplashScreen
- `/first-download` → FirstDownloadAppScreen
- `/auth` → AuthChoiceScreen
- `/login` → LoginScreen
- `/signup` → SignUpScreen

### Onboarding Routes
- `/gdpr-consent` → GdprConsentScreen
- `/permissions` → PermissionsScreen
- `/welcome` → WelcomeScreen
- `/onboarding/questionnaire/q[1-4]` → QuestionnaireScreens
- `/onboarding-success` → OnboardingSuccessScreen

### Main App Routes (Protected)
- `/main`, `/home` → MainAppShell (MoodSelectionScreen)
- `/dashboard` → MainAppShell (DashboardScreen)
- `/journal` → MainAppShell (RecordingScreen)
- `/calendar` → MainAppShell (JournalCalendarScreen)
- `/settings` → SettingsScreen
- `/affirmation` → AffirmationScreen
- `/review` → ReviewSubmitScreen
- `/paywall` → PaywallScreen

---

## Key Features by Screen

### Splash Screen
- Rotating compass animation
- 8-second delay before navigation
- Poetic quote subtitle

### Auth Screens
- Email validation (format + uniqueness)
- Password strength validation
- Password visibility toggle
- Real-time form validation
- Loading state with spinner

### Onboarding
- GDPR compliance with embedded policies
- Permission requests (mic required, others optional)
- 4-question user profiling
- Step indicator (1 of 4)
- Celebration animation on completion

### Mood Selection
- 5 swipeable emotion cards
- PageView carousel with dots
- Keyboard-friendly page indicator ("1 of 5")
- Continue button enabled when selected

### Recording Screen
- Dual mode: Voice record OR text typing
- Real-time audio waveform visualization
- 2:30 max recording duration
- Mode toggle buttons
- "Hi [User]" personalized greeting
- Full-screen text area for typing mode

### Review Screen
- Recording playback ability
- Mood selection with emoji icons
- Horizontal scrollable mood list
- Submit validation (mood required)
- Save status feedback (loading/success/error)

### Dashboard Screen
- User's emotional journey objective (editable)
- Export journal as PDF
- Streak counter + most frequent mood
- Weekly mood sparkline chart
- Horizontal scrolling recent entries
- AI-generated insight
- Book recommendation

### Calendar Screen
- Month-based calendar view
- Entry indicators (dots on dates)
- Month navigation
- Statistics bar at top
- Selected date entry preview

### Affirmation Screen
- Animated entrance (fade + scale)
- AI-personalized affirmation
- "Based on your recent reflections" attribution
- Error fallback quote
- Continue or Skip options

### Settings Screen
- Premium subscription badge
- Daily reminder toggle + time picker
- Test notification button
- AI analysis toggle
- Data export
- Account deletion
- Terms/Privacy/Licenses links

---

## Animation Patterns

### Entrance Animations
- **Fade + Scale**: OnboardingSuccessScreen, AffirmationScreen
- **Staggered**: AffirmationScreen (fade→scale→buttons)
- **Auto-play**: OnboardingSuccessScreen (auto-nav after 3 sec)

### Interactive Animations
- **Scale on Page Change**: SwipeableMoodCards (center card 1.0, others 0.92)
- **Smooth Toggle**: PermissionCard toggle switches
- **Carousel**: RecordingScreen record button pulse effect

### Transitions
- **Fade Transitions**: Between most screens (250ms)
- **Slide Transitions**: Review screen, Paywall screen (400ms)

---

## Design System Specs

### Typography
- **Heading 1**: 32-40px, bold
- **Heading 2**: 20-24px, semi-bold
- **Body**: 16px, regular
- **Caption**: 12-14px
- **Button**: 16-18px, semi-bold, letter-spacing 0.5-1.0

### Spacing
- **xs**: 8px | **sm**: 12px | **md**: 16px
- **lg**: 20px | **xl**: 24px | **xxl**: 32px

### Border Radius
- **Button**: 16px (60px height)
- **Card**: 16px
- **Input**: 16px
- **Bottom Nav Top**: 24px

### Shadows
- **Level 1**: blur 8, offset (0,4), alpha 0.08
- **Level 2**: blur 12, offset (0,8), alpha 0.12
- **Level 3**: blur 24, offset (0,12), alpha 0.15

### Button Sizes
- **Primary**: 60px height, 16px radius
- **Navigation Bar**: 84px height

---

## File Structure Reference

```
lib/
├── screens/
│   ├── auth/
│   │   ├── auth_choice_screen.dart
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── onboarding/
│   │   ├── gdpr_consent_screen.dart
│   │   ├── permissions_screen.dart
│   │   ├── welcome_screen.dart
│   │   ├── questionnaire_q[1-4]_screen.dart
│   │   └── onboarding_success_screen.dart
│   ├── action/
│   │   ├── mood_selection_screen.dart
│   │   ├── recording_screen.dart
│   │   └── review_submit_screen.dart
│   ├── reflection/
│   │   ├── dashboard_screen.dart
│   │   └── journal_calendar_screen.dart
│   ├── inspiration/
│   │   └── affirmation_screen.dart
│   ├── settings/
│   │   └── settings_screen.dart
│   ├── renewal/
│   │   └── coming_soon_screen.dart
│   ├── splash_screen.dart
│   ├── main_app_shell.dart
│   └── paywall_screen.dart
│
├── widgets/
│   ├── common/
│   │   ├── odyseya_button.dart
│   │   ├── app_background.dart
│   │   ├── odyseya_screen_layout.dart
│   │   ├── swipeable_mood_cards.dart
│   │   ├── mood_card.dart
│   │   └── ...
│   ├── voice_recording/
│   │   ├── audio_waveform_widget.dart
│   │   └── record_button.dart
│   ├── calendar/
│   │   ├── calendar_widget.dart
│   │   ├── statistics_bar.dart
│   │   └── entry_preview_card.dart
│   ├── navigation/
│   │   ├── bottom_navigation_bar.dart
│   │   └── top_navigation_bar.dart
│   └── ...
│
└── providers/
    ├── auth_provider.dart
    ├── mood_provider.dart
    ├── voice_journal_provider.dart
    ├── affirmation_provider.dart
    ├── calendar_provider.dart
    ├── onboarding_provider.dart
    ├── settings_provider.dart
    ├── notification_provider.dart
    └── subscription_provider.dart
```

---

## Quick Navigation by Use Case

### "I need to add a new settings option"
1. Find: `lib/screens/settings/settings_screen.dart`
2. Add: New `_buildSettingsTile()` call in appropriate section
3. Provider: Update `settingsProvider` with new field

### "I need to modify the onboarding flow"
1. Edit: Questionnaire screens in `lib/screens/onboarding/`
2. Update: Routes in `lib/config/router.dart`
3. Provider: Modify `onboardingProvider` state

### "I need to create a new mood-related screen"
1. Create: New screen file in `lib/screens/`
2. Add: Route to `lib/config/router.dart`
3. Provider: Use existing `moodProvider` or create new

### "I need to change button colors across the app"
1. Edit: `lib/widgets/common/odyseya_button.dart`
2. Update: `DesertColors` constants in `lib/constants/colors.dart`
3. Test: All screens using OdyseyaButton

---

**Last Updated**: 2025-10-23  
**Total Documentation**: 1180+ lines  
**Screens Covered**: All 27 main screens  
**Components**: 20+ custom widgets  
**Providers**: 12+ state management providers
