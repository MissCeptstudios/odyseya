# Typography Usage Guide - Odyseya App

## CTA Button Text - UPPERCASE Requirement

All CTA (Call-To-Action) buttons must display text in **UPPERCASE** letters according to the design system.

### Button Styles Configuration

The following button text styles are configured with increased letter spacing for uppercase text:

- `AppTextStyles.ctaButtonText` - 16pt, letter spacing 1.2
- `AppTextStyles.buttonLarge` - 18pt, letter spacing 1.5
- `AppTextStyles.button` - 16pt, letter spacing 1.2

### How to Use Uppercase CTA Buttons

#### Method 1: Using the Extension (Recommended)

```dart
import 'package:odyseya/constants/typography.dart';

// Simple and clean
ElevatedButton(
  onPressed: () {},
  child: Text(
    'Continue'.toButtonText(), // Converts to "CONTINUE"
    style: AppTextStyles.ctaButtonText,
  ),
);

// Works with any string
Text(
  'get started'.toButtonText(), // Converts to "GET STARTED"
  style: AppTextStyles.buttonLarge,
);
```

#### Method 2: Using .toUpperCase() Directly

```dart
// Standard Dart method
ElevatedButton(
  onPressed: () {},
  child: Text(
    'Continue'.toUpperCase(), // Converts to "CONTINUE"
    style: AppTextStyles.button,
  ),
);
```

#### Method 3: Hardcoded Uppercase

```dart
// Direct uppercase text
ElevatedButton(
  onPressed: () {},
  child: Text(
    'CONTINUE', // Already uppercase
    style: AppTextStyles.ctaButtonText,
  ),
);
```

### Complete Button Examples

#### Primary CTA Button
```dart
import 'package:odyseya/constants/typography.dart';
import 'package:odyseya/utils/design_tokens.dart';

ElevatedButton(
  onPressed: _handleContinue,
  style: DesignTokens.primaryButtonStyle,
  child: Text(
    'Continue'.toButtonText(),
    style: AppTextStyles.ctaButtonText,
  ),
);
```

#### Large CTA Button
```dart
ElevatedButton(
  onPressed: _handleGetStarted,
  style: DesignTokens.primaryButtonStyle,
  child: Text(
    'get started'.toButtonText(),
    style: AppTextStyles.buttonLarge,
  ),
);
```

#### Standard Button
```dart
OutlinedButton(
  onPressed: _handleSubmit,
  style: DesignTokens.functionalButtonStyle,
  child: Text(
    'submit'.toButtonText(),
    style: AppTextStyles.button,
  ),
);
```

### Migration Guide for Existing Buttons

To update existing buttons in the codebase:

**Before:**
```dart
Text('Continue', style: AppTextStyles.ctaButtonText)
```

**After:**
```dart
Text('Continue'.toButtonText(), style: AppTextStyles.ctaButtonText)
```

### Common Button Text Examples

Here are common button texts properly formatted:

```dart
'Continue'.toButtonText()       // → "CONTINUE"
'Get Started'.toButtonText()    // → "GET STARTED"
'Submit'.toButtonText()         // → "SUBMIT"
'Next'.toButtonText()           // → "NEXT"
'Save'.toButtonText()           // → "SAVE"
'Cancel'.toButtonText()         // → "CANCEL"
'Skip'.toButtonText()           // → "SKIP"
'Done'.toButtonText()           // → "DONE"
'Sign In'.toButtonText()        // → "SIGN IN"
'Sign Up'.toButtonText()        // → "SIGN UP"
'Start Journaling'.toButtonText() // → "START JOURNALING"
```

### Why Uppercase for CTA Buttons?

1. **Visual Hierarchy** - Uppercase draws attention to primary actions
2. **Design Consistency** - Matches modern mobile app design patterns
3. **Accessibility** - Bold, clear text is easier to identify
4. **Brand Identity** - Creates a strong, confident visual presence

### Non-Button Text (Keep Normal Case)

Not all text should be uppercase. The following should remain in normal sentence case:

- Body text (`AppTextStyles.body`)
- Journal entries (`AppTextStyles.journalBodyText`)
- Headings (`AppTextStyles.h1`, `h2`, etc.)
- Labels (`AppTextStyles.ui`)
- Navigation (`AppTextStyles.navActive`)
- Captions (`AppTextStyles.caption`)

### Typography System Summary

| Style | Size | Weight | Letter Spacing | Uppercase |
|-------|------|--------|----------------|-----------|
| `ctaButtonText` | 16pt | 600 | 1.2 | ✅ YES |
| `buttonLarge` | 18pt | 600 | 1.5 | ✅ YES |
| `button` | 16pt | 600 | 1.2 | ✅ YES |
| `buttonSmall` | 14pt | 500 | 0.3 | ❌ NO |
| `journalBodyText` | 17pt | 400 | 0.0 | ❌ NO |
| `body` | 16pt | 400 | 0.0 | ❌ NO |

### Need Help?

For questions about typography usage, refer to:
- [lib/constants/typography.dart](lib/constants/typography.dart) - Full typography definitions
- [lib/utils/design_tokens.dart](lib/utils/design_tokens.dart) - Button styles and tokens
- [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) - Overall design system documentation
