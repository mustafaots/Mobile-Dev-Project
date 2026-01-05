import supabase from '../config/supabase';
import { ApiError } from '../utils/apiError';

export interface CreateReviewInput {
  post_id: number;
  user_id: string;  // This maps to reviewer_id in DB
  rating: number;
  comment?: string;
}

export interface ReviewRecord {
  id: number;
  post_id: number;
  reviewer_id: string;
  rating: number;
  comment: string | null;
  created_at: string;
}

export interface ReviewWithDetails extends ReviewRecord {
  user: {
    user_id: string;
    first_name: string | null;
    last_name: string | null;
  };
}

export interface PostRatingSummary {
  average_rating: number;
  total_reviews: number;
  rating_distribution: Record<number, number>;
}

class ReviewManagementService {
  /**
   * Create a review for a post
   */
  async createReview(input: CreateReviewInput): Promise<ReviewWithDetails> {
    // Get post
    const { data: post, error: postError } = await supabase
      .from('posts')
      .select('*')
      .eq('id', input.post_id)
      .single();

    if (postError || !post) {
      throw new ApiError(404, 'Post not found.');
    }

    // Check if user is not reviewing their own post
    if (post.owner_id === input.user_id) {
      throw new ApiError(400, 'You cannot review your own listing.');
    }

    // Check if user has a completed booking for this post
    const { data: bookings } = await supabase
      .from('bookings')
      .select('*')
      .eq('post_id', input.post_id)
      .eq('client_id', input.user_id)
      .eq('status', 'completed');

    if (!bookings || bookings.length === 0) {
      throw new ApiError(
        403,
        'You can only review listings you have completed a stay at.'
      );
    }

    // Check if user already reviewed this post
    const { data: existingReviews } = await supabase
      .from('reviews')
      .select('id')
      .eq('post_id', input.post_id)
      .eq('reviewer_id', input.user_id);

    if (existingReviews && existingReviews.length > 0) {
      throw new ApiError(400, 'You have already reviewed this listing.');
    }

    // Validate rating
    if (input.rating < 1 || input.rating > 5) {
      throw new ApiError(400, 'Rating must be between 1 and 5.');
    }

    const { data: review, error: createError } = await supabase
      .from('reviews')
      .insert({
        post_id: input.post_id,
        reviewer_id: input.user_id,
        rating: input.rating,
        comment: input.comment ?? null,
      })
      .select()
      .single();

    if (createError || !review) {
      throw new ApiError(500, 'Failed to create review.', createError?.message);
    }

    return this.getReviewById(review.id);
  }


  // check if a user can add a review for a post
  async canUserReviewPost(postId: number, userId: string): Promise<boolean> {
    // Get post
    const { data: post, error: postError } = await supabase
      .from('posts')
      .select('id, owner_id')
      .eq('id', postId)
      .single();

    if (postError || !post) {
      return false;
    }

    // User cannot review their own post
    if (post.owner_id === userId) {
      return false;
    }

    // Check if user already reviewed the post
    const { data: existingReviews } = await supabase
      .from('reviews')
      .select('id')
      .eq('post_id', postId)
      .eq('reviewer_id', userId);

    if (existingReviews && existingReviews.length > 0) {
      return false;
    }

    // Check if user has a completed booking
    const { data: bookings } = await supabase
      .from('bookings')
      .select('id')
      .eq('post_id', postId)
      .eq('client_id', userId)
      .eq('status', 'completed');

    if(bookings && bookings.length > 0) {
      return false;
    }

    return true;
  }

  /**
   * Get review by ID with user details
   */
  async getReviewById(reviewId: number): Promise<ReviewWithDetails> {
    const { data: review, error } = await supabase
      .from('reviews')
      .select('*')
      .eq('id', reviewId)
      .single();

    if (error || !review) {
      throw new ApiError(404, 'Review not found.');
    }

    const { data: user } = await supabase
      .from('users')
      .select('user_id, first_name, last_name')
      .eq('user_id', review.reviewer_id)
      .single();

    return {
      id: review.id,
      post_id: review.post_id,
      reviewer_id: review.reviewer_id,
      rating: review.rating,
      comment: review.comment,
      created_at: review.created_at,
      user: user ?? { user_id: review.reviewer_id, first_name: null, last_name: null },
    };
  }

  /**
   * Get all reviews for a post
   */
  async getPostReviews(postId: number): Promise<ReviewWithDetails[]> {
    const { data, error } = await supabase
      .from('reviews')
      .select('*')
      .eq('post_id', postId)
      .order('created_at', { ascending: false });

    if (error) {
      throw new ApiError(500, 'Failed to fetch reviews.', error.message);
    }

    const reviews = await Promise.all(
      (data ?? []).map((r) => this.getReviewById(r.id))
    );

    return reviews;
  }

  /**
   * Get rating summary for a post
   */
  async getPostRatingSummary(postId: number): Promise<PostRatingSummary> {
    const { data, error } = await supabase
      .from('reviews')
      .select('rating')
      .eq('post_id', postId);

    if (error) {
      throw new ApiError(500, 'Failed to fetch ratings.', error.message);
    }

    const ratings = data ?? [];
    const total_reviews = ratings.length;

    if (total_reviews === 0) {
      return {
        average_rating: 0,
        total_reviews: 0,
        rating_distribution: { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 },
      };
    }

    const sum = ratings.reduce((acc, r) => acc + r.rating, 0);
    const average_rating = Math.round((sum / total_reviews) * 10) / 10;

    const rating_distribution: Record<number, number> = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 };
    ratings.forEach((r) => {
      rating_distribution[r.rating]++;
    });

    return {
      average_rating,
      total_reviews,
      rating_distribution,
    };
  }

  /**
   * Update a review
   */
  async updateReview(
    reviewId: number,
    userId: string,
    updates: { rating?: number; comment?: string }
  ): Promise<ReviewWithDetails> {
    const { data: review, error } = await supabase
      .from('reviews')
      .select('*')
      .eq('id', reviewId)
      .single();

    if (error || !review) {
      throw new ApiError(404, 'Review not found.');
    }

    if (review.reviewer_id !== userId) {
      throw new ApiError(403, 'You can only update your own reviews.');
    }

    if (updates.rating !== undefined && (updates.rating < 1 || updates.rating > 5)) {
      throw new ApiError(400, 'Rating must be between 1 and 5.');
    }

    const { error: updateError } = await supabase
      .from('reviews')
      .update({
        ...(updates.rating !== undefined && { rating: updates.rating }),
        ...(updates.comment !== undefined && { comment: updates.comment }),
      })
      .eq('id', reviewId);

    if (updateError) {
      throw new ApiError(500, 'Failed to update review.', updateError.message);
    }

    return this.getReviewById(reviewId);
  }

  /**
   * Delete a review
   */
  async deleteReview(reviewId: number, userId: string): Promise<void> {
    const { data: review, error } = await supabase
      .from('reviews')
      .select('*')
      .eq('id', reviewId)
      .single();

    if (error || !review) {
      throw new ApiError(404, 'Review not found.');
    }

    if (review.reviewer_id !== userId) {
      throw new ApiError(403, 'You can only delete your own reviews.');
    }

    const { error: deleteError } = await supabase
      .from('reviews')
      .delete()
      .eq('id', reviewId);

    if (deleteError) {
      throw new ApiError(500, 'Failed to delete review.', deleteError.message);
    }
  }

  /**
   * Get reviews by a user
   */
  async getUserReviews(userId: string): Promise<ReviewWithDetails[]> {
    const { data, error } = await supabase
      .from('reviews')
      .select('*')
      .eq('reviewer_id', userId)
      .order('created_at', { ascending: false });

    if (error) {
      throw new ApiError(500, 'Failed to fetch reviews.', error.message);
    }

    const reviews = await Promise.all(
      (data ?? []).map((r) => this.getReviewById(r.id))
    );

    return reviews;
  }
}

export const reviewManagementService = new ReviewManagementService();
export default reviewManagementService;
