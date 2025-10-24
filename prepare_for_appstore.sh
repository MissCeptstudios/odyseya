#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "======================================"
echo "📱 App Store Deployment Preparation"
echo "======================================"
echo ""

# Function to check if command succeeded
check_result() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $1${NC}"
    else
        echo -e "${RED}❌ $1 FAILED${NC}"
        exit 1
    fi
}

# 1. Check Flutter version
echo -e "${BLUE}Checking Flutter version...${NC}"
flutter --version
check_result "Flutter version check"
echo ""

# 2. Clean previous builds
echo -e "${BLUE}Cleaning previous builds...${NC}"
flutter clean
check_result "Flutter clean"
echo ""

# 3. Get dependencies
echo -e "${BLUE}Getting dependencies...${NC}"
flutter pub get
check_result "Flutter pub get"
echo ""

# 4. Update iOS pods
echo -e "${BLUE}Updating iOS CocoaPods...${NC}"
cd ios
pod install
check_result "Pod install"
echo ""

# 5. Check for iOS build issues
echo -e "${BLUE}Checking iOS configuration...${NC}"
cd ..

# Check Info.plist
if [ -f "ios/Runner/Info.plist" ]; then
    echo -e "${GREEN}✅ Info.plist exists${NC}"

    # Check for required privacy descriptions
    if grep -q "NSMicrophoneUsageDescription" "ios/Runner/Info.plist"; then
        echo -e "${GREEN}✅ Microphone permission description found${NC}"
    else
        echo -e "${RED}❌ Missing NSMicrophoneUsageDescription${NC}"
    fi

    if grep -q "NSUserNotificationsUsageDescription" "ios/Runner/Info.plist" || \
       grep -q "NSUserNotificationUsageDescription" "ios/Runner/Info.plist"; then
        echo -e "${GREEN}✅ Notifications permission description found${NC}"
    else
        echo -e "${YELLOW}⚠️  Missing NSUserNotificationsUsageDescription${NC}"
    fi
else
    echo -e "${RED}❌ Info.plist not found${NC}"
fi

echo ""

# Check for App Icon
if [ -d "ios/Runner/Assets.xcassets/AppIcon.appiconset" ]; then
    echo -e "${GREEN}✅ AppIcon.appiconset exists${NC}"

    # Count images
    icon_count=$(ls -1 ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png 2>/dev/null | wc -l)
    if [ $icon_count -gt 0 ]; then
        echo -e "${GREEN}✅ Found $icon_count app icon images${NC}"
    else
        echo -e "${RED}❌ No app icon images found${NC}"
    fi
else
    echo -e "${RED}❌ AppIcon.appiconset not found${NC}"
fi

echo ""

# Check version in pubspec.yaml
echo -e "${BLUE}Checking version...${NC}"
if [ -f "pubspec.yaml" ]; then
    version=$(grep "^version:" pubspec.yaml | awk '{print $2}')
    echo -e "${GREEN}✅ Current version: $version${NC}"
else
    echo -e "${RED}❌ pubspec.yaml not found${NC}"
fi

echo ""

# 6. Run tests (optional but recommended)
echo -e "${BLUE}Running tests...${NC}"
echo -e "${YELLOW}⚠️  Skipping tests (run manually: flutter test)${NC}"
# Uncomment to run tests automatically:
# flutter test
# check_result "Tests"

echo ""

# 7. Build iOS release
echo -e "${BLUE}Building iOS release...${NC}"
echo -e "${YELLOW}This may take 5-10 minutes...${NC}"
flutter build ios --release --no-codesign
check_result "iOS release build"

echo ""
echo "======================================"
echo -e "${GREEN}✅ Preparation Complete!${NC}"
echo "======================================"
echo ""
echo "Next steps:"
echo "1. Open Xcode:"
echo "   ${BLUE}open ios/Runner.xcworkspace${NC}"
echo ""
echo "2. In Xcode:"
echo "   - Select 'Any iOS Device' as destination"
echo "   - Product → Archive"
echo "   - Wait for archive to complete"
echo "   - Distribute App → App Store Connect"
echo ""
echo "3. Follow the guide:"
echo "   ${BLUE}APPLE_APP_STORE_DEPLOYMENT.md${NC}"
echo ""
echo "Good luck! 🚀"
