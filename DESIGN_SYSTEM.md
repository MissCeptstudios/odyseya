# Odyseya Design System

**Version 1.0** | Last Updated: October 2025

A comprehensive guide to the visual language, components, and patterns used in Odyseya - an emotional voice journaling app designed for inner peace.

---

## Table of Contents

1. [Design Principles](#design-principles)
2. [Color System](#color-system)
3. [Typography](#typography)
4. [Spacing & Layout](#spacing--layout)
5. [Shadows & Elevation](#shadows--elevation)
6. [Animation & Motion](#animation--motion)
7. [Components](#components)
8. [Navigation Patterns](#navigation-patterns)
9. [Accessibility Guidelines](#accessibility-guidelines)
10. [Usage Examples](#usage-examples)

---

## Design Principles

### 1. Desert-Inspired Warmth
Colors and imagery evoke calm, natural desert landscapes - creating a serene and grounded visual experience.

### 2. Emotional Safety
Soft animations, rounded corners, and accessible contrast create a safe space for emotional expression.

### 3. Poetic & Serene
Typography uses elegant serif fonts (Cormorant Garamond) for emotional moments, paired with clean sans-serif for clarity.

### 4. Responsive & Intuitive
Large touch targets (48px+), clear feedback, and haptic confirmation ensure effortless interaction.

### 5. Consistent Component Library
Reusable widgets reduce design drift and maintain a cohesive experience across all screens.

---

## Color System

**File:** `lib/constants/colors.dart`

### Primary Brand Colors (Cool Desert Morning Palette)

```dart
DesertColors.roseSand      // #C89B7A - Primary actions, buttons
DesertColors.dustyBlue     // #B0C4DE - Secondary accents
DesertColors.paleDesert    // #F2D8C1 - Background tint
DesertColors.offWhite      // #FEFCFA - Cards, elevated surfaces
DesertColors.deepBrown     // #442B0C - Primary text
DesertColors.taupe         // #8B7355 - Secondary text
```

### Extended Palette (Onboarding & UI Elements)

```dart
DesertColors.westernSunrise    // #D8A36C - Golden sunrise (PRIMARY)
DesertColors.caramelDrizzle    // #DBAC80 - Warm caramel
DesertColors.treeBranch        // #8B7362 - Warm brown
DesertColors.brownBramble      // #57351E - Deep brown text
DesertColors.creamBeige        // #F9F6F0 - Cream background
DesertColors.arcticRain        // #C6D9ED - Light blue tint
DesertColors.waterWash         // #AAC8E5 - Medium blue
```

### Semantic Colors

```dart
DesertColors.primary           // westernSunrise - Primary actions
DesertColors.secondary         // waterWash - Secondary elements
DesertColors.background        // Colors.white - Main background
DesertColors.surface           // Colors.white - Card surfaces
DesertColors.accent            // caramelDrizzle - Highlights
DesertColors.onSurface         // brownBramble - Text on surfaces
```

### Button State Colors

```dart
// Unselected State
DesertColors.buttonUnselectedBg     // #F9F6F0
DesertColors.buttonUnselectedBorder // #D0C4B8
DesertColors.buttonUnselectedText   // #8B7362

// Selected State
DesertColors.buttonSelectedBg       // #DBAC80
DesertColors.buttonSelectedBorder   // #D8A36C
DesertColors.buttonSelectedText     // #57351E
```

### Usage Guidelines

- **Primary Actions:** Use `dustyBlue` or `westernSunrise`
- **Text Hierarchy:** `deepBrown` for headings, `taupe` for body/secondary
- **Backgrounds:** White or `paleDesert` for warmth
- **Disabled States:** Use color with `withValues(alpha: 0.5)`

---

## Typography

**File:** `lib/constants/typography.dart`

### Font Families

- **Inter** - UI elements, navigation, buttons, labels
- **Nunito Sans** - Journaling content, body text
- **Cormorant Garamond** - Quotes, affirmations, welcome screens

### Type Scale

#### Display Text (Cormorant Garamond)
```dart
OdyseyaTypography.h1Large      // 24pt, Regular, 1.3 line height
OdyseyaTypography.h1           // 22pt, Regular, 1.3 line height
OdyseyaTypography.h1Italic     // 22pt, Italic, 1.3 line height
OdyseyaTypography.quoteAuthor  // 14pt, Regular, 1.3 line height
```

#### Headings (Inter Medium)
```dart
OdyseyaTypography.h2Large      // 20pt, Medium, 1.4 line height
OdyseyaTypography.h2           // 18pt, Medium, 1.4 line height
```

#### Body Text (Nunito Sans)
```dart
OdyseyaTypography.bodyLarge    // 16pt, Regular, 1.5 line height
OdyseyaTypography.body         // 15pt, Regular, 1.5 line height
OdyseyaTypography.bodyMedium   // 16pt, Medium, 1.5 line height
```

#### Buttons (Inter)
```dart
OdyseyaTypography.buttonLarge  // 16pt, Bold, 1.2 line height
OdyseyaTypography.button       // 16pt, Regular, 1.2 line height
OdyseyaTypography.buttonSmall  // 14pt, Medium, 1.2 line height
```

#### UI Elements (Inter)
```dart
OdyseyaTypography.uiLarge      // 16pt, Medium, 1.3 line height
OdyseyaTypography.ui           // 14pt, Medium, 1.3 line height
```

#### Navigation (Inter)
```dart
OdyseyaTypography.navActive    // 12pt, Semibold, 1.2 line height
OdyseyaTypography.navInactive  // 11pt, Regular, 1.2 line height
```

#### Captions & Meta
```dart
OdyseyaTypography.caption      // 13pt, Nunito Light, 1.3 line height
OdyseyaTypography.captionSmall // 12pt, Inter Light, 1.3 line height
```

### Usage Guidelines

- **Screen Titles:** Use `h1` (Cormorant) or `h2Large` (Inter)
- **Body Content:** Use `bodyLarge` (16pt) or `body` (15pt)
- **Action Labels:** Use `buttonLarge` (bold)
- **Emotional Moments:** Use Cormorant Garamond for quotes and affirmations

---

## Spacing & Layout

**File:** `lib/constants/spacing.dart`

### Base Spacing Scale (8px system)

```dart
OdyseyaSpacing.xs       // 4px   - Extra small
OdyseyaSpacing.sm       // 8px   - Small
OdyseyaSpacing.md       // 12px  - Medium
OdyseyaSpacing.lg       // 16px  - Large
OdyseyaSpacing.xl       // 20px  - Extra large
OdyseyaSpacing.xxl      // 24px  - 2X large
OdyseyaSpacing.xxxl     // 32px  - 3X large
OdyseyaSpacing.huge     // 40px  - Huge
OdyseyaSpacing.massive  // 48px  - Massive
```

### Common Padding Patterns

```dart
// Screen padding
OdyseyaSpacing.screenHorizontal    // 24px
OdyseyaSpacing.screenVertical      // 16px

// Content padding
OdyseyaSpacing.contentHorizontal   // 16px
OdyseyaSpacing.contentVertical     // 20px

// Card/container
OdyseyaSpacing.cardPadding         // 20px
OdyseyaSpacing.cardMargin          // 12px
```

### Component Dimensions

```dart
// Buttons
OdyseyaSpacing.buttonHeight               // 56px
OdyseyaSpacing.buttonHorizontalPadding    // 32px
OdyseyaSpacing.buttonVerticalSpacing      // 8px

// Navigation
OdyseyaSpacing.navBarHeight               // 72px
OdyseyaSpacing.navBarPadding              // 16px

// Touch targets (accessibility)
OdyseyaSpacing.minTouchTarget             // 48px
```

### Border Radius

```dart
OdyseyaSpacing.radiusSmall      // 8px   - Small elements
OdyseyaSpacing.radiusMedium     // 12px  - Standard
OdyseyaSpacing.radiusLarge      // 16px  - Cards
OdyseyaSpacing.radiusXLarge     // 20px  - Large cards
OdyseyaSpacing.radiusXXLarge    // 24px  - Mood cards
OdyseyaSpacing.radiusPill       // 28px  - Buttons (pill shape)
```

### Icon Sizes

```dart
OdyseyaSpacing.iconSmall        // 16px
OdyseyaSpacing.iconMedium       // 20px
OdyseyaSpacing.iconLarge        // 22px  - Navigation icons
OdyseyaSpacing.iconXLarge       // 24px
OdyseyaSpacing.iconHuge         // 32px
OdyseyaSpacing.iconMoodCard     // 64px  - Mood emoji
```

### Section Spacing

```dart
OdyseyaSpacing.sectionSpacing       // 24px
OdyseyaSpacing.sectionSpacingLarge  // 32px
OdyseyaSpacing.heroSpacing          // 40px

OdyseyaSpacing.formFieldSpacing     // 12px
OdyseyaSpacing.formSectionSpacing   // 20px
```

---

## Shadows & Elevation

**File:** `lib/constants/shadows.dart`

### Elevation Levels

```dart
OdyseyaShadows.elevation0    // 0px   - Flat
OdyseyaShadows.elevation1    // 2px   - Subtle
OdyseyaShadows.elevation2    // 4px   - Card
OdyseyaShadows.elevation3    // 8px   - Raised
OdyseyaShadows.elevation4    // 16px  - Floating
OdyseyaShadows.elevation5    // 24px  - Modal
```

### Shadow Presets

```dart
// Soft ambient shadow (cards at rest)
OdyseyaShadows.soft
// BoxShadow(color: black.withAlpha(0.04), blur: 8, offset: (0, 2))

// Medium shadow (interactive elements)
OdyseyaShadows.medium
// BoxShadow(color: black.withAlpha(0.06), blur: 12, offset: (0, 4))

// Strong shadow (selected/elevated items)
OdyseyaShadows.strong
// BoxShadow(color: black.withAlpha(0.08), blur: 24, offset: (0, 8))

// Navigation bars
OdyseyaShadows.topBar        // Shadow pointing down
OdyseyaShadows.bottomBar     // Shadow pointing up
```

### Component Shadows

```dart
OdyseyaShadows.card          // For mood cards, entry cards
OdyseyaShadows.button        // For primary buttons
OdyseyaShadows.selected      // For selected/active items
OdyseyaShadows.modal         // For dialogs, sheets
OdyseyaShadows.navigation    // For nav bars
```

### Opacity Constants

```dart
OdyseyaOpacity.subtle              // 0.05
OdyseyaOpacity.light               // 0.1
OdyseyaOpacity.lightMedium         // 0.2
OdyseyaOpacity.medium              // 0.3
OdyseyaOpacity.mediumHeavy         // 0.5
OdyseyaOpacity.heavy               // 0.7

// Common uses
OdyseyaOpacity.backgroundOverlay   // 0.1
OdyseyaOpacity.scrim               // 0.5
OdyseyaOpacity.disabled            // 0.5
```

---

## Animation & Motion

**File:** `lib/constants/animations.dart`

### Duration Constants

```dart
OdyseyaAnimations.instant           // 0ms
OdyseyaAnimations.fastest           // 100ms
OdyseyaAnimations.fast              // 150ms
OdyseyaAnimations.normal            // 300ms
OdyseyaAnimations.slow              // 400ms
OdyseyaAnimations.slower            // 600ms

// Specific animations
OdyseyaAnimations.buttonTap         // 150ms
OdyseyaAnimations.cardSelection     // 300ms
OdyseyaAnimations.navigationTransition  // 300ms
OdyseyaAnimations.pageTransition    // 400ms
OdyseyaAnimations.fadeIn            // 300ms
OdyseyaAnimations.modalAppear       // 300ms
```

### Curve Constants

```dart
OdyseyaAnimations.emphasized        // Curves.easeOutCubic (default)
OdyseyaAnimations.decelerate        // Curves.easeOut
OdyseyaAnimations.accelerate        // Curves.easeIn
OdyseyaAnimations.standard          // Curves.easeInOut

// Component-specific
OdyseyaAnimations.button            // easeOutCubic
OdyseyaAnimations.card              // easeInOut
OdyseyaAnimations.page              // easeOutCubic
```

### Scale Values

```dart
OdyseyaAnimations.scaleNormal       // 1.0
OdyseyaAnimations.scaleTapped       // 0.95
OdyseyaAnimations.scaleUnselected   // 0.92
OdyseyaAnimations.scalePressed      // 0.97
OdyseyaAnimations.scaleExpanded     // 1.05
```

### Motion Principles

1. **Smooth Transitions:** Use `easeOutCubic` for most movements
2. **Micro-interactions:** Scale 0.95x on tap for tactile feedback
3. **Haptic Feedback:** Light impacts on selections
4. **Consistent Duration:** 300ms for UI, 400ms for screens

---

## Components

### Buttons

#### OdyseyaButton
**File:** `lib/widgets/common/odyseya_button.dart`

**Variants:**
```dart
OdyseyaButton.primary(text: "Continue", onPressed: () {})
OdyseyaButton.secondary(text: "Skip", onPressed: () {})
OdyseyaButton.tertiary(text: "Learn More", onPressed: () {})
```

**Props:**
- `text` - Button label
- `onPressed` - Callback (null = disabled)
- `icon` - Optional leading icon
- `isLoading` - Shows spinner
- `width` - Custom width (default: full)
- `height` - Default: 56px

**Styling:**
- Primary: Blue background, white text
- Secondary: Beige background, brown text
- Tertiary: Transparent, border only

#### AuthButton
**File:** `lib/widgets/auth/auth_button.dart`

Used for authentication flows (Google Sign In, Apple Sign In)

```dart
AuthButton(
  icon: Icons.g_translate,
  text: "Continue with Google",
  backgroundColor: Colors.white,
  textColor: Colors.black,
  borderColor: Colors.grey,
  onPressed: () {},
)
```

### Layout Components

#### OdyseyaScreenLayout
**File:** `lib/widgets/common/odyseya_screen_layout.dart`

Standard screen wrapper with consistent structure:

```dart
OdyseyaScreenLayout(
  title: "Welcome to Odyseya",
  subtitle: "Your personal emotional journal",
  child: YourContentWidget(),
  primaryButtonText: "Get Started",
  onPrimaryPressed: () {},
  currentStep: 1,
  totalSteps: 5,
)
```

**Features:**
- Desert background with overlay
- Back button & help icon header
- Step indicator support
- Bottom button area with gradient

#### OdyseyaTopNavigationBar
**File:** `lib/widgets/navigation/top_navigation_bar.dart`

```dart
OdyseyaTopNavigationBar()  // Shows centered logo
```

#### OdyseyaBottomNavigationBar
**File:** `lib/widgets/navigation/bottom_navigation_bar.dart`

```dart
OdyseyaBottomNavigationBar(
  currentIndex: 0,
  onTap: (index) {},
)
```

**Tabs:**
0. Home (mood selection)
1. Journal (recording)
2. Calendar (entries)
3. Settings

### Mood & Selection

#### MoodCard
**File:** `lib/widgets/mood_card.dart`

```dart
MoodCard(
  mood: moodObject,
  isSelected: true,
  onTap: () {},
)
```

**Features:**
- 64px emoji/image
- Selection animation (scale 0.95)
- Haptic feedback
- Border changes on selection

#### SwipeableMoodCards
**File:** `lib/widgets/swipeable_mood_cards.dart`

Horizontal PageView with 5 mood cards:

```dart
SwipeableMoodCards(
  moods: moodList,
  onMoodSelected: (mood) {},
  selectedMood: currentMood,
)
```

### Premium Components

#### PremiumBadge
**File:** `lib/widgets/common/premium_badge.dart`

```dart
PremiumBadge()              // Large variant
PremiumBadge(small: true)   // Compact variant
```

#### PremiumGate
Wraps content and shows lock overlay if not premium:

```dart
PremiumGate(
  feature: PremiumFeature.advancedInsights,
  featureName: "Advanced AI Insights",
  featureDescription: "Get deeper emotional analysis",
  child: YourPremiumWidget(),
)
```

---

## Navigation Patterns

### Route Structure

```
/first-download       → First entry screen
/splash               → Splash screen
/auth                 → Auth choice
  /login              → Login
  /signup             → Sign up
/gdpr-consent         → GDPR consent
/permissions          → Permission requests
/welcome              → Welcome screen
/onboarding           → Onboarding flow
/mood-selection       → Mood picker
/main                 → Main app shell
  /home               → Home tab
  /journal            → Journal tab
  /calendar           → Calendar tab
  /settings           → Settings tab
/affirmation          → Daily affirmation
/review               → Review entry
/paywall              → Subscription screen
```

### Authentication Flow

```
Unauthenticated → /auth → (login/signup) → /onboarding → /main
Returning User  → /splash → /main
```

### Bottom Navigation

```dart
// In MainAppShell
final tabs = [
  MoodSelectionScreen(),   // Index 0: /home
  RecordingScreen(),       // Index 1: /journal
  JournalCalendarScreen(), // Index 2: /calendar
  SettingsScreen(),        // Index 3: /settings
];
```

---

## Accessibility Guidelines

### Color Contrast

- **Text on White:** Use `deepBrown` (#442B0C) - passes WCAG AA
- **Secondary Text:** Use `taupe` (#8B7355) - minimum 4.5:1 contrast
- **Avoid:** Low contrast combinations (pale on pale)

### Touch Targets

- **Minimum Size:** 48x48px (use `OdyseyaSpacing.minTouchTarget`)
- **Button Height:** 56px (exceeds minimum)
- **Navigation Icons:** 22px with 48px+ touch area

### Screen Reader Support

```dart
// Add semantic labels
Semantics(
  label: "Select joyful mood",
  button: true,
  child: MoodCard(...),
)
```

### Haptic Feedback

```dart
// Import services
import 'package:flutter/services.dart';

// Use on interactions
HapticFeedback.lightImpact();      // Light touch
HapticFeedback.selectionClick();   // Selection change
```

---

## Usage Examples

### Complete Screen Example

```dart
import 'package:flutter/material.dart';
import '../widgets/common/odyseya_screen_layout.dart';
import '../widgets/common/odyseya_button.dart';
import '../constants/spacing.dart';
import '../constants/typography.dart';

class ExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OdyseyaScreenLayout(
      title: "Your Journey Begins",
      subtitle: "Let's explore your emotional landscape",
      currentStep: 1,
      totalSteps: 3,
      child: Padding(
        padding: EdgeInsets.all(OdyseyaSpacing.screenHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose your path",
              style: OdyseyaTypography.h2Large,
            ),
            SizedBox(height: OdyseyaSpacing.lg),
            Text(
              "How do you feel today?",
              style: OdyseyaTypography.body,
            ),
            SizedBox(height: OdyseyaSpacing.xxl),
            // Your content here
          ],
        ),
      ),
      primaryButtonText: "Continue",
      onPrimaryPressed: () {
        // Handle action
      },
    );
  }
}
```

### Custom Button with Styling

```dart
OdyseyaButton.primary(
  text: "Start Journaling",
  icon: Icons.mic,
  onPressed: () => print("Pressed!"),
  width: 200, // Custom width
)
```

### Mood Card Selection

```dart
GridView.builder(
  padding: EdgeInsets.all(OdyseyaSpacing.cardPadding),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: OdyseyaSpacing.md,
    crossAxisSpacing: OdyseyaSpacing.md,
  ),
  itemCount: moods.length,
  itemBuilder: (context, index) {
    return MoodCard(
      mood: moods[index],
      isSelected: selectedMood == moods[index],
      onTap: () => setState(() => selectedMood = moods[index]),
    );
  },
)
```

### Premium Feature Gating

```dart
PremiumGate(
  feature: PremiumFeature.exportEntries,
  featureName: "Export Journal Entries",
  featureDescription: "Download your entries as PDF or text",
  child: ExportWidget(),
)
```

---

## Design System Maintenance

### Adding New Components

1. Create widget in appropriate folder (`lib/widgets/`)
2. Use existing constants (colors, spacing, typography)
3. Follow naming convention: `Odyseya[ComponentName]`
4. Document props and variants
5. Add to this design system doc

### Updating Constants

When updating design tokens:
1. Update constant file (`lib/constants/`)
2. Update this documentation
3. Test affected components
4. Run `flutter analyze` to check for issues

### Version History

- **v1.0** (October 2025) - Initial design system documentation
  - Complete color palette
  - Typography system
  - Spacing & layout constants
  - Animation & motion guidelines
  - Component library documentation

---

## Resources

- **Figma Designs:** See `UX/` folder for mockups
- **Component Files:** `lib/widgets/`
- **Constants:** `lib/constants/`
- **Example Screens:** `lib/screens/`

---

**Questions or Feedback?**
Refer to `CLAUDE.md` for project context and coding standards.
