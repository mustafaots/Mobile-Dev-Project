import { Request, Response } from 'express';
import { reviewManagementService, CreateReviewInput } from '../services/review.service';
import { asyncHandler } from '../middleware/asyncHandler';
import { z } from 'zod';
import { ApiError } from '../utils/apiError';

// Validation schemas
const createReviewSchema = z.object({
  post_id: z.number().int().positive(),
  rating: z.number().int().min(1).max(5),
  comment: z.string().optional(),
});

const updateReviewSchema = z.object({
  rating: z.number().int().min(1).max(5).optional(),
  comment: z.string().optional(),
});

class ReviewController {
  /**
   * Create a new review
   * POST /api/reviews
   */
  create = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const validated = createReviewSchema.parse(req.body);
    
    const input: CreateReviewInput = {
      ...validated,
      user_id: user.id,
    };

    const review = await reviewManagementService.createReview(input);

    res.status(201).json({
      success: true,
      data: review,
    });
  });

  /**
   * Get review by ID
   * GET /api/reviews/:id
   */
  getById = asyncHandler(async (req: Request, res: Response) => {
    const id = parseInt(req.params.id, 10);
    const review = await reviewManagementService.getReviewById(id);

    res.json({
      success: true,
      data: review,
    });
  });

  /**
   * Get reviews for a listing
   * GET /api/listings/:id/reviews
   */
  getForListing = asyncHandler(async (req: Request, res: Response) => {
    const postId = parseInt(req.params.id, 10);
    const reviews = await reviewManagementService.getPostReviews(postId);

    res.json({
      success: true,
      data: reviews,
    });
  });

  /**
   * Get rating summary for a listing
   * GET /api/listings/:id/ratings
   */
  getRatingSummary = asyncHandler(async (req: Request, res: Response) => {
    const postId = parseInt(req.params.id, 10);
    const summary = await reviewManagementService.getPostRatingSummary(postId);

    res.json({
      success: true,
      data: summary,
    });
  });

  /**
   * Get my reviews
   * GET /api/reviews/my
   */
  getMyReviews = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const reviews = await reviewManagementService.getUserReviews(user.id);

    res.json({
      success: true,
      data: reviews,
    });
  });

  /**
   * Update a review
   * PATCH /api/reviews/:id
   */
  update = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const id = parseInt(req.params.id, 10);
    const validated = updateReviewSchema.parse(req.body);
    const review = await reviewManagementService.updateReview(id, user.id, validated);

    res.json({
      success: true,
      data: review,
    });
  });

  /**
   * Delete a review
   * DELETE /api/reviews/:id
   */
  delete = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const id = parseInt(req.params.id, 10);
    await reviewManagementService.deleteReview(id, user.id);

    res.json({
      success: true,
      message: 'Review deleted successfully.',
    });
  });
}

export const reviewController = new ReviewController();
export default reviewController;
