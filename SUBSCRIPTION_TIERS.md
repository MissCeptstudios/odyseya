# Subscription Tier System

## Overview

Odyseya uses a two-tier subscription model to balance free access with sustainable costs for AI analysis.

## Tier Comparison

| Feature | Free Tier | Premium Tier |
|---------|-----------|--------------|
| **Monthly AI Analyses** | 5 | Unlimited |
| **Biweekly/Monthly Summaries** | 1 | Unlimited |
| **Rate Limit (per hour)** | 10 requests | 60 requests |
| **Voice Journal** | ✅ Unlimited | ✅ Unlimited |
| **Calendar View** | ✅ Full Access | ✅ Full Access |
| **Data Export** | ✅ Included | ✅ Included |
| **Priority Support** | ❌ | ✅ |
| **Cost** | **FREE** | **$4.99/month** |

## How It Works

### 1. Usage Tracking

The backend tracks usage in Firestore:

```
users/{userId}/usage/{monthKey}
  - analysesCount: 3
  - summariesCount: 0
  - lastReset: 2024-01-01T00:00:00Z
  - month: "2024-01"
```

**Month Key Format:** `YYYY-MM` (e.g., "2024-01" for January 2024)

Usage resets automatically on the 1st of each month.

### 2. Rate Limiting

Rate limits prevent abuse and manage costs:

- **Free:** 10 API calls per hour
- **Premium:** 60 API calls per hour

Rate limit tracking:

```
users/{userId}/usage/rateLimits
  - requestCount: 5
  - windowStart: 2024-01-15T14:00:00Z
```

### 3. Subscription Status

User subscription status is stored in:

```
users/{userId}
  - isPremium: boolean
  - subscriptionStartDate: timestamp
  - subscriptionEndDate: timestamp (optional)
```

## Implementation Details

### Backend (Firebase Cloud Functions)

Located in `functions/src/index.ts`:

```typescript
const SUBSCRIPTION_LIMITS = {
  free: {
    monthlyAnalyses: 5,
    monthlySummaries: 1,
    rateLimit: 10, // per hour
  },
  premium: {
    monthlyAnalyses: -1, // unlimited
    monthlySummaries: -1, // unlimited
    rateLimit: 60, // per hour
  },
};
```

### Flutter Client

Located in `lib/services/openai_backend_service.dart`:

```dart
class OpenAIBackendService implements AIServiceInterface {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<AIAnalysis> analyzeEmotionalContent({
    required String text,
    String? mood,
  }) async {
    final callable = _functions.httpsCallable('analyzeJournalEntry');
    final result = await callable.call({
      'text': text,
      'mood': mood,
    });
    return parseAnalysis(result);
  }
}
```

## User Flow

### Free User Journey

1. **First Journal Entry**
   - Records audio
   - Transcribes locally
   - Calls `analyzeJournalEntry` Cloud Function
   - Backend checks usage: 0/5 analyses used ✅
   - Returns AI analysis
   - Usage incremented: 1/5

2. **5th Analysis**
   - Usage: 4/5 before analysis ✅
   - Analysis completed successfully
   - Usage: 5/5 after analysis

3. **6th Analysis Attempt**
   - Usage: 5/5 ❌
   - Backend returns error: "Monthly limit reached"
   - App shows upgrade prompt:
     > "You've used all 5 free analyses this month. Upgrade to Premium for unlimited AI insights!"

4. **Next Month (Auto Reset)**
   - January → February
   - Usage automatically resets: 0/5
   - User can continue with free tier

### Premium User Journey

1. **Subscribe via RevenueCat**
   - User taps "Upgrade to Premium"
   - RevenueCat handles payment
   - On success, update Firestore:
   ```dart
   await FirebaseFirestore.instance
     .collection('users')
     .doc(userId)
     .update({'isPremium': true});
   ```

2. **Unlimited Analyses**
   - Every analysis checks subscription
   - Backend sees `isPremium: true`
   - No monthly limit enforced
   - Only hourly rate limit (60/hour)

3. **Subscription Expires**
   - RevenueCat webhook fires
   - Update Firestore: `isPremium: false`
   - User reverts to free tier limits
   - Current month usage persists (e.g., if 20/unlimited, now 20/5 = over limit)

## Error Handling

### Monthly Limit Reached

**Error Code:** `resource-exhausted`

**User sees:**
```
"Monthly Limit Reached"
"You've used all 5 AI analyses this month.
Upgrade to Premium for unlimited insights, or wait
until {nextMonthDate} for your limit to reset."

[Upgrade to Premium] [Dismiss]
```

**Implementation:**
```dart
try {
  final analysis = await aiService.analyzeEmotionalContent(...);
} on FirebaseFunctionsException catch (e) {
  if (e.code == 'resource-exhausted') {
    if (e.message?.contains('monthly limit')) {
      showUpgradeDialog();
    } else if (e.message?.contains('rate limit')) {
      showRateLimitDialog();
    }
  }
}
```

### Rate Limit Exceeded

**Error Code:** `resource-exhausted`

**User sees:**
```
"Too Many Requests"
"You've reached the hourly limit. Please wait
{minutesRemaining} minutes and try again."

[OK]
```

### Subscription Check Failed

**Error Code:** `internal`

**Fallback:** Allow analysis (fail open for better UX)

## Pricing Strategy

### Why $4.99/month?

**Cost Analysis:**

| Item | Cost per User/Month |
|------|---------------------|
| OpenAI API (60 analyses) | $0.15 |
| Firebase Functions | $0.05 |
| Firebase Firestore | $0.02 |
| **Total Cost** | **$0.22** |
| **Gross Margin** | **95.6%** |

**Comparable Apps:**
- Calm: $14.99/month
- Headspace: $12.99/month
- Day One Journal: $4.99/month ✅
- Reflectly: $8.99/month

### Free Tier Justification

**5 analyses/month** allows users to:
- Journal 1-2 times per week
- Experience AI insights
- Build habit before committing
- Typical conversion: 2-5% free → premium

**Monthly cost per free user:** $0.0125 (5 × $0.0025)

With 10,000 free users: **$125/month total cost**

## RevenueCat Integration

### Setup

1. **Create RevenueCat Account:** https://app.revenuecat.com

2. **Configure Entitlements:**
   - Name: `premium`
   - Identifier: `premium`

3. **Create Products:**
   - ID: `odyseya_premium_monthly`
   - Price: $4.99
   - Duration: 1 month

4. **Add to Flutter:**

```dart
// In main.dart
await Purchases.configure(
  PurchasesConfiguration('YOUR_REVENUECAT_API_KEY'),
);

// Check subscription status
final customerInfo = await Purchases.getCustomerInfo();
final isPremium = customerInfo.entitlements.all['premium']?.isActive ?? false;

// Update Firestore
await FirebaseFirestore.instance
  .collection('users')
  .doc(userId)
  .update({'isPremium': isPremium});
```

### Webhook (Server-Side)

Configure RevenueCat webhook to update Firestore automatically:

**Webhook URL:** `https://us-central1-{project}.cloudfunctions.net/revenuecat-webhook`

**Function:**
```typescript
export const revenuecatWebhook = functions.https.onRequest(async (req, res) => {
  const event = req.body;

  if (event.type === 'INITIAL_PURCHASE' || event.type === 'RENEWAL') {
    await admin.firestore()
      .collection('users')
      .doc(event.app_user_id)
      .update({ isPremium: true });
  } else if (event.type === 'CANCELLATION' || event.type === 'EXPIRATION') {
    await admin.firestore()
      .collection('users')
      .doc(event.app_user_id)
      .update({ isPremium: false });
  }

  res.sendStatus(200);
});
```

## UI Implementation

### Show Usage Stats

Display current usage in settings:

```dart
// In settings screen
StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .collection('usage')
    .doc(currentMonthKey) // e.g., "2024-01"
    .snapshots(),
  builder: (context, snapshot) {
    final usage = snapshot.data?.data() as Map<String, dynamic>?;
    final count = usage?['analysesCount'] ?? 0;
    final isPremium = userDoc['isPremium'] ?? false;

    if (isPremium) {
      return Text('Analyses this month: $count (Unlimited)');
    } else {
      return LinearProgressIndicator(
        value: count / 5,
        child: Text('$count / 5 analyses used'),
      );
    }
  },
)
```

### Upgrade Prompt

Show when limit reached:

```dart
void showUpgradeDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Monthly Limit Reached'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('You\'ve used all 5 free AI analyses this month.'),
          SizedBox(height: 16),
          Text('Upgrade to Premium for:'),
          ListTile(
            leading: Icon(Icons.check),
            title: Text('Unlimited AI analyses'),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text('Unlimited summaries'),
          ),
          ListTile(
            leading: Icon(Icons.check),
            title: Text('Priority support'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Maybe Later'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            await purchasePremium();
          },
          child: Text('Upgrade - \$4.99/month'),
        ),
      ],
    ),
  );
}
```

## Testing

### Test Free Tier

1. Set user to free tier:
```dart
await FirebaseFirestore.instance
  .collection('users')
  .doc(userId)
  .update({'isPremium': false});
```

2. Make 5 analyses - should succeed
3. Make 6th analysis - should fail with limit error
4. Verify error message shows upgrade prompt

### Test Premium Tier

1. Set user to premium:
```dart
await FirebaseFirestore.instance
  .collection('users')
  .doc(userId)
  .update({'isPremium': true});
```

2. Make 10+ analyses - all should succeed
3. Verify no monthly limit enforced

### Test Rate Limiting

1. Make 11 rapid requests as free user
2. 11th request should fail with rate limit error
3. Wait 1 hour, should work again

### Test Month Reset

1. Manually set usage to 5/5
2. Change month key to previous month
3. Make analysis - should succeed (new month)

## Analytics

Track key metrics:

```dart
// Conversion rate
final freeUsers = await getFreeUserCount();
final premiumUsers = await getPremiumUserCount();
final conversionRate = premiumUsers / (freeUsers + premiumUsers);

// Usage patterns
await FirebaseAnalytics.instance.logEvent(
  name: 'monthly_limit_reached',
  parameters: {
    'user_tier': 'free',
    'month': currentMonthKey,
  },
);

// Revenue
final mrr = premiumUsers * 4.99; // Monthly Recurring Revenue
```

## Future Enhancements

1. **Annual Plan:** $49.99/year (2 months free)
2. **Family Plan:** $9.99/month (up to 5 users)
3. **Lifetime:** $99.99 one-time
4. **Gift Subscriptions:** Send premium to friends
5. **Dynamic Pricing:** A/B test different price points
6. **Usage-Based:** Pay per analysis (e.g., $0.10 each)

## Summary

- ✅ Secure backend proxy with API key protection
- ✅ Two-tier system (Free: 5/month, Premium: unlimited)
- ✅ Rate limiting to prevent abuse
- ✅ Automatic monthly reset
- ✅ RevenueCat integration ready
- ✅ Clear upgrade prompts
- ✅ Usage tracking and analytics
