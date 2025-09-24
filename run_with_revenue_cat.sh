#!/bin/bash

# 🚀 Run Odyseya with RevenueCat configuration
# This script loads configuration from .env file

# STEP 1: Load environment variables from .env file
if [ -f .env ]; then
    echo "📄 Loading configuration from .env file..."
    export $(grep -v '^#' .env | xargs)
else
    echo "⚠️  Warning: .env file not found. Using defaults."
fi

# STEP 2: Set defaults if not provided in .env
export RC_IOS_KEY_DEV="${RC_IOS_KEY_DEV:-PASTE_YOUR_IOS_API_KEY_HERE}"
export RC_ANDROID_KEY_DEV="${RC_ANDROID_KEY_DEV:-PASTE_YOUR_ANDROID_API_KEY_HERE}"
export MONTHLY_PRODUCT_ID="${MONTHLY_PRODUCT_ID:-odyseya_monthly_premium}"
export ANNUAL_PRODUCT_ID="${ANNUAL_PRODUCT_ID:-odyseya_annual_premium}"
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