import { z } from 'zod';
import {
  nonEmptyString,
  uuidSchema,
  timestampSchema,
  jsonbSchema,
  booleanSchema
} from './shared';

// FCM Token Model
export const fcmTokenSchema = z.object({
  id: uuidSchema,
  user_id: uuidSchema,
  fcm_token: nonEmptyString,
  platform: nonEmptyString.default('mobile'),
  created_at: timestampSchema,
  updated_at: timestampSchema,
});

export const fcmTokenCreateSchema = z.object({
  user_id: uuidSchema,
  fcm_token: nonEmptyString,
  platform: nonEmptyString.optional().default('mobile'),
});

export const fcmTokenUpdateSchema = z.object({
  fcm_token: nonEmptyString.optional(),
  platform: nonEmptyString.optional(),
});

export type FCMTokenModel = z.infer<typeof fcmTokenSchema>;
export type FCMTokenCreateInput = z.infer<typeof fcmTokenCreateSchema>;
export type FCMTokenUpdateInput = z.infer<typeof fcmTokenUpdateSchema>;

// Notification Model
export const notificationSchema = z.object({
  id: uuidSchema,
  user_id: uuidSchema,
  title: nonEmptyString,
  body: nonEmptyString,
  data: jsonbSchema.optional().default({}),
  type: nonEmptyString.default('general'),
  is_read: booleanSchema.default(false),
  created_at: timestampSchema,
  updated_at: timestampSchema,
});

export const notificationCreateSchema = z.object({
  user_id: uuidSchema,
  title: nonEmptyString,
  body: nonEmptyString,
  data: jsonbSchema.optional().default({}),
  type: nonEmptyString.optional().default('general'),
  is_read: booleanSchema.optional().default(false),
});

export const notificationUpdateSchema = z.object({
  title: nonEmptyString.optional(),
  body: nonEmptyString.optional(),
  data: jsonbSchema.optional(),
  type: nonEmptyString.optional(),
  is_read: booleanSchema.optional(),
});

export type NotificationModel = z.infer<typeof notificationSchema>;
export type NotificationCreateInput = z.infer<typeof notificationCreateSchema>;
export type NotificationUpdateInput = z.infer<typeof notificationUpdateSchema>;

// Notification types enum
export const notificationTypes = [
  'general',
  'booking_request',
  'booking_confirmed',
  'booking_rejected',
  'booking_reminder',
  'review_request',
  'promotional',
] as const;

export type NotificationType = typeof notificationTypes[number];

// Notification data schemas for different types
export const bookingRequestDataSchema = z.object({
  type: z.literal('booking_request'),
  booking_id: nonEmptyString,
  post_id: nonEmptyString,
  client_id: nonEmptyString,
  start_date: nonEmptyString,
  end_date: nonEmptyString,
});

export const bookingConfirmedDataSchema = z.object({
  type: z.literal('booking_confirmed'),
  booking_id: nonEmptyString,
  post_id: nonEmptyString,
});

export const bookingRejectedDataSchema = z.object({
  type: z.literal('booking_rejected'),
  booking_id: nonEmptyString,
  post_id: nonEmptyString,
});

export const reviewRequestDataSchema = z.object({
  type: z.literal('review_request'),
  post_id: nonEmptyString,
  reviewer_id: nonEmptyString.optional(),
});

export const bookingReminderDataSchema = z.object({
  type: z.literal('booking_reminder'),
  booking_id: nonEmptyString,
  post_id: nonEmptyString,
  start_date: nonEmptyString,
  end_date: nonEmptyString,
});

export const promotionalDataSchema = z.object({
  type: z.literal('promotional'),
  campaign_id: nonEmptyString.optional(),
  image_url: nonEmptyString.optional(),
});

export const generalDataSchema = z.object({
  type: z.literal('general'),
});

// Union type for all notification data
export const notificationDataSchema = z.union([
  bookingRequestDataSchema,
  bookingConfirmedDataSchema,
  bookingRejectedDataSchema,
  reviewRequestDataSchema,
  bookingReminderDataSchema,
  promotionalDataSchema,
  generalDataSchema,
]);

export type NotificationData = z.infer<typeof notificationDataSchema>;

// Export all schemas
export const notificationSchemas = {
  fcmToken: {
    create: fcmTokenCreateSchema,
    update: fcmTokenUpdateSchema,
  },
  notification: {
    create: notificationCreateSchema,
    update: notificationUpdateSchema,
  },
  data: {
    bookingRequest: bookingRequestDataSchema,
    bookingConfirmed: bookingConfirmedDataSchema,
    bookingRejected: bookingRejectedDataSchema,
    reviewRequest: reviewRequestDataSchema,
    bookingReminder: bookingReminderDataSchema,
    promotional: promotionalDataSchema,
    general: generalDataSchema,
    any: notificationDataSchema,
  },
};