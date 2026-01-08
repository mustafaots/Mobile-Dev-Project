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
  reservation: nonEmptyString, // JSON string like availability
});

export const bookingCreateSchema = z.object({
  post_id: numericIdSchema,
  client_id: uuidSchema,
  reservation: nonEmptyString, // JSON string: [{"startDate": "...", "endDate": "..."}]
  status: nonEmptyString.optional(),
});

export const bookingUpdateSchema = z.object({
  status: nonEmptyString.optional(),
  reservation: nonEmptyString.optional(),
});

export type BookingModel = z.infer<typeof bookingSchema>;
export type BookingCreateInput = z.infer<typeof bookingCreateSchema>;
export type BookingUpdateInput = z.infer<typeof bookingUpdateSchema>;

export const bookingSchemas = {
  create: bookingCreateSchema,
  update: bookingUpdateSchema,
};
