#!/bin/bash

echo "🧹 Starting hard reset of Odyseya app..."
echo ""

# Navigate to project
cd /Users/joannacholas/CursorProjects/odyseya

# Stop any running Flutter processes
echo "1️⃣ Stopping any running Flutter processes..."
pkill -f flutter || true

# Flutter clean
echo "2️⃣ Running flutter clean..."
flutter clean

# Remove iOS build artifacts
echo "3️⃣ Removing iOS build artifacts..."
rm -rf ios/build
rm -rf ios/.symlinks
rm -rf ios/Flutter/Flutter.framework
rm -rf ios/Pods

# Remove all build caches
echo "4️⃣ Removing build caches..."
rm -rf build
rm -rf .dart_tool

# Pod install (if using iOS)
if [ -d "ios" ]; then
    echo "5️⃣ Running pod install..."
    cd ios
    pod deintegrate || true
    pod install
    cd ..
fi

# Get Flutter dependencies
echo "6️⃣ Getting Flutter dependencies..."
flutter pub get

# Verify colors in code
echo ""
echo "✅ Verifying button colors in code:"
grep "westernSunrise = Color" lib/constants/colors.dart

echo ""
echo "✅ Hard reset complete!"
echo ""
echo "📱 Next steps:"
echo "1. Close the app completely on your device/simulator"
echo "2. Run: flutter run"
echo "3. All buttons should now show #D8A36C (westernSunrise)"
echo ""
