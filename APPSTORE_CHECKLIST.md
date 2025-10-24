# App Store Deployment Checklist - Szybki Przegląd

## ✅ Przed rozpoczęciem

- [ ] Masz Apple Developer Account ($99/rok)
- [ ] Dwuskładnikowe uwierzytelnianie (2FA) włączone
- [ ] Zainstalowany Xcode (najnowsza wersja)
- [ ] Flutter SDK zaktualizowany

---

## 📱 Przygotowanie Aplikacji

### Assety:
- [ ] App Icon (1024×1024 + wszystkie rozmiary) w `ios/Runner/Assets.xcassets/`
- [ ] Screenshoty (min. 3) dla iPhone 6.7" (1290 x 2796)
- [ ] Screenshoty dla iPhone 6.5" (1242 x 2688)
- [ ] Screenshoty dla iPad Pro 12.9" (2048 x 2732) - opcjonalnie
- [ ] App Preview video - opcjonalnie

### Konfiguracja:
- [ ] Bundle ID ustalony: `com.odyseya.app` (lub własny)
- [ ] Wersja w `pubspec.yaml`: `version: 1.0.0+1`
- [ ] Wszystkie opisy uprawnień w `Info.plist`:
  - [ ] NSMicrophoneUsageDescription
  - [ ] NSUserNotificationsUsageDescription
  - [ ] NSLocationWhenInUseUsageDescription (jeśli używane)
- [ ] Privacy Manifest: `ios/Runner/PrivacyInfo.xcprivacy`
- [ ] Display Name: "Odyseya" w Info.plist

### Testy:
- [ ] App działa na prawdziwym iPhone
- [ ] Brak crashy
- [ ] Wszystkie funkcje działają
- [ ] Testowane na różnych rozmiarach ekranów

---

## 🔐 Apple Developer Portal

### App ID:
- [ ] Utworzony w https://developer.apple.com/account
- [ ] Bundle ID: `com.odyseya.app`
- [ ] Capabilities włączone:
  - [ ] Sign in with Apple
  - [ ] Push Notifications
  - [ ] In-App Purchase
  - [ ] iCloud (jeśli używane)

### Certyfikaty:
- [ ] Distribution Certificate utworzony
- [ ] Zainstalowany w Keychain (Apple Distribution)

### Provisioning Profile:
- [ ] App Store profile utworzony
- [ ] Pobrany i zainstalowany

---

## 📱 App Store Connect

### Utworzenie Aplikacji:
- [ ] Aplikacja utworzona w https://appstoreconnect.apple.com
- [ ] Name: Odyseya
- [ ] Primary Language: Polish (lub English)
- [ ] Bundle ID wybrany
- [ ] SKU: `odyseya-001`

### App Information:
- [ ] Subtitle (max 30 znaków)
- [ ] Privacy Policy URL (WYMAGANE!)
- [ ] Category: Health & Fitness
- [ ] Age Rating: 4+

### Pricing:
- [ ] Price: Free (lub wybrany tier)
- [ ] Availability: All Countries

### App Privacy:
- [ ] Kwestionariusz wypełniony
- [ ] Data types zadeklarowane

### Metadata (dla wersji):
- [ ] Description (4000 znaków)
- [ ] Keywords (100 znaków)
- [ ] Support URL
- [ ] Marketing URL (opcjonalnie)
- [ ] What's New text
- [ ] Screenshots uploaded dla wszystkich rozmiarów
- [ ] App Preview video (opcjonalnie)

### App Review Information:
- [ ] Contact info wypełniony
- [ ] Demo account credentials (jeśli wymagane)
- [ ] Review notes

---

## 🚀 Build i Upload

### Przygotowanie:
- [ ] Uruchom: `./prepare_for_appstore.sh`
- [ ] Lub ręcznie:
  ```bash
  flutter clean
  flutter pub get
  cd ios && pod install
  flutter build ios --release
  ```

### Xcode Configuration:
- [ ] Otwórz: `ios/Runner.xcworkspace`
- [ ] Signing & Capabilities:
  - [ ] Team wybrany
  - [ ] Bundle ID: `com.odyseya.app`
  - [ ] Automatically manage signing: ON
  - [ ] Sign in with Apple capability dodana
- [ ] General:
  - [ ] Version: 1.0.0
  - [ ] Build: 1
  - [ ] Deployment Target: iOS 13.0+

### Archive:
- [ ] Product → Scheme → Runner
- [ ] Product → Destination → Any iOS Device
- [ ] Product → Archive
- [ ] Poczekaj 5-10 minut

### Upload:
- [ ] Organizer otworzył się z archiwum
- [ ] Distribute App → App Store Connect
- [ ] Upload → Automatic Signing
- [ ] Upload symbols: YES
- [ ] Bitcode: NO
- [ ] Upload (poczekaj 10-15 minut)

### Weryfikacja:
- [ ] App Store Connect → TestFlight
- [ ] Build pojawił się: 1.0.0 (1)
- [ ] Status: Processing → Ready to Submit
- [ ] Export Compliance wypełniony (jeśli wymagane)

---

## ✅ Submission

### Final Check:
- [ ] Build wybrany w wersji
- [ ] Wszystkie sekcje mają ✅
- [ ] Screenshots dla wszystkich rozmiarów
- [ ] Privacy Policy dostępna
- [ ] Demo account działa (jeśli wymagane)

### Submit:
- [ ] Kliknij "Add for Review"
- [ ] Wypełnij Export Compliance
- [ ] Submit to App Review

### Status:
- [ ] Waiting for Review
- [ ] W ciągu 24-48 godzin → In Review
- [ ] Po przeglądzie → Approved / Rejected

---

## 📊 Po Publikacji

- [ ] Monitor App Store Connect Analytics
- [ ] Sprawdź Reviews i odpowiadaj
- [ ] Monitor Crash Reports (Xcode Organizer)
- [ ] Zaplanuj pierwszą aktualizację

---

## 🆘 Szybka Pomoc

**Przydatne linki:**
- Apple Developer: https://developer.apple.com/account
- App Store Connect: https://appstoreconnect.apple.com
- Pełny guide: `APPLE_APP_STORE_DEPLOYMENT.md`

**Przydatne komendy:**
```bash
# Preparation script
./prepare_for_appstore.sh

# Open Xcode
open ios/Runner.xcworkspace

# Check version
grep "^version:" pubspec.yaml

# List certificates
security find-identity -v -p codesigning

# List provisioning profiles
ls ~/Library/MobileDevice/Provisioning\ Profiles/
```

**Częste problemy:**
- **Missing Privacy Policy** → Dodaj URL
- **Missing Permissions** → Dodaj opisy w Info.plist
- **Crashes** → Test na prawdziwym urządzeniu
- **Build nie pojawia się** → Poczekaj 15 min i odśwież

---

## 🎯 Typical Timeline

| Etap | Czas |
|------|------|
| Przygotowanie assetów | 2-4 godziny |
| Konfiguracja Developer Account | 30 min |
| App Store Connect setup | 1 godzina |
| Build i Upload | 30 min |
| **Czekanie na review** | **24-48 godzin** |
| Publikacja | Instant lub zaplanowana |

**Razem (pierwsze wydanie):** ~5-6 godzin + czas przeglądu

**Aktualizacje:** ~30 min + czas przeglądu (12-24h)

---

**Powodzenia! 🚀**

Jeśli masz pytania, sprawdź pełny przewodnik: [APPLE_APP_STORE_DEPLOYMENT.md](APPLE_APP_STORE_DEPLOYMENT.md)
