# Quick Reference Card

## 🚀 Your Deployment At a Glance

### Firebase Project
- **Project ID:** `odyseya-voice-journal`
- **Console:** https://console.firebase.google.com/project/odyseya-voice-journal
- **Plan:** Blaze (Pay-as-you-go)

### Cloud Functions (All Live ✅)
```
analyzeJournalEntry   → AI analysis of journal entries
generateSummary       → Biweekly/monthly summaries
getUsageStats         → Usage tracking
```

### OpenAI API Key
```
✅ Configured and secure
✅ Stored in Firebase (encrypted)
✅ Never exposed to clients
```

---

## 🧪 Quick Test (5 Minutes)

### 1. Create Test User
Firebase Console → Authentication → Add User

### 2. Initialize User Doc
Firebase Console → Firestore → Create:
```
Collection: users
Document ID: [your-test-user-id]
Fields:
  - isPremium: false
  - email: "test@example.com"
  - createdAt: [now]
```

### 3. Run App
```bash
flutter run
```

### 4. Test Journal Entry
- Sign in
- Create voice journal
- Wait for AI analysis
- Check Firestore for usage tracking

---

## 💰 Costs

### Per Analysis
- OpenAI: ~$0.01
- Firebase: ~$0.0001
- **Total: ~$0.01**

### Monthly (Example)
- 1000 free users (5 each): $50
- 100 premium users (60 each): $60
- **Revenue from premium**: $499
- **Net profit**: $389

---

## 🔒 Security Checklist

- [x] API key secure (server-side only)
- [x] Firestore rules deployed
- [x] Authentication required
- [x] Rate limiting active
- [ ] **TODO: Set OpenAI spending limits!**
- [ ] **TODO: Set Firebase budget alerts!**

---

## 📊 Subscription Tiers

| Feature | Free | Premium |
|---------|------|---------|
| Analyses/month | 5 | Unlimited |
| Summaries/month | 1 | Unlimited |
| Rate limit/hour | 10 | 60 |
| **Price** | **FREE** | **$4.99/mo** |

---

## 🛠️ Useful Commands

### View Functions
```bash
firebase functions:list
```

### View Logs
```bash
firebase functions:log
```

### Check Config
```bash
firebase functions:config:get
```

### Redeploy Functions
```bash
firebase deploy --only functions
```

### Deploy Firestore Rules
```bash
firebase deploy --only firestore:rules
```

### Flutter Analyze
```bash
flutter analyze
```

---

## 📱 App Integration

### Already Configured ✅
- `lib/services/openai_backend_service.dart` → Calls Cloud Functions
- `lib/services/ai_service_factory.dart` → Uses backend by default
- No additional setup needed!

### How It Works
```
Flutter App
    ↓
Firebase Auth
    ↓
Cloud Functions (Backend)
    ↓
OpenAI GPT-4o
    ↓
AI Analysis Response
```

---

## 🚨 Set Spending Limits NOW!

### OpenAI
1. https://platform.openai.com/settings/organization/limits
2. Hard limit: $10/month
3. Soft limit: $5/month

### Firebase
1. Console → Project Settings → Billing
2. Alert at $5, $10, $20

---

## 🐛 Common Issues

### "Function not found"
→ Wait 2-3 min after deployment

### "Unauthenticated"
→ User not logged in with Firebase Auth

### "Monthly limit reached"
→ Delete usage doc in Firestore OR set `isPremium: true`

### No AI analysis
→ Check Firebase Functions logs for errors

---

## 📚 Full Documentation

- [DEPLOYMENT_SUCCESS.md](DEPLOYMENT_SUCCESS.md) - Complete deployment summary
- [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Step-by-step guide
- [SUBSCRIPTION_TIERS.md](SUBSCRIPTION_TIERS.md) - Pricing details
- [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - Technical details
- [QUICK_START.md](QUICK_START.md) - 10-minute setup

---

## ✅ Status: FULLY DEPLOYED

All systems operational! Ready to test and launch! 🎉
