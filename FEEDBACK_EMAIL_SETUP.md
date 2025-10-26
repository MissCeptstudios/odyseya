# Feedback Email Setup Guide

This guide explains how to configure email notifications for user feedback in the Odyseya app.

## Overview

When users submit feedback through the app settings, the feedback is:
1. ✅ Saved to Firestore `/feedback` collection
2. ✅ Automatically triggers a Cloud Function
3. ✉️ Sends email notification to `odyseya.journal@gmail.com`

## Current Status

- **Feedback Collection**: ✅ Working (saves to Firestore)
- **Cloud Function**: ✅ Deployed (`sendFeedbackEmail`)
- **Email Sending**: ⚠️ Requires Gmail App Password Configuration

## Email Configuration Steps

### 1. Generate Gmail App Password

To send emails from Firebase Cloud Functions, you need a Gmail App Password (not your regular password):

1. Go to your Google Account: https://myaccount.google.com/
2. Navigate to **Security** → **2-Step Verification** (enable if not already)
3. Scroll down to **App passwords**
4. Click **Generate app password**
5. Name it: "Odyseya Firebase Functions"
6. **Copy the 16-character password** (it looks like: `abcd efgh ijkl mnop`)

### 2. Configure Firebase Functions

Run this command to store your Gmail credentials securely in Firebase:

```bash
cd /Users/joannacholas/CursorProjects/MissceptStudios/odyseya

# Set Gmail email
firebase functions:config:set gmail.email="odyseya.journal@gmail.com"

# Set Gmail app password (replace with your 16-character password)
firebase functions:config:set gmail.password="abcd efgh ijkl mnop"
```

### 3. Redeploy the Function

After setting the configuration, redeploy:

```bash
firebase deploy --only functions:sendFeedbackEmail
```

## Testing

To test the email functionality:

1. Open the Odyseya app
2. Go to **Settings** → **Feedback** → **Write to Us**
3. Fill in the feedback form and submit
4. Check the Firebase Functions logs:
   ```bash
   firebase functions:log --only sendFeedbackEmail
   ```
5. Check your email inbox: `odyseya.journal@gmail.com`

## Email Format

When feedback is submitted, you'll receive an email with:

```
Subject: New Feedback from Odyseya - [User Name]

Hello!

You have received new feedback from your Odyseya app:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FEEDBACK DETAILS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

From: [User Name]
User ID: [Firebase UID]
Email: [User Email or "Not provided"]
Platform: [iOS/Android]
Status: new
Submitted: [Date and Time]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FEEDBACK MESSAGE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[User's feedback message]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

View in Firebase Console:
[Direct link to feedback in Firestore]

Best regards,
Odyseya Feedback System
```

## Firestore Structure

Each feedback submission creates a document in `/feedback` collection:

```json
{
  "userId": "dev_607408728",
  "userName": "Demo User",
  "userEmail": "user@example.com",
  "feedback": "The app is great! I love the...",
  "createdAt": "2025-01-26T10:30:00Z",
  "status": "new",
  "platform": "iOS",
  "emailSent": true,
  "emailSentAt": "2025-01-26T10:30:05Z"
}
```

## Monitoring

### View Feedback in Firebase Console

https://console.firebase.google.com/project/odyseya-voice-journal/firestore/data/feedback

### View Cloud Function Logs

```bash
# View recent logs
firebase functions:log --only sendFeedbackEmail

# Follow logs in real-time
firebase functions:log --only sendFeedbackEmail --tail
```

### Check Function Status

```bash
firebase functions:list
```

## Troubleshooting

### "Gmail credentials not configured" Error

**Solution**: Run the configuration commands from Step 2 above.

### "Invalid credentials" or "Authentication failed"

**Possible causes**:
1. Using regular Gmail password instead of App Password
2. 2-Step Verification not enabled on Gmail account
3. Incorrect App Password

**Solution**:
1. Verify 2-Step Verification is enabled
2. Generate a new App Password
3. Update configuration with correct password
4. Redeploy function

### Email not received

**Check**:
1. Firebase Functions logs for errors: `firebase functions:log --only sendFeedbackEmail`
2. Gmail spam/junk folder
3. Gmail inbox quotas (rarely an issue)
4. Check Firestore `/feedback` document has `emailSent: true`

### Cost Monitoring

- **Firestore**: Free tier covers 50,000 reads + 20,000 writes per day
- **Cloud Functions**: Free tier covers 2M invocations per month
- **Email Sending**: Nodemailer with Gmail is free

Expected cost for typical usage: **$0/month** (within free tier)

## Alternative: Using SendGrid

If you prefer SendGrid over Gmail:

1. Sign up at https://sendgrid.com/ (free tier: 100 emails/day)
2. Get API key
3. Update Cloud Function to use SendGrid API
4. Configure: `firebase functions:config:set sendgrid.key="YOUR_API_KEY"`

## Security Notes

✅ App Passwords are stored securely in Firebase Functions environment
✅ Users never see your Gmail credentials
✅ Emails are sent server-side only
✅ Function requires authentication to trigger

## Support

For issues or questions:
- Check Firebase Console: https://console.firebase.google.com/project/odyseya-voice-journal
- Review logs: `firebase functions:log`
- Contact: odyseya.journal@gmail.com
