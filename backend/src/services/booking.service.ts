import supabase from '../config/supabase';
import { ApiError } from '../utils/apiError';
import { Post } from '../types';
import { NotificationService } from './notification.service';

export type BookingStatus = 'pending' | 'confirmed' | 'cancelled' | 'completed';

export interface CreateBookingInput {
  post_id: number;
  client_id: string;
  start_time: string;  // ISO datetime
  end_time: string;    // ISO datetime
}

export interface BookingRecord {
  id: number;
  post_id: number;
  client_id: string;
  status: string;
  booked_at: string;
  start_time: string;
  end_time: string;
  reservation?: string;  // JSON string from Supabase
}

export interface BookingWithDetails extends BookingRecord {
  post: Post;
  client: {
    user_id: string;
    first_name: string | null;
    last_name: string | null;
  };
  owner: {
    user_id: string;
    first_name: string | null;
    last_name: string | null;
  };
}

class BookingManagementService {
  /**
   * Create a new booking
   */
  async createBooking(input: CreateBookingInput): Promise<BookingWithDetails> {
    // Get post
    const { data: post, error: postError } = await supabase
      .from('posts')
      .select('*')
      .eq('id', input.post_id)
      .single();

    if (postError || !post) {
      throw new ApiError(404, 'Post not found.');
    }

    // Check if post is available
    if (post.status !== 'published') {
      throw new ApiError(400, 'This listing is not available for booking.');
    }

    // Check if user is not booking their own post
    if (post.owner_id === input.client_id) {
      throw new ApiError(400, 'You cannot book your own listing.');
    }

    // Check for date conflicts using start_time/end_time
    const { data: conflictingBookings } = await supabase
      .from('bookings')
      .select('*')
      .eq('post_id', input.post_id)
      .in('status', ['pending', 'confirmed'])
      .or(
        `and(start_time.lte.${input.end_time},end_time.gte.${input.start_time})`
      );

    if (conflictingBookings && conflictingBookings.length > 0) {
      throw new ApiError(409, 'The selected dates are not available.');
    }

    // Create booking
    const { data: booking, error: createError } = await supabase
      .from('bookings')
      .insert({
        post_id: input.post_id,
        client_id: input.client_id,
        start_time: input.start_time,
        end_time: input.end_time,
        status: 'pending',
      })
      .select()
      .single();

    if (createError || !booking) {
      throw new ApiError(500, 'Failed to create booking.', createError?.message);
    }

    // Send notification to post owner
    try {
      const bookingDetails = await this.getBookingById(booking.id);

      // Format dates for display
      const startDate = new Date(bookingDetails.start_time).toLocaleDateString();
      const endDate = new Date(bookingDetails.end_time).toLocaleDateString();

      await NotificationService.sendToUser(post.owner_id, {
        title: 'New Booking Request',
        body: `${bookingDetails.client.first_name || 'A user'} wants to book your "${post.title}" from ${startDate} to ${endDate}`,
        data: {
          type: 'booking_request',
          booking_id: booking.id.toString(),
          post_id: post.id.toString(),
          client_id: bookingDetails.client.user_id,
          start_date: startDate,
          end_date: endDate,
        },
      });
    } catch (notificationError) {
      // Log notification error but don't fail the booking
      console.error('Failed to send booking notification:', notificationError);
    }

    return this.getBookingById(booking.id);
  }

  /**
   * Get booking by ID with details
   */
  async getBookingById(bookingId: number): Promise<BookingWithDetails> {
    const { data: booking, error } = await supabase
      .from('bookings')
      .select('*')
      .eq('id', bookingId)
      .single();

    if (error || !booking) {
      throw new ApiError(404, 'Booking not found.');
    }

    // Parse reservation JSON to get start_time and end_time
    let startTime = '';
    let endTime = '';
    if (booking.reservation) {
      try {
        const reservation = typeof booking.reservation === 'string' 
          ? JSON.parse(booking.reservation) 
          : booking.reservation;
        if (Array.isArray(reservation) && reservation.length > 0) {
          startTime = reservation[0].startDate || reservation[0].start_date || '';
          endTime = reservation[0].endDate || reservation[0].end_date || '';
        }
      } catch (e) {
        console.error('Error parsing reservation JSON:', e);
      }
    }

    // Get post
    const { data: post } = await supabase
      .from('posts')
      .select('*')
      .eq('id', booking.post_id)
      .single();

    if (!post) {
      throw new ApiError(404, 'Post not found.');
    }

    // Get client
    const { data: client } = await supabase
      .from('users')
      .select('user_id, first_name, last_name')
      .eq('user_id', booking.client_id)
      .single();

    // Get owner
    const { data: owner } = await supabase
      .from('users')
      .select('user_id, first_name, last_name')
      .eq('user_id', post.owner_id)
      .single();

    return {
      id: booking.id,
      post_id: booking.post_id,
      client_id: booking.client_id,
      status: booking.status,
      booked_at: booking.booked_at,
      start_time: startTime,
      end_time: endTime,
      reservation: booking.reservation,
      post,
      client: client ?? { user_id: booking.client_id, first_name: null, last_name: null },
      owner: owner ?? { user_id: post.owner_id, first_name: null, last_name: null },
    };
  }

  /**
   * Get bookings for a client
   */
  async getClientBookings(clientId: string): Promise<BookingWithDetails[]> {
    const { data, error } = await supabase
      .from('bookings')
      .select('*')
      .eq('client_id', clientId)
      .order('booked_at', { ascending: false });

    if (error) {
      throw new ApiError(500, 'Failed to fetch bookings.', error.message);
    }

    const bookings = await Promise.all(
      (data ?? []).map((b) => this.getBookingById(b.id))
    );

    return bookings;
  }

  /**
   * Get bookings for an owner (all bookings for their posts)
   */
  async getOwnerBookings(ownerId: string): Promise<BookingWithDetails[]> {
    // Get all posts by owner
    const { data: posts } = await supabase
      .from('posts')
      .select('id')
      .eq('owner_id', ownerId);

    if (!posts || posts.length === 0) {
      return [];
    }

    const postIds = posts.map((p) => p.id);

    // Get all bookings for these posts
    const { data, error } = await supabase
      .from('bookings')
      .select('*')
      .in('post_id', postIds)
      .order('booked_at', { ascending: false });

    if (error) {
      throw new ApiError(500, 'Failed to fetch bookings.', error.message);
    }

    const bookings = await Promise.all(
      (data ?? []).map((b) => this.getBookingById(b.id))
    );

    return bookings;
  }

  /**
   * Update booking status
   */
  async updateBookingStatus(
    bookingId: number,
    status: BookingStatus,
    userId: string
  ): Promise<BookingWithDetails> {
    const booking = await this.getBookingById(bookingId);

    // Verify authorization
    const isOwner = booking.owner.user_id === userId;
    const isClient = booking.client.user_id === userId;

    if (!isOwner && !isClient) {
      throw new ApiError(403, 'You are not authorized to update this booking.');
    }

    // Validate status transitions
    const validTransitions: Record<string, BookingStatus[]> = {
      pending: ['confirmed', 'cancelled'],
      confirmed: ['cancelled', 'completed'],
      cancelled: [],
      completed: [],
    };

    if (!validTransitions[booking.status]?.includes(status)) {
      throw new ApiError(
        400,
        `Cannot change status from ${booking.status} to ${status}.`
      );
    }

    // Only owner can confirm
    if (status === 'confirmed' && !isOwner) {
      throw new ApiError(403, 'Only the owner can confirm bookings.');
    }

    // Only owner can mark as completed
    if (status === 'completed' && !isOwner) {
      throw new ApiError(403, 'Only the owner can mark bookings as completed.');
    }

    const { error } = await supabase
      .from('bookings')
      .update({ status })
      .eq('id', bookingId);

    if (error) {
      throw new ApiError(500, 'Failed to update booking.', error.message);
    }

    return this.getBookingById(bookingId);
  }

  /**
   * Cancel a booking
   */
  async cancelBooking(bookingId: number, userId: string): Promise<BookingWithDetails> {
    return this.updateBookingStatus(bookingId, 'cancelled', userId);
  }

  /**
   * Confirm a booking (owner only)
   */
  async confirmBooking(bookingId: number, userId: string): Promise<BookingWithDetails> {
    return this.updateBookingStatus(bookingId, 'confirmed', userId);
  }

  /**
   * Complete a booking (owner only)
   */
  async completeBooking(bookingId: number, userId: string): Promise<BookingWithDetails> {
    return this.updateBookingStatus(bookingId, 'completed', userId);
  }

  /**
   * Check availability for a post
   */
  async checkAvailability(
    postId: number,
    startTime: string,
    endTime: string
  ): Promise<boolean> {
    const { data } = await supabase
      .from('bookings')
      .select('id')
      .eq('post_id', postId)
      .in('status', ['pending', 'confirmed'])
      .or(
        `and(start_time.lte.${endTime},end_time.gte.${startTime})`
      );

    return !data || data.length === 0;
  }

  /**
   * Get unavailable dates for a post
   */
  async getUnavailableDates(postId: number): Promise<{ start: string; end: string }[]> {
    const { data } = await supabase
      .from('bookings')
      .select('start_time, end_time')
      .eq('post_id', postId)
      .in('status', ['pending', 'confirmed'])
      .gte('end_time', new Date().toISOString());

    return (data ?? []).map((b) => ({
      start: b.start_time,
      end: b.end_time,
    }));
  }
}

export const bookingManagementService = new BookingManagementService();
export default bookingManagementService;
