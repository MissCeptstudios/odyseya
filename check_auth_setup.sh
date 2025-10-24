#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "======================================"
echo "🔐 Checking Authentication Setup"
echo "======================================"
echo ""

# Check iOS Files
echo "📱 iOS Configuration:"
echo "--------------------"

if [ -f "ios/Runner/Runner.entitlements" ]; then
    echo -e "${GREEN}✅${NC} Runner.entitlements exists"

    # Check if it contains Apple Sign In capability
    if grep -q "com.apple.developer.applesignin" "ios/Runner/Runner.entitlements"; then
        echo -e "${GREEN}✅${NC} Apple Sign In capability found in entitlements"
    else
        echo -e "${RED}❌${NC} Apple Sign In capability NOT found in entitlements"
    fi
else
    echo -e "${RED}❌${NC} Runner.entitlements NOT found"
fi

if [ -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo -e "${GREEN}✅${NC} GoogleService-Info.plist exists"
else
    echo -e "${RED}❌${NC} GoogleService-Info.plist NOT found"
fi

if [ -f "ios/Runner/Info.plist" ]; then
    echo -e "${GREEN}✅${NC} Info.plist exists"

    # Check for required privacy descriptions
    if grep -q "NSMicrophoneUsageDescription" "ios/Runner/Info.plist"; then
        echo -e "${GREEN}✅${NC} Microphone permission description found"
    else
        echo -e "${YELLOW}⚠️${NC}  Microphone permission description missing"
    fi
else
    echo -e "${RED}❌${NC} Info.plist NOT found"
fi

echo ""

# Check Android Files
echo "🤖 Android Configuration:"
echo "------------------------"

if [ -f "android/app/google-services.json" ]; then
    echo -e "${GREEN}✅${NC} google-services.json exists"
else
    echo -e "${RED}❌${NC} google-services.json NOT found"
fi

if grep -q "com.google.gms.google-services" "android/settings.gradle.kts"; then
    echo -e "${GREEN}✅${NC} Google Services plugin declared in settings.gradle.kts"
else
    echo -e "${RED}❌${NC} Google Services plugin NOT declared in settings.gradle.kts"
fi

if grep -q "com.google.gms.google-services" "android/app/build.gradle.kts"; then
    echo -e "${GREEN}✅${NC} Google Services plugin applied in build.gradle.kts"
else
    echo -e "${RED}❌${NC} Google Services plugin NOT applied in build.gradle.kts"
fi

if grep -q "INTERNET" "android/app/src/main/AndroidManifest.xml"; then
    echo -e "${GREEN}✅${NC} Internet permission found in AndroidManifest.xml"
else
    echo -e "${YELLOW}⚠️${NC}  Internet permission missing in AndroidManifest.xml"
fi

echo ""

# Check Flutter Dependencies
echo "📦 Flutter Dependencies:"
echo "-----------------------"

if grep -q "firebase_auth:" "pubspec.yaml"; then
    echo -e "${GREEN}✅${NC} firebase_auth package found"
else
    echo -e "${RED}❌${NC} firebase_auth package NOT found"
fi

if grep -q "google_sign_in:" "pubspec.yaml"; then
    echo -e "${GREEN}✅${NC} google_sign_in package found"
else
    echo -e "${RED}❌${NC} google_sign_in package NOT found"
fi

if grep -q "sign_in_with_apple:" "pubspec.yaml"; then
    echo -e "${GREEN}✅${NC} sign_in_with_apple package found"
else
    echo -e "${RED}❌${NC} sign_in_with_apple package NOT found"
fi

echo ""

# Check Code Implementation
echo "💻 Code Implementation:"
echo "----------------------"

if [ -f "lib/services/auth_service.dart" ]; then
    echo -e "${GREEN}✅${NC} AuthService exists"

    if grep -q "signInWithApple" "lib/services/auth_service.dart"; then
        echo -e "${GREEN}✅${NC} Apple Sign In method implemented"
    else
        echo -e "${RED}❌${NC} Apple Sign In method NOT implemented"
    fi

    if grep -q "signInWithGoogle" "lib/services/auth_service.dart"; then
        echo -e "${GREEN}✅${NC} Google Sign In method implemented"
    else
        echo -e "${RED}❌${NC} Google Sign In method NOT implemented"
    fi

    if grep -q "signInWithEmail" "lib/services/auth_service.dart"; then
        echo -e "${GREEN}✅${NC} Email/Password Sign In method implemented"
    else
        echo -e "${RED}❌${NC} Email/Password Sign In method NOT implemented"
    fi
else
    echo -e "${RED}❌${NC} AuthService NOT found"
fi

echo ""
echo "======================================"
echo "📋 Summary"
echo "======================================"
echo ""
echo "Next steps:"
echo "1. Open Xcode and add 'Sign in with Apple' capability"
echo "   👉 See: XCODE_SETUP_INSTRUCTIONS.md"
echo ""
echo "2. Enable Sign in with Apple in Apple Developer Console"
echo "   👉 https://developer.apple.com/account"
echo ""
echo "3. Get SHA-1 fingerprint and add to Firebase"
echo "   👉 cd android && ./gradlew signingReport"
echo ""
echo "4. Enable auth providers in Firebase Console"
echo "   👉 https://console.firebase.google.com"
echo ""
echo "Full guide: APPLE_GOOGLE_AUTH_SETUP.md"
echo ""
