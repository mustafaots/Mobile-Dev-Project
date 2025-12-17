import { z } from 'zod';
import {
  nonEmptyString,
  numericIdSchema,
  positiveMoneySchema,
  timestampSchema,
  uuidSchema,
  booleanSchema,
} from './shared';

export const postSchema = z.object({
  id: numericIdSchema,
  owner_id: uuidSchema,
  category: nonEmptyString,
  title: nonEmptyString,
  description: z.string().nullable(),
  price: positiveMoneySchema,
  location_id: numericIdSchema,
  is_paid: booleanSchema,
  created_at: timestampSchema,
  updated_at: timestampSchema,
  status: nonEmptyString,
  availability: z.string(),
});

export const postCreateSchema = z.object({
  owner_id: uuidSchema,
  category: nonEmptyString,
  title: nonEmptyString,
  description: z.string().nullable().optional(),
  price: positiveMoneySchema,
  location_id: numericIdSchema,
  is_paid: booleanSchema.optional(),
  status: nonEmptyString.optional(),
  availability: z.string().optional(),
});

export const postUpdateSchema = z.object({
  owner_id: uuidSchema.optional(),
  category: nonEmptyString.optional(),
  title: nonEmptyString.optional(),
  description: z.string().nullable().optional(),
  price: positiveMoneySchema.optional(),
  location_id: numericIdSchema.optional(),
  is_paid: booleanSchema.optional(),
  status: nonEmptyString.optional(),
  availability: z.string().optional(),
});

export type PostModel = z.infer<typeof postSchema>;
export type PostCreateInput = z.infer<typeof postCreateSchema>;
export type PostUpdateInput = z.infer<typeof postUpdateSchema>;

export const postSchemas = {
  create: postCreateSchema,
  update: postUpdateSchema,
};
