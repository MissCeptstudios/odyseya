# 🏜️ ODYSEYA AUTO-FIX INSTRUCTIONS
## Generated: 2025-10-23

This document contains detailed fix instructions for all UX compliance violations detected in the Odyseya codebase.

---

## 🔴 CRITICAL PRIORITY FIXES

### 1. **review_submit_screen.dart** - 10+ Violations (HIGHEST PRIORITY)

**File**: `lib/screens/action/review_submit_screen.dart`

#### Required Changes:

1. **Add import** (after line 6):
   ```dart
   import '../../constants/colors.dart';
   ```

2. **Fix mood colors** (lines 18-22):
   ```dart
   // BEFORE:
   {'emoji': '😊', 'label': 'Happy', 'color': Color(0xFFFFD93D)},
   {'emoji': '😢', 'label': 'Sad', 'color': Color(0xFF6BCB77)},
   {'emoji': '😰', 'label': 'Anxious', 'color': Color(0xFFFF6B6B)},
   {'emoji': '😌', 'label': 'Calm', 'color': Color(0xFF4D96FF)},
   {'emoji': '😠', 'label': 'Angry', 'color': Color(0xFFFF9671)},

   // AFTER:
   {'emoji': '😊', 'label': 'Happy', 'color': DesertColors.westernSunrise},
   {'emoji': '😢', 'label': 'Sad', 'color': DesertColors.arcticRain},
   {'emoji': '😰', 'label': 'Anxious', 'color': DesertColors.caramelDrizzle},
   {'emoji': '😌', 'label': 'Calm', 'color': DesertColors.arcticRain},
   {'emoji': '😠', 'label': 'Angry', 'color': DesertColors.westernSunrise},
   ```

3. **Fix white text color** (line 57):
   ```dart
   // BEFORE: color: Colors.white,
   // AFTER:
   color: DesertColors.brownBramble,
   ```

4. **Fix white text color** (line 123):
   ```dart
   // BEFORE: color: Colors.white,
   // AFTER:
   color: DesertColors.brownBramble,
   ```

5. **Fix mood card colors** (lines 79-80):
   ```dart
   // BEFORE:
   color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.3),

   // AFTER:
   color: isSelected ? DesertColors.cardWhite : DesertColors.cardWhite.withValues(alpha: 0.3),
   ```

6. **Fix mood label text color** (lines 102-104):
   ```dart
   // BEFORE:
   color: isSelected ? const Color(0xFF2B7A9E) : Colors.white,

   // AFTER:
   color: isSelected ? DesertColors.brownBramble : DesertColors.treeBranch,
   ```

7. **Fix entry preview container** (lines 133-140):
   ```dart
   // BEFORE:
   color: Colors.white.withValues(alpha: 0.9),
   borderRadius: BorderRadius.circular(20),
   boxShadow: [
     BoxShadow(
       color: Colors.black.withValues(alpha: 0.1),
       blurRadius: 10,
       offset: const Offset(0, 5),
     ),
   ],

   // AFTER:
   color: DesertColors.cardWhite.withValues(alpha: 0.9),
   borderRadius: BorderRadius.circular(16),  // 20 → 16
   boxShadow: [
     BoxShadow(
       color: Colors.black.withValues(alpha: 0.08),  // 0.1 → 0.08
       blurRadius: 8,  // 10 → 8
       offset: const Offset(0, 4),  // (0,5) → (0,4)
     ),
   ],
   ```

8. **Fix mic icon color** (line 150):
   ```dart
   // BEFORE: color: Color(0xFF2B8AB8),
   // AFTER:
   color: DesertColors.arcticRain,
   ```

9. **Fix voice recording text color** (line 159):
   ```dart
   // BEFORE: color: Color(0xFF2B7A9E),
   // AFTER:
   color: DesertColors.brownBramble,
   ```

10. **Fix duration text color** (line 169):
    ```dart
    // BEFORE: color: Color(0xFF8B7355),
    // AFTER:
    color: DesertColors.treeBranch,
    ```

11. **Fix hint text color** (line 177):
    ```dart
    // BEFORE: color: Color(0xFF8B7355),
    // AFTER:
    color: DesertColors.treeBranch,
    ```

12. **Fix button color** (line 200):
    ```dart
    // BEFORE: backgroundColor: const Color(0xFFD8A36C),
    // AFTER:
    backgroundColor: DesertColors.westernSunrise,
    ```

13. **Fix error SnackBar** (line 230):
    ```dart
    // BEFORE: backgroundColor: Color(0xFFFF6B6B),
    // AFTER:
    backgroundColor: DesertColors.westernSunrise,
    ```

14. **Fix loading indicator** (line 248):
    ```dart
    // BEFORE: valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    // AFTER:
    valueColor: AlwaysStoppedAnimation<Color>(DesertColors.cardWhite),
    ```

15. **Fix loading SnackBar** (line 255):
    ```dart
    // BEFORE: backgroundColor: Color(0xFF2B8AB8),
    // AFTER:
    backgroundColor: DesertColors.arcticRain,
    ```

16. **Fix success icon** (line 289):
    ```dart
    // BEFORE: Icon(Icons.check_circle, color: Colors.white),
    // AFTER:
    Icon(Icons.check_circle, color: DesertColors.cardWhite),
    ```

17. **Fix success SnackBar** (line 296):
    ```dart
    // BEFORE: backgroundColor: Color(0xFF2B8AB8),
    // AFTER:
    backgroundColor: DesertColors.arcticRain,
    ```

18. **Fix error icon** (line 314):
    ```dart
    // BEFORE: const Icon(Icons.error_outline, color: Colors.white),
    // AFTER:
    const Icon(Icons.error_outline, color: DesertColors.cardWhite),
    ```

19. **Fix error SnackBar** (line 321):
    ```dart
    // BEFORE: backgroundColor: const Color(0xFFFF6B6B),
    // AFTER:
    backgroundColor: DesertColors.westernSunrise,
    ```

**Summary for review_submit_screen.dart**: 19 fixes total

---

### 2. **splash_screen.dart** - Critical Typography Violation

**File**: `lib/screens/splash_screen.dart`

**Line 134**: Change white text to brown
```dart
// BEFORE: color: const Color(0xFFFFFFFF)
// AFTER: color: DesertColors.brownBramble  // or treeBranch for secondary text
```

**Add import**:
```dart
import '../constants/colors.dart';
```

---

### 3. **recording_screen.dart** - White Timer Text

**File**: `lib/screens/action/recording_screen.dart`

**Lines 148-159**: Replace white timer text
```dart
// BEFORE: color: Colors.white
// AFTER: color: DesertColors.brownBramble
```

**Line 318**: Fix selected text color
```dart
// BEFORE: color: isSelected ? Colors.white : DesertColors.caramelDrizzle
// AFTER: color: isSelected ? DesertColors.brownBramble : DesertColors.caramelDrizzle
```

---

## 🟠 HIGH PRIORITY FIXES

### 4. **affirmation_screen.dart** - Animation Duration Violations

**File**: `lib/screens/inspiration/affirmation_screen.dart`

**Line 31**: Reduce animation duration
```dart
// BEFORE: duration: const Duration(milliseconds: 1200)
// AFTER: duration: const Duration(milliseconds: 250)
```

**Lines 35-42**: Fix multiple animation durations
```dart
// BEFORE: duration: const Duration(milliseconds: 800)
// AFTER: duration: const Duration(milliseconds: 250)

// BEFORE: duration: const Duration(milliseconds: 600)
// AFTER: duration: const Duration(milliseconds: 250)
```

---

### 5. **dashboard_screen.dart** - Multiple Violations

**File**: `lib/screens/reflection/dashboard_screen.dart`

**Line 136**: Fix corner radius
```dart
// BEFORE: borderRadius: BorderRadius.circular(40)
// AFTER: borderRadius: BorderRadius.circular(16)
```

**Line 304**: Fix hardcoded color
```dart
// BEFORE: Color(0xFFFFF9F4)
// AFTER: DesertColors.backgroundSand  // or cardWhite
```

**Lines 539, 564, 969**: Replace hardcoded colors
```dart
// BEFORE: const Color(0xFFD8A36C)
// AFTER: DesertColors.westernSunrise
```

**Add import if not present**:
```dart
import '../../constants/colors.dart';
```

---

### 6. **voice_journal_screen.dart** - Button Radius + Colors

**File**: `lib/screens/action/voice_journal_screen.dart`

**Lines 243-260**: Fix timer white text
```dart
// BEFORE: color: Colors.white
// AFTER: color: DesertColors.brownBramble
```

**Line 277**: Fix non-compliant microphone button color
```dart
// BEFORE: color: const Color(0xFFA6D8EE)
// AFTER: color: DesertColors.arcticRain  // #C6D9ED
```

**Line 308**: Fix button radius
```dart
// BEFORE: borderRadius: BorderRadius.circular(24)
// AFTER: borderRadius: BorderRadius.circular(16)
```

---

## 🟡 MEDIUM PRIORITY FIXES

### 7. **settings_screen.dart** - Modal Corner Radii

**File**: `lib/screens/settings/settings_screen.dart`

**Lines 326, 433, 553, 717, 761, 1023**: Fix modal border radius to top-only
```dart
// BEFORE:
borderRadius: BorderRadius.circular(32)

// AFTER:
borderRadius: const BorderRadius.only(
  topLeft: Radius.circular(32),
  topRight: Radius.circular(32),
)
```

**Line 1094**: Fix premium container radius
```dart
// BEFORE: borderRadius: BorderRadius.circular(20)
// AFTER: borderRadius: BorderRadius.circular(16)
```

---

### 8. **mood_selection_screen.dart** - Hardcoded Color

**File**: `lib/screens/action/mood_selection_screen.dart`

**Line 90**: Replace hardcoded color
```dart
// BEFORE: color: Color(0xFF57351E)
// AFTER: color: DesertColors.brownBramble
```

**Add import**:
```dart
import '../../constants/colors.dart';
```

---

### 9. **mood_card.dart** - Animation Durations

**File**: `lib/widgets/mood_card.dart`

**Line 31**: Fix too-fast animation
```dart
// BEFORE: duration: const Duration(milliseconds: 150)
// AFTER: duration: const Duration(milliseconds: 200)
```

**Lines 150-153**: Fix slow animations
```dart
// BEFORE: duration: const Duration(milliseconds: 400)
// AFTER: duration: const Duration(milliseconds: 250)
```

---

## 🟢 LOW PRIORITY FIXES

### 10. **signup_screen.dart** - Hardcoded Color

**File**: `lib/screens/auth/signup_screen.dart`

**Lines 130, 177**: Replace hardcoded color
```dart
// BEFORE: color: Color(0xFF6B4423)
// AFTER: color: DesertColors.treeBranch  // or create new constant if needed
```

---

### 11. **gdpr_consent_screen.dart** - Comment Fix

**File**: `lib/screens/onboarding/gdpr_consent_screen.dart`

**Lines 157, 223**: Update misleading comments
```dart
// BEFORE: // 24px radius
// AFTER: // 16px radius (UX Framework v2.0)
```

---

### 12. **preferred_time_screen.dart** - Corner Radius

**File**: `lib/screens/onboarding/preferred_time_screen.dart`

**Line 126**: Fix card radius
```dart
// BEFORE: borderRadius: BorderRadius.circular(20)
// AFTER: borderRadius: BorderRadius.circular(16)
```

---

## 📊 FIX SUMMARY

| Priority | Files | Total Fixes |
|----------|-------|-------------|
| 🔴 Critical | 3 | 25+ |
| 🟠 High | 3 | 12 |
| 🟡 Medium | 3 | 8 |
| 🟢 Low | 3 | 5 |
| **TOTAL** | **12 files** | **50+ fixes** |

---

## ✅ VERIFICATION CHECKLIST

After applying fixes, verify:

- [ ] All imports for `../../constants/colors.dart` are added
- [ ] No hardcoded `Color(0xFF...)` values remain (use DesertColors.*)
- [ ] All corner radii follow framework: 16px (cards/buttons), 32px (modals top-only), 24px (bottom nav top), 12px (toasts)
- [ ] All animations are 200-300ms
- [ ] All text colors are `brownBramble` or `treeBranch` (no white text on backgrounds)
- [ ] All shadows use `blurRadius: 8`, `offset: (0, 4)`, `alpha: 0.08`
- [ ] Run `flutter analyze` to check for errors
- [ ] Run `ux_compliance_checker.py` to verify fixes

---

## 🔄 NEXT STEPS

1. Apply fixes in priority order (Critical → High → Medium → Low)
2. Test each screen after fixing
3. Run compliance checker to verify improvements
4. Commit changes with message: `fix: UX compliance - align colors, radii, and animations to v2.0 framework`
5. Re-run audit to confirm 95%+ compliance

---

*Generated by Odyseya Auto-Fix Agent*
*Timestamp: 2025-10-23*
*Framework: v2.0*
