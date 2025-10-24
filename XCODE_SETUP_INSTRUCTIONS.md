# Xcode Setup Instructions - Sign in with Apple

## ✅ Prerequisite: Xcode już się otworzył
Plik workspace został otwarty automatycznie: `Runner.xcworkspace`

---

## 📱 Krok po kroku w Xcode

### 1. Dodaj plik Runner.entitlements do projektu

**Opcja A: Dodaj istniejący plik (ZALECANE)**

1. W Xcode, w lewym panelu (Project Navigator), kliknij prawym na folder **Runner**
2. Wybierz **"Add Files to Runner..."**
3. Przejdź do: `/Users/joannacholas/CursorProjects/odyseya/ios/Runner/`
4. Wybierz plik **`Runner.entitlements`**
5. ✅ Upewnij się, że zaznaczone są:
   - ✅ "Copy items if needed" (ODZNACZ to - plik już jest we właściwym miejscu)
   - ✅ "Create groups"
   - ✅ Target "Runner" jest zaznaczony
6. Kliknij **"Add"**

**Opcja B: Xcode utworzy automatycznie (jeśli nie widzi pliku)**

Jeśli powyższe nie zadziała, Xcode może utworzyć nowy plik:
1. W lewym panelu, wybierz **Runner** (niebieski projekt)
2. W środkowym panelu, wybierz target **Runner**
3. Przejdź do zakładki **"Signing & Capabilities"**
4. Kliknij **"+ Capability"** (u góry po lewej)
5. Znajdź i kliknij **"Sign in with Apple"**
6. Xcode utworzy plik entitlements automatycznie

---

### 2. Włącz capability "Sign in with Apple"

1. W lewym panelu (Project Navigator), kliknij na **Runner** (niebieski projekt na górze)
2. W środkowym panelu, upewnij się że wybrano:
   - Target: **Runner** (nie RunnerTests)
3. Przejdź do zakładki **"Signing & Capabilities"** (u góry)
4. Kliknij przycisk **"+ Capability"** (u góry po lewej stronie)
5. W wyszukiwarce wpisz: **"Sign in with Apple"**
6. Kliknij na **"Sign in with Apple"** żeby dodać capability

Po dodaniu powinieneś zobaczyć:
```
Sign In with Apple
✓ Enabled
```

---

### 3. Sprawdź plik entitlements

1. W zakładce **"Signing & Capabilities"**
2. Znajdź sekcję **"Sign in with Apple"**
3. W sekcji **"Build Settings"** (inna zakładka), wyszukaj **"Code Signing Entitlements"**
4. Upewnij się, że wartość to: **`Runner/Runner.entitlements`**

---

### 4. Sprawdź Team i Bundle ID

**WAŻNE: Musisz mieć Apple Developer Account!**

1. W zakładce **"Signing & Capabilities"**
2. Sekcja **"Signing"** (u góry):
   - **Team**: Wybierz swój Apple Developer Team
   - **Bundle Identifier**: `com.example.odyseya`
   - ✅ **Automatically manage signing**: WŁĄCZONE (zalecane)

3. Jeśli widzisz błędy:
   - Zaloguj się do swojego Apple Developer Account w Xcode:
   - **Xcode → Settings → Accounts → "+" → Add Apple ID**

---

### 5. Zbuduj projekt (test)

1. Wybierz symulator lub urządzenie (u góry, obok "Runner")
2. Naciśnij **Cmd + B** (lub Product → Build)
3. Sprawdź czy build się udaje bez błędów

**Jeśli widzisz błędy provisioning:**
- Otwórz zakładkę **Signing & Capabilities**
- Kliknij na błąd
- Kliknij **"Try Again"** lub **"Download Manual Profiles"**

---

## ⚠️ Częste problemy

### Problem: "No profiles for 'com.example.odyseya' were found"
**Rozwiązanie:**
1. Upewnij się że jesteś zalogowany w Apple Developer Account
2. W Signing & Capabilities, kliknij Team i wybierz ponownie
3. Włącz "Automatically manage signing"

### Problem: "Runner.entitlements not found"
**Rozwiązanie:**
1. W Xcode, usuń capability "Sign in with Apple"
2. Dodaj ponownie - Xcode utworzy nowy plik entitlements
3. Skopiuj zawartość z `/Users/joannacholas/CursorProjects/odyseya/ios/Runner/Runner.entitlements`

### Problem: "Signing for Runner requires a development team"
**Rozwiązanie:**
1. Musisz mieć Apple Developer Account (płatny - $99/rok)
2. Dodaj swój Apple ID w Xcode Settings → Accounts
3. Wybierz Team w projekcie

---

## 🎯 Apple Developer Console (równolegle)

**Podczas gdy pracujesz w Xcode, musisz też:**

1. Otwórz: https://developer.apple.com/account
2. Przejdź do: **Certificates, Identifiers & Profiles**
3. Kliknij: **Identifiers**
4. Znajdź: **com.example.odyseya** (App ID)
   - Jeśli nie istnieje, kliknij "+" i utwórz nowy:
     - Description: **Odyseya**
     - Bundle ID: **com.example.odyseya**
5. Kliknij na App ID
6. Znajdź **"Sign in with Apple"** w liście Capabilities
7. ✅ Zaznacz checkbox przy **"Sign in with Apple"**
8. Kliknij **"Save"**
9. Potwierdź zmiany

---

## ✅ Weryfikacja

Po wykonaniu wszystkich kroków, sprawdź:

**W Xcode:**
- [ ] Plik `Runner.entitlements` widoczny w Project Navigator
- [ ] Capability "Sign in with Apple" widoczne w Signing & Capabilities
- [ ] Team wybrany (Twój Apple Developer Team)
- [ ] Build przechodzi bez błędów (Cmd + B)
- [ ] W Build Settings, "Code Signing Entitlements" = `Runner/Runner.entitlements`

**W Apple Developer Console:**
- [ ] App ID `com.example.odyseya` istnieje
- [ ] "Sign in with Apple" jest włączone dla tego App ID
- [ ] Provisioning Profile jest aktualny

**W pliku Runner.entitlements:**
```xml
<key>com.apple.developer.applesignin</key>
<array>
    <string>Default</string>
</array>
```

---

## 🚀 Następne kroki

Po skonfigurowaniu Xcode:

1. **Test na symulatorze:**
   ```bash
   cd /Users/joannacholas/CursorProjects/odyseya
   flutter run
   ```

2. **Test na prawdziwym urządzeniu:**
   - Podłącz iPhone
   - Wybierz urządzenie w Xcode
   - `flutter run`
   - **UWAGA:** Sign in with Apple działa TYLKO na prawdziwym urządzeniu, nie na symulatorze!

3. **Test Apple Sign In:**
   - Otwórz app na prawdziwym iPhone
   - Kliknij "Sign in with Apple"
   - Powinieneś zobaczyć natywny prompt Apple ID

---

## 📞 Potrzebujesz pomocy?

Jeśli coś nie działa:
1. Sprawdź Console w Xcode (View → Debug Area → Show Debug Area)
2. Sprawdź logi: `flutter run --verbose`
3. Upewnij się że masz aktywny Apple Developer Account
4. Sprawdź czy certyfikaty są aktualne w Apple Developer Portal

---

**Status plików:**
```
✅ ios/Runner/Runner.entitlements - utworzony
✅ lib/services/auth_service.dart - zaimplementowany
⚠️ Xcode configuration - wymaga ręcznej konfiguracji (powyżej)
⚠️ Apple Developer Console - wymaga włączenia capability (powyżej)
```
