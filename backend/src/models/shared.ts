import { z } from 'zod';
import { Json } from '../types';

export const uuidSchema = z.string().uuid();
export const numericIdSchema = z.number().int().nonnegative();
export const bigintSchema = z.number().int().nonnegative();
export const timestampSchema = z.string().datetime({ offset: true });
export const nonEmptyString = z.string().min(1);
export const booleanSchema = z.boolean();

export const jsonValueSchema: z.ZodType<Json> = z.lazy(() =>
  z.union([
    z.string(),
    z.number(),
    z.boolean(),
    z.null(),
    z.array(jsonValueSchema),
    z.record(jsonValueSchema),
  ])
);

export const jsonbSchema = jsonValueSchema;

export const stayTypes = [
  'apartment',
  'villa',
  'room',
  'house',
  'chalet',
  'other',
] as const;

export const vehicleTypes = ['car', 'bicycle', 'motorcycle', 'boat', 'scooter', 'other'] as const;
export const fuelTypes = ['gasoline', 'diesel', 'electric', 'hybrid'] as const;

export const stayTypeSchema = z.enum(stayTypes);
export const vehicleTypeSchema = z.enum(vehicleTypes);
export const fuelTypeSchema = z.enum(fuelTypes);

export const latitudeSchema = z.number().min(-90).max(90);
export const longitudeSchema = z.number().min(-180).max(180);
export const positiveMoneySchema = z.number().nonnegative();
