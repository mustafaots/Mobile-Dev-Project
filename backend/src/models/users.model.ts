import { z } from 'zod';
import { booleanSchema, nonEmptyString, uuidSchema } from './shared';

export const userProfileSchema = z.object({
  user_id: uuidSchema,
  first_name: nonEmptyString.nullable(),
  last_name: nonEmptyString.nullable(),
  is_verified: booleanSchema,
  is_suspended: booleanSchema,
});

export const userProfileCreateSchema = z.object({
  user_id: uuidSchema,
  first_name: nonEmptyString.nullable().optional(),
  last_name: nonEmptyString.nullable().optional(),
  is_verified: booleanSchema.optional(),
  is_suspended: booleanSchema.optional(),
});

export const userProfileUpdateSchema = z.object({
  first_name: nonEmptyString.nullable().optional(),
  last_name: nonEmptyString.nullable().optional(),
  is_verified: booleanSchema.optional(),
  is_suspended: booleanSchema.optional(),
});

export type UserProfileModel = z.infer<typeof userProfileSchema>;
export type UserProfileCreateInput = z.infer<typeof userProfileCreateSchema>;
export type UserProfileUpdateInput = z.infer<typeof userProfileUpdateSchema>;

export const userProfileSchemas = {
  create: userProfileCreateSchema,
  update: userProfileUpdateSchema,
};
