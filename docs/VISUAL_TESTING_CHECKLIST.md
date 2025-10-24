# Visual Testing Checklist - Background Removal

**Project:** Odyseya - Emotional Voice Journaling App
**Test Type:** Visual Regression Testing
**Change:** Background image removal, solid color implementation
**Date:** October 24, 2025

---

## Testing Overview

**What Changed:**
- All screens migrated from background images to solid color (`DesertColors.creamBeige`)
- Removed `AppBackground` widget wrapper
- Simplified widget tree structure

**What to Test:**
- Visual appearance and consistency
- Color contrast and readability
- Animations and transitions
- UI element positioning
- Screen-specific functionality

---

## General Visual Checks (All Screens)

For every screen tested, verify:

- [ ] Background color displays as cream/beige (`#F5F0E8`)
- [ ] No white flashes or background flicker
- [ ] Text is readable with good contrast
- [ ] UI elements are properly positioned
- [ ] No visual glitches or rendering issues
- [ ] Smooth animations and transitions
- [ ] Status bar text color is appropriate
- [ ] Safe area boundaries respected
- [ ] No layout overflow errors
- [ ] Consistent appearance with design system

---

## Screen-by-Screen Testing

### 1. Authentication Flow

#### 1.1 SplashScreen
**Path:** Initial app launch
**File:** `lib/screens/splash_screen.dart`

**Visual Checks:**
- [ ] Cream beige background displays correctly
- [ ] Compass logo centered and visible
- [ ] Spinning animation smooth (3 seconds/rotation)
- [ ] "Odyseya" text clearly visible
- [ ] Quote text readable with good contrast
- [ ] Brown text (#57351E) on cream background
- [ ] No background image artifacts
- [ ] Smooth transition to next screen (8 seconds)

**Specific Elements:**
- [ ] Inside compass (blue crown) - static
- [ ] Outer compass ring - spinning smoothly
- [ ] Text: "Like a desert wanderer..." - legible
- [ ] Font: PoiretOne, 18px, brown color

**Expected Background:** `DesertColors.creamBeige` (#F5F0E8)

---

#### 1.2 FirstDownloadAppScreen
**Path:** After splash (first time)
**File:** `lib/screens/first_downloadapp_screen.dart`

**Visual Checks:**
- [ ] Solid cream background (no desert image)
- [ ] Content centered properly
- [ ] Compass logo visible
- [ ] "Odyseya" branding clear
- [ ] Button styling correct
- [ ] Text hierarchy clear
- [ ] Spacing feels balanced

**Specific Elements:**
- [ ] Primary button: Western Sunrise color (#D8A36C)
- [ ] Button text: White, readable
- [ ] Body text: Brown on cream, good contrast

**Expected Background:** `DesertColors.creamBeige`

---

#### 1.3 AuthChoiceScreen
**Path:** `/auth`
**File:** `lib/screens/auth/auth_choice_screen.dart`

**Visual Checks:**
- [ ] Clean cream background
- [ ] Compass logo centered
- [ ] "Odyseya" word logo clear
- [ ] "SIGN IN" button - primary style
- [ ] "CREATE ACCOUNT" button - outline style
- [ ] Button shadows visible
- [ ] Proper spacing between elements

**Specific Elements:**
- [ ] Sign In button: #D8A36C background, white text
- [ ] Create Account button: White background, #D8A36C border
- [ ] Button height: 60px
- [ ] Border radius: 16px
- [ ] Button shadows: Present

**Expected Background:** `DesertColors.creamBeige`

---

#### 1.4 LoginScreen
**Path:** `/login`
**File:** `lib/screens/auth/login_screen.dart`

**Visual Checks:**
- [ ] Cream background throughout
- [ ] Back button visible (top left)
- [ ] "Sign In" title - large, brown
- [ ] Subtitle readable
- [ ] Email field: white background, shadow
- [ ] Password field: white background, shadow
- [ ] Eye icon for password toggle
- [ ] Error messages display correctly (red)
- [ ] Sign in button: Western Sunrise color
- [ ] Loading state shows spinner

**Specific Elements:**
- [ ] Title: 40px, brown color
- [ ] Input fields: White (#FFFFFF) with shadows
- [ ] Input borders: Rounded 16px
- [ ] Button: 60px height, Western Sunrise

**Expected Background:** `DesertColors.creamBeige`

**Test Scenarios:**
- [ ] Empty state (no error)
- [ ] Error state (show error message)
- [ ] Loading state (button spinner)

---

#### 1.5 SignUpScreen
**Path:** `/signup`
**File:** `lib/screens/auth/signup_screen.dart`

**Visual Checks:**
- [ ] Consistent cream background
- [ ] Back button functional
- [ ] "Create Account" title visible
- [ ] Four input fields displayed:
  - [ ] Full Name
  - [ ] Email
  - [ ] Password
  - [ ] Confirm Password
- [ ] Password visibility toggles work
- [ ] "CONTINUE" button styled correctly
- [ ] Error states display properly
- [ ] Scrollable when keyboard appears

**Specific Elements:**
- [ ] All inputs: White background, shadows
- [ ] Validation errors: Red text, clear
- [ ] Button: Western Sunrise, 60px height

**Expected Background:** `DesertColors.creamBeige`

---

#### 1.6 GdprConsentScreen
**Path:** `/gdpr-consent`
**File:** `lib/screens/onboarding/gdpr_consent_screen.dart`

**Visual Checks:**
- [ ] White background (not cream - design choice)
- [ ] GDPR consent text readable
- [ ] Checkboxes functional
- [ ] Links clickable
- [ ] Continue button enabled/disabled appropriately

**Expected Background:** `Colors.white` (exception)

---

### 2. Onboarding Flow

#### 2.1 WelcomeScreen
**Path:** After GDPR consent
**File:** `lib/screens/onboarding/welcome_screen.dart`
**Uses:** `OdyseyaScreenLayout`

**Visual Checks:**
- [ ] Cream background from layout widget
- [ ] Welcome message centered
- [ ] Introduction text readable
- [ ] CTA button visible
- [ ] Back button if applicable
- [ ] Smooth animations

**Expected Background:** `DesertColors.creamBeige` (via `OdyseyaScreenLayout`)

---

#### 2.2 FirstJournalScreen
**Path:** Onboarding step
**File:** `lib/screens/onboarding/first_journal_screen.dart`
**Uses:** `OnboardingLayout`

**Visual Checks:**
- [ ] Cream background consistent
- [ ] Progress indicator at top
- [ ] Title and subtitle clear
- [ ] Instructions readable
- [ ] Interactive elements visible
- [ ] Continue button styled correctly
- [ ] Fade-in animation smooth

**Expected Background:** `DesertColors.creamBeige` (via `OnboardingLayout`)

---

#### 2.3 AccountCreationScreen
**Path:** Onboarding step
**File:** `lib/screens/onboarding/account_creation_screen.dart`
**Uses:** `OnboardingLayout`

**Visual Checks:**
- [ ] Consistent cream background
- [ ] Form fields visible
- [ ] Input validation clear
- [ ] Progress indicator updated
- [ ] Layout responds to keyboard

**Expected Background:** `DesertColors.creamBeige`

---

#### 2.4 PermissionsScreen
**Path:** Onboarding step
**File:** `lib/screens/onboarding/permissions_screen.dart`
**Uses:** `OnboardingLayout`

**Visual Checks:**
- [ ] Background color consistent
- [ ] Permission cards/buttons visible
- [ ] Icons clear and recognizable
- [ ] Text explanations readable
- [ ] Toggle/button states clear

**Expected Background:** `DesertColors.creamBeige`

---

#### 2.5 PreferredTimeScreen
**Path:** Onboarding step
**File:** `lib/screens/onboarding/preferred_time_screen.dart`

**Visual Checks:**
- [ ] Time picker visible
- [ ] Selection state clear
- [ ] AM/PM toggle if applicable
- [ ] Confirmation button ready

**Expected Background:** `DesertColors.creamBeige`

---

#### 2.6 OnboardingSuccessScreen
**Path:** End of onboarding
**File:** `lib/screens/onboarding/onboarding_success_screen.dart`

**Visual Checks:**
- [ ] Success message prominent
- [ ] Celebration/checkmark icon
- [ ] CTA to main app
- [ ] Positive visual feedback

**Expected Background:** `DesertColors.creamBeige`

---

### 3. Main App Screens

#### 3.1 DashboardScreen (Reflection Tab)
**Path:** `/dashboard` (main)
**File:** `lib/screens/reflection/dashboard_screen.dart`

**Visual Checks:**
- [ ] Cream background already in place
- [ ] Journey header with gradient
- [ ] Stats cards visible
- [ ] Insights card readable
- [ ] Bottom navigation visible
- [ ] Floating action button (if any)
- [ ] Cards have proper shadows
- [ ] Text hierarchy clear

**Specific Elements:**
- [ ] Journey header: Gradient background
- [ ] Stats cards: White background, shadows
- [ ] Insights: Gradient or solid card
- [ ] Export button visible

**Expected Background:** `DesertColors.creamBeige`

**Note:** Already had solid color, verify no regressions

---

#### 3.2 RecordingScreen (Action Tab - Step 1)
**Path:** `/recording`
**File:** `lib/screens/action/recording_screen.dart`

**Visual Checks:**
- [ ] Cream background clean
- [ ] Record button prominent
- [ ] Waveform visible during recording
- [ ] Timer display clear
- [ ] Stop/pause buttons visible
- [ ] Audio visualization smooth
- [ ] Container has subtle shadow

**Specific Elements:**
- [ ] Container: Cream with shadow
- [ ] Record button: Circular, red when active
- [ ] Waveform: Animated, Western Sunrise color

**Expected Background:** `DesertColors.creamBeige`

**Note:** Already had solid color, verify no regressions

---

#### 3.3 MoodSelectionScreen (Action Tab - Step 2)
**Path:** `/mood-selection`
**File:** `lib/screens/action/mood_selection_screen.dart`

**Visual Checks:**
- [ ] Cream background (was AppBackground before)
- [ ] AppBar: Off-white with transparency
- [ ] Back button works
- [ ] Swipeable mood cards visible
- [ ] 5 mood options clear:
  - [ ] Happy
  - [ ] Sad
  - [ ] Anxious
  - [ ] Calm
  - [ ] Angry
- [ ] Swipe gestures smooth
- [ ] Selected mood highlighted
- [ ] Continue button enabled when selected

**Specific Elements:**
- [ ] AppBar: `DesertColors.offWhite` with 95% alpha
- [ ] Mood cards: Swipeable, colorful
- [ ] Continue button: Western Sunrise

**Expected Background:** `DesertColors.creamBeige`

**Previous:** Used `AppBackground` - verify smooth transition

---

#### 3.4 ReviewSubmitScreen (Action Tab - Step 3)
**Path:** `/review-submit`
**File:** `lib/screens/action/review_submit_screen.dart`

**Visual Checks:**
- [ ] Cream background (removed image container)
- [ ] Transcription text readable
- [ ] Mood emoji display
- [ ] Edit options available
- [ ] Submit button prominent
- [ ] Review content scrollable
- [ ] No background image bleeding

**Specific Elements:**
- [ ] Submit button: Primary style
- [ ] Mood selection: 5 options
- [ ] Transcription: Black text on cream

**Expected Background:** `DesertColors.creamBeige`

**Previous:** Had `Container` with `Background_F.png` - verify removal

---

#### 3.5 JournalCalendarScreen (Reflection Tab)
**Path:** `/calendar`
**File:** `lib/screens/reflection/journal_calendar_screen.dart`

**Visual Checks:**
- [ ] Cream background (was AppBackground)
- [ ] AppBar transparent
- [ ] Calendar widget visible
- [ ] Month/year header clear
- [ ] Date cells properly styled
- [ ] Entry indicators visible
- [ ] Statistics bar at top
- [ ] Entry preview card (when selected)
- [ ] Smooth transitions

**Specific Elements:**
- [ ] AppBar: Transparent
- [ ] Calendar: Grid layout clear
- [ ] Selected date: Highlighted
- [ ] Entry dots/indicators visible

**Expected Background:** `DesertColors.creamBeige`

**Previous:** Used `AppBackground` - verify transition

---

### 4. Settings & Other Screens

#### 4.1 SettingsScreen
**Path:** `/settings`
**File:** `lib/screens/settings/settings_screen.dart`

**Visual Checks:**
- [ ] Cream background (was AppBackground)
- [ ] AppBar transparent
- [ ] Settings sections clear
- [ ] Toggle switches visible
- [ ] Notification settings
- [ ] Premium badge if applicable
- [ ] Export data button
- [ ] Terms/Privacy links
- [ ] Logout button

**Specific Elements:**
- [ ] Section headers: Brown, bold
- [ ] Setting items: White cards with shadows
- [ ] Switches: Functional, colored
- [ ] Premium badge: Gold/special

**Expected Background:** `DesertColors.creamBeige`

**Previous:** Used `AppBackground`

---

#### 4.2 AffirmationScreen (Inspiration Tab)
**Path:** `/affirmation`
**File:** `lib/screens/inspiration/affirmation_screen.dart`

**Visual Checks:**
- [ ] Cream background (was AppBackground)
- [ ] Affirmation text centered
- [ ] Text large and readable
- [ ] Fade-in animation smooth
- [ ] "Good Morning" greeting
- [ ] Continue button at bottom
- [ ] Button animation on load
- [ ] No overlay artifacts

**Specific Elements:**
- [ ] Greeting: 28px, faded
- [ ] Affirmation: Large, serif font
- [ ] Continue button: Scaled animation

**Expected Background:** `DesertColors.creamBeige`

**Previous:** Used `AppBackground` with overlay - verify no overlay remnants

**Animations to Test:**
- [ ] Fade in animation
- [ ] Scale animation
- [ ] Button appear animation

---

#### 4.3 ComingSoonScreen (Renewal Tab)
**Path:** `/coming-soon`
**File:** `lib/screens/renewal/coming_soon_screen.dart`

**Visual Checks:**
- [ ] Cream background (was AppBackground)
- [ ] Centered content
- [ ] Leaf icon visible
- [ ] "Coming Soon" title clear
- [ ] Description text readable
- [ ] Feature list visible
- [ ] Clean, minimalist design

**Specific Elements:**
- [ ] Icon: Eco/leaf, large
- [ ] Title: Brown, prominent
- [ ] Feature bullets: Clear hierarchy

**Expected Background:** `DesertColors.creamBeige`

**Previous:** Used `AppBackground`

---

#### 4.4 PaywallScreen
**Path:** `/paywall`
**File:** `lib/screens/paywall_screen.dart`

**Visual Checks:**
- [ ] Cream background (was in AppBackground)
- [ ] Premium features list visible
- [ ] Subscription cards/options clear
- [ ] Pricing displayed correctly
- [ ] Selected package highlighted
- [ ] Subscribe button prominent
- [ ] Terms/restore links visible
- [ ] Loading states work

**Specific Elements:**
- [ ] Feature list: Checkmarks, text
- [ ] Package cards: Bordered, selectable
- [ ] Pricing: Large, bold
- [ ] Subscribe button: Western Sunrise

**Expected Background:** `DesertColors.creamBeige`

**Previous:** `AppBackground` child within Expanded

**Test States:**
- [ ] Loading state (spinner)
- [ ] Error state (message)
- [ ] Packages loaded state
- [ ] Processing purchase state

---

### 5. Navigation & Shell

#### 5.1 MainAppShell
**Path:** All main app routes
**File:** `lib/screens/main_app_shell.dart`

**Visual Checks:**
- [ ] Transparent background (correct)
- [ ] Bottom navigation bar visible
- [ ] 4 tabs clearly labeled:
  - [ ] Reflection (Dashboard)
  - [ ] Action (Record)
  - [ ] Inspiration (Affirmation)
  - [ ] Renewal (Coming Soon)
- [ ] Selected tab highlighted
- [ ] Tab icons clear
- [ ] Smooth tab switching
- [ ] Individual screens show their backgrounds

**Specific Elements:**
- [ ] Bottom nav: Proper styling
- [ ] Icons: Recognizable
- [ ] Labels: Readable
- [ ] Active state: Clear indication

**Expected Background:** `Colors.transparent` (screens handle their own)

**Navigation Flow:**
- [ ] Switch between all 4 tabs
- [ ] Verify each screen's background
- [ ] No flashing or flickering
- [ ] State preservation

---

## Cross-Screen Testing

### Screen Transitions

Test transitions between screens:

1. **Authentication Flow:**
   - [ ] Splash → FirstDownload → Auth Choice
   - [ ] Auth Choice → Login → Dashboard
   - [ ] Auth Choice → Sign Up → GDPR → Onboarding

2. **Onboarding Flow:**
   - [ ] Sequential navigation through all steps
   - [ ] Back button navigation
   - [ ] Skip functionality if available

3. **Main App Navigation:**
   - [ ] Dashboard → Recording → Mood → Review
   - [ ] Bottom nav tab switching
   - [ ] Settings navigation

**Verify:**
- [ ] No background flashing
- [ ] Smooth transitions
- [ ] Consistent colors
- [ ] No layout jumps

---

## Platform-Specific Testing

### iOS Testing

**Devices to Test:**
- [ ] iPhone 16 Pro (Simulator)
- [ ] iPhone SE (Simulator - small screen)
- [ ] iPad (if supported)
- [ ] Physical device (recommended)

**iOS-Specific Checks:**
- [ ] Safe area insets correct
- [ ] Notch/Dynamic Island handled
- [ ] Status bar text color (dark on light background)
- [ ] Home indicator visible
- [ ] Haptic feedback (if any)
- [ ] Dark mode (if supported)

---

### Android Testing

**Devices to Test:**
- [ ] Pixel 8 Pro (Emulator)
- [ ] Samsung device (if available)
- [ ] Small screen device
- [ ] Physical device (recommended)

**Android-Specific Checks:**
- [ ] Navigation bar color
- [ ] Status bar color
- [ ] Material Design consistency
- [ ] Back button behavior
- [ ] System bars overlap
- [ ] Dark theme (if supported)

---

## Performance Testing

### Visual Performance

- [ ] No frame drops during animations
- [ ] Smooth scrolling
- [ ] Quick screen renders
- [ ] No jank or stuttering
- [ ] Transitions under 300ms
- [ ] No memory leaks

**Tools:**
- Flutter DevTools Performance tab
- Frame rendering times
- Widget rebuild tracking

---

## Accessibility Testing

### Color Contrast

- [ ] Text readable on cream background
- [ ] WCAG AA compliance (4.5:1 minimum)
- [ ] Brown text (#57351E) on cream (#F5F0E8)
- [ ] Button text has sufficient contrast
- [ ] Error messages visible

**Tool:** Contrast checker
- Brown on Cream: Check ratio
- White on Western Sunrise: Check ratio

### Screen Reader

- [ ] VoiceOver (iOS) works correctly
- [ ] TalkBack (Android) works correctly
- [ ] All elements have labels
- [ ] Navigation order logical

---

## Edge Cases

### Screen Sizes

- [ ] Small screens (iPhone SE)
- [ ] Large screens (iPhone Pro Max)
- [ ] Tablets (iPad)
- [ ] Landscape orientation

### System Settings

- [ ] Large text size
- [ ] Bold text enabled
- [ ] Reduced motion
- [ ] Dark mode (if applicable)

### States

- [ ] Loading states
- [ ] Error states
- [ ] Empty states
- [ ] Offline mode

---

## Bug Reporting Template

If issues found, document:

```
Screen: [Screen name]
Issue: [Description]
Expected: Cream background (#F5F0E8)
Actual: [What you see]
Severity: [Critical/High/Medium/Low]
Platform: [iOS/Android]
Device: [Device model]
OS Version: [Version]
Steps to Reproduce:
1. [Step 1]
2. [Step 2]
Screenshot: [Attach if possible]
```

---

## Sign-Off

### Test Completion

- [ ] All screens tested on iOS
- [ ] All screens tested on Android
- [ ] Transitions verified
- [ ] Performance acceptable
- [ ] Accessibility checked
- [ ] Edge cases covered
- [ ] Bugs documented
- [ ] Fixes verified

**Tested By:** _________________
**Date:** _________________
**Build Version:** _________________
**Sign-Off:** _________________

---

## Quick Reference

**Expected Background Color:**
- **Most screens:** `DesertColors.creamBeige` (#F5F0E8)
- **Exception:** `GdprConsentScreen` → White
- **Exception:** `MainAppShell` → Transparent

**Primary Text Color:** `DesertColors.brownBramble` (#57351E)

**Button Color:** `DesertColors.westernSunrise` (#D8A36C)

---

**Document Version:** 1.0
**Last Updated:** October 24, 2025
**Status:** Ready for Testing
