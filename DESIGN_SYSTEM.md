# Odyseya Design System

## Overview
This design system provides consistent UX components matching the reference design with:
- Desert sand dune background on all screens
- Centered, spacious layouts
- Consistent button styles
- Step indicators for multi-step flows
- Clean typography and color palette

## Components

### 1. OdyseyaScreenLayout
Main layout component for all screens.

**Usage:**
```dart
import '../../widgets/common/odyseya_screen_layout.dart';

OdyseyaScreenLayout(
  title: 'Share Your Thoughts',
  subtitle: 'Choose voice or text to express yourself',
  totalSteps: 4,        // Show step indicators (optional)
  currentStep: 1,       // Current step (1-indexed)
  primaryButtonText: 'Continue',
  onPrimaryPressed: () => context.go('/next'),
  secondaryButtonText: 'Skip', // Optional
  onSecondaryPressed: () => context.go('/skip'),
  child: YourContent(),
)
```

**Properties:**
- `title`: Main heading (uses Cormorant Garamond)
- `subtitle`: Subheading below title
- `child`: Main content widget
- `primaryButtonText`: Text for main button (beige/cream colored)
- `onPrimaryPressed`: Primary button callback
- `secondaryButtonText`: Text for secondary button (outline style)
- `onSecondaryPressed`: Secondary button callback
- `totalSteps` / `currentStep`: For step indicators
- `showBackButton`: Show back arrow (default: true)
- `onBack`: Custom back button handler
- `centerContent`: Center the content vertically (default: false)

### 2. OdyseyaButton
Consistent button styling across the app.

**Three variants:**

```dart
// Primary - Blue background, white text (like "Voice" button)
OdyseyaButton.primary(
  text: 'Voice',
  icon: Icons.mic,
  onPressed: () {},
)

// Secondary - Beige/cream background, brown text (like "Continue" button)
OdyseyaButton.secondary(
  text: 'Continue',
  onPressed: () {},
)

// Tertiary - Outline style, brown text
OdyseyaButton.tertiary(
  text: 'Skip',
  onPressed: () {},
)
```

**Properties:**
- `text`: Button label
- `icon`: Optional icon (shown before text)
- `onPressed`: Callback (null = disabled)
- `isLoading`: Show loading spinner
- `width`: Custom width (default: full width)
- `height`: Custom height (default: 56)

### 3. StepIndicator
Numbered circles showing progress through multi-step flows.

**Usage:**
```dart
StepIndicator(
  totalSteps: 4,
  currentStep: 2,  // 1-indexed
)
```

Creates numbered circles (1, 2, 3, 4) with:
- Current step: Large, blue filled
- Completed steps: Smaller, light blue filled
- Future steps: Smaller, gray

### 4. AppBackground
Desert background for all screens (already in use).

**Usage:**
```dart
AppBackground(
  useOverlay: true,
  overlayOpacity: 0.03,
  child: YourScreen(),
)
```

## Color Palette

From `lib/constants/colors.dart`:

- **Primary:** `DesertColors.dustyBlue` - Blue accent (buttons, active states)
- **Background:** `DesertColors.paleDesert` - Warm beige/cream
- **Surface:** `DesertColors.offWhite` - Card backgrounds
- **Text Primary:** `DesertColors.deepBrown` - Main text
- **Text Secondary:** `DesertColors.taupe` - Subtitles, hints
- **Accents:** `DesertColors.roseSand`, `DesertColors.sageGreen`, `DesertColors.terracotta`

## Typography

From `lib/constants/typography.dart`:

- **Headings:** `OdyseyaTypography.h1` (Cormorant Garamond)
- **Body:** `OdyseyaTypography.body` (Nunito Sans)
- **Buttons:** `OdyseyaTypography.button` (Inter)
- **UI Labels:** `OdyseyaTypography.ui` (Inter)

## Migration Guide

### Before (Old Style):
```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('My Screen')),
      body: Column(
        children: [
          Text('Title'),
          ElevatedButton(
            onPressed: () {},
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }
}
```

### After (New Style):
```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OdyseyaScreenLayout(
      title: 'My Screen',
      subtitle: 'Optional subtitle here',
      primaryButtonText: 'Continue',
      onPrimaryPressed: () => context.go('/next'),
      child: YourContent(),
    );
  }
}
```

## Screen Examples

### 1. Simple Single-Screen Flow
```dart
return OdyseyaScreenLayout(
  title: 'Welcome',
  subtitle: 'Get started with Odyseya',
  primaryButtonText: 'Get Started',
  onPrimaryPressed: () => context.go('/onboarding'),
  showBackButton: false,
  centerContent: true,
  child: Image.asset('assets/images/logo.png'),
);
```

### 2. Multi-Step Questionnaire
```dart
return OdyseyaScreenLayout(
  totalSteps: 4,
  currentStep: 2,
  title: 'How are you feeling today?',
  subtitle: 'Select all that apply',
  primaryButtonText: 'Continue',
  onPrimaryPressed: hasSelection ? () => next() : null,
  child: MoodSelectionGrid(),
);
```

### 3. Voice/Text Input Screen (like reference image)
```dart
return OdyseyaScreenLayout(
  title: 'Share Your Thoughts',
  subtitle: 'Choose voice or text to express yourself',
  totalSteps: 4,
  currentStep: 1,
  primaryButtonText: 'Continue',
  onPrimaryPressed: () => context.go('/review'),
  child: Column(
    children: [
      Row(
        children: [
          Expanded(
            child: OdyseyaButton.primary(
              text: 'Voice',
              icon: Icons.mic,
              onPressed: () => selectVoice(),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: OdyseyaButton.secondary(
              text: 'Type',
              icon: Icons.edit,
              onPressed: () => selectText(),
            ),
          ),
        ],
      ),
      // Recording UI or text input here
    ],
  ),
);
```

## Bottom Navigation

Bottom nav is handled separately in `MainAppShell` and matches the reference design with:
- Icon + label layout
- Beige background
- Active state highlighting

## Next Steps for Full Migration

To apply this design system to all screens:

1. **Onboarding Screens** (✅ Q1 done):
   - questionnaire_q2_screen.dart
   - questionnaire_q3_screen.dart
   - questionnaire_q4_screen.dart
   - welcome_screen.dart
   - permissions_screen.dart
   - gdpr_consent_screen.dart

2. **Auth Screens**:
   - login_screen.dart
   - signup_screen.dart
   - auth_choice_screen.dart

3. **Main App Screens**:
   - voice_journal_screen.dart (partially done)
   - mood_selection_screen.dart
   - affirmation_screen.dart
   - settings_screen.dart

4. **Review/Submit**:
   - review_submit_screen.dart

Simply replace the old layout with `OdyseyaScreenLayout` and use `OdyseyaButton` components!
