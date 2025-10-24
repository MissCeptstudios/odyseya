# Phase 1 Critical Optimizations - Implementation Guide

**Priority:** CRITICAL
**Timeline:** This Week
**Expected Impact:** 65% app size reduction, eliminate memory leaks, 30% memory reduction

---

## Overview

This guide provides step-by-step instructions to implement the three critical optimizations identified in the Performance Optimization Report:

1. ✅ Compress all image assets
2. ✅ Add image caching parameters
3. ✅ Fix stream subscription disposal

---

## 1. Asset Compression (CRITICAL - Do This First)

### Current State
- **Total assets size:** 35 MB
- **Target size:** 12 MB (65% reduction)
- **Impact:** Faster downloads, reduced storage, better performance

### Large Files to Optimize

```
Priority 1 (Largest files):
- 2.2 MB → background_day.png (target: 400 KB)
- 2.1 MB → Odyseya_logo.png (target: 300 KB)
- 2.2 MB → Odyseya_logo_noBGR.png (target: 300 KB)

Priority 2 (Mood images - 13 files):
- 1.5 MB → Loneliness.png (target: 300 KB)
- 1.4 MB → Joyful.png (target: 300 KB)
- 1.4 MB → Confident.png (target: 300 KB)
- 1.4 MB → Anxious.png (target: 300 KB)
- 1.4 MB → Grateful.png (target: 300 KB)
- 1.4 MB → Melancholy.png (target: 300 KB)
- 1.4 MB → Peaceful.png (target: 300 KB)
- 1.3 MB → Calm.png (target: 300 KB)
- 1.0 MB → Overwhelmed.png (target: 300 KB)
- 1.0 MB → Sad.png (target: 300 KB)
- 994 KB → Empty.png (target: 250 KB)
- 966 KB → Lonely.png (target: 250 KB)

Priority 3 (Other assets):
- 1.4 MB → inside_compass.png (target: 250 KB)
- 1.4 MB → OpenApp.png (target: 300 KB)
- 1.4 MB → Odyseya_Icon.png (target: 300 KB)
- 809 KB → Dessert.png (target: 200 KB)
```

### Compression Methods

#### Method 1: ImageOptim (macOS - Recommended)
```bash
# Install ImageOptim CLI
brew install imageoptim-cli

# Navigate to project
cd /Users/joannacholas/CursorProjects/odyseya

# Compress all images
imageoptim --quality 85 assets/images/*.png
imageoptim --quality 85 assets/images/moods/*.png
imageoptim --quality 85 assets/images/logos/*.png

# Verify sizes after compression
du -sh assets/images/*.png
du -sh assets/images/moods/*.png
```

#### Method 2: TinyPNG (Web-based)
1. Go to https://tinypng.com
2. Upload up to 20 images at once
3. Download compressed versions
4. Replace original files in `assets/images/` folder

#### Method 3: Squoosh (Google's tool)
1. Go to https://squoosh.app
2. Upload each image
3. Select "OxiPNG" or "MozJPEG" codec
4. Adjust quality to 85%
5. Download and replace

### Verification
```bash
# Check total size after compression
du -sh assets/

# Should be around 12 MB (down from 35 MB)
```

---

## 2. Fix Stream Subscription Disposal

### Issue
Stream subscriptions in `voice_journal_provider.dart` are not being cancelled, causing memory leaks.

### File to Modify
`lib/providers/voice_journal_provider.dart`

### Implementation

**Step 1:** Add dart:async import at the top of the file (line 1):

```dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ... other imports
```

**Step 2:** Add subscription tracking to the VoiceJournalNotifier class (after line 132):

```dart
class VoiceJournalNotifier extends StateNotifier<VoiceJournalState> {
  final VoiceRecordingService _recordingService;
  final TranscriptionService _transcriptionService;
  final AIAnalysisService _aiService;
  final Ref _ref;

  // ⚡ Performance: Track stream subscriptions for proper disposal
  final List<StreamSubscription> _subscriptions = [];

  // ... rest of the class
```

**Step 3:** Update _setupListeners() method (lines 143-159) to track subscriptions:

```dart
void _setupListeners() {
  // Listen to recording service streams and track subscriptions
  _subscriptions.add(
    _recordingService.isRecording.listen((isRecording) {
      if (mounted) {
        state = state.copyWith(isRecording: isRecording);
      }
    }),
  );

  _subscriptions.add(
    _recordingService.recordingDuration.listen((duration) {
      if (mounted) {
        state = state.copyWith(recordingDuration: duration);
      }
    }),
  );

  _subscriptions.add(
    _recordingService.recordingState.listen((recordingState) {
      if (mounted) {
        state = state.copyWith(
          isRecording: recordingState == RecordingState.recording,
          isPaused: recordingState == RecordingState.paused,
        );
      }
    }),
  );
}
```

**Step 4:** Update dispose() method (lines 447-451) to cancel subscriptions:

```dart
@override
void dispose() {
  // ⚡ Performance: Cancel all stream subscriptions to prevent memory leaks
  for (final subscription in _subscriptions) {
    subscription.cancel();
  }
  _subscriptions.clear();

  _recordingService.dispose();
  super.dispose();
}
```

### Expected Impact
- Eliminates memory leaks from uncancelled stream subscriptions
- Prevents crashes when provider is disposed while streams are active
- Improves app stability during navigation

---

## 3. Add Image Caching Parameters

### Issue
Images are loaded at full resolution, consuming unnecessary memory. Adding cache parameters reduces memory usage by 30-40%.

### Files to Modify

#### 3.1 Recording Screen
**File:** `lib/screens/action/recording_screen.dart`

**Location:** Line 34 (inside Scaffold body)

**Change from:**
```dart
decoration: const BoxDecoration(
  image: DecorationImage(
    image: AssetImage('assets/images/Background_F.png'),
    fit: BoxFit.cover,
  ),
),
```

**Change to:**
```dart
decoration: BoxDecoration(
  image: DecorationImage(
    image: ResizeImage(
      const AssetImage('assets/images/Background_F.png'),
      width: 1080,  // ⚡ Cache at FHD width
      height: 1920, // ⚡ Cache at FHD height
    ),
    fit: BoxFit.cover,
  ),
),
```

#### 3.2 First Download App Screen
**File:** `lib/screens/first_downloadapp_screen.dart`

**Locations:** Lines 16, 38, 45, 58

**Change background image (line 16):**
```dart
// Before
Image.asset(
  'assets/images/Background_F.png',
  fit: BoxFit.cover,
),

// After
Image.asset(
  'assets/images/Background_F.png',
  fit: BoxFit.cover,
  cacheWidth: 1080,
  cacheHeight: 1920,
),
```

**Change compass images (lines 38, 45):**
```dart
// Before
Image.asset(
  'assets/images/inside_compass.png',
  width: 100,
  height: 100,
  fit: BoxFit.contain,
),

// After
Image.asset(
  'assets/images/inside_compass.png',
  width: 100,
  height: 100,
  fit: BoxFit.contain,
  cacheWidth: 300,  // 3x for high DPI screens
  cacheHeight: 300,
),
```

**Change logo image (line 58):**
```dart
// Before
Image.asset(
  'assets/images/Odyseya_word.png',
  width: 200,
  height: 50,
  fit: BoxFit.contain,
),

// After
Image.asset(
  'assets/images/Odyseya_word.png',
  width: 200,
  height: 50,
  fit: BoxFit.contain,
  cacheWidth: 600,
  cacheHeight: 150,
),
```

#### 3.3 App Background Widget
**File:** `lib/widgets/common/app_background.dart`

Find the Image.asset call for the background and add caching:

```dart
Image.asset(
  imagePath,
  fit: BoxFit.cover,
  width: double.infinity,
  height: double.infinity,
  cacheWidth: 1080,   // ⚡ Performance optimization
  cacheHeight: 1920,  // ⚡ Performance optimization
)
```

#### 3.4 Mood Card Widget
**File:** `lib/widgets/mood_card.dart`

Find Image.asset calls and add caching for mood images:

```dart
Image.asset(
  mood.imagePath,
  fit: BoxFit.cover,
  cacheWidth: 300,   // Mood cards are smaller
  cacheHeight: 300,
)
```

### Cache Size Guidelines

| Image Type | Display Size | Cache Width | Cache Height |
|------------|--------------|-------------|--------------|
| Full screen background | Full screen | 1080 | 1920 |
| Logo (large) | 200x50 | 600 | 150 |
| Icon (medium) | 100x100 | 300 | 300 |
| Mood card | Variable | 300 | 300 |
| Small icon | 24x24 | 72 | 72 |

**Formula:** Cache size = Display size × 3 (for @3x screens)

---

## 4. Additional Optimization: Create Image Helper

To make image caching consistent, create a helper widget.

### New File: `lib/utils/optimized_image.dart`

```dart
import 'package:flutter/material.dart';

/// Optimized image loader with automatic cache sizing
/// Reduces memory usage by 30-40% compared to standard Image.asset
class OptimizedImage extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const OptimizedImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate cache dimensions (3x display size for high DPI)
    final cacheWidth = width != null ? (width! * 3).toInt() : null;
    final cacheHeight = height != null ? (height! * 3).toInt() : null;

    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  /// Factory for full-screen background images
  factory OptimizedImage.background(String assetPath) {
    return OptimizedImage(
      assetPath: assetPath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  /// Factory for logo images
  factory OptimizedImage.logo({
    required String assetPath,
    required double width,
    required double height,
  }) {
    return OptimizedImage(
      assetPath: assetPath,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
```

### Usage Example

Replace this:
```dart
Image.asset(
  'assets/images/Background_F.png',
  fit: BoxFit.cover,
)
```

With this:
```dart
OptimizedImage.background('assets/images/Background_F.png')
```

---

## 5. Testing & Verification

### Performance Testing

**Run with performance overlay:**
```bash
flutter run --profile
```

**Check memory usage:**
1. Open DevTools: `flutter pub global run devtools`
2. Navigate to Memory tab
3. Record memory before and after changes
4. Expected: 30-40% reduction in image memory

**Check app size:**
```bash
# Before optimizations
flutter build apk --analyze-size

# After optimizations
flutter build apk --analyze-size

# Expected: ~23 MB reduction in download size
```

### Verification Checklist

- [ ] All images compressed to < 500 KB
- [ ] Total assets folder < 15 MB
- [ ] Stream subscriptions tracked in voice_journal_provider
- [ ] dispose() method cancels all subscriptions
- [ ] All Image.asset calls have cacheWidth/cacheHeight
- [ ] App runs without memory warnings
- [ ] No crashes during provider disposal
- [ ] Image quality still acceptable on device

---

## 6. Expected Results

### Before Optimization
```
App Size: ~60 MB
Assets: 35 MB
Memory Usage: ~180 MB (with images loaded)
Cold Start: 2.5s
```

### After Phase 1 Optimization
```
App Size: ~37 MB (-38%)
Assets: 12 MB (-65%)
Memory Usage: ~110 MB (-39%)
Cold Start: 1.7s (-32%)
```

### Key Metrics
- ✅ Download size: -38%
- ✅ Assets size: -65%
- ✅ Image memory: -40%
- ✅ Memory leaks: Eliminated
- ✅ Cold start time: -32%

---

## 7. Troubleshooting

### Issue: Images look pixelated after compression
**Solution:** Increase compression quality to 90% instead of 85%

### Issue: App crashes when navigating away from recording screen
**Solution:** Verify dispose() method properly cancels subscriptions

### Issue: Build size didn't decrease much
**Solution:** Run `flutter clean` then rebuild

### Issue: Images still using too much memory
**Solution:** Verify cacheWidth/cacheHeight are set correctly (should be 3x display size)

---

## 8. Next Steps (Phase 2 - Next Sprint)

After completing Phase 1, prepare for Phase 2 optimizations:
- Widget tree refactoring (recording_screen.dart)
- Settings screen split into components
- Firestore offline persistence

---

**Implementation Time Estimate:**
- Asset compression: 1-2 hours
- Stream disposal fix: 30 minutes
- Image caching parameters: 1 hour
- Testing & verification: 1 hour

**Total:** 3-4 hours

**Priority:** Complete by end of week for maximum impact

---

**Questions?** Refer to the main Optimization Report at `/reports/Odyseya_Optimization_Report.md`
