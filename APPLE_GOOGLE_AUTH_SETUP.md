# Apple Sign In & Google Sign In - Complete Setup Guide

## ✅ Status: READY TO USE

All code and configurations are in place. You only need to complete the Apple Developer and Firebase Console steps below.

---

## 📱 iOS - Apple Sign In Configuration

### ✅ Code Implementation - COMPLETE
- [x] `sign_in_with_apple` package installed (v6.1.1)
- [x] `AuthService` class with Apple Sign In implementation
- [x] Nonce generation for security
- [x] SHA256 hashing for nonce
- [x] Full name handling from Apple ID

### ✅ Local Files - COMPLETE
- [x] `Runner.entitlements` created with Apple Sign In capability
- [x] Info.plist has proper privacy descriptions
- [x] PrivacyInfo.xcprivacy configured

### ⚠️ Apple Developer Console - REQUIRES ACTION

**You MUST complete these steps in Apple Developer Console:**

1. **Enable Sign in with Apple Capability**
   - Go to: https://developer.apple.com/account
   - Navigate to: Certificates, Identifiers & Profiles
   - Select your App ID (Bundle ID: `com.example.odyseya`)
   - Enable "Sign in with Apple" capability
   - Click "Save"

2. **Configure Service ID (Optional for Web)**
   - If you plan to support web in future
   - Create a Services ID
   - Enable "Sign in with Apple"
   - Configure Return URLs

3. **Xcode Project Configuration**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select Runner target
   - Go to "Signing & Capabilities" tab
   - Click "+ Capability"
   - Add "Sign in with Apple"
   - Ensure the entitlements file is linked: `Runner/Runner.entitlements`

**File Location:**
```
ios/Runner/Runner.entitlements
```

**Contents:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.applesignin</key>
    <array>
        <string>Default</string>
    </array>
    <key>aps-environment</key>
    <string>development</string>
    <key>keychain-access-groups</key>
    <array>
        <string>$(AppIdentifierPrefix)com.example.odyseya</string>
    </array>
</dict>
</plist>
```

---

## 🤖 Android - Google Sign In Configuration

### ✅ Code Implementation - COMPLETE
- [x] `google_sign_in` package installed (v6.1.6)
- [x] `AuthService` class with Google Sign In implementation
- [x] Proper credential handling
- [x] Sign out functionality

### ✅ Local Files - COMPLETE
- [x] `google-services.json` present in `android/app/`
- [x] Google Services plugin configured in `settings.gradle.kts`
- [x] Google Services plugin applied in `app/build.gradle.kts`
- [x] Android permissions added to `AndroidManifest.xml`

### ⚠️ Firebase Console - REQUIRES ACTION

**You MUST complete these steps in Firebase Console:**

1. **Enable Google Sign-In**
   - Go to: https://console.firebase.google.com
   - Select your project
   - Navigate to: Authentication → Sign-in method
   - Enable "Google" provider
   - Click "Save"

2. **Get SHA-1 Certificate Fingerprint**

   For **Debug** builds:
   ```bash
   cd android
   ./gradlew signingReport
   ```

   Look for the SHA-1 under "Variant: debug"

   For **Release** builds (when you create release keystore):
   ```bash
   keytool -list -v -keystore your-release-key.keystore
   ```

3. **Add SHA-1 to Firebase**
   - In Firebase Console
   - Go to: Project Settings → Your Apps → Android app
   - Scroll to "SHA certificate fingerprints"
   - Click "Add fingerprint"
   - Paste your SHA-1
   - Click "Save"

4. **Download Updated google-services.json**
   - After adding SHA-1, download new `google-services.json`
   - Replace existing file at: `android/app/google-services.json`

**Important Files:**
```
android/app/google-services.json (Firebase config)
android/settings.gradle.kts (Google Services plugin declared)
android/app/build.gradle.kts (Google Services plugin applied)
```

---

## 🔥 Firebase Authentication Setup

### ✅ Code Implementation - COMPLETE
- [x] `firebase_auth` package installed (v5.3.1)
- [x] `firebase_core` package installed (v3.6.0)
- [x] Complete `AuthService` with all methods

### ⚠️ Firebase Console Configuration - REQUIRES ACTION

1. **Enable Email/Password Authentication**
   - Firebase Console → Authentication → Sign-in method
   - Enable "Email/Password"
   - Click "Save"

2. **Enable Google Sign-In**
   - Same location as above
   - Enable "Google"
   - Provide project support email
   - Click "Save"

3. **Enable Apple Sign-In**
   - Same location as above
   - Enable "Apple"
   - You'll need:
     - Apple Team ID (from Apple Developer)
     - Service ID (optional)
     - Private Key (.p8 file from Apple Developer)
     - Key ID
   - Click "Save"

**To get Apple credentials for Firebase:**
1. Go to Apple Developer Console
2. Certificates, Identifiers & Profiles → Keys
3. Create new key with "Sign in with Apple" enabled
4. Download .p8 file (keep it safe!)
5. Note the Key ID
6. Add these to Firebase Apple provider settings

---

## 📋 Flutter Code Usage

### Using the AuthService

The `AuthService` is already implemented at:
```
lib/services/auth_service.dart
```

### Example Usage:

```dart
import 'package:odyseya/services/auth_service.dart';

final authService = AuthService();

// Sign in with Email
try {
  await authService.signInWithEmail(
    email: 'user@example.com',
    password: 'password123',
  );
} catch (e) {
  // Handle error
}

// Sign in with Google
try {
  await authService.signInWithGoogle();
} catch (e) {
  // Handle error
}

// Sign in with Apple (iOS only)
try {
  await authService.signInWithApple();
} catch (e) {
  // Handle error
}

// Sign out
await authService.signOut();
```

---

## 🧪 Testing Checklist

### iOS Testing
- [ ] Build runs without errors
- [ ] Apple Sign In button appears
- [ ] Tapping button shows Apple ID prompt
- [ ] Can sign in with Apple ID
- [ ] User data persists after app restart
- [ ] Sign out works correctly

### Android Testing
- [ ] Build runs without errors
- [ ] Google Sign In button appears
- [ ] Tapping button shows Google account picker
- [ ] Can sign in with Google account
- [ ] User data persists after app restart
- [ ] Sign out works correctly

### Both Platforms
- [ ] Email/Password sign in works
- [ ] Email/Password sign up works
- [ ] Password reset works
- [ ] Auth state persists correctly
- [ ] Navigation works after auth state changes

---

## 📁 File Structure

```
odyseya/
├── lib/
│   └── services/
│       └── auth_service.dart          ✅ Complete implementation
│
├── ios/
│   └── Runner/
│       ├── Runner.entitlements        ✅ Apple Sign In enabled
│       ├── Info.plist                 ✅ Privacy descriptions
│       ├── PrivacyInfo.xcprivacy      ✅ Privacy manifest
│       └── GoogleService-Info.plist   ✅ Firebase iOS config
│
└── android/
    ├── settings.gradle.kts            ✅ Google Services plugin
    ├── app/
    │   ├── build.gradle.kts           ✅ Google Services applied
    │   ├── google-services.json       ✅ Firebase Android config
    │   └── src/main/
    │       └── AndroidManifest.xml    ✅ Permissions configured
    └── app/proguard-rules.pro         ✅ ProGuard rules
```

---

## 🚀 Next Steps

### Immediate Actions Required:
1. ✅ Open Xcode and add "Sign in with Apple" capability
2. ✅ Enable Apple Sign In in Apple Developer Console
3. ✅ Get SHA-1 fingerprint for Android
4. ✅ Add SHA-1 to Firebase Console
5. ✅ Enable authentication providers in Firebase Console
6. ✅ Configure Apple credentials in Firebase (for Apple Sign In)

### After Configuration:
1. Test on iOS device/simulator
2. Test on Android device/emulator
3. Verify auth persistence
4. Test error handling
5. Deploy to TestFlight/Internal Testing

---

## 🔐 Security Notes

- ✅ Nonce generated securely for Apple Sign In
- ✅ SHA256 hashing implemented
- ✅ Firebase handles token management
- ✅ ProGuard rules protect sensitive code
- ⚠️ Keep .p8 Apple key file secure (NEVER commit to git)
- ⚠️ Use environment variables for sensitive data
- ⚠️ Enable App Check in Firebase for production

---

## 📚 Resources

- [Firebase Authentication Docs](https://firebase.google.com/docs/auth)
- [Sign in with Apple (Apple)](https://developer.apple.com/sign-in-with-apple/)
- [Google Sign-In for iOS](https://developers.google.com/identity/sign-in/ios)
- [Google Sign-In for Android](https://developers.google.com/identity/sign-in/android)
- [Flutter Firebase Auth Package](https://pub.dev/packages/firebase_auth)

---

## ❓ Common Issues & Solutions

### iOS: "Sign in with Apple" button doesn't appear
- Check if entitlements file is linked in Xcode
- Verify capability is enabled in Apple Developer Console
- Clean build folder and rebuild

### Android: Google Sign In fails
- Verify SHA-1 is added to Firebase Console
- Check google-services.json is up to date
- Ensure Google Sign In is enabled in Firebase

### Both: Authentication not persisting
- Check Firebase initialization in main.dart
- Verify auth state listener is set up correctly
- Check for errors in console logs

---

**Status:** Ready for Apple Developer Console and Firebase Console configuration ✅

**Code Status:** 100% Complete ✅

**Configuration Status:** Requires manual steps in external consoles ⚠️
