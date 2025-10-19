# Hard Reset & Rebuild Instructions

**Issue:** App not showing button color changes  
**Solution:** Complete rebuild from scratch

---

## 🚀 Quick Method (Recommended)

```bash
cd /Users/joannacholas/CursorProjects/odyseya
./hard_reset.sh
```

Then:
1. **Close the app completely** on your device/simulator
2. Run: `flutter run`
3. Verify button colors are now #D8A36C

---

## 🔧 Manual Method (Step by Step)

### 1. Stop Everything
```bash
# Kill all Flutter processes
pkill -f flutter
```

### 2. Clean Flutter
```bash
cd /Users/joannacholas/CursorProjects/odyseya
flutter clean
```

### 3. Remove iOS Build Artifacts
```bash
rm -rf ios/build
rm -rf ios/.symlinks  
rm -rf ios/Flutter/Flutter.framework
rm -rf ios/Pods
```

### 4. Remove Build Caches
```bash
rm -rf build
rm -rf .dart_tool
```

### 5. Reinstall Pods (iOS)
```bash
cd ios
pod deintegrate
pod install
cd ..
```

### 6. Get Dependencies
```bash
flutter pub get
```

### 7. Rebuild & Run
```bash
flutter run
```

---

## ✅ Verification Checklist

After rebuild, verify these screens:

### Auth Choice Screen
- [ ] Sign In button: Bold orange #D8A36C
- [ ] Sign Up button: Orange border #D8A36C

### Login Screen  
- [ ] Sign In button: Bold orange #D8A36C

### Affirmation Screen
- [ ] Continue button: Bold orange #D8A36C

### Voice Journal Screen
- [ ] Save button: Bold orange #D8A36C
- [ ] Action buttons: Bold orange #D8A36C

### Paywall Screen
- [ ] Subscription buttons: Bold orange #D8A36C

### Settings Screen
- [ ] Upgrade to Premium: Bold orange #D8A36C

---

## 🎨 Correct Color Reference

**westernSunrise (#D8A36C)**
- RGB: (216, 163, 108)
- Should look like warm orange/caramel
- NOT washed out or too brownish

**Wrong Colors (Should NOT See):**
- ❌ #DBAC80 (too light/washed out)
- ❌ #C89B7A (too brownish/pinkish)

---

## 🔍 Debugging

If colors still wrong after rebuild:

### 1. Verify Code
```bash
# Check Sign In button
grep -A10 "Sign In" lib/screens/auth/auth_choice_screen.dart

# Should show: backgroundColor: DesertColors.westernSunrise
```

### 2. Check Color Definition
```bash
grep "westernSunrise" lib/constants/colors.dart

# Should show: static const Color westernSunrise = Color(0xFFD8A36C);
```

### 3. Verify Commits
```bash
git log --oneline -5

# Should include:
# 482c16a fix: Correct primary button colors to westernSunrise (#D8A36C)
```

### 4. Hard Device Reset
- Completely uninstall app from device/simulator
- Rebuild and reinstall fresh

---

## 📱 Platform-Specific Notes

### iOS
- May need to clean Xcode DerivedData:
  ```bash
  rm -rf ~/Library/Developer/Xcode/DerivedData
  ```
- Restart Simulator completely

### Android
- Clear app data: Settings → Apps → Odyseya → Clear Data
- Or uninstall/reinstall

---

## ⚠️ Common Issues

### "Still seeing wrong colors"
1. Make sure you **closed the app completely**
2. Not just backgrounded - fully quit
3. On iOS: Swipe up and remove from app switcher
4. On Android: Force stop in settings

### "Build fails"
1. Check Flutter doctor: `flutter doctor -v`
2. Update Flutter if needed: `flutter upgrade`
3. Verify Xcode/Android Studio are up to date

### "Hot reload doesn't show changes"
- Hot reload WON'T update const colors
- Must do full restart or rebuild

---

## ✅ Success Indicators

After successful rebuild:
- ✅ All primary buttons bold orange #D8A36C
- ✅ Consistent color across all screens
- ✅ No washed out or brownish buttons
- ✅ Clear visual hierarchy

---

**Last Updated:** 2025-01-19  
**Related Fix:** Commit 482c16a
