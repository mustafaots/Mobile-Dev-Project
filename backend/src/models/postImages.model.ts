import { z } from 'zod';
import { nonEmptyString, numericIdSchema, timestampSchema } from './shared';

export const postImageSchema = z.object({
  id: numericIdSchema,
  post_id: numericIdSchema,
  public_id: nonEmptyString,
  secure_url: nonEmptyString,
  width: z.number().int().positive().nullable(),
  height: z.number().int().positive().nullable(),
  format: nonEmptyString.nullable(),
  bytes: z.number().int().nonnegative().nullable(),
  sort_order: z.number().int(),
  created_at: timestampSchema,
});

export const postImageCreateSchema = z.object({
  post_id: numericIdSchema,
  public_id: nonEmptyString,
  secure_url: nonEmptyString,
  width: z.number().int().positive().nullable().optional(),
  height: z.number().int().positive().nullable().optional(),
  format: nonEmptyString.nullable().optional(),
  bytes: z.number().int().nonnegative().nullable().optional(),
  sort_order: z.number().int().optional(),
});

export const postImageUpdateSchema = z.object({
  public_id: nonEmptyString.optional(),
  secure_url: nonEmptyString.optional(),
  width: z.number().int().positive().nullable().optional(),
  height: z.number().int().positive().nullable().optional(),
  format: nonEmptyString.nullable().optional(),
  bytes: z.number().int().nonnegative().nullable().optional(),
  sort_order: z.number().int().optional(),
});

export type PostImageModel = z.infer<typeof postImageSchema>;
export type PostImageCreateInput = z.infer<typeof postImageCreateSchema>;
export type PostImageUpdateInput = z.infer<typeof postImageUpdateSchema>;

export const postImageSchemas = {
  create: postImageCreateSchema,
  update: postImageUpdateSchema,
};
