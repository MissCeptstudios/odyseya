# 🌿 Odyseya — Emotional Voice Journaling App

**Odyseya** is a cross-platform Flutter app that helps users reflect on their emotions through voice journaling, mood tracking, and personalized AI insights. It creates a calm, private, and intelligent space for emotional self-awareness and healing.

---

## ✨ Core Features (MVP1)

- 🎤 **Voice Journaling**: Record spoken reflections and transcribe them in real-time.
- 😊 **Mood Selection**: Choose from 5 swipeable moods using poetic, desert-inspired cards.
- 🤖 **AI Insights**: Get emotional tone analysis, trigger detection, and gentle suggestions powered by Claude or GPT.
- 📆 **Journal Calendar**: View past entries and insights in a scrollable daily calendar.
- 🔔 **Reminders**: Receive in-app or push notifications to journal regularly.
- 💾 **Firebase Backend**: Auth, Firestore, and secure storage for entries.
- 💳 **Freemium Model**: RevenueCat integration with a paywall and subscription tiers.

---

## 🎨 Design Language

- **Palette**: Soft, desert-inspired tones (Caramel Drizzle, Arctic Rain, Tree Branch)
- **Mood**: Calm, poetic, emotionally safe
- **UX Goals**: Accessibility, minimalism, gentle animations, and high readability

---

## 🔧 Tech Stack

| Layer            | Technology              |
|------------------|-------------------------|
| Frontend         | Flutter (iOS + Android) |
| Voice to Text    | speech_to_text (MVP1) / Whisper (V2+) |
| AI Integration   | Claude or GPT API       |
| Backend          | Firebase (Auth, Firestore, Storage) |
| Subscriptions    | RevenueCat SDK          |
| State Management | Riverpod / Provider     |
| Analytics        | Firebase Analytics, Crashlytics |
| CI/CD            | GitHub Actions          |

---

## 📁 Folder Structure (recommended)

```text
lib/
├── screens/            # Main screens (e.g., mood selection, recorder, calendar)
├── widgets/            # Reusable components
├── models/             # Data models (e.g., Mood, Entry)
├── services/           # Firebase, AI, storage logic
├── constants/          # Colors, strings, styles
├── main.dart           # App entry point
