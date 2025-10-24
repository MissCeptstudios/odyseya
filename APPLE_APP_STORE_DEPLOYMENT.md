# Apple App Store Deployment Guide - Odyseya

## 📋 Kompletny przewodnik deployment do Apple App Store

---

## 🎯 Przegląd procesu

Deployment do App Store składa się z 5 głównych etapów:
1. **Przygotowanie aplikacji** (konfiguracja, ikony, screenshoty)
2. **Konfiguracja Apple Developer Account** (App ID, certyfikaty)
3. **App Store Connect** (utworzenie aplikacji, metadata)
4. **Build i Upload** (archiwizacja i wysłanie do Apple)
5. **Przegląd i Release** (submission i publikacja)

**Czas trwania:** 2-4 godziny (pierwsze wysłanie), potem ~30 min na update

---

## 📱 ETAP 1: Przygotowanie Aplikacji

### 1.1 Wymagane Assety

#### App Icon (wymagane wszystkie rozmiary):
```
1024×1024 - App Store (bez alpha channel)
180×180   - iPhone
167×167   - iPad Pro
152×152   - iPad, iPad mini
120×120   - iPhone
87×87     - iPhone Settings
80×80     - iPad Settings
76×76     - iPad
60×60     - iPhone Notification
58×58     - iPad Notification
40×40     - iPhone Spotlight
29×29     - Settings
20×20     - iPad Notifications
```

**Lokalizacja:** `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

**Narzędzia do generowania:**
- https://appicon.co/
- https://www.appicon.build/
- Adobe Photoshop/Illustrator

#### Screenshoty (wymagane):
```
iPhone 6.7" (iPhone 14 Pro Max, 15 Pro Max, 16 Pro Max)
- 1290 x 2796 pixels (portrait)
- 2796 x 1290 pixels (landscape) - opcjonalnie

iPhone 6.5" (iPhone 11 Pro Max, Xs Max)
- 1242 x 2688 pixels (portrait)
- 2688 x 1242 pixels (landscape) - opcjonalnie

iPad Pro (3rd gen) 12.9"
- 2048 x 2732 pixels (portrait)
- 2732 x 2048 pixels (landscape) - opcjonalnie
```

**Minimalna liczba:** 3-10 screenshotów na rozmiar
**Format:** PNG lub JPEG (bez alpha channel)
**Waga:** maksymalnie 500 KB każdy

**Jak zrobić screenshoty:**
```bash
# Uruchom na symulatorze odpowiedniego rozmiaru
flutter run

# W simulatorze: Cmd + S (zapisze w ~/Desktop)

# Lub użyj Xcode:
# Simulator → File → New Screen Shot
```

#### App Preview Video (opcjonalnie):
- Długość: 15-30 sekund
- Format: .mov, .mp4, .m4v
- Rozdzielczość: taka sama jak screenshoty
- Maksymalny rozmiar: 500 MB

---

### 1.2 Konfiguracja Bundle ID i Wersji

#### Sprawdź/Zmień Bundle Identifier:

**Lokalizacja 1:** `ios/Runner.xcodeproj/project.pbxproj`
```
PRODUCT_BUNDLE_IDENTIFIER = com.odyseya.app;
```

**Lokalizacja 2:** Xcode
1. Otwórz `ios/Runner.xcworkspace`
2. Wybierz Runner target
3. General tab → Bundle Identifier
4. Zmień na: `com.odyseya.app` (lub własny)

**WAŻNE:** Bundle ID musi być unikalny w całym App Store!

#### Ustaw wersję aplikacji:

**Lokalizacja:** `pubspec.yaml`
```yaml
version: 1.0.0+1
         ↑       ↑
    Version    Build Number
    (widoczna) (wewnętrzny)
```

**Zasady:**
- Version: Semantic versioning (np. 1.0.0, 1.1.0, 2.0.0)
- Build Number: Kolejna liczba (1, 2, 3...) - musi rosnąć z każdym buildem

**Jak zwiększyć:**
```yaml
# Pierwsze wydanie
version: 1.0.0+1

# Poprawki bugów
version: 1.0.1+2

# Nowe funkcje
version: 1.1.0+3

# Duże zmiany
version: 2.0.0+4
```

---

### 1.3 Konfiguracja Info.plist

**Lokalizacja:** `ios/Runner/Info.plist`

Sprawdź/dodaj wymagane klucze:

```xml
<!-- Nazwa wyświetlana -->
<key>CFBundleDisplayName</key>
<string>Odyseya</string>

<!-- Wersja (automatycznie z pubspec.yaml) -->
<key>CFBundleShortVersionString</key>
<string>$(FLUTTER_BUILD_NAME)</string>

<key>CFBundleVersion</key>
<string>$(FLUTTER_BUILD_NUMBER)</string>

<!-- WSZYSTKIE opisy uprawnień (WYMAGANE!) -->
<key>NSMicrophoneUsageDescription</key>
<string>Odyseya needs access to your microphone to record your voice journal entries.</string>

<key>NSUserNotificationsUsageDescription</key>
<string>Odyseya sends gentle reminders to help you maintain your journaling practice.</string>

<!-- Jeśli używasz lokalizacji -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>Odyseya can add location context to your journal entries.</string>
```

**KRYTYCZNE:** Apple odrzuci aplikację jeśli brakuje opisów uprawnień!

---

### 1.4 Privacy Manifest (iOS 17+)

**Lokalizacja:** `ios/Runner/PrivacyInfo.xcprivacy` ✅ (już utworzony)

Sprawdź czy zawiera:
```xml
<key>NSPrivacyAccessedAPITypes</key>
<array>
    <!-- Lista używanych API wymagających prywatności -->
</array>

<key>NSPrivacyCollectedDataTypes</key>
<array>
    <!-- Jakie dane zbierasz -->
</array>

<key>NSPrivacyTracking</key>
<false/>
```

---

## 🔐 ETAP 2: Apple Developer Account

### 2.1 Wymagania

- ✅ Apple Developer Program membership ($99/rok)
- ✅ Zweryfikowane konto Apple ID
- ✅ Dwuskładnikowe uwierzytelnianie (2FA) włączone

**Rejestracja:** https://developer.apple.com/programs/enroll/

---

### 2.2 Utworzenie App ID

1. Przejdź do: https://developer.apple.com/account
2. **Certificates, Identifiers & Profiles** → **Identifiers**
3. Kliknij **"+"** (plus)
4. Wybierz **"App IDs"** → Continue
5. Wybierz **"App"** → Continue

**Konfiguracja:**
```
Description: Odyseya
Bundle ID: Explicit → com.odyseya.app (lub Twój)
```

**Capabilities (wybierz używane):**
- ✅ Sign in with Apple
- ✅ Push Notifications
- ✅ iCloud (jeśli używasz)
- ✅ In-App Purchase (dla RevenueCat)
- ⬜ Game Center (nie)
- ⬜ HealthKit (nie)

6. Kliknij **"Continue"** → **"Register"**

---

### 2.3 Certyfikaty

#### Distribution Certificate (do wysyłania do App Store):

1. **Certificates, Identifiers & Profiles** → **Certificates**
2. Kliknij **"+"**
3. Wybierz **"Apple Distribution"** → Continue
4. **Wygeneruj CSR (Certificate Signing Request):**

**Na Macu:**
```
1. Keychain Access → Certificate Assistant → Request a Certificate
2. Email: twój email Apple Developer
3. Common Name: Odyseya Distribution
4. Request: Saved to disk
5. Continue
6. Zapisz jako: CertificateSigningRequest.certSigningRequest
```

5. Upload CSR do Developer Portal
6. Download certyfikatu (.cer)
7. Kliknij dwukrotnie na .cer (zainstaluje się w Keychain)

#### Weryfikacja w Keychain:
```
Keychain Access → My Certificates
Powinieneś zobaczyć: "Apple Distribution: [Twoja nazwa] ([Team ID])"
```

---

### 2.4 Provisioning Profile

1. **Profiles** → **"+"**
2. Wybierz **"App Store"** → Continue
3. App ID: Wybierz **com.odyseya.app**
4. Certificate: Wybierz swój Distribution Certificate
5. Profile Name: **Odyseya App Store**
6. Download profilu (.mobileprovision)
7. Kliknij dwukrotnie (zainstaluje się)

**Weryfikacja:**
```bash
# Lista zainstalowanych profili
ls ~/Library/MobileDevice/Provisioning\ Profiles/
```

---

## 📱 ETAP 3: App Store Connect

### 3.1 Utworzenie aplikacji

1. Przejdź do: https://appstoreconnect.apple.com
2. **My Apps** → **"+"** → **New App**

**Konfiguracja:**
```
Platforms: ✅ iOS
Name: Odyseya
Primary Language: Polish (lub English)
Bundle ID: com.odyseya.app (wybierz z listy)
SKU: odyseya-001 (unikalny identyfikator, może być dowolny)
User Access: Full Access
```

3. Kliknij **"Create"**

---

### 3.2 App Information

**App Store Connect → Twoja aplikacja → App Information**

```
Name: Odyseya
Subtitle: Inner Peace Through Voice Journaling (max 30 znaków)
Privacy Policy URL: https://twoja-strona.com/privacy
Category:
  Primary: Health & Fitness
  Secondary: Lifestyle
Content Rights: Nie zawiera praw osób trzecich
Age Rating: 4+ (będzie wymagany kwestionariusz)
```

**Privacy Policy:**
- WYMAGANA dla wszystkich aplikacji
- Musi być publicznie dostępna (URL)
- Musi być w języku angielskim
- Generatory: https://www.privacypolicygenerator.info/

---

### 3.3 Pricing and Availability

```
Price: Free (lub wybierz tier)
Availability: All Countries
```

**Jeśli płatna (RevenueCat):**
```
Base Price: Tier X
In-App Purchases: Skonfiguruj osobno
```

---

### 3.4 App Privacy

**App Store Connect → Twoja aplikacja → App Privacy**

Odpowiedz na pytania o zbieranie danych:

**Przykładowe odpowiedzi dla Odyseya:**
```
Do you collect data from this app?
✅ Yes

Data Types:
- Contact Info (Email) - for authentication
- User Content (Audio recordings) - for journaling
- Usage Data - for analytics

Linked to User: Yes (jeśli zapisujesz w Firebase)
Used for Tracking: No (unless using tracking)
```

**WAŻNE:** Musisz być zgodny z tym co deklarujesz!

---

### 3.5 Age Rating

Wypełnij kwestionariusz:
```
Violence: None
Sexual Content: None
Horror/Fear: None
Medical/Treatment Info: None
Alcohol/Drugs/Tobacco: None
Gambling: No
Profanity/Crude Humor: None
```

Rating powinien być: **4+**

---

## 🚀 ETAP 4: Build i Upload

### 4.1 Przygotowanie do buildu

**1. Wyczyść poprzednie buildy:**
```bash
cd /Users/joannacholas/CursorProjects/odyseya
flutter clean
flutter pub get
cd ios
pod install
pod update
```

**2. Uruchom testy (opcjonalnie):**
```bash
flutter test
```

**3. Sprawdź konfigurację:**
```bash
flutter doctor
flutter doctor -v
```

---

### 4.2 Konfiguracja Xcode dla Release

**Otwórz Xcode:**
```bash
open ios/Runner.xcworkspace
```

**W Xcode:**

1. **Wybierz target Runner** (nie RunnerTests)

2. **Signing & Capabilities:**
   ```
   Team: [Twój Apple Developer Team]
   Bundle Identifier: com.odyseya.app
   Signing Certificate: Apple Distribution
   Provisioning Profile: Odyseya App Store (Automatic)
   ✅ Automatically manage signing (zalecane)
   ```

3. **General tab:**
   ```
   Display Name: Odyseya
   Version: 1.0.0 (z pubspec.yaml)
   Build: 1 (z pubspec.yaml)
   Deployment Target: iOS 13.0 (lub wyższy)
   ```

4. **Build Settings:**
   ```
   Search: "bitcode"
   Enable Bitcode: No (Flutter nie wspiera)
   ```

---

### 4.3 Build Archive (Opcja A - Xcode GUI)

**W Xcode:**

1. Product → Scheme → **Runner**
2. Product → Destination → **Any iOS Device (arm64)**
3. Product → **Archive**

Poczekaj 5-10 minut...

**Organizer otworzy się automatycznie z archiwum**

---

### 4.4 Build Archive (Opcja B - Command Line)

```bash
cd /Users/joannacholas/CursorProjects/odyseya

# Build release (Flutter)
flutter build ios --release

# Lub bezpośrednio z Xcode
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -sdk iphoneos \
  -configuration Release \
  archive -archivePath $PWD/build/Runner.xcarchive

# Jeśli sukces:
# ✅ Archive created at: ios/build/Runner.xcarchive
```

---

### 4.5 Upload do App Store Connect

**Opcja A - Xcode Organizer (ZALECANE):**

1. Xcode → Window → **Organizer** (Cmd + Shift + Option + O)
2. Wybierz swoje archiwum
3. Kliknij **"Distribute App"**
4. Wybierz **"App Store Connect"** → Next
5. Wybierz **"Upload"** → Next
6. **Distribution options:**
   ```
   ✅ Include bitcode for iOS content: NO
   ✅ Upload your app's symbols: YES (dla crash reports)
   ⬜ Manage Version and Build Number: NO
   ```
7. Next → wybierz **Automatic signing** → Next
8. **Review** → **Upload**

Poczekaj 5-15 minut...

**Opcja B - Command Line (zaawansowane):**

```bash
# Export IPA
xcodebuild -exportArchive \
  -archivePath $PWD/build/Runner.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath $PWD/build

# Upload via Transporter lub altool (deprecated)
xcrun altool --upload-app \
  -f build/Runner.ipa \
  -t ios \
  -u "twoj-apple-id@email.com" \
  -p "app-specific-password"
```

---

### 4.6 Weryfikacja uploadu

1. App Store Connect → **My Apps** → **Odyseya**
2. **TestFlight** tab
3. Po 5-15 minutach zobaczysz build: **1.0.0 (1)**

**Status:**
```
Processing → Ready to Submit
```

Jeśli "Missing Compliance" - odpowiedz na pytania o encryption.

---

## ✅ ETAP 5: Submission i Review

### 5.1 Przygotowanie do submission

**App Store Connect → Twoja aplikacja → główna zakładka (nie TestFlight)**

1. Kliknij **"+"** przy **iOS App** (jeśli pierwsza wersja)
2. Lub **"Add Version"** dla aktualizacji

**Wypełnij wszystkie pola:**

#### What's New in This Version:
```
Initial release of Odyseya - your personal voice journaling companion.

Features:
• Voice-based journaling with AI transcription
• Mood tracking and emotional insights
• Gentle daily reminders
• Secure cloud storage
• Privacy-first design

Start your journey to inner peace today.
```

#### Description:
```
[Max 4000 znaków]

Odyseya is a serene voice journaling app designed to help you understand
your emotions and build healthier emotional habits through the power of
your voice.

KEY FEATURES:
🎙️ Voice Recording - Express yourself naturally through voice
🧠 AI-Powered Insights - Understand your emotional patterns
📅 Daily Prompts - Gentle guidance for your journaling practice
🔒 Privacy First - Your data is encrypted and secure
💚 Mood Tracking - Track your emotional journey over time

WHY ODYSEYA?
...
[Rozwiń opis - sprzedaj wartość aplikacji]
```

#### Keywords:
```
journal,voice,diary,mood,mental health,wellness,mindfulness,therapy,emotions
```
(Max 100 znaków, oddzielone przecinkami)

#### Support URL:
```
https://twoja-strona.com/support
```

#### Marketing URL (opcjonalnie):
```
https://twoja-strona.com
```

---

### 5.2 Upload Screenshotów

1. **App Screenshots** → Dodaj dla KAŻDEGO wymaganego rozmiaru
2. Przeciągnij screenshoty (drag & drop)
3. Opcjonalnie: dodaj App Preview (wideo)

**Kolejność:**
- Pierwszy screenshot = główny (pokazywany w wyszukiwaniu)
- Układaj od najważniejszej funkcji do najmniej

---

### 5.3 Wybór Buildu

1. Scroll do **Build** section
2. Kliknij **"+"** lub **"Select a build"**
3. Wybierz build: **1.0.0 (1)**

Jeśli nie ma buildu - poczekaj kilka minut i odśwież.

---

### 5.4 App Review Information

```
Contact Information:
  First Name: [Twoje imię]
  Last Name: [Nazwisko]
  Phone: +48...
  Email: twoj@email.com

Demo Account (jeśli wymagane logowanie):
  Username: demo@odyseya.app
  Password: Demo123!

Notes:
  This app requires microphone access for voice journaling.
  All user data is stored securely in Firebase.
```

**WAŻNE:** Podaj działające demo konto jeśli app wymaga logowania!

---

### 5.5 Version Release

```
Wybierz:
● Automatically release this version
  (Opublikuj automatycznie po aprobacie)

Lub:

○ Manually release this version
  (Ręcznie opublikuj - możesz wybrać datę/czas)
```

---

### 5.6 Submit for Review

1. **Sprawdź wszystkie sekcje** - muszą mieć ✅
2. Kliknij **"Add for Review"**
3. Przeczytaj Export Compliance questions:
   ```
   Does your app use encryption?
   - If only HTTPS: NO
   - If custom encryption: YES (wymaga dokumentacji)
   ```
4. Kliknij **"Submit to App Review"**

**Status zmieni się na:**
```
Waiting for Review → In Review → Pending Developer Release / Ready for Sale
```

---

## ⏱️ Czas Przeglądu

**Typowy czas przeglądu:**
- Pierwszy submission: 24-48 godzin
- Aktualizacje: 12-24 godziny
- Czasami: kilka dni

**Sprawdzaj status:**
- App Store Connect
- Email notifications
- App Store Connect app (iOS)

---

## ❌ Częste Przyczyny Odrzucenia

### 1. Missing Privacy Policy
**Rozwiązanie:** Dodaj link do Privacy Policy

### 2. Missing Permission Descriptions
**Rozwiązanie:** Dodaj wszystkie `NS*UsageDescription` w Info.plist

### 3. Crashes on Launch
**Rozwiązanie:** Test na prawdziwym urządzeniu przed submission

### 4. Incomplete Metadata
**Rozwiązanie:** Wypełnij WSZYSTKIE pola w App Store Connect

### 5. Invalid Screenshots
**Rozwiązanie:** Użyj dokładnych rozmiarów, bez status bar (jeśli wymagane)

### 6. Demo Account Issues
**Rozwiązanie:** Upewnij się że demo konto działa

### 7. Guideline 4.3 (Spam)
**Rozwiązanie:** Aplikacja musi być unikalna, nie klon

### 8. Guideline 2.1 (Crashes/Bugs)
**Rozwiązanie:** Napraw wszystkie znane bugi

---

## 🔄 Aktualizacje Aplikacji

### Proces aktualizacji (szybszy):

1. **Zwiększ wersję** w `pubspec.yaml`:
   ```yaml
   version: 1.0.1+2  # było 1.0.0+1
   ```

2. **Build nowej wersji:**
   ```bash
   flutter clean
   flutter build ios --release
   ```

3. **Archive i Upload** (jak wyżej)

4. **App Store Connect:**
   - Dodaj nową wersję
   - Co nowego (What's New)
   - Wybierz nowy build
   - Submit

**Czas przeglądu:** zwykle szybszy (12-24h)

---

## 📊 Po Publikacji

### Monitoring:

**App Analytics (wbudowane):**
- App Store Connect → Analytics
- Downloads, impressions, conversions
- Crashes, performance

**Crash Reports:**
- Xcode → Window → Organizer → Crashes
- Wymaga symbols upload podczas dystrybucji

**Reviews:**
- App Store Connect → Ratings and Reviews
- Odpowiadaj na recenzje!

### Beta Testing (TestFlight):

Przed każdym release możesz:
1. Upload buildu (jak wyżej)
2. TestFlight → wybierz build
3. Add testers (email)
4. Test przez 90 dni

---

## 🛠️ Narzędzia Pomocnicze

### Fastlane (automatyzacja):
```bash
# Instalacja
brew install fastlane

# Inicjalizacja
cd ios
fastlane init

# Automated deployment
fastlane release
```

### Codemagic / Bitrise (CI/CD):
- Automatyczny build przy git push
- Automatyczny upload do TestFlight
- Integracja z Slack/Discord

---

## 📝 Checklist przed Submission

**Aplikacja:**
- [ ] Wszystkie funkcje działają
- [ ] Brak crashy na prawdziwym urządzeniu
- [ ] Testowane na iOS 13+ i różnych rozmiarach iPhone/iPad
- [ ] Wszystkie uprawnienia mają opisy
- [ ] App Icon (wszystkie rozmiary)
- [ ] Launch Screen

**Apple Developer:**
- [ ] App ID utworzony z capabilities
- [ ] Distribution Certificate zainstalowany
- [ ] Provisioning Profile utworzony

**App Store Connect:**
- [ ] Aplikacja utworzona
- [ ] Wszystkie metadata wypełnione
- [ ] Screenshots dla wszystkich rozmiarów (min. 3)
- [ ] Privacy Policy URL
- [ ] Support URL
- [ ] Age Rating
- [ ] Pricing
- [ ] Build uploaded i processing zakończony

**Submission:**
- [ ] Build wybrany
- [ ] Export Compliance odpowiedzi
- [ ] Demo account (jeśli wymagane)
- [ ] Contact info

---

## 🎉 Gratulacje!

Po aprobacie Twoja aplikacja będzie dostępna w App Store!

**Następne kroki:**
1. Monitoruj analytics
2. Odpowiadaj na reviews
3. Planuj aktualizacje
4. Marketing i promocja

**Powodzenia z Odyseya! 🚀**
