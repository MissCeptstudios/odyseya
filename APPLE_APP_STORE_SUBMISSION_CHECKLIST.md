# Apple App Store Submission Checklist for Odyseya

**Last Updated:** January 2025
**App Name:** Odyseya
**Bundle ID:** Currently `com.example.odyseya` → **MUST CHANGE**

---

## 🚨 CRITICAL - DO BEFORE ANYTHING ELSE

### 1. Apple Developer Program Membership
- [ ] **Active Apple Developer Account** ($99/year)
- [ ] Enrollment complete and verified
- [ ] Access to https://developer.apple.com
- [ ] Access to https://appstoreconnect.apple.com

**If you don't have this yet:**
1. Go to https://developer.apple.com/programs/
2. Enroll in Apple Developer Program ($99/year)
3. Wait 24-48 hours for approval
4. **You CANNOT submit without this**

---

## 📱 STEP 1: APP CONFIGURATION (IN YOUR CODE)

### A. Update Bundle Identifier ⚠️ CRITICAL
Currently: `com.example.odyseya`

**Must change to your actual domain:**
- Example: `com.yourcompany.odyseya` or `com.odyseya.app`

**Where to change:**
1. Open Xcode project: `ios/Runner.xcodeproj`
2. Select Runner target
3. Go to "Signing & Capabilities" tab
4. Change "Bundle Identifier" to your domain
5. Or edit directly in: `ios/Runner.xcodeproj/project.pbxproj`

**File location:** Line 458 in `project.pbxproj`:
```
PRODUCT_BUNDLE_IDENTIFIER = com.example.odyseya;
```
Change to:
```
PRODUCT_BUNDLE_IDENTIFIER = com.yourcompany.odyseya;
```

### B. App Version & Build Number
Currently: `version: 1.0.0+1` in `pubspec.yaml`

For App Store:
- [ ] Version: 1.0.0 (this is fine)
- [ ] Build number: 1 (this is fine)
- [ ] Increment build number for each submission

### C. App Display Name
Currently: "Odyseya" (in Info.plist) ✅ Good

### D. App Icon
- [ ] Icon at 1024x1024 exists at: `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png`
- [ ] Verify icon looks good (no transparency, no rounded corners)
- [ ] Icon represents your brand

---

## 🔐 STEP 2: CERTIFICATES & PROVISIONING (Apple Developer Portal)

### A. Register App ID
1. Go to https://developer.apple.com/account/resources/identifiers/list
2. Click "+" to create new App ID
3. Select "App IDs" → Continue
4. Select "App" → Continue
5. **Description:** Odyseya
6. **Bundle ID:** Explicit → Enter your new bundle ID (e.g., `com.yourcompany.odyseya`)
7. **Capabilities:** Enable:
   - [ ] Sign in with Apple
   - [ ] Push Notifications (if needed)
   - [ ] In-App Purchase
8. Click "Register"

### B. Create Distribution Certificate
1. Go to https://developer.apple.com/account/resources/certificates/list
2. Click "+" to create new certificate
3. Select "Apple Distribution" → Continue
4. Create Certificate Signing Request (CSR):
   - On Mac: Open "Keychain Access"
   - Menu: Keychain Access → Certificate Assistant → Request Certificate from Certificate Authority
   - Email: Your developer email
   - Common Name: Your name
   - Save to disk
5. Upload CSR → Continue
6. Download certificate
7. Double-click to install in Keychain

### C. Create App Store Provisioning Profile
1. Go to https://developer.apple.com/account/resources/profiles/list
2. Click "+" to create new profile
3. Select "App Store" → Continue
4. Select your App ID → Continue
5. Select your Distribution Certificate → Continue
6. **Profile Name:** "Odyseya App Store"
7. Click "Generate"
8. Download and double-click to install

---

## 🌐 STEP 3: HOSTING REQUIREMENTS

### A. Privacy Policy URL (REQUIRED)
Apple requires a publicly accessible privacy policy URL.

**Options:**

**Option 1: Create Simple Website (Recommended)**
- Use: GitHub Pages, Vercel, Netlify (all FREE)
- Host your privacy policy at: `https://yourname.github.io/odyseya/privacy`
- Must be accessible without login

**Option 2: Use Privacy Policy Generator Site**
- Use service like: https://www.privacypolicies.com/
- Export as web page
- Upload to any web hosting

**Option 3: Google Sites (FREE)**
1. Go to https://sites.google.com
2. Create new site
3. Copy privacy policy text from `gdpr_consent_screen.dart`
4. Publish publicly
5. Get URL

**What you need:**
- [ ] Privacy Policy URL: `https://____________` (fill this in)
- [ ] Publicly accessible (test in private browser)
- [ ] Matches the privacy policy in your app

### B. Support URL (REQUIRED)
- [ ] Support URL: Can be same as privacy policy or email link
- Example: `mailto:odyseya.journal@gmail.com`

### C. Marketing URL (Optional)
- [ ] If you have a website: `https://odyseya.com`
- [ ] Otherwise: Leave blank

---

## 📸 STEP 4: APP STORE SCREENSHOTS (REQUIRED)

You need screenshots for different iPhone sizes:

### Required Sizes:
1. **6.7" Display (iPhone 15 Pro Max, 14 Pro Max, 13 Pro Max, 12 Pro Max)**
   - Resolution: 1290 x 2796 pixels
   - Number needed: 3-10 screenshots

2. **6.5" Display (iPhone 11 Pro Max, XS Max)**
   - Resolution: 1242 x 2688 pixels
   - Number needed: 3-10 screenshots

**How to get screenshots:**
1. Run your app on iPhone 15 Pro Max simulator
2. Take screenshots (Cmd + S in simulator)
3. Find in Desktop or simulator's screenshot folder
4. Name them clearly: `screenshot_1.png`, `screenshot_2.png`, etc.

**Tips:**
- Show main features: Journal entry, voice recording, mood tracking, AI insights
- Remove any test data or dummy content
- Make sure UI looks polished
- First screenshot is most important (shows in search results)

**Optional but Recommended:**
- Add text overlays explaining features
- Use tools like: https://www.appstorescreenshot.com/
- Or design in Canva/Figma

---

## 🎨 STEP 5: APP STORE LISTING CONTENT

Prepare the following content before starting submission:

### A. App Name
- [ ] **App Name:** Odyseya (or "Odyseya - Voice Journal")
- Max 30 characters
- Must be unique on App Store

### B. Subtitle
- [ ] **Subtitle:** "AI-Powered Voice Journaling" (or similar)
- Max 30 characters
- Appears under app name

### C. Description
- [ ] **Description:** Write 2-3 paragraphs about your app
- Max 4000 characters
- Explain features, benefits, what makes it unique

**Example:**
```
Odyseya is your personal voice journaling companion that helps you understand your emotions through AI-powered insights.

Features:
• Voice Recording - Capture your thoughts naturally through voice
• AI Transcription - Automatic transcription of your journal entries
• Emotional Insights - Discover patterns in your emotional journey
• Mood Tracking - Track how you feel over time
• Privacy First - All data encrypted, never sold

Whether you're managing stress, tracking personal growth, or simply want to reflect on your day, Odyseya makes journaling effortless and insightful.

Your privacy matters: All journal entries are encrypted and stored securely. You have complete control over your data with easy export and deletion options.
```

### D. Keywords
- [ ] **Keywords:** Comma-separated, max 100 characters
- Examples: "journal,voice,diary,mood,wellness,mental health,AI,therapy,emotions,mindfulness"

### E. Promotional Text (Optional)
- [ ] 170 characters max
- Can be updated without new app version
- Example: "Start your emotional wellness journey today with AI-powered voice journaling."

### F. What's New (for Version 1.0.0)
- [ ] Release notes for this version
- Example: "Welcome to Odyseya! Your AI-powered voice journaling companion for emotional wellness."

---

## 👤 STEP 6: APP INFORMATION

### A. Category
- [ ] **Primary Category:** Health & Fitness
- [ ] **Secondary Category (optional):** Lifestyle or Productivity

### B. Age Rating
**Based on your app content (mental health, journaling):**

Age Rating Questionnaire:
- Unrestricted Web Access: NO
- Gambling & Contests: NO
- Mature/Suggestive Themes: NO
- Violence: NO
- Realistic Violence: NO
- Prolonged Graphic/Sadistic Violence: NO
- Horror/Fear Themes: NO
- Medical/Treatment Information: YES (select "Infrequent/Mild")
- Alcohol, Tobacco, or Drug Use: NO
- Profanity or Crude Humor: NO
- Sexual Content or Nudity: NO

**Recommended Rating:** 12+ or 17+ (due to mental health content)

### C. Content Rights
- [ ] Check: "I own the rights to this app"

---

## 🔒 STEP 7: APP PRIVACY DETAILS (CRITICAL)

Use your **APP_STORE_PRIVACY_REPORT.md** to fill this out.

### Data Collection - YES or NO?
- [x] **YES** - Your app collects data

### For Each Data Type, Answer:

**Contact Info:**
- Email Address: ✅ YES
  - Linked to user: YES
  - Used for tracking: NO
  - Purposes: App Functionality

- Name: ✅ YES
  - Linked to user: YES
  - Used for tracking: NO
  - Purposes: App Functionality

**Health & Fitness:**
- Mental Health: ✅ YES
  - Linked to user: YES
  - Used for tracking: NO
  - Purposes: App Functionality

**User Content:**
- Audio Data: ✅ YES
  - Linked to user: YES
  - Used for tracking: NO
  - Purposes: App Functionality

- Other User Content: ✅ YES
  - Linked to user: YES
  - Used for tracking: NO
  - Purposes: App Functionality

**Identifiers:**
- User ID: ✅ YES
  - Linked to user: YES
  - Used for tracking: NO
  - Purposes: App Functionality, Analytics

**Location (Optional):**
- Precise Location: ✅ YES (Optional feature)
  - Linked to user: YES
  - Used for tracking: NO
  - Purposes: App Functionality

**Purchases:**
- Purchase History: ✅ YES
  - Linked to user: YES
  - Used for tracking: NO
  - Purposes: App Functionality

**Important:**
- [ ] Privacy Policy URL: (from Step 3)
- [ ] Do you collect data: YES
- [ ] Do you track users: NO

---

## 🏗️ STEP 8: BUILD THE RELEASE VERSION

### A. Clean Build
```bash
cd odyseya
flutter clean
flutter pub get
```

### B. Build for Release
```bash
flutter build ios --release
```

### C. Open in Xcode
```bash
open ios/Runner.xcworkspace
```

### D. Configure Signing in Xcode
1. Select "Runner" project in left sidebar
2. Select "Runner" target
3. Go to "Signing & Capabilities" tab
4. **Team:** Select your Apple Developer account
5. **Provisioning Profile:** Select "Odyseya App Store" profile
6. **Signing Certificate:** Apple Distribution
7. Ensure "Automatically manage signing" is UNCHECKED for Release

### E. Archive the App
1. In Xcode menu: Product → Scheme → Edit Scheme
2. Select "Archive" on left
3. Build Configuration: **Release**
4. Click "Close"
5. In Xcode menu: Product → Archive
6. Wait for archive to complete (5-10 minutes)

### F. Validate the Archive
1. When archive completes, Xcode Organizer opens
2. Select your archive
3. Click "Validate App"
4. Select your distribution certificate and profile
5. Click "Validate"
6. Fix any errors that appear

---

## 📤 STEP 9: CREATE APP IN APP STORE CONNECT

### A. Create App Listing
1. Go to https://appstoreconnect.apple.com
2. Click "My Apps"
3. Click "+" → "New App"
4. **Platforms:** iOS
5. **Name:** Odyseya
6. **Primary Language:** English (or your language)
7. **Bundle ID:** Select your bundle ID from dropdown
8. **SKU:** odyseya-001 (unique identifier, can be anything)
9. **User Access:** Full Access
10. Click "Create"

### B. Fill Out App Information
1. **Subtitle:** (from Step 5)
2. **Privacy Policy URL:** (from Step 3) ⚠️ REQUIRED
3. **Category:** Health & Fitness
4. **Age Rating:** Answer questionnaire (from Step 6)

### C. Fill Out Pricing and Availability
1. **Price:** Free (or select tier if paid)
2. **Availability:** All countries (or select specific)
3. **Pre-orders:** NO (for first version)

### D. App Privacy
1. Click "App Privacy" in left sidebar
2. Click "Get Started"
3. Use APP_STORE_PRIVACY_REPORT.md to answer all questions
4. This takes 15-30 minutes - be thorough!

---

## 🚀 STEP 10: SUBMIT FOR REVIEW

### A. Create Version 1.0.0
1. In App Store Connect, click "1.0.0 Prepare for Submission"
2. Upload screenshots (from Step 4)
3. Add description (from Step 5)
4. Add keywords (from Step 5)
5. Add promotional text (optional)
6. Support URL: `mailto:odyseya.journal@gmail.com`
7. Marketing URL: (if you have one)

### B. Upload Build
1. Click "Build" section
2. Click "Select a build before you submit your app"
3. If build not available yet:
   - Go back to Xcode Organizer
   - Select your archive
   - Click "Distribute App"
   - Select "App Store Connect"
   - Click "Upload"
   - Wait 5-15 minutes for processing
4. Refresh App Store Connect
5. Select your build (1.0.0, build 1)

### C. Content Rights
- [ ] Export Compliance: Does your app use encryption?
  - **YES** (you use Firebase which has encryption)
  - Select "NO" for export compliance if only using standard encryption
- [ ] Advertising Identifier: Do you use IDFA?
  - **NO** (you don't use advertising)

### D. Version Release
- [ ] Automatically release after approval (recommended for first version)
- OR: Manually release (you control when it goes live)

### E. Submit for Review
1. Review everything one last time
2. Click "Submit for Review"
3. Wait for confirmation email

---

## ⏱️ REVIEW TIMELINE

- **App Review Time:** Usually 24-48 hours
- **First submission:** May take longer (3-7 days)
- **Common reasons for rejection:**
  - Privacy policy doesn't match data collection
  - Missing permission descriptions
  - App crashes on launch
  - Screenshots don't match app
  - Incomplete metadata

---

## ✅ FINAL PRE-SUBMISSION CHECKLIST

**Code & Configuration:**
- [ ] Bundle ID changed from com.example.odyseya
- [ ] App tested on real device (if possible)
- [ ] All features working
- [ ] No debug code or console logs
- [ ] Firebase production config in place
- [ ] .env file has production values
- [ ] Version and build number set

**Apple Developer Portal:**
- [ ] Active Apple Developer membership
- [ ] App ID registered
- [ ] Distribution certificate created
- [ ] Provisioning profile created

**App Store Connect:**
- [ ] App created in App Store Connect
- [ ] App Information filled out
- [ ] Privacy Policy URL added
- [ ] App Privacy questionnaire completed
- [ ] Screenshots uploaded (all required sizes)
- [ ] Description, keywords added
- [ ] Age rating set
- [ ] Pricing set

**Build:**
- [ ] Release build created
- [ ] Build validated in Xcode
- [ ] Build uploaded to App Store Connect
- [ ] Build selected for submission
- [ ] Export compliance answered

**Final Checks:**
- [ ] Privacy policy accessible at public URL
- [ ] Contact email (odyseya.journal@gmail.com) is active
- [ ] Ready to respond to review team within 24-48 hours
- [ ] Terms of Service accessible (if separate from privacy policy)

---

## 📞 IF YOU GET REJECTED

Common rejection reasons and fixes:

### 1. Privacy Policy Issues
**Rejection:** Privacy policy doesn't match data collection
**Fix:** Ensure your hosted privacy policy matches APP_STORE_PRIVACY_REPORT.md

### 2. Crash on Launch
**Rejection:** App crashes during review
**Fix:** Test thoroughly, check Firebase config, verify all dependencies

### 3. Missing Permissions
**Rejection:** App requests permission without description
**Fix:** Already handled - Info.plist has all descriptions ✅

### 4. Incomplete Metadata
**Rejection:** Missing screenshots or information
**Fix:** Ensure all required fields filled in App Store Connect

### 5. Guideline Violations
**Rejection:** Violates specific App Store guideline
**Fix:** Read rejection message carefully, fix specific issue mentioned

**To Resubmit:**
1. Fix the issue
2. Increment build number in pubspec.yaml (1 → 2)
3. Create new archive in Xcode
4. Upload new build
5. Select new build in App Store Connect
6. Address reviewer notes
7. Resubmit

---

## 🎯 ESTIMATED TIME TO COMPLETE

- Apple Developer setup: 1-2 hours (if new account: +24-48 hours approval)
- Bundle ID & configuration: 30 minutes
- Certificates & profiles: 1 hour (first time)
- Privacy policy hosting: 30 minutes - 2 hours
- Screenshots: 1-2 hours
- App Store listing content: 1-2 hours
- App Privacy questionnaire: 30 minutes - 1 hour
- Build & upload: 1 hour
- App Store Connect setup: 1-2 hours
- **Total: 6-12 hours of active work**

---

## 📚 HELPFUL RESOURCES

- Apple Developer Portal: https://developer.apple.com
- App Store Connect: https://appstoreconnect.apple.com
- App Store Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
- Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/
- App Store Connect Help: https://help.apple.com/app-store-connect/

---

## 🆘 NEED HELP?

**Contact Apple:**
- Developer Support: https://developer.apple.com/support/
- Phone: 1-800-633-2152 (for paid developers)

**Community Help:**
- Stack Overflow: Tag your questions with `ios` and `app-store-connect`
- Flutter Community: https://flutter.dev/community
- r/iOSProgramming on Reddit

---

## 🎉 AFTER APPROVAL

Once approved (congrats!):

1. **Monitor Reviews:**
   - Check App Store Connect daily
   - Respond to user reviews
   - Track ratings and feedback

2. **Analytics:**
   - Check App Analytics in App Store Connect
   - Monitor downloads and engagement

3. **Updates:**
   - Fix bugs quickly
   - Increment version number for each update
   - Update privacy policy if you add new features

4. **Marketing:**
   - Share on social media
   - Get early users to review
   - Build a community around your app

---

**Good luck with your App Store submission! 🚀**

You've done all the hard compliance work. The rest is mostly paperwork and following Apple's process step by step.
