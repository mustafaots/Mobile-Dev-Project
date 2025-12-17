import { z } from 'zod';
import { nonEmptyString, numericIdSchema, timestampSchema, uuidSchema } from './shared';

export const reportSchema = z.object({
  id: numericIdSchema,
  reporter_id: uuidSchema,
  reported_post_id: numericIdSchema.nullable(),
  reported_user_id: uuidSchema.nullable(),
  reason: nonEmptyString,
  description: z.string().nullable(),
  created_at: timestampSchema,
});

export const reportCreateSchema = z.object({
  reporter_id: uuidSchema,
  reported_post_id: numericIdSchema.optional(),
  reported_user_id: uuidSchema.optional(),
  reason: nonEmptyString,
  description: z.string().optional(),
});

export const reportUpdateSchema = z.object({
  reported_post_id: numericIdSchema.optional(),
  reported_user_id: uuidSchema.optional(),
  reason: nonEmptyString.optional(),
  description: z.string().optional(),
});

export type ReportModel = z.infer<typeof reportSchema>;
export type ReportCreateInput = z.infer<typeof reportCreateSchema>;
export type ReportUpdateInput = z.infer<typeof reportUpdateSchema>;

export const reportSchemas = {
  create: reportCreateSchema,
  update: reportUpdateSchema,
};
