# Odyseya App Documentation Index

This directory contains comprehensive documentation of the Odyseya voice journaling app's architecture, screens, components, and design system.

## Documentation Files

### 1. SCREENS_AND_COMPONENTS_DOCUMENTATION.md (1180 lines, 38KB)
**The Complete Reference** - Most comprehensive documentation

Contains:
- Overview of the entire app architecture
- All 27 screens organized by user journey phase
- Complete widget/component library (20+ custom widgets)
- All state management providers (12 providers)
- Design patterns and reusable patterns
- Color system, typography, spacing specifications
- Navigation graph and routing flow
- Implementation checklist for new screens

**Best for**: 
- Deep architectural understanding
- Learning all screens in detail
- Understanding component composition
- Learning design patterns used
- Complete reference when building new features

### 2. SCREENS_QUICK_REFERENCE.md (397 lines, 12KB)
**Quick Lookup Guide** - Fast reference for common tasks

Contains:
- All 27 screens at a glance (with descriptions)
- 20+ widget components listed
- 12+ state providers summarized
- Color system quick lookup
- Navigation routes
- Key features by screen
- Animation patterns
- Design system specs
- File structure
- Quick navigation by use case

**Best for**:
- Quick lookups during development
- Finding which screen does what
- Reference when implementing features
- Understanding app structure at a glance
- Onboarding new developers

### 3. DOCUMENTATION_INDEX.md (This file)
Navigation guide for all documentation

---

## Screen Overview

### Total Screens: 27
- **Authentication & Marketing**: 3 screens
- **Onboarding**: 7 screens
- **Daily Journaling**: 4 screens
- **Reflection**: 2 screens
- **Inspiration**: 1 screen
- **Settings & Premium**: 2 screens
- **Renewal**: 1 screen
- **Navigation Container**: 1 screen
- **Debug/Test**: 3 screens

### User Journey
```
SPLASH 
  ↓ (8 sec)
FIRST DOWNLOAD 
  ├→ LOGIN
  └→ SIGNUP
     └→ GDPR CONSENT
        └→ PERMISSIONS
           └→ WELCOME
              └→ QUESTIONNAIRE (Q1-Q4)
                 └→ ONBOARDING SUCCESS
                    └→ AFFIRMATION
                       └→ MOOD SELECTION (Home)
                          └→ RECORDING (Journal)
                             └→ REVIEW & SUBMIT
                                └→ CALENDAR
```

### Daily Flow (After Onboarding)
```
AFFIRMATION → MOOD SELECTION → RECORDING → REVIEW → CALENDAR/DASHBOARD
```

---

## Component Categories

### Core Components (Used Everywhere)
- **OdyseyaButton** - Primary action button (#D8A36C, 60px)
- **AppBackground** - Desert background wrapper
- **OdyseyaScreenLayout** - Onboarding screen template

### Input Components
- **SwipeableMoodCards** - 5-card mood carousel
- **MoodCard** - Individual mood option
- **AudioWaveformWidget** - Real-time audio visualization

### Navigation Components
- **OdyseyaBottomNavigationBar** - 4-tab main nav
- **MainAppShell** - Bottom nav container

### Data Display Components
- **CalendarWidget** - Month calendar with dots
- **StatisticsBar** - Streak/completion stats
- **EntryPreviewCard** - Journal entry detail view

### Other Components
- **RecordButton** - Record/stop control
- **InsightPreview** - AI insight display
- **PremiumBadge** - Premium indicator
- **StepIndicator** - Progress indicator
- **OnboardingLayout** - Onboarding wrapper

---

## State Management Providers

### Authentication (5 providers)
- `authStateProvider` - User auth state
- `firebaseAuthProvider` - Firebase integration
- `emailValidationProvider` - Email validator
- `passwordValidationProvider` - Password validator
- `confirmPasswordValidationProvider` - Password confirmation

### User Journey (3 providers)
- `moodProvider` - Current mood selection
- `voiceJournalProvider` - Recording/journal entry
- `affirmationProvider` - Daily affirmation

### Data (3 providers)
- `journalProvider` - All journal entries
- `calendarProvider` - Calendar state + stats
- `onboardingProvider` - Onboarding progress

### Settings (3 providers)
- `settingsProvider` - User preferences
- `notificationProvider` - Push notifications
- `subscriptionProvider` - Premium subscription (RevenueCat)

---

## Design System

### Color Palette (Desert-Inspired)
**Primary**:
- Western Sunrise: #D8A36C (action buttons)
- Brown Bramble: #57351E (primary text)

**Secondary**:
- Water Wash: #2B8AB8 (secondary highlights)
- Arctic Rain: #4BA3C3 (info/secondary actions)

**Neutral**:
- Cream Beige: #FFFDF8 (backgrounds)
- Card White: #FFFFFF (cards)
- Surface: #F5F5F5 (surfaces)

**Accent**:
- Caramel Drizzle (warm accent)
- Rose Sand (warm accent)
- Dusty Blue (cool accent)
- Sage Green (success)

### Typography
- **H1**: 32-40px, bold
- **H2**: 20-24px, semi-bold
- **Body**: 16px, regular
- **Caption**: 12-14px
- **Button**: 16-18px, semi-bold, letter-spacing 0.5-1.0

### Spacing System
- xs: 8px | sm: 12px | md: 16px | lg: 20px | xl: 24px | xxl: 32px

### Border Radius
- Button: 16px
- Card: 16px
- Input: 16px
- Navigation: 24px (top)

### Shadows
- Level 1: blur 8, offset (0,4), alpha 0.08
- Level 2: blur 12, offset (0,8), alpha 0.12
- Level 3: blur 24, offset (0,12), alpha 0.15

---

## Key Patterns

### Layout Patterns
1. **Content Card Inside Background** - RecordingScreen, ReviewScreen
2. **OdyseyaScreenLayout** - Onboarding/questionnaires
3. **Full Background with Modal** - AffirmationScreen, PaywallScreen
4. **Tab Navigation** - MainAppShell with bottom nav

### Animation Patterns
1. **Fade + Scale Entrance** - OnboardingSuccess, Affirmation
2. **Staggered Animations** - Multi-element sequences
3. **Transform on Selection** - SwipeableMoodCards
4. **Auto-play** - Splash, OnboardingSuccess

### State Patterns
1. **Local State for UI** - Toggles, text inputs
2. **Provider + Consumer** - Complex state
3. **Listen for Navigation** - Redirect on auth change

### Form Patterns
1. **Validation with Inline Error** - Auth screens
2. **Visibility Toggle** - Password fields
3. **Checkbox with Description** - GDPR consent

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
- `/dashboard` → DashboardScreen (via MainAppShell)
- `/journal` → RecordingScreen (via MainAppShell)
- `/calendar` → JournalCalendarScreen (via MainAppShell)
- `/settings` → SettingsScreen
- `/affirmation` → AffirmationScreen
- `/review` → ReviewSubmitScreen
- `/paywall` → PaywallScreen

---

## How to Use This Documentation

### For Feature Development
1. Start with **SCREENS_QUICK_REFERENCE.md**
2. Find your screen in the list
3. Go to **SCREENS_AND_COMPONENTS_DOCUMENTATION.md** for details
4. Look up components/providers needed
5. Reference design system specs for styling

### For Adding a New Screen
1. Check **Screen Implementation Checklist** in main doc
2. Study similar existing screen pattern
3. Create in appropriate subfolder under `lib/screens/`
4. Add route to `lib/config/router.dart`
5. Add provider if needed under `lib/providers/`

### For Component Library Improvements
1. Review **Component/Widget Library** section
2. Check which screens use the component
3. Update component in `lib/widgets/`
4. Test in all dependent screens
5. Update color/spacing if using design system

### For New Developers
1. Read this index
2. Skim **SCREENS_QUICK_REFERENCE.md** for overview
3. Read your specific screen section in main doc
4. Study the providers section
5. Reference design system for styling

---

## File Structure

```
odyseya/
├── DOCUMENTATION_INDEX.md (this file)
├── SCREENS_QUICK_REFERENCE.md (quick lookup)
├── SCREENS_AND_COMPONENTS_DOCUMENTATION.md (complete reference)
│
├── lib/
│   ├── screens/
│   │   ├── auth/ (3 files)
│   │   ├── onboarding/ (7 files)
│   │   ├── action/ (3 files)
│   │   ├── reflection/ (2 files)
│   │   ├── inspiration/ (1 file)
│   │   ├── settings/ (1 file)
│   │   ├── renewal/ (1 file)
│   │   ├── splash_screen.dart
│   │   ├── main_app_shell.dart
│   │   └── paywall_screen.dart
│   │
│   ├── widgets/
│   │   ├── common/
│   │   ├── voice_recording/
│   │   ├── calendar/
│   │   ├── navigation/
│   │   ├── ai_insights/
│   │   ├── auth/
│   │   ├── onboarding/
│   │   └── transcription/
│   │
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── mood_provider.dart
│   │   ├── voice_journal_provider.dart
│   │   ├── affirmation_provider.dart
│   │   ├── calendar_provider.dart
│   │   ├── onboarding_provider.dart
│   │   ├── settings_provider.dart
│   │   ├── notification_provider.dart
│   │   └── subscription_provider.dart
│   │
│   ├── constants/
│   │   ├── colors.dart (DesertColors)
│   │   ├── typography.dart (OdyseyaTypography)
│   │   └── spacing.dart (OdyseyaSpacing)
│   │
│   └── config/
│       └── router.dart (GoRouter navigation)
```

---

## Quick Links by Task

### "How do I add a settings option?"
→ See SettingsScreen in SCREENS_AND_COMPONENTS_DOCUMENTATION.md

### "Where is the mood selection?"
→ See MoodSelectionScreen section

### "How do I customize button colors?"
→ See OdyseyaButton component + DesertColors in Quick Reference

### "What providers do I need for recording?"
→ See voiceJournalProvider in providers section

### "How are screens transitioned?"
→ See Navigation Graph and router.dart documentation

### "What's the onboarding flow?"
→ See Onboarding Flow section and navigation routes

---

## Statistics

- **Total Screens**: 27
- **Total Widgets**: 20+
- **Total Providers**: 12
- **Documentation Lines**: 1577
- **Design System Colors**: 15+
- **Animation Patterns**: 5+
- **Layout Patterns**: 6+

---

## Document Versions

| File | Lines | Size | Last Updated | Purpose |
|------|-------|------|--------------|---------|
| SCREENS_AND_COMPONENTS_DOCUMENTATION.md | 1180 | 38KB | 2025-10-23 | Complete reference |
| SCREENS_QUICK_REFERENCE.md | 397 | 12KB | 2025-10-23 | Quick lookup |
| DOCUMENTATION_INDEX.md | (this file) | - | 2025-10-23 | Navigation guide |

---

## Contributing to Documentation

When adding new screens, components, or features:
1. Update SCREENS_AND_COMPONENTS_DOCUMENTATION.md with full details
2. Update SCREENS_QUICK_REFERENCE.md with concise entry
3. Add to appropriate section in both files
4. Update navigation graph if routes change
5. Document providers used
6. Add animation patterns if applicable
7. Reference design system usage

---

**Last Updated**: 2025-10-23  
**App Framework**: Flutter + Riverpod + GoRouter  
**Design System**: Desert-Inspired Emotional Journey  
**Target Platforms**: iOS & Android (Mobile only)

For detailed information, refer to the main documentation files above.
