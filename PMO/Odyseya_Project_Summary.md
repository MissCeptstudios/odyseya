
# Odyseya — Emotional Voice Journaling App  
## Complete Project Summary & Roadmap

---

## 🎯 Project Objectives

- **Empower emotional self-awareness:** Create a warm, safe space for users to explore and express emotions using voice journaling and mood tracking.  
- **Leverage AI insight:** Use Whisper for transcription and GPT-4 / Claude for emotional tone analysis, trigger detection, and personalized reflections.  
- **Build daily habits:** Encourage regular journaling through reminders and easy mood entry.  
- **Cross-platform access:** Native iOS & Android experience via Flutter.  
- **Privacy & security:** Use Firebase backend with GDPR-compliant data controls.

---

## 🎨 UX/UI Vision & Color Palette

- **Cozy, inviting, poetic:** Warm desert-inspired palette evokes calm, warmth, and emotional safety.  
- **Minimal & focused:** Clean layouts guiding users gently through journaling journey.  
- **Interactive & engaging:** Swipeable mood cards, animated recording states, smooth transitions.  
- **Personalized & empathetic:** Gentle UI copy and AI insights acting like a trusted companion.  
- **Accessible & inclusive:** High contrast, legible fonts, intuitive navigation.

### 🌵 Desert Palette Colors

| Color Name       | Hex     | Usage in App UI                       |
|------------------|---------|-------------------------------------|
| Arctic Rain      | #c6d9ed | Backgrounds, cards, light surfaces  |
| Water Wash       | #aac8e5 | Buttons, interactive elements       |
| Caramel Drizzle  | #dbac80 | Accent highlights, mood tags        |
| Western Sunrise  | #d8a36c | Primary buttons, headers, key CTAs  |
| Tree Branch      | #8b7362 | Secondary text, borders, subtle UI  |
| Brown Bramble    | #57351e | Main text, icons, strong contrast   |

---

## 🗂️ Core MVP Plan

### MVP1 — Core Voice Journaling & Mood Entry (~2 weeks)

- Onboarding questionnaire for personalization  
- Swipeable mood selection (5 moods, desert palette)  
- Voice recording + automatic transcription (Whisper/OpenAI)  
- Save mood + voice note + transcription to Firebase  
- AI emotional analysis (tone + trigger detection)  
- Daily calendar view of journal entries  
- Daily reminders (push & in-app)  
- Firebase Authentication (email/password or social)  
- Cross-platform Flutter app (iOS & Android)  
- Basic paywall integration via RevenueCat

---

### V2 — Mood Pattern Analysis & Personalized Suggestions (~3 weeks)

- Detect daily/monthly mood patterns and summarize  
- AI-generated personalized mood improvement tips  
- Save/favorite suggestions and track progress  
- Enhanced reminders & settings customization  
- UI/UX improvements for summaries, suggestions, and paywall flow  

---

### V3 — Engagement & Advanced Features (~4–6 weeks)

- Voice journal playback & audio storage  
- Interactive mood visualizations & charts  
- AI-powered daily affirmations & healing messages  
- Gamification: streaks, badges, milestones  
- Basic community features & anonymous sharing  
- Offline journaling + data export  

---

## 🤖 AI Features & Flow

- Transcribe voice notes with Whisper  
- Analyze emotional tone and detect triggers with GPT-4/Claude  
- Generate empathetic, personalized reflections and suggestions  
- Summarize daily/monthly mood patterns  
- Provide actionable tips and habit ideas on demand  

---

## ⏰ Reminder System

- Daily push notifications and in-app banners nudging journaling  
- Customizable schedule and notification preferences  
- Encourages consistent journaling habit-building  

---

## 💳 Payments & Monetization

### Business Model

- **Freemium subscription:**  
  - Free tier with limited daily mood entries and AI insights (e.g., 3 free entries per month)  
  - Premium tier unlocking unlimited journaling, advanced AI analysis, personalized suggestions, and extra features  

### Subscription Pricing (Example)

| Plan           | Duration           | Price Example                | Features Included                          |
|----------------|--------------------|-----------------------------|--------------------------------------------|
| Monthly        | 1 month            | £7.99 / $9.99               | Unlimited entries, AI suggestions, reminders |
| Yearly         | 12 months          | £79.99 / $99.99 (approx. 15% off) | Same as monthly + bonus content or priority support |

### Technical Implementation

- Use **RevenueCat** SDK to manage iOS and Android subscriptions.  
- Sync subscription status with Firebase user profiles.  
- Integrate with Flutter via RevenueCat plugin.  
- Show UI states clearly indicating free vs premium features with upgrade prompts.

### User Flow

- Users start free with limited access.  
- Upgrade prompts trigger on feature limit or premium feature access attempts.  
- After purchase, premium features unlock immediately.  
- Users manage subscriptions via app store standard flows.  

### Compliance

- Transparent pricing and terms shown in-app and on website.  
- Privacy policy and refund instructions clearly accessible.  
- Follow Apple and Google guidelines to ensure app store compliance.  
- GDPR-compliant data handling and consent.

### Timeline Integration

| When         | Task                                           |
|--------------|------------------------------------------------|
| MVP1 (Days 10–13) | RevenueCat integration + basic paywall UI  |
| V2 (Week 3)  | Paywall UX refinement and subscription management  |
| V3           | Premium perks: exclusive content, badges       |

---

## 🔧 Tech Stack & Execution

- Flutter for iOS & Android native cross-platform development  
- Firebase for authentication, storage, data, and notifications  
- OpenAI APIs (Whisper + GPT-4 / Claude) for AI capabilities  
- RevenueCat or Firebase for subscription/paywall  
- Claude Code + Cursor for rapid prompt-driven development  

---

## 📅 Timeline Summary

| Phase | Duration  | Focus                                         |
|-------|-----------|-----------------------------------------------|
| MVP1  | ~2 weeks  | Core journaling, mood entry, AI insights, reminders, calendar, paywall setup |
| V2    | ~3 weeks  | Pattern detection, personalized tips, UI & paywall improvements |
| V3    | 4–6 weeks | Playback, visualizations, affirmations, gamification, community features |

