import { z } from 'zod';
import { numericIdSchema, stayTypeSchema } from './shared';

export const staySchema = z.object({
  post_id: numericIdSchema,
  stay_type: stayTypeSchema,
  area: z.number().positive().nullable(),
  bedrooms: z.number().int().nonnegative().nullable(),
});

export const stayCreateSchema = z.object({
  post_id: numericIdSchema,
  stay_type: stayTypeSchema,
  area: z.number().positive().nullable().optional(),
  bedrooms: z.number().int().nonnegative().nullable().optional(),
});

export const stayUpdateSchema = z.object({
  stay_type: stayTypeSchema.optional(),
  area: z.number().positive().nullable().optional(),
  bedrooms: z.number().int().nonnegative().nullable().optional(),
});

export type StayModel = z.infer<typeof staySchema>;
export type StayCreateInput = z.infer<typeof stayCreateSchema>;
export type StayUpdateInput = z.infer<typeof stayUpdateSchema>;

export const staySchemas = {
  create: stayCreateSchema,
  update: stayUpdateSchema,
};
