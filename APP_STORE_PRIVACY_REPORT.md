# Odyseya - App Store Privacy Report

**Last Updated:** January 2025
**For App Store Connect Submission**

---

## Overview

This document provides the complete privacy disclosure required for Apple App Store Connect. Use this information when filling out the "App Privacy" section in App Store Connect.

---

## 1. DATA COLLECTION SUMMARY

### Does your app collect data?
**YES** - Odyseya collects data to provide journaling services and improve user experience.

---

## 2. DATA TYPES COLLECTED

### 2.1 CONTACT INFO

#### **Email Address**
- **Collected:** YES
- **Purpose:** App functionality, Developer's advertising or marketing
- **Linked to user:** YES
- **Used for tracking:** NO
- **Description:** Email address from Google Sign In or Sign In with Apple for account creation and authentication

#### **Name**
- **Collected:** YES
- **Purpose:** App functionality
- **Linked to user:** YES
- **Used for tracking:** NO
- **Description:** User's name from Google Sign In or Sign In with Apple

---

### 2.2 HEALTH & FITNESS

#### **Mental Health**
- **Collected:** YES
- **Purpose:** App functionality
- **Linked to user:** YES
- **Used for tracking:** NO
- **Description:** Mood logs, emotional data, journal entries about feelings and mental wellness

---

### 2.3 USER CONTENT

#### **Audio Data**
- **Collected:** YES
- **Purpose:** App functionality
- **Linked to user:** YES
- **Used for tracking:** NO
- **Description:** Voice recordings for journaling (stored encrypted, user can delete anytime)

#### **Other User Content**
- **Collected:** YES
- **Purpose:** App functionality
- **Linked to user:** YES
- **Used for tracking:** NO
- **Description:** Journal entries, written reflections, AI-generated insights, affirmations

---

### 2.4 IDENTIFIERS

#### **User ID**
- **Collected:** YES
- **Purpose:** App functionality, Analytics
- **Linked to user:** YES
- **Used for tracking:** NO
- **Description:** Unique identifier for user account (Firebase UID)

#### **Device ID**
- **Collected:** YES
- **Purpose:** App functionality, Analytics
- **Linked to user:** YES
- **Used for tracking:** NO
- **Description:** Device identifier for security, fraud prevention, and crash reporting

---

### 2.5 USAGE DATA

#### **Product Interaction**
- **Collected:** YES
- **Purpose:** Analytics, App functionality
- **Linked to user:** YES (anonymized for analytics)
- **Used for tracking:** NO
- **Description:** App usage patterns, feature usage, journaling frequency

#### **Crash Data**
- **Collected:** YES
- **Purpose:** Analytics, App functionality
- **Linked to user:** YES
- **Used for tracking:** NO
- **Description:** Crash logs and performance data via Firebase Crashlytics

---

### 2.6 DIAGNOSTICS

#### **Performance Data**
- **Collected:** YES
- **Purpose:** Analytics, App functionality
- **Linked to user:** YES (anonymized)
- **Used for tracking:** NO
- **Description:** App performance metrics, load times, errors

#### **Other Diagnostic Data**
- **Collected:** YES
- **Purpose:** Analytics, App functionality
- **Linked to user:** YES (anonymized)
- **Used for tracking:** NO
- **Description:** Device information (OS version, device model) for compatibility and debugging

---

### 2.7 LOCATION (OPTIONAL)

#### **Precise Location**
- **Collected:** YES (Optional - only if user grants permission)
- **Purpose:** App functionality
- **Linked to user:** YES
- **Used for tracking:** NO
- **Description:** Location data to add weather and location context to journal entries (optional feature)

---

### 2.8 PURCHASES

#### **Purchase History**
- **Collected:** YES
- **Purpose:** App functionality
- **Linked to user:** YES
- **Used for tracking:** NO
- **Description:** Subscription status and purchase events (processed via RevenueCat, no credit card details stored)

---

## 3. DATA NOT COLLECTED

The following data types are **NOT** collected:

- Financial Info (credit card details - handled by Apple/Google)
- Physical Address
- Phone Number
- Photos or Videos (except for sharing journal entries)
- Browsing History
- Search History
- Contacts
- Calendar Data
- Sensitive Info (except mental health data which is disclosed above)
- Other Contact Info

---

## 4. THIRD-PARTY SDKs & DATA SHARING

### Firebase (Google Cloud Platform)
- **Purpose:** Authentication, Cloud Storage, Database, Analytics, Crash Reporting
- **Data Shared:** User ID, email, journal entries (encrypted), device info, usage analytics
- **Link:** https://firebase.google.com/support/privacy

### RevenueCat
- **Purpose:** In-app purchase and subscription management
- **Data Shared:** User ID, subscription status, purchase events
- **Data NOT Shared:** Journal content, emotional data
- **Link:** https://www.revenuecat.com/privacy

### Google Sign In
- **Purpose:** Authentication
- **Data Shared:** Email, name, profile picture (if user chooses Google login)
- **Link:** https://policies.google.com/privacy

### Sign In with Apple
- **Purpose:** Authentication
- **Data Shared:** Email (or private relay), name (if user chooses Apple login)
- **Link:** https://www.apple.com/legal/privacy/

### AI Processing Services
- **Purpose:** Voice transcription and emotional analysis
- **Data Shared:** Voice recordings (encrypted), journal text
- **Training:** Your data is NOT used to train AI models
- **Security:** Enterprise-grade encryption

---

## 5. DATA USAGE PURPOSES

### App Functionality
- Store and sync journal entries
- Transcribe voice recordings
- Generate AI insights
- Provide personalized affirmations
- Enable mood tracking
- Deliver notifications (if enabled)

### Analytics
- Improve app performance
- Understand feature usage (anonymized)
- Debug crashes and errors
- Improve AI accuracy (anonymized data only)

### Developer's Advertising or Marketing (Optional)
- Send wellness tips (only with user opt-in)
- App feature updates
- User can unsubscribe anytime

---

## 6. DATA LINKED VS NOT LINKED TO USER

### Data Linked to User (Identifiable)
- Email address and name
- User ID
- Journal entries and voice recordings
- Mood logs and emotional data
- AI-generated insights
- Location data (if enabled)
- Subscription status
- Device ID

### Data Not Linked to User (Anonymous)
- Aggregated usage analytics
- Aggregated crash statistics
- App performance metrics

---

## 7. TRACKING

### Do you use data for tracking?
**NO** - Odyseya does not use data for tracking purposes as defined by Apple.

We do NOT:
- Track users across apps or websites owned by other companies
- Share data with data brokers
- Use data for targeted advertising
- Create user profiles for advertising purposes

---

## 8. USER RIGHTS & DATA DELETION

### Data Access
- Users can view all their data in the app
- Export feature: Download all data in JSON format

### Data Deletion
- Users can delete individual journal entries
- Users can delete their entire account (Settings > Delete Account)
- All personal data deleted within 30 days
- Deletion is permanent and cannot be undone

### Data Portability
- Users can export their journal entries
- Format: JSON or CSV
- Available in Settings > Export Data

---

## 9. PRIVACY PRACTICES

### Encryption
- All data encrypted in transit (TLS/SSL)
- All data encrypted at rest (AES-256)
- Voice recordings encrypted before upload

### Data Retention
- Voice recordings: Until user deletes or account closure
- Journal entries: Until user deletes or account closure
- Account data: Active account + 30 days after deletion
- Analytics: Anonymized, up to 2 years
- Backups: Deleted data removed within 90 days

### Parental Controls
- Age rating: 12+ (should be 16+ due to mental health content)
- Not intended for users under 16
- Underage accounts deleted immediately upon discovery

---

## 10. GDPR & PRIVACY LAW COMPLIANCE

### GDPR (European Union)
✅ Right to Access
✅ Right to Rectification
✅ Right to Erasure (Right to be Forgotten)
✅ Right to Data Portability
✅ Right to Restrict Processing
✅ Right to Object
✅ Right to Withdraw Consent

### CCPA (California)
✅ Right to Know
✅ Right to Delete
✅ Right to Opt-Out of Sale (we don't sell data)
✅ Right to Non-Discrimination

### Contact for Privacy Requests
- Email: odyseya.journal@gmail.com
- Privacy & Data Protection: odyseya.journal@gmail.com
- Response time: Within 48 hours

---

## 11. APP STORE CONNECT - PRIVACY QUESTIONS ANSWERED

When filling out App Store Connect privacy questionnaire:

**Does your app collect data?**
✅ Yes

**Do you or your third-party partners collect data from this app?**
✅ Yes

**Is the data linked to the user's identity?**
✅ Yes (as detailed in sections above)

**Do you use this data to track users?**
❌ No

**Can users request that their data be deleted?**
✅ Yes - In-app deletion available in Settings

**Do you provide a way for users to access their data?**
✅ Yes - View and export in app Settings

**Do you collect data before account creation?**
❌ No - Account creation required first

**Age rating considerations:**
- Suggested: 12+ or 17+ (due to mental health content)
- Not intended for children under 16

---

## 12. PRIVACY POLICY URLS

**Primary Privacy Policy URL:**
https://odyseya.com/privacy (or your actual URL)

**Required for App Store Connect:**
- Must be publicly accessible
- Must match the privacy disclosures in this document
- Must be up-to-date before submission

**Alternative:** Host the privacy policy from your app as a web view at a public URL

---

## 13. PRIVACY NUTRITION LABELS (App Store)

Based on this report, your App Store privacy nutrition labels will show:

**Data Used to Track You:** None

**Data Linked to You:**
- Contact Info (Email, Name)
- Health & Fitness (Mental Health)
- User Content (Audio, Journal Entries)
- Identifiers (User ID, Device ID)
- Usage Data (Product Interaction, Crash Data)
- Location (Optional)
- Purchases

**Data Not Linked to You:**
- Diagnostics (Performance Data - anonymized)

---

## 14. COMPLIANCE CHECKLIST

Before App Store submission, ensure:

- [x] Privacy Policy URL is publicly accessible
- [x] Privacy Policy matches data collection practices
- [x] Info.plist has all required permission descriptions
- [x] In-app privacy settings allow data management
- [x] Data export functionality is working
- [x] Account deletion is working (with 30-day timeline)
- [x] GDPR consent screen is shown on first launch
- [x] Marketing consent is optional and opt-in
- [ ] Test all privacy features on real device
- [ ] Privacy Policy URL added to App Store Connect
- [ ] All privacy questions answered in App Store Connect
- [ ] Age rating reflects mental health content (12+ or 17+)

---

## 15. NOTES FOR APP REVIEW

**Important for Apple App Review Team:**

1. **Mental Health Content:** This app deals with emotional wellness and mental health journaling. We recommend professional help for serious mental health issues via in-app resources.

2. **Data Security:** All sensitive data (journal entries, voice recordings) is encrypted using Firebase's enterprise-grade security.

3. **User Control:** Users have full control over their data with easy-to-use export and deletion features in Settings.

4. **No Tracking:** We do not track users across apps or websites, and we do not share data with data brokers or advertisers.

5. **GDPR Compliant:** Full GDPR compliance with explicit consent flows, data portability, and right to erasure.

---

## 16. CONTACT INFORMATION FOR REVIEW

**Developer Contact:**
Email: odyseya.journal@gmail.com
Privacy & Support: odyseya.journal@gmail.com

**Response Time:** Within 24-48 hours

---

## VERSION HISTORY

- **Version 2.0** - January 2025 - Comprehensive privacy compliance update
- **Version 1.0** - Initial release

---

**END OF PRIVACY REPORT**

Use this document as your reference when completing the App Privacy section in App Store Connect. All information provided is accurate and matches the app's actual data collection practices.
