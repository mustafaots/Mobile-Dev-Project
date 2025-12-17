import { z } from 'zod';
import {
  nonEmptyString,
  numericIdSchema,
  timestampSchema,
  uuidSchema,
} from './shared';

export const bookingSchema = z.object({
  id: numericIdSchema,
  post_id: numericIdSchema,
  client_id: uuidSchema,
  status: nonEmptyString,
  booked_at: timestampSchema,
  start_time: timestampSchema,
  end_time: timestampSchema,
});

export const bookingCreateSchema = z.object({
  post_id: numericIdSchema,
  client_id: uuidSchema,
  start_time: timestampSchema,
  end_time: timestampSchema,
  status: nonEmptyString.optional(),
});

export const bookingUpdateSchema = z.object({
  status: nonEmptyString.optional(),
  start_time: timestampSchema.optional(),
  end_time: timestampSchema.optional(),
});

export type BookingModel = z.infer<typeof bookingSchema>;
export type BookingCreateInput = z.infer<typeof bookingCreateSchema>;
export type BookingUpdateInput = z.infer<typeof bookingUpdateSchema>;

export const bookingSchemas = {
  create: bookingCreateSchema,
  update: bookingUpdateSchema,
};
