import { Request, Response } from 'express';
import { searchService, SearchQuery } from '../services/search.service';
import { asyncHandler } from '../middleware/asyncHandler';
import { z } from 'zod';

// Validation schema for search query
const searchQuerySchema = z.object({
  q: z.string().optional(),
  category: z.enum(['stay', 'vehicle', 'activity']).optional(),
  wilaya: z.string().optional(),
  city: z.string().optional(),
  min_price: z.coerce.number().min(0).optional(),
  max_price: z.coerce.number().min(0).optional(),
  min_rating: z.coerce.number().min(0).max(5).optional(),
  stay_type: z.string().optional(),
  min_bedrooms: z.coerce.number().int().min(0).optional(),
  min_area: z.coerce.number().min(0).optional(),
  vehicle_type: z.string().optional(),
  fuel_type: z.string().optional(),
  transmission: z.coerce.boolean().optional(),
  min_seats: z.coerce.number().int().min(1).optional(),
  activity_type: z.string().optional(),
  limit: z.coerce.number().int().min(1).max(100).optional(),
  offset: z.coerce.number().int().min(0).optional(),
  sort_by: z.enum(['price', 'rating', 'created_at']).optional(),
  sort_order: z.enum(['asc', 'desc']).optional(),
});

class SearchController {
  /**
   * Search listings
   * GET /api/search
   */
  search = asyncHandler(async (req: Request, res: Response) => {
    const query = searchQuerySchema.parse(req.query) as SearchQuery;
    const { results, total } = await searchService.search(query);

    res.json({
      success: true,
      data: results,
      meta: {
        total,
        limit: query.limit ?? 20,
        offset: query.offset ?? 0,
      },
    });
  });

  /**
   * Get search suggestions
   * GET /api/search/suggestions?q=...
   */
  getSuggestions = asyncHandler(async (req: Request, res: Response) => {
    const q = z.string().min(1).parse(req.query.q);
    const suggestions = await searchService.getSuggestions(q);

    res.json({
      success: true,
      data: suggestions,
    });
  });

  /**
   * Get available locations
   * GET /api/search/locations
   */
  getLocations = asyncHandler(async (req: Request, res: Response) => {
    const locations = await searchService.getLocations();

    res.json({
      success: true,
      data: locations,
    });
  });

  /**
   * Get featured listings
   * GET /api/search/featured
   */
  getFeatured = asyncHandler(async (req: Request, res: Response) => {
    const limit = z.coerce.number().int().min(1).max(50).optional().parse(req.query.limit) ?? 10;
    const listings = await searchService.getFeaturedListings(limit);

    res.json({
      success: true,
      data: listings,
    });
  });
}

export const searchController = new SearchController();
export default searchController;
