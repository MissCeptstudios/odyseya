# TODO - Odyseya Voice Journaling App

## ✅ CORE FEATURES – MVP1 (RECENTLY COMPLETED)

### User Experience Flow - ✅ COMPLETED
- [x] **Complete Onboarding Flow** ✅
  - SplashScreen with Continue button (no auto-navigation)
  - AuthChoiceScreen with clean UI (removed privacy notices)
  - SignupScreen with pre-filled dummy data for testing
  - GDPR Consent Screen with full legal documents
  - WelcomeScreen with feature showcase
  - Seamless navigation flow without loops

- [x] **GDPR Compliance System** ✅
  - Complete Terms & Conditions document
  - Full Privacy Policy with GDPR rights
  - Marketing consent (optional)
  - Required checkboxes validation
  - Proper user flow: Signup → GDPR → Welcome → Main App

- [x] **Authentication Screens** ✅
  - Clean login/signup forms with validation
  - High-quality logo assets (Odyseya_Icon.png, Odyseya_word.png)
  - White background theme throughout
  - Form validation with real-time feedback

### Mood Selection System - ✅ COMPLETED
- [x] **Face Emoji Mood Cards** ✅
  - Three mood options: 😄 Joyful, 😌 Calm, 😢 Melancholy
  - Clean white card backgrounds
  - Desert color theme integration
  - Proper mood state management with Riverpod

### Navigation & Routing - ✅ COMPLETED
- [x] **GoRouter Implementation** ✅
  - Complete route definitions for all screens
  - Authentication guards and redirects
  - Fixed navigation loops and flow issues
  - Support for both authenticated and unauthenticated flows

### Visual Design - ✅ COMPLETED
- [x] **UI/UX Consistency** ✅
  - Clean white backgrounds across all screens
  - High-quality logo assets without brown circles
  - Consistent desert color palette
  - Proper spacing and typography

### Technical Infrastructure - ✅ COMPLETED
- [x] **State Management** ✅
  - Riverpod providers for onboarding, auth, mood
  - Proper state persistence and management
  - Error handling for Firebase unavailability

- [x] **Firebase Integration** ✅
  - Authentication setup (temporarily disabled for testing)
  - Firestore integration with graceful fallbacks
  - Affirmation provider with demo data

---

## 🚧 PENDING FEATURES – MVP1

### Mood Check-In System
- [ ] **Mood Check-In Slider + Emoji**
  - Replace carousel with horizontal mood slider
  - Include emoji and mood labels (e.g., "Low", "Okay-ish", "Peaceful")
  - Smooth swipe interaction with haptic feedback

### AI Insights & Summaries
- [ ] **2-Week Summary Unlock**
  - Firestore logic: unlock emotional insight after 14 unique check-in days
  - Summary includes mood trends, tone shifts, and one AI-powered book recommendation
  - Beautiful summary presentation with charts/graphs
- [ ] **Monthly Option**
  - In settings: user can switch between 2-week or 1-month summary cycles
  - Store user preference in Firestore

### Notifications & Engagement
- [ ] **Push Notifications / Mood Reminders**
  - Daily push reminder to check in (default ON)
  - Visible on phone lock screen
  - Opt-out toggle in Settings
  - Future: smart reminders based on emotional trends

### App Configuration
- [ ] **Settings Menu**
  - Toggle for daily reminders
  - Choose reminder time (time picker)
  - Select between 2-week or monthly summary cycle
  - Privacy controls and data export options
- [ ] **Bottom Navigation Bar**
  - Add bottom nav bar (Reflectly-style)
  - Placeholder icons/tabs for now
  - Styled to match Odyseya's desert theme
  - Smooth tab transitions

## 💸 MONETIZATION – MVP1

### Trial System
- [ ] **14-Day Free Trial**
  - Full feature access for 14 days after signup
  - Countdown shown (e.g., "You have 9 days left…")
  - Trial status visible in app header
- [ ] **Track Trial Period**
  - Save user's signup date in Firestore
  - Logic compares current date → activates paywall
  - Handle edge cases (offline users, etc.)

### Paywall Implementation
- [ ] **Soft Paywall After Trial**
  - After day 14, journaling and insights are locked
  - Paywall screen prompts user to subscribe
  - Allow viewing past entries but no new ones
- [ ] **Paywall Screen Design**
  - Clearly list benefits
  - CTA: "Continue your emotional journey…"
  - Beautiful, non-aggressive design

### Payment Processing
- [ ] **Payment Integration**
  - Stripe or RevenueCat integration
  - Monthly ($9.99) or yearly ($99) plans
  - "Restore purchase" button for returning users
  - Handle payment failures gracefully

## 🔧 TECHNICAL IMPROVEMENTS

### Architecture & Performance
- [ ] **State Management Optimization**
  - Optimize Riverpod providers for better performance
  - Implement proper error handling across all screens
  - Add loading states for better UX

### Data & Storage
- [ ] **Enhanced Firestore Integration**
  - Re-enable Firebase for production
  - Implement proper offline support
  - Add data sync indicators
  - Handle network errors gracefully
- [ ] **Voice Recording Improvements**
  - Better audio quality settings
  - Background recording support
  - Waveform visualization during recording

### Security & Privacy
- [ ] **Production Firebase Setup**
  - Configure Firebase for web and iOS
  - Set up proper authentication flow
  - Enable Firestore rules and security

## 🌙 COMPANION (Optional – Future Phase)

### Companion System
- [ ] **Conceptualise Companion Persona**
  - Ideas: Desert Moon 🌙, Compass 🧭, Owl 🦉, Oracle Whisper 🔮
  - No robot; poetic emotional guide instead
  - Develop companion personality and voice
- [ ] **Sample Dialogues for Companion**
  - Messages like: "Your inner voice feels gentler today, MissC. Ready to reflect?"
  - Context-aware based on mood patterns
  - Supportive, non-judgmental tone

### Integration
- [ ] **Companion UI Elements**
  - Subtle presence throughout app
  - Animated companion icon
  - Contextual messages and encouragement

## 🚀 FUTURE ENHANCEMENTS

### Advanced Features
- [ ] **Mood Pattern Recognition**
  - AI-powered insights from mood data
  - Trend analysis and predictions
  - Personalized recommendations
- [ ] **Social Features (Optional)**
  - Anonymous community support
  - Shared wisdom/quotes
  - Privacy-first approach
- [ ] **Export & Backup**
  - PDF export of journal entries
  - Cloud backup options
  - Data portability features

### Platform Expansion
- [ ] **Web Version**
  - Responsive web app
  - Cross-platform sync
  - Same feature parity
- [ ] **Apple Watch Integration**
  - Quick mood check-ins
  - Haptic reminders
  - Minimal UI for watch

## 🐛 BUG FIXES & MAINTENANCE

### Ongoing Maintenance
- [ ] **Performance Monitoring**
  - Add crash reporting
  - Monitor app performance
  - User analytics (privacy-compliant)
- [ ] **Regular Updates**
  - Flutter/dependency updates
  - Security patches
  - Feature improvements based on user feedback

---

## 📋 DEVELOPMENT PRIORITIES

### Phase 1 (CURRENT FOCUS)
1. **Bottom Navigation Bar** - Core app navigation
2. **Settings Menu** - User preferences and controls
3. **Push Notifications** - User engagement
4. **2-Week Summary System** - Core AI feature
5. **Monetization (Trial + Paywall)** - Revenue model

### Phase 2 (Post-Launch)
1. Voice recording improvements
2. Advanced AI insights
3. Performance optimizations
4. Companion system

### Phase 3 (Future)
1. Apple Watch app
2. Social features
3. Advanced analytics
4. Platform expansion

---

## 🎯 IMPLEMENTATION STATUS SUMMARY

**✅ COMPLETED (Major Achievement!):**
- Complete user onboarding flow (Splash → Auth → Signup → GDPR → Welcome)
- GDPR compliance system with full legal documents
- Clean UI/UX with high-quality assets
- Mood selection with face emojis
- Navigation system without loops
- State management with Riverpod
- Firebase integration (temporarily disabled)

**🚧 IN PROGRESS:**
- Voice journaling functionality
- Core app features (calendar, affirmations)

**📋 NEXT PRIORITIES:**
- Bottom navigation bar
- Settings menu
- Push notifications
- Monetization system

The app now has a **solid foundation** with proper user flow, GDPR compliance, and clean UI. Ready for core feature development!