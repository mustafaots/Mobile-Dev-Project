import { Request, Response } from 'express';
import { bookingManagementService, CreateBookingInput } from '../services/booking.service';
import { asyncHandler } from '../middleware/asyncHandler';
import { z } from 'zod';
import { ApiError } from '../utils/apiError';

// Validation schemas - using ISO datetime strings for start_time/end_time
const createBookingSchema = z.object({
  post_id: z.number().int().positive(),
  start_time: z.string().datetime({ message: 'Start time must be a valid ISO datetime' }),
  end_time: z.string().datetime({ message: 'End time must be a valid ISO datetime' }),
}).refine((data) => new Date(data.end_time) > new Date(data.start_time), {
  message: 'End time must be after start time',
});

const checkAvailabilitySchema = z.object({
  start_time: z.string().datetime({ message: 'Start time must be a valid ISO datetime' }),
  end_time: z.string().datetime({ message: 'End time must be a valid ISO datetime' }),
});

class BookingController {
  /**
   * Create a new booking
   * POST /api/bookings
   */
  create = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const validated = createBookingSchema.parse(req.body);
    
    const input: CreateBookingInput = {
      post_id: validated.post_id,
      start_time: validated.start_time,
      end_time: validated.end_time,
      client_id: user.id,
    };

    const booking = await bookingManagementService.createBooking(input);

    res.status(201).json({
      success: true,
      data: booking,
    });
  });

  /**
   * Get booking by ID
   * GET /api/bookings/:id
   */
  getById = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const id = parseInt(req.params.id, 10);
    const booking = await bookingManagementService.getBookingById(id);

    // Check if user is client or owner
    if (booking.client.user_id !== user.id && booking.owner.user_id !== user.id) {
      throw new ApiError(403, 'You are not authorized to view this booking.');
    }

    res.json({
      success: true,
      data: booking,
    });
  });

  /**
   * Get my bookings (as client)
   * GET /api/bookings/my
   */
  getMyBookings = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const bookings = await bookingManagementService.getClientBookings(user.id);

    res.json({
      success: true,
      data: bookings,
    });
  });

  /**
   * Get bookings for my listings (as owner)
   * GET /api/bookings/received
   */
  getReceivedBookings = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const bookings = await bookingManagementService.getOwnerBookings(user.id);

    res.json({
      success: true,
      data: bookings,
    });
  });

  /**
   * Cancel a booking
   * POST /api/bookings/:id/cancel
   */
  cancel = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const id = parseInt(req.params.id, 10);
    const booking = await bookingManagementService.cancelBooking(id, user.id);

    res.json({
      success: true,
      data: booking,
    });
  });

  /**
   * Confirm a booking (owner only)
   * POST /api/bookings/:id/confirm
   */
  confirm = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const id = parseInt(req.params.id, 10);
    const booking = await bookingManagementService.confirmBooking(id, user.id);

    res.json({
      success: true,
      data: booking,
    });
  });

  /**
   * Complete a booking (owner only)
   * POST /api/bookings/:id/complete
   */
  complete = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const id = parseInt(req.params.id, 10);
    const booking = await bookingManagementService.completeBooking(id, user.id);

    res.json({
      success: true,
      data: booking,
    });
  });

  /**
   * Check availability for a listing
   * GET /api/listings/:id/availability
   */
  checkAvailability = asyncHandler(async (req: Request, res: Response) => {
    const postId = parseInt(req.params.id, 10);
    const { start_time, end_time } = checkAvailabilitySchema.parse(req.query);

    const available = await bookingManagementService.checkAvailability(
      postId,
      start_time,
      end_time
    );

    res.json({
      success: true,
      data: { available },
    });
  });

  /**
   * Get unavailable dates for a listing
   * GET /api/listings/:id/unavailable-dates
   */
  getUnavailableDates = asyncHandler(async (req: Request, res: Response) => {
    const postId = parseInt(req.params.id, 10);
    const dates = await bookingManagementService.getUnavailableDates(postId);

    res.json({
      success: true,
      data: dates,
    });
  });
}

export const bookingController = new BookingController();
export default bookingController;
