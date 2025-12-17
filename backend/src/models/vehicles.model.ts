import { z } from 'zod';
import {
  booleanSchema,
  jsonValueSchema,
  numericIdSchema,
  vehicleTypeSchema,
  fuelTypeSchema,
} from './shared';

export const vehicleSchema = z.object({
  post_id: numericIdSchema,
  vehicle_type: vehicleTypeSchema,
  model: z.string().nullable(),
  year: z.number().int().nullable(),
  fuel_type: fuelTypeSchema.nullable(),
  transmission: booleanSchema,
  seats: z.number().int().nonnegative().nullable(),
  features: jsonValueSchema,
});

export const vehicleCreateSchema = z.object({
  post_id: numericIdSchema,
  vehicle_type: vehicleTypeSchema,
  model: z.string().nullable().optional(),
  year: z.number().int().min(1900).max(2100).nullable().optional(),
  fuel_type: fuelTypeSchema.nullable().optional(),
  transmission: booleanSchema.optional(),
  seats: z.number().int().nonnegative().nullable().optional(),
  features: jsonValueSchema.optional(),
});

export const vehicleUpdateSchema = z.object({
  vehicle_type: vehicleTypeSchema.optional(),
  model: z.string().nullable().optional(),
  year: z.number().int().min(1900).max(2100).nullable().optional(),
  fuel_type: fuelTypeSchema.nullable().optional(),
  transmission: booleanSchema.optional(),
  seats: z.number().int().nonnegative().nullable().optional(),
  features: jsonValueSchema.optional(),
});

export type VehicleModel = z.infer<typeof vehicleSchema>;
export type VehicleCreateInput = z.infer<typeof vehicleCreateSchema>;
export type VehicleUpdateInput = z.infer<typeof vehicleUpdateSchema>;

export const vehicleSchemas = {
  create: vehicleCreateSchema,
  update: vehicleUpdateSchema,
};
