# Firebase Setup Guide

This guide explains how to set up Firebase Cloud Messaging (FCM) for push notifications in the Easy Vacation app.

## Prerequisites

1. Firebase project created at https://console.firebase.google.com/
2. Android app configured in Firebase
3. Service account key generated

## Environment Variables Required

Add these environment variables to your `.env` file:

```env
# Firebase Configuration
FIREBASE_PROJECT_ID=your_firebase_project_id
FIREBASE_PRIVATE_KEY_ID=your_private_key_id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYOUR_PRIVATE_KEY_HERE\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@your-project.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=your_client_id
FIREBASE_CLIENT_X509_CERT_URL=https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-xxxxx%40your-project.iam.gserviceaccount.com
```

## Firebase Console Setup

### 1. Create Service Account Key

1. Go to Firebase Console → Project Settings → Service Accounts
2. Click "Generate new private key"
3. Download the JSON file
4. Extract the values for the environment variables above

### 2. Enable Cloud Messaging API

1. Go to Google Cloud Console → APIs & Services → Library
2. Search for "Firebase Cloud Messaging API"
3. Enable it for your project

### 3. Configure Android App

Make sure your Android app is properly configured in Firebase:
- Package name matches your app's package name
- SHA-1 certificate fingerprint is added (for release builds)

## Database Tables

The following tables need to be created in your Supabase database:

### fcm_tokens
```sql
CREATE TABLE public.fcm_tokens (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  user_id uuid NOT NULL,
  fcm_token text NOT NULL,
  platform character varying DEFAULT 'mobile' CHECK (platform::text = ANY (ARRAY['mobile'::character varying, 'web'::character varying])),
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT fcm_tokens_pkey PRIMARY KEY (id),
  CONSTRAINT fcm_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE,
  CONSTRAINT fcm_tokens_user_token_unique UNIQUE (user_id, fcm_token)
);

CREATE INDEX idx_fcm_tokens_user_id ON public.fcm_tokens(user_id);
CREATE INDEX idx_fcm_tokens_token ON public.fcm_tokens(fcm_token);
```

### notifications
```sql
CREATE TABLE public.notifications (
  id uuid DEFAULT gen_random_uuid() NOT NULL,
  user_id uuid NOT NULL,
  title character varying NOT NULL,
  body text NOT NULL,
  data jsonb DEFAULT '{}'::jsonb,
  type character varying DEFAULT 'general',
  is_read boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT notifications_pkey PRIMARY KEY (id),
  CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX idx_notifications_is_read ON public.notifications(is_read);
CREATE INDEX idx_notifications_created_at ON public.notifications(created_at DESC);
```

## Testing Notifications

### 1. Install Dependencies

```bash
npm install
```

### 2. Start the Server

```bash
npm run dev
```

### 3. Test FCM Token Registration

```bash
curl -X POST http://localhost:5000/notifications/register-token \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "your-user-id",
    "fcmToken": "your-fcm-token",
    "platform": "mobile"
  }'
```

### 4. Test Sending Notification

```bash
curl -X POST http://localhost:5000/notifications/send \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "your-user-id",
    "title": "Test Notification",
    "body": "This is a test notification",
    "data": {
      "type": "general"
    }
  }'
```

## Flutter App Setup

The Flutter app is already configured with:
- `firebase_messaging` and `flutter_local_notifications` dependencies
- Firebase initialization in `main.dart`
- Notification service handling foreground/background messages
- FCM token registration with the backend

## Notification Types

The app supports different notification types:
- `booking_confirmed`: When a booking is confirmed
- `booking_reminder`: Reminder for upcoming bookings
- `review_request`: Request to leave a review
- `promotional`: Marketing/promotional notifications
- `general`: Default notification type

## Troubleshooting

### Common Issues

1. **FCM token not registering**: Check Firebase configuration and environment variables
2. **Notifications not received**: Verify FCM token is valid and app has notification permissions
3. **Background notifications not working**: Ensure proper Firebase initialization in main.dart

### Debug Tips

1. Check server logs for Firebase errors
2. Use Firebase Console to send test notifications
3. Verify FCM tokens are being stored correctly in the database
4. Test with both foreground and background app states