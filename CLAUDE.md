# CLAUDE.md — Project Context for Claude Code

## App Name: Odyseya — Emotional Voice Journaling App

### Mission:
Create a safe, calm, and emotionally intelligent space where **anyone** can journal using their voice, understand their feelings through AI insights, and build healthier emotional habits over time.

### Core Features (MVP1):
- Voice recording with transcription (using Whisper or speech_to_text)
- Mood selection using 5 swipeable cards
- AI analysis of tone, emotional triggers, and reflections (via Claude or GPT)
- Daily calendar view of entries
- Reminders (push notifications and in-app)
- Firebase backend for auth, storage, and journaling data
- RevenueCat integration for subscription-based premium access

### Design Style:
- Warm, poetic, and serene desert-inspired color palette
- Clean, intuitive, and accessible user experience
- Soft animations and supportive language that feel emotionally safe and welcoming to all

### Tech Stack:
- Flutter (cross-platform mobile)
- Firebase (Authentication, Firestore, Storage, FCM)
- Claude + OpenAI (Whisper + GPT)
- RevenueCat for in-app purchases

### Coding Standards:
- Use Riverpod or Provider for scalable state management
- Separate UI components from business logic
- Ensure accessibility (contrast, screen reader labels, touch targets)
- Follow Flutter and Dart best practices
- Write asynchronous code responsibly to keep UI responsive
- Always handle permissions, errors, and network issues gracefully

### Recommended Folder Structure:
- `lib/screens/`
- `lib/widgets/`
- `lib/models/`
- `lib/services/`
- `lib/constants/`

