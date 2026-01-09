import { z } from 'zod';
import { nonEmptyString, numericIdSchema, timestampSchema, uuidSchema } from './shared';

export const subscriptionSchema = z.object({
  id: numericIdSchema,
  subscriber_id: uuidSchema,
  plan: nonEmptyString,
  created_at: timestampSchema,
  updated_at: timestampSchema,
});

export const subscriptionCreateSchema = z.object({
  subscriber_id: uuidSchema,
  plan: nonEmptyString.optional(),
});

export const subscriptionUpdateSchema = z.object({
  plan: nonEmptyString.optional(),
});

export type SubscriptionModel = z.infer<typeof subscriptionSchema>;
export type SubscriptionCreateInput = z.infer<typeof subscriptionCreateSchema>;
export type SubscriptionUpdateInput = z.infer<typeof subscriptionUpdateSchema>;

export const subscriptionSchemas = {
  create: subscriptionCreateSchema,
  update: subscriptionUpdateSchema,
};
