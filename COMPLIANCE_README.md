# 🏜️ Odyseya Compliance Agent

**ONE agent. ONE command. ONE report.**

---

## 🚀 Usage

```bash
./run_compliance.sh
```

---

## 📊 What It Checks

- 🎨 **UX**: Colors, typography, spacing, animations
- 🧱 **Architecture**: Files, folders, imports, logic

---

## 🎯 Priority: Fix White Text

**Problem**: White text on light backgrounds

**Fix**:
```dart
// ❌ WRONG
color: Colors.white

// ✅ CORRECT
color: DesertColors.brownBramble  // #57351E
```

---

## 📄 Report

```bash
open reports/Odyseya_Compliance_Report.md
```

---

## 🎨 Approved Colors

```
#D8A36C - Western Sunrise  (PRIMARY BUTTON)
#57351E - Brown Bramble    (text, icons)
#8B7362 - Tree Branch      (secondary text)
```

**Rule**: NO WHITE TEXT on light backgrounds

---

## 📖 Framework

- [docs/ODYSEYA_FULL_UX_STRUCTURE_NOTES_v2.0.md](docs/ODYSEYA_FULL_UX_STRUCTURE_NOTES_v2.0.md)

---

🏜️ *Desert calm meets emotional clarity.*
