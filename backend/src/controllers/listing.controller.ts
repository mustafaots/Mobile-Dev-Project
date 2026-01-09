import { Request, Response, NextFunction } from 'express';
import { listingService, CreateListingInput, SearchFilters } from '../services/listing.service';
import { asyncHandler } from '../middleware/asyncHandler';
import { z } from 'zod';
import { ApiError } from '../utils/apiError';

// Validation schemas
const locationSchema = z.object({
  wilaya: z.string().min(1),
  city: z.string().min(1),
  address: z.string().min(1),
  latitude: z.number(),
  longitude: z.number(),
});

const stayDetailsSchema = z.object({
  stay_type: z.string().min(1),
  area: z.number().optional(),
  bedrooms: z.number().int().optional(),
});

const vehicleDetailsSchema = z.object({
  vehicle_type: z.string().min(1),
  model: z.string().optional(),
  year: z.number().int().optional(),
  fuel_type: z.string().optional(),
  transmission: z.boolean().optional(),
  seats: z.number().int().optional(),
  features: z.any().optional(),
});

const activityDetailsSchema = z.object({
  activity_type: z.string().min(1),
  requirements: z.any().optional(),
});

const createListingSchema = z.object({
  category: z.enum(['stay', 'vehicle', 'activity']),
  title: z.string().min(3).max(200),
  description: z.string().optional(),
  price: z.number().positive(),
  status: z.string().optional(),
  availability: z.string().optional(),
  location: locationSchema,
  stay_details: stayDetailsSchema.optional(),
  vehicle_details: vehicleDetailsSchema.optional(),
  activity_details: activityDetailsSchema.optional(),
  images: z.array(z.string()).optional(),
});

const updateListingSchema = createListingSchema.partial();

const searchFiltersSchema = z.object({
  category: z.enum(['stay', 'vehicle', 'activity']).optional(),
  wilaya: z.string().optional(),
  city: z.string().optional(),
  min_price: z.coerce.number().optional(),
  max_price: z.coerce.number().optional(),
  stay_type: z.string().optional(),
  vehicle_type: z.string().optional(),
  activity_type: z.string().optional(),
  limit: z.coerce.number().int().min(1).max(100).optional(),
  offset: z.coerce.number().int().min(0).optional(),
});

class ListingController {
  /**
   * Create a new listing
   * POST /api/listings
   */
  create = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const validated = createListingSchema.parse(req.body);
    
    const input: CreateListingInput = {
      ...validated,
      owner_id: user.id,
    };

    const listing = await listingService.createListing(input);

    res.status(201).json({
      success: true,
      data: listing,
    });
  });

  /**
   * Get a single listing by ID
   * GET /api/listings/:id
   */
  getById = asyncHandler(async (req: Request, res: Response) => {
    const id = parseInt(req.params.id, 10);
    const listing = await listingService.getListingById(id);

    res.json({
      success: true,
      data: listing,
    });
  });

  /**
   * Search/filter listings
   * GET /api/listings
   */
  search = asyncHandler(async (req: Request, res: Response) => {
    const { limit = 20, offset = 0, ...filters } = searchFiltersSchema.parse(req.query);
    
    const result = await listingService.searchListings(
      filters as SearchFilters,
      limit,
      offset
    );

    res.json({
      success: true,
      data: result.listings,
      meta: {
        total: result.total,
        limit,
        offset,
      },
    });
  });

  /**
   * Get listings by current user
   * GET /api/listings/my
   */
  getMyListings = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const listings = await listingService.getOwnerListings(user.id);

    res.json({
      success: true,
      data: listings,
    });
  });

  /**
   * Get listings by owner ID (public)
   * GET /api/listings/owner/:ownerId
   */
  getByOwner = asyncHandler(async (req: Request, res: Response) => {
    const { ownerId } = req.params;
    // Don't filter by status - show all owner's listings
    const { listings } = await listingService.searchListings(
      { owner_id: ownerId },
      100,
      0
    );

    res.json({
      success: true,
      data: listings,
    });
  });

  /**
   * Update a listing
   * PATCH /api/listings/:id
   */
  update = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const id = parseInt(req.params.id, 10);
    const existing = await listingService.getListingById(id);

    // Check ownership
    if (existing.owner_id !== user.id) {
      throw new ApiError(403, 'You are not authorized to update this listing.');
    }

    const validated = updateListingSchema.parse(req.body);
    const listing = await listingService.updateListing(id, validated);

    res.json({
      success: true,
      data: listing,
    });
  });

  /**
   * Delete a listing
   * DELETE /api/listings/:id
   */
  delete = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const id = parseInt(req.params.id, 10);
    const existing = await listingService.getListingById(id);

    // Check ownership
    if (existing.owner_id !== user.id) {
      throw new ApiError(403, 'You are not authorized to delete this listing.');
    }

    await listingService.deleteListing(id);

    res.json({
      success: true,
      message: 'Listing deleted successfully.',
    });
  });

  /**
   * Publish a listing
   * POST /api/listings/:id/publish
   */
  publish = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const id = parseInt(req.params.id, 10);
    const existing = await listingService.getListingById(id);

    if (existing.owner_id !== user.id) {
      throw new ApiError(403, 'You are not authorized to publish this listing.');
    }

    const listing = await listingService.publishListing(id);

    res.json({
      success: true,
      data: listing,
    });
  });

  /**
   * Unpublish a listing
   * POST /api/listings/:id/unpublish
   */
  unpublish = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const id = parseInt(req.params.id, 10);
    const existing = await listingService.getListingById(id);

    if (existing.owner_id !== user.id) {
      throw new ApiError(403, 'You are not authorized to unpublish this listing.');
    }

    const listing = await listingService.unpublishListing(id);

    res.json({
      success: true,
      data: listing,
    });
  });
}

export const listingController = new ListingController();
export default listingController;
