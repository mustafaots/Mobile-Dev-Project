import { Request, Response } from 'express';
import { profileService, UpdateProfileInput } from '../services/profile.service';
import { asyncHandler } from '../middleware/asyncHandler';
import { z } from 'zod';
import { ApiError } from '../utils/apiError';

// Validation schemas - matches actual DB schema (first_name, last_name)
const updateProfileSchema = z.object({
  first_name: z.string().min(1).max(100).optional(),
  last_name: z.string().min(1).max(100).optional(),
  phone: z.string().max(20).optional(),
});

class ProfileController {
  /**
   * Get current user's profile
   * GET /api/profile
   */
  getMyProfile = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const profile = await profileService.getProfile(user.id);

    res.json({
      success: true,
      data: profile,
    });
  });

  /**
   * Update current user's profile
   * PATCH /api/profile
   */
  updateMyProfile = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const validated = updateProfileSchema.parse(req.body) as UpdateProfileInput;
    const profile = await profileService.updateProfile(user.id, validated);

    res.json({
      success: true,
      data: profile,
    });
  });

  /**
   * Get public profile of a user
   * GET /api/users/:id/profile
   */
  getPublicProfile = asyncHandler(async (req: Request, res: Response) => {
    const { id } = req.params;
    const profile = await profileService.getPublicProfile(id);

    res.json({
      success: true,
      data: profile,
    });
  });

  /**
   * Request account verification
   * POST /api/profile/verify
   */
  requestVerification = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const result = await profileService.requestVerification(user.id);

    res.json({
      success: true,
      data: result,
    });
  });

  /**
   * Delete account
   * DELETE /api/profile
   */
  deleteAccount = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    await profileService.deleteAccount(user.id);

    res.json({
      success: true,
      message: 'Account deleted successfully.',
    });
  });
}

export const profileController = new ProfileController();
export default profileController;
