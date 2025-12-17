import { z } from 'zod';
import {
  latitudeSchema,
  longitudeSchema,
  nonEmptyString,
  numericIdSchema,
  timestampSchema,
} from './shared';

export const locationSchema = z.object({
  id: numericIdSchema,
  wilaya: nonEmptyString,
  city: nonEmptyString,
  address: nonEmptyString,
  latitude: latitudeSchema,
  longitude: longitudeSchema,
  created_at: timestampSchema,
  updated_at: timestampSchema,
});

export const locationCreateSchema = z.object({
  wilaya: nonEmptyString,
  city: nonEmptyString,
  address: nonEmptyString,
  latitude: latitudeSchema,
  longitude: longitudeSchema,
});

export const locationUpdateSchema = z.object({
  wilaya: nonEmptyString.optional(),
  city: nonEmptyString.optional(),
  address: nonEmptyString.optional(),
  latitude: latitudeSchema.optional(),
  longitude: longitudeSchema.optional(),
});

export type LocationModel = z.infer<typeof locationSchema>;
export type LocationCreateInput = z.infer<typeof locationCreateSchema>;
export type LocationUpdateInput = z.infer<typeof locationUpdateSchema>;

export const locationSchemas = {
  create: locationCreateSchema,
  update: locationUpdateSchema,
};
