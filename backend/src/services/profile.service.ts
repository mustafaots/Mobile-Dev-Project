import supabase from '../config/supabase';
import { ApiError } from '../utils/apiError';
import { imageService } from './image.service';

export interface UserProfileData {
  user_id: string;
  first_name: string | null;
  last_name: string | null;
  is_verified: boolean;
  is_suspended: boolean;
  total_posts: number;
  total_bookings_as_client: number;
  total_bookings_as_owner: number;
  average_rating: number;
}

export interface UpdateProfileInput {
  first_name?: string;
  last_name?: string;
  phone?: string;
}

class ProfileService {
  /**
   * Get user profile with stats
   */
  async getProfile(userId: string): Promise<UserProfileData> {
    const { data: user, error } = await supabase
      .from('users')
      .select('*')
      .eq('user_id', userId)
      .single();

    if (error || !user) {
      throw new ApiError(404, 'User not found.');
    }

    // Count posts
    const { count: totalPosts } = await supabase
      .from('posts')
      .select('*', { count: 'exact', head: true })
      .eq('owner_id', userId);

    // Count bookings as client
    const { count: bookingsAsClient } = await supabase
      .from('bookings')
      .select('*', { count: 'exact', head: true })
      .eq('client_id', userId);

    // Count bookings as owner
    const { data: ownerPosts } = await supabase
      .from('posts')
      .select('id')
      .eq('owner_id', userId);

    let bookingsAsOwner = 0;
    if (ownerPosts && ownerPosts.length > 0) {
      const postIds = ownerPosts.map((p) => p.id);
      const { count } = await supabase
        .from('bookings')
        .select('*', { count: 'exact', head: true })
        .in('post_id', postIds);
      bookingsAsOwner = count ?? 0;
    }

    // Calculate average rating for owner's posts
    let averageRating = 0;
    if (ownerPosts && ownerPosts.length > 0) {
      const postIds = ownerPosts.map((p) => p.id);
      const { data: ratings } = await supabase
        .from('reviews')
        .select('rating')
        .in('post_id', postIds);

      if (ratings && ratings.length > 0) {
        const sum = ratings.reduce((acc, r) => acc + r.rating, 0);
        averageRating = Math.round((sum / ratings.length) * 10) / 10;
      }
    }

    return {
      user_id: user.user_id,
      first_name: user.first_name,
      last_name: user.last_name,
      is_verified: user.is_verified,
      is_suspended: user.is_suspended,
      total_posts: totalPosts ?? 0,
      total_bookings_as_client: bookingsAsClient ?? 0,
      total_bookings_as_owner: bookingsAsOwner,
      average_rating: averageRating,
    };
  }

  /**
   * Update user profile
   */
  async updateProfile(userId: string, updates: UpdateProfileInput): Promise<UserProfileData> {
    const updateData: Record<string, unknown> = {};

    if (updates.first_name !== undefined) {
      updateData.first_name = updates.first_name;
    }

    if (updates.last_name !== undefined) {
      updateData.last_name = updates.last_name;
    }

    if (Object.keys(updateData).length > 0) {
      const { error } = await supabase
        .from('users')
        .update(updateData)
        .eq('user_id', userId);

      if (error) {
        throw new ApiError(500, 'Failed to update profile.', error.message);
      }
    }

    // Update phone in Supabase Auth if provided
    if (updates.phone !== undefined) {
      const { error: authError } = await supabase.auth.admin.updateUserById(userId, {
        phone: updates.phone,
      });

      if (authError) {
        console.error('Failed to update phone:', authError);
        // Don't throw - phone update is optional
      }
    }

    return this.getProfile(userId);
  }

  /**
   * Get public profile (limited info for other users)
   */
  async getPublicProfile(userId: string): Promise<{
    user_id: string;
    first_name: string | null;
    last_name: string | null;
    is_verified: boolean;
    total_posts: number;
    average_rating: number;
  }> {
    const { data: user, error } = await supabase
      .from('users')
      .select('*')
      .eq('user_id', userId)
      .single();

    if (error || !user) {
      throw new ApiError(404, 'User not found.');
    }

    // Count published posts
    const { count: totalPosts } = await supabase
      .from('posts')
      .select('*', { count: 'exact', head: true })
      .eq('owner_id', userId)
      .eq('status', 'published');

    // Get posts for rating calculation
    const { data: ownerPosts } = await supabase
      .from('posts')
      .select('id')
      .eq('owner_id', userId);

    let averageRating = 0;
    if (ownerPosts && ownerPosts.length > 0) {
      const postIds = ownerPosts.map((p) => p.id);
      const { data: ratings } = await supabase
        .from('reviews')
        .select('rating')
        .in('post_id', postIds);

      if (ratings && ratings.length > 0) {
        const sum = ratings.reduce((acc, r) => acc + r.rating, 0);
        averageRating = Math.round((sum / ratings.length) * 10) / 10;
      }
    }

    return {
      user_id: user.user_id,
      first_name: user.first_name,
      last_name: user.last_name,
      is_verified: user.is_verified,
      total_posts: totalPosts ?? 0,
      average_rating: averageRating,
    };
  }

  /**
   * Request verification
   */
  async requestVerification(userId: string): Promise<{ message: string }> {
    const { data: user, error } = await supabase
      .from('users')
      .select('*')
      .eq('user_id', userId)
      .single();

    if (error || !user) {
      throw new ApiError(404, 'User not found.');
    }

    if (user.is_verified) {
      throw new ApiError(400, 'User is already verified.');
    }

    // In a real app, this would trigger a verification process
    return { message: 'Verification request submitted. Please check your email.' };
  }

  /**
   * Verify user (admin only)
   */
  async verifyUser(userId: string): Promise<UserProfileData> {
    const { error } = await supabase
      .from('users')
      .update({ is_verified: true })
      .eq('user_id', userId);

    if (error) {
      throw new ApiError(500, 'Failed to verify user.', error.message);
    }

    return this.getProfile(userId);
  }

  /**
   * Delete account - removes user from both public.users and auth.users
   */
  async deleteAccount(userId: string): Promise<void> {
    // First, delete from public.users table (profile data)
    const { error: profileError } = await supabase
      .from('users')
      .delete()
      .eq('user_id', userId);

    if (profileError) {
      throw new ApiError(500, 'Failed to delete account profile.', profileError.message);
    }

    // Then, delete from Supabase auth.users table
    const { error: authError } = await supabase.auth.admin.deleteUser(userId);

    if (authError) {
      throw new ApiError(500, 'Failed to delete auth account.', authError.message);
    }
  }
}

export const profileService = new ProfileService();
export default profileService;
