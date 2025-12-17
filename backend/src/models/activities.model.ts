import { z } from 'zod';
import { jsonValueSchema, numericIdSchema, nonEmptyString } from './shared';

export const activitySchema = z.object({
  post_id: numericIdSchema,
  activity_type: nonEmptyString,
  requirements: jsonValueSchema.optional(),
});

export const activityCreateSchema = activitySchema;
export const activityUpdateSchema = z.object({
  activity_type: nonEmptyString.optional(),
  requirements: jsonValueSchema.optional(),
});

export type ActivityModel = z.infer<typeof activitySchema>;
export type ActivityCreateInput = z.infer<typeof activityCreateSchema>;
export type ActivityUpdateInput = z.infer<typeof activityUpdateSchema>;

export const activitySchemas = {
  create: activityCreateSchema,
  update: activityUpdateSchema,
};
