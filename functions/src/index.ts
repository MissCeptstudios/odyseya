import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import axios from "axios";

admin.initializeApp();

// Configuration
const OPENAI_API_KEY = functions.config().openai?.key;
const OPENAI_BASE_URL = "https://api.openai.com/v1";

// Model Configuration
// Switch between models by changing this value:
// - "gpt-4o" (default): Best quality, ~$0.01 per analysis
// - "gpt-4o-mini": Faster & cheaper, ~$0.001 per analysis (10x cheaper!)
const OPENAI_MODEL = "gpt-4o"; // Change to "gpt-4o-mini" to save costs

// Subscription Tiers & Limits
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

// ============================================================================
// TYPES
// ============================================================================

interface UsageRecord {
  userId: string;
  type: "analysis" | "summary";
  tokens: number;
  timestamp: number;
  month: string; // "2024-01"
}

interface UserTier {
  tier: "free" | "premium";
  subscriptionId?: string;
  expiresAt?: number;
}

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

/**
 * Get user's subscription tier from RevenueCat or Firestore
 */
async function getUserTier(userId: string): Promise<UserTier> {
  const db = admin.firestore();

  try {
    // Check user's subscription status in Firestore
    // (Your subscription_provider.dart should sync this)
    const userDoc = await db.collection("users").doc(userId).get();

    if (!userDoc.exists) {
      return {tier: "free"};
    }

    const userData = userDoc.data();
    const isPremium = userData?.isPremium === true;
    const subscriptionExpiry = userData?.premiumExpiresAt;

    // Check if premium subscription is active
    if (isPremium && subscriptionExpiry) {
      const now = Date.now();
      if (subscriptionExpiry > now) {
        return {
          tier: "premium",
          subscriptionId: userData?.subscriptionId,
          expiresAt: subscriptionExpiry,
        };
      }
    }

    return {tier: "free"};
  } catch (error) {
    console.error("Error fetching user tier:", error);
    return {tier: "free"}; // Default to free on error
  }
}

/**
 * Check if user has exceeded their monthly limit
 */
async function checkMonthlyLimit(
  userId: string,
  type: "analysis" | "summary",
  tier: UserTier
): Promise<{allowed: boolean; used: number; limit: number}> {
  const db = admin.firestore();

  // Get current month key (e.g., "2024-01")
  const now = new Date();
  const monthKey = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;

  // Get limits for user's tier
  const limits = SUBSCRIPTION_LIMITS[tier.tier];
  const monthlyLimit = type === "analysis" ? limits.monthlyAnalyses : limits.monthlySummaries;

  // If unlimited (-1), always allow
  if (monthlyLimit === -1) {
    return {allowed: true, used: 0, limit: -1};
  }

  // Count this month's usage
  const usageSnapshot = await db
    .collection("ai_usage")
    .where("userId", "==", userId)
    .where("type", "==", type)
    .where("month", "==", monthKey)
    .count()
    .get();

  const usedThisMonth = usageSnapshot.data().count;

  return {
    allowed: usedThisMonth < monthlyLimit,
    used: usedThisMonth,
    limit: monthlyLimit,
  };
}

/**
 * Check rate limit (requests per hour)
 */
async function checkRateLimit(
  userId: string,
  tier: UserTier
): Promise<{allowed: boolean; used: number; limit: number}> {
  const db = admin.firestore();

  const limits = SUBSCRIPTION_LIMITS[tier.tier];
  const rateLimit = limits.rateLimit;

  const oneHourAgo = Date.now() - (60 * 60 * 1000);

  const recentRequests = await db
    .collection("ai_usage")
    .where("userId", "==", userId)
    .where("timestamp", ">", oneHourAgo)
    .count()
    .get();

  const usedLastHour = recentRequests.data().count;

  return {
    allowed: usedLastHour < rateLimit,
    used: usedLastHour,
    limit: rateLimit,
  };
}

/**
 * Log usage for billing and analytics
 */
async function logUsage(
  userId: string,
  type: "analysis" | "summary",
  tokens: number
): Promise<void> {
  const db = admin.firestore();

  const now = new Date();
  const monthKey = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;

  const usageRecord: UsageRecord = {
    userId,
    type,
    tokens,
    timestamp: Date.now(),
    month: monthKey,
  };

  await db.collection("ai_usage").add(usageRecord);
}

/**
 * System prompt for emotional analysis
 */
function getAnalysisSystemPrompt(): string {
  return `You are an empathetic emotional intelligence assistant for a mental wellness journaling app called Odyseya. Your role is to:

1. Analyze journal entries with deep emotional understanding
2. Identify emotional patterns, triggers, and underlying themes
3. Provide compassionate, actionable insights
4. Suggest healthy coping strategies and self-care practices
5. Track emotional growth over time

Always be:
- Empathetic and non-judgmental
- Specific and actionable in suggestions
- Mindful of mental health best practices
- Encouraging of professional help when appropriate

Respond ONLY with valid JSON matching this exact structure:
{
  "emotionalTone": "brief overall emotional state",
  "confidence": 0.85,
  "triggers": ["specific trigger 1", "specific trigger 2"],
  "insight": "detailed compassionate insight about their emotional state and patterns",
  "suggestions": ["actionable suggestion 1", "actionable suggestion 2", "actionable suggestion 3"],
  "emotionScores": {
    "joy": 0.3,
    "sadness": 0.6,
    "anxiety": 0.4,
    "calm": 0.2,
    "anger": 0.1,
    "hope": 0.5
  }
}`;
}

/**
 * Build analysis prompt
 */
function buildAnalysisPrompt(text: string, mood?: string, previousContext?: string): string {
  let prompt = `Analyze this journal entry:\n\nEntry: "${text}"`;

  if (mood) {
    prompt += `\n\nUser-selected mood: ${mood}`;
  }

  if (previousContext) {
    prompt += `\n\nRecent context: ${previousContext}`;
  }

  prompt += "\n\nProvide a JSON analysis with emotional insights, triggers, and suggestions.";

  return prompt;
}

// ============================================================================
// CLOUD FUNCTIONS
// ============================================================================

/**
 * Analyze journal entry using OpenAI GPT-4o
 * Respects subscription tiers and usage limits
 */
export const analyzeJournalEntry = functions
  .region("us-central1")
  .runWith({
    timeoutSeconds: 60,
    memory: "256MB",
  })
  .https.onCall(async (data, context) => {
    // 1. Authentication check
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Authentication required to use AI analysis"
      );
    }

    const userId = context.auth.uid;

    // 2. Validate OpenAI key is configured
    if (!OPENAI_API_KEY) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "OpenAI API key not configured. Please contact support."
      );
    }

    // 3. Get user's subscription tier
    const userTier = await getUserTier(userId);

    console.log(`User ${userId} tier: ${userTier.tier}`);

    // 4. Check rate limit
    const rateCheck = await checkRateLimit(userId, userTier);
    if (!rateCheck.allowed) {
      throw new functions.https.HttpsError(
        "resource-exhausted",
        `Rate limit exceeded. You've used ${rateCheck.used}/${rateCheck.limit} requests in the last hour. ` +
        (userTier.tier === "free" ? "Upgrade to Premium for higher limits!" : "Please try again later.")
      );
    }

    // 5. Check monthly usage limit
    const monthlyCheck = await checkMonthlyLimit(userId, "analysis", userTier);
    if (!monthlyCheck.allowed) {
      throw new functions.https.HttpsError(
        "resource-exhausted",
        `Monthly limit exceeded. You've used ${monthlyCheck.used}/${monthlyCheck.limit} analyses this month. ` +
        (userTier.tier === "free" ? "Upgrade to Premium for unlimited analyses!" : "")
      );
    }

    // 6. Extract and validate request data
    const {text, mood, previousContext} = data;

    if (!text || typeof text !== "string" || text.length < 10) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Journal entry text must be at least 10 characters"
      );
    }

    if (text.length > 10000) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Journal entry text too long (max 10,000 characters)"
      );
    }

    try {
      // 7. Call OpenAI API
      console.log(`Calling OpenAI for user ${userId}, tier: ${userTier.tier}`);

      const response = await axios.post(
        `${OPENAI_BASE_URL}/chat/completions`,
        {
          model: OPENAI_MODEL,
          messages: [
            {
              role: "system",
              content: getAnalysisSystemPrompt(),
            },
            {
              role: "user",
              content: buildAnalysisPrompt(text, mood, previousContext),
            },
          ],
          temperature: 0.7,
          max_tokens: 1000,
          top_p: 0.9,
          response_format: {type: "json_object"},
        },
        {
          headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${OPENAI_API_KEY}`,
          },
          timeout: 50000, // 50 second timeout
        }
      );

      const result = response.data.choices[0].message.content;
      const usage = response.data.usage;

      // 8. Log usage for tracking
      await logUsage(userId, "analysis", usage.total_tokens);

      console.log(`✅ Analysis complete for ${userId}. Tokens: ${usage.total_tokens}`);

      // 9. Return result to app
      return {
        success: true,
        analysis: JSON.parse(result),
        usage: {
          tokensUsed: usage.total_tokens,
          monthlyUsed: monthlyCheck.used + 1,
          monthlyLimit: monthlyCheck.limit,
          tier: userTier.tier,
        },
      };
    } catch (error: any) {
      console.error("OpenAI API error:", error.response?.data || error.message);

      // Handle specific OpenAI errors
      if (error.response?.status === 429) {
        throw new functions.https.HttpsError(
          "resource-exhausted",
          "OpenAI rate limit exceeded. Please try again in a moment."
        );
      }

      if (error.response?.status === 401) {
        throw new functions.https.HttpsError(
          "failed-precondition",
          "OpenAI API authentication failed. Please contact support."
        );
      }

      throw new functions.https.HttpsError(
        "internal",
        "Failed to analyze journal entry. Please try again.",
        error.message
      );
    }
  });

/**
 * Generate periodic summary using OpenAI
 * Premium feature with limits for free users
 */
export const generateSummary = functions
  .region("us-central1")
  .runWith({
    timeoutSeconds: 120,
    memory: "512MB",
  })
  .https.onCall(async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError("unauthenticated", "Authentication required");
    }

    const userId = context.auth.uid;

    if (!OPENAI_API_KEY) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "OpenAI API key not configured"
      );
    }

    // Check subscription tier
    const userTier = await getUserTier(userId);

    // Check monthly summary limit
    const monthlyCheck = await checkMonthlyLimit(userId, "summary", userTier);
    if (!monthlyCheck.allowed) {
      throw new functions.https.HttpsError(
        "resource-exhausted",
        `Monthly summary limit exceeded (${monthlyCheck.used}/${monthlyCheck.limit}). ` +
        (userTier.tier === "free" ? "Upgrade to Premium for unlimited summaries!" : "")
      );
    }

    const {entries, frequency} = data;
    // periodStart and periodEnd are optional metadata (not used in current implementation)
    const _periodStart = data.periodStart;
    const _periodEnd = data.periodEnd;
    // Avoid unused variable warnings
    void _periodStart;
    void _periodEnd;

    if (!Array.isArray(entries)) {
      throw new functions.https.HttpsError("invalid-argument", "Entries must be an array");
    }

    try {
      // Build comprehensive summary prompt
      const summaryPrompt = buildSummaryPrompt(entries, frequency);

      const response = await axios.post(
        `${OPENAI_BASE_URL}/chat/completions`,
        {
          model: OPENAI_MODEL,
          messages: [
            {
              role: "system",
              content: "You are an empathetic emotional wellness assistant creating periodic journal summaries.",
            },
            {
              role: "user",
              content: summaryPrompt,
            },
          ],
          temperature: 0.7,
          max_tokens: 2000,
          response_format: {type: "json_object"},
        },
        {
          headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${OPENAI_API_KEY}`,
          },
          timeout: 110000,
        }
      );

      const result = response.data.choices[0].message.content;
      const usage = response.data.usage;

      await logUsage(userId, "summary", usage.total_tokens);

      console.log(`✅ Summary generated for ${userId}. Tokens: ${usage.total_tokens}`);

      return {
        success: true,
        summary: JSON.parse(result),
        usage: {
          tokensUsed: usage.total_tokens,
          monthlyUsed: monthlyCheck.used + 1,
          monthlyLimit: monthlyCheck.limit,
          tier: userTier.tier,
        },
      };
    } catch (error: any) {
      console.error("Summary generation error:", error.response?.data || error.message);
      throw new functions.https.HttpsError(
        "internal",
        "Failed to generate summary",
        error.message
      );
    }
  });

/**
 * Get user's AI usage statistics
 * Shows how many analyses they've used this month
 */
export const getUsageStats = functions
  .region("us-central1")
  .https.onCall(async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError("unauthenticated", "Authentication required");
    }

    const userId = context.auth.uid;
    const db = admin.firestore();

    // Get user tier
    const userTier = await getUserTier(userId);

    // Get current month
    const now = new Date();
    const monthKey = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}`;

    // Count this month's usage
    const [analysesSnapshot, summariesSnapshot] = await Promise.all([
      db.collection("ai_usage")
        .where("userId", "==", userId)
        .where("type", "==", "analysis")
        .where("month", "==", monthKey)
        .count()
        .get(),
      db.collection("ai_usage")
        .where("userId", "==", userId)
        .where("type", "==", "summary")
        .where("month", "==", monthKey)
        .count()
        .get(),
    ]);

    const limits = SUBSCRIPTION_LIMITS[userTier.tier];

    return {
      tier: userTier.tier,
      analyses: {
        used: analysesSnapshot.data().count,
        limit: limits.monthlyAnalyses,
        unlimited: limits.monthlyAnalyses === -1,
      },
      summaries: {
        used: summariesSnapshot.data().count,
        limit: limits.monthlySummaries,
        unlimited: limits.monthlySummaries === -1,
      },
      rateLimit: limits.rateLimit,
      subscriptionExpiry: userTier.expiresAt,
    };
  });

/**
 * Helper to build summary prompt (simplified)
 */
function buildSummaryPrompt(entries: any[], frequency: string): string {
  const periodType = frequency === "twoWeeks" ? "biweekly" : "monthly";

  let prompt = `You are analyzing a ${periodType} journal summary.\n\n`;
  prompt += `Total entries: ${entries.length}\n\n`;
  prompt += "JOURNAL ENTRIES:\n";

  entries.slice(0, 30).forEach((entry: any, index: number) => {
    prompt += `${index + 1}. [${entry.mood}] ${entry.transcription?.substring(0, 150) || ""}...\n`;
  });

  prompt += "\nProvide a comprehensive JSON summary with: overallMoodTrend, keyThemes, emotionalHighlights, challengingMoments, growthAreas, suggestedFocus, executiveSummary, detailedInsight, actionableSteps";

  return prompt;
}
