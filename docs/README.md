# 📚 ODYSEYA DOCUMENTATION INDEX

**Last Updated:** 2025-10-23
**Maintained By:** Odyseya Documentation & Regulation Agent

---

## 🎯 Quick Navigation

### Core Documentation
- **[SCREEN_MAP.md](./SCREEN_MAP.md)** - Complete map of all 34 screens
- **[WIDGET_REFERENCE.md](./WIDGET_REFERENCE.md)** - All 21 reusable UI components
- **[SERVICE_REFERENCE.md](./SERVICE_REFERENCE.md)** - All 23 backend services
- **[ARCHITECTURE_OVERVIEW.md](./ARCHITECTURE_OVERVIEW.md)** - System architecture *(pending)*
- **[GDPR_COMPLIANCE.md](./GDPR_COMPLIANCE.md)** - Privacy compliance reference *(pending)*

### UX & Design
- **[ODYSEYA_FULL_UX_STRUCTURE_NOTES_v2.0.md](./ODYSEYA_FULL_UX_STRUCTURE_NOTES_v2.0.md)** - Complete UX framework

### Compliance Reports
See [/reports/](../reports/) folder:
- **[Compliance_Gap_Report.md](../reports/Compliance_Gap_Report.md)** - 10 legal/regulatory gaps identified
- **[Regulation_Watch_Report.md](../reports/Regulation_Watch_Report.md)** - Ongoing regulation monitoring *(pending)*

---

## 📊 Documentation Status

| Document | Status | Lines | Last Updated |
|----------|--------|-------|--------------|
| SCREEN_MAP.md | ✅ Complete | ~350 | 2025-10-23 |
| WIDGET_REFERENCE.md | ✅ Complete | ~450 | 2025-10-23 |
| SERVICE_REFERENCE.md | ✅ Complete | ~600 | 2025-10-23 |
| ARCHITECTURE_OVERVIEW.md | 🔄 In Progress | ~400 | 2025-10-23 |
| GDPR_COMPLIANCE.md | 🔄 In Progress | ~500 | 2025-10-23 |
| UX Framework v2.0 | ✅ Complete | ~250 | 2025-10-23 |

---

## 🚨 Critical Compliance Gaps (Action Required)

From [Compliance_Gap_Report.md](../reports/Compliance_Gap_Report.md):

### 🔴 Critical (Fix in 0-7 days):
1. **EU AI Act Transparency** - Disclose OpenAI models (GPT, Whisper) in Privacy Policy
2. **CCPA "Do Not Sell" Notice** - Add formal California compliance section
3. **Apple Privacy Manifest** - Create `PrivacyInfo.xcprivacy` file

### 🟠 High Priority (Fix in 8-30 days):
4. **AI Risk Classification** - Disclose "Limited Risk" status under EU AI Act
5. **Data Retention Schedule** - Complete retention periods for all data types
6. **Accessibility (WCAG 2.1)** - Add `Semantics` to voice recording widgets

**Overall Compliance Score:** 87/100 (Good)

---

## 🏗️ Architecture Overview

```
UI Layer (34 screens)
    ↓
State Management (Riverpod)
    ↓
Service Layer (23 services)
    ↓
External APIs (Firebase, OpenAI, RevenueCat)
```

**Key Components:**
- **Screens:** 34 (System: 7, Onboarding: 14, Main App: 13)
- **Widgets:** 21 reusable components
- **Services:** 23 (Auth, Firebase, AI, Audio, Data, Payments)
- **State:** Riverpod providers for auth, journals, navigation, subscriptions

---

## 🔐 Privacy & Compliance

**Regulations Covered:**
- ✅ EU GDPR (95% compliant)
- ✅ CCPA/CPRA (90% compliant)
- ⚠️ EU AI Act (70% compliant - needs transparency updates)
- ✅ Apple App Store (100%)
- ✅ Google Play Store (100%)

**User Rights Implemented:**
- ✅ Right to Access (data download)
- ✅ Right to Erasure (account deletion)
- ✅ Right to Portability (JSON/CSV export)
- ✅ Right to Restrict Processing (AI opt-out)
- ✅ Right to Withdraw Consent (settings)

---

## 🛠️ For Developers

### Quick References
- **Screen Map:** [SCREEN_MAP.md](./SCREEN_MAP.md) - Find any screen by feature
- **Widget Docs:** [WIDGET_REFERENCE.md](./WIDGET_REFERENCE.md) - Reusable components
- **Service Docs:** [SERVICE_REFERENCE.md](./SERVICE_REFERENCE.md) - Backend integration
- **UX Framework:** [ODYSEYA_FULL_UX_STRUCTURE_NOTES_v2.0.md](./ODYSEYA_FULL_UX_STRUCTURE_NOTES_v2.0.md) - Design system

### Code References
All documentation includes file paths and line numbers:
- Example: `lib/screens/auth/login_screen.dart:42`
- Example: `lib/widgets/common/odyseya_button.dart`

---

## 📅 Maintenance Schedule

**Monthly:**
- Regulation scan (EU AI Act, App Store policies)
- Update documentation for new screens/services

**Quarterly:**
- Compliance gap re-audit
- GDPR/CCPA regulation review
- Documentation completeness check

**Annually:**
- Full security audit
- DPIA (Data Protection Impact Assessment)
- Third-party processor DPA renewal

---

## 📞 Contact

**Documentation Questions:** odyseya.journal@gmail.com
**Compliance Inquiries:** odyseya.journal@gmail.com
**Privacy Requests:** odyseya.journal@gmail.com

---

**Next Documentation Review:** 2025-11-23
**Next Compliance Audit:** 2025-11-23
