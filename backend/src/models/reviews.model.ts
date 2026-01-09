import { z } from 'zod';
import { nonEmptyString, numericIdSchema, timestampSchema, uuidSchema } from './shared';

export const reviewSchema = z.object({
  id: numericIdSchema,
  post_id: numericIdSchema,
  reviewer_id: uuidSchema,
  rating: z.number().int().min(1).max(5),
  comment: z.string().nullable(),
  created_at: timestampSchema,
});

export const reviewCreateSchema = z.object({
  post_id: numericIdSchema,
  reviewer_id: uuidSchema,
  rating: z.number().int().min(1).max(5),
  comment: z.string().optional(),
});

export const reviewUpdateSchema = z.object({
  rating: z.number().int().min(1).max(5).optional(),
  comment: z.string().optional(),
});

export type ReviewModel = z.infer<typeof reviewSchema>;
export type ReviewCreateInput = z.infer<typeof reviewCreateSchema>;
export type ReviewUpdateInput = z.infer<typeof reviewUpdateSchema>;

export const reviewSchemas = {
  create: reviewCreateSchema,
  update: reviewUpdateSchema,
};
