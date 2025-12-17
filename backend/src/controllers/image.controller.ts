import { Request, Response } from 'express';
import { imageService } from '../services/image.service';
import { listingService } from '../services/listing.service';
import { asyncHandler } from '../middleware/asyncHandler';
import { z } from 'zod';
import { ApiError } from '../utils/apiError';

// Validation schemas
const uploadImagesSchema = z.object({
  images: z.array(z.string()).min(1).max(10),
});

const reorderImagesSchema = z.object({
  image_orders: z.array(
    z.object({
      id: z.number().int().positive(),
      position: z.number().int().min(0),
    })
  ),
});

class ImageController {
  /**
   * Upload images to a listing
   * POST /api/listings/:id/images
   */
  uploadImages = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const postId = parseInt(req.params.id, 10);
    const listing = await listingService.getListingById(postId);

    // Check ownership
    if (listing.owner_id !== user.id) {
      throw new ApiError(403, 'You are not authorized to upload images to this listing.');
    }

    const validated = uploadImagesSchema.parse(req.body);
    const images = await imageService.uploadImages(postId, validated.images);

    res.status(201).json({
      success: true,
      data: images,
    });
  });

  /**
   * Get images for a listing
   * GET /api/listings/:id/images
   */
  getImages = asyncHandler(async (req: Request, res: Response) => {
    const postId = parseInt(req.params.id, 10);
    const images = await imageService.getPostImages(postId);

    res.json({
      success: true,
      data: images,
    });
  });

  /**
   * Delete an image
   * DELETE /api/images/:id
   */
  deleteImage = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const imageId = parseInt(req.params.id, 10);
    
    // Get image and verify ownership through the post
    const image = await imageService.getImageById(imageId);
    const listing = await listingService.getListingById(image.post_id);

    if (listing.owner_id !== user.id) {
      throw new ApiError(403, 'You are not authorized to delete this image.');
    }

    await imageService.deleteImage(imageId);

    res.json({
      success: true,
      message: 'Image deleted successfully.',
    });
  });

  /**
   * Reorder images
   * PUT /api/listings/:id/images/order
   */
  reorderImages = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const postId = parseInt(req.params.id, 10);
    const listing = await listingService.getListingById(postId);

    // Check ownership
    if (listing.owner_id !== user.id) {
      throw new ApiError(403, 'You are not authorized to reorder images for this listing.');
    }

    const validated = reorderImagesSchema.parse(req.body);
    await imageService.reorderImages(validated.image_orders);

    const images = await imageService.getPostImages(postId);

    res.json({
      success: true,
      data: images,
    });
  });
}

export const imageController = new ImageController();
export default imageController;
