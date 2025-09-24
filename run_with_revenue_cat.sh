#!/bin/bash

# 🚀 Run Odyseya with RevenueCat configuration
# Replace the API keys below with your actual keys from RevenueCat dashboard

# STEP 1: Replace these with your actual RevenueCat API keys
export RC_IOS_KEY_DEV="PASTE_YOUR_IOS_API_KEY_HERE"
export RC_ANDROID_KEY_DEV="PASTE_YOUR_ANDROID_API_KEY_HERE"

# STEP 2: Product IDs (must match what you created in RevenueCat)
export MONTHLY_PRODUCT_ID="odyseya_monthly_premium"
export ANNUAL_PRODUCT_ID="odyseya_annual_premium"

# STEP 3: OpenAI Configuration - Use environment variable or .env file
export OPENAI_API_KEY="${OPENAI_API_KEY:-PASTE_YOUR_OPENAI_API_KEY_HERE}"

# STEP 4: App Configuration
export USE_WHISPER=true
export IS_PROD=false

echo "🔐 Starting Odyseya with RevenueCat configuration..."
echo "📱 iOS API Key: ${RC_IOS_KEY_DEV:0:10}..."
echo "🛍️ Monthly Product: $MONTHLY_PRODUCT_ID"
echo "📅 Annual Product: $ANNUAL_PRODUCT_ID"

# STEP 5: Run Flutter with environment variables
flutter run \
  --dart-define=RC_IOS_KEY_DEV="$RC_IOS_KEY_DEV" \
  --dart-define=RC_ANDROID_KEY_DEV="$RC_ANDROID_KEY_DEV" \
  --dart-define=MONTHLY_PRODUCT_ID="$MONTHLY_PRODUCT_ID" \
  --dart-define=ANNUAL_PRODUCT_ID="$ANNUAL_PRODUCT_ID" \
  --dart-define=OPENAI_API_KEY="$OPENAI_API_KEY" \
  --dart-define=USE_WHISPER="$USE_WHISPER" \
  --dart-define=IS_PROD="$IS_PROD"