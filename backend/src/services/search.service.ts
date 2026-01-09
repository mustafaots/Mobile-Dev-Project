import supabase from '../config/supabase';
import { ApiError } from '../utils/apiError';

export interface SearchQuery {
  q?: string;              // Full-text search query
  category?: string;       // stay, vehicle, activity
  wilaya?: string;         // Location wilaya
  city?: string;           // Location city
  min_price?: number;
  max_price?: number;
  min_rating?: number;
  
  // Stay-specific filters
  stay_type?: string;
  min_bedrooms?: number;
  min_area?: number;
  
  // Vehicle-specific filters
  vehicle_type?: string;
  fuel_type?: string;
  transmission?: boolean;
  min_seats?: number;
  
  // Activity-specific filters
  activity_type?: string;
  
  // Pagination
  limit?: number;
  offset?: number;
  
  // Sorting
  sort_by?: 'price' | 'rating' | 'created_at';
  sort_order?: 'asc' | 'desc';
  availability_dates?: string[];
}

export interface SearchResult {
  id: number;
  title: string;
  description: string | null;
  category: string;
  price: number;
  status: string;
  owner_id: string;
  created_at: string;
  location: {
    wilaya: string;
    city: string;
  };
  thumbnail_url: string | null;
  images: { secure_url: string; sort_order: number }[];
  average_rating: number;
  review_count: number;
}

class SearchService {
  /**
   * Search listings with advanced filters
   */
  async search(query: SearchQuery): Promise<{ results: SearchResult[]; total: number }> {
    const limit = query.limit ?? 20;
    const offset = query.offset ?? 0;

    // Create a new array of Date objects for the RPC
    let availabilityDates: Date[] = [];

    if (typeof query.availability_dates === 'string') {
      try {
        const parsed = JSON.parse(query.availability_dates);
        availabilityDates = parsed.map((d: string) => new Date(d));
      } catch (e) {
        console.warn('Invalid availability_dates:', query.availability_dates);
        availabilityDates = [];
      }
    } else if (Array.isArray(query.availability_dates)) {
      availabilityDates = query.availability_dates.map((d: string) => new Date(d));
    }

    // Handle availability dates filter FIRST
    let allowedIds: number[] | null = null;
    if (availabilityDates.length > 0) {
      const { data, error } = await supabase.rpc(
        'filter_posts_by_available_dates',
        {
          requested_dates: availabilityDates,
        }
      );
      if (error) {
        throw new ApiError(500, 'Availability filtering failed', error.message);
      }
      
      allowedIds = (data ?? []).map((r: any) => Number(r.id));
      console.log(`🔍 Filtering by available post IDs:`, allowedIds);
      
      if (allowedIds === null || allowedIds.length === 0) {
        return { results: [], total: 0 };
      }
    }

    // Build the base query
    let dbQuery = supabase.from('posts').select(`
      id,
      title,
      description,
      category,
      price,
      status,
      owner_id,
      created_at,
      locations!inner (wilaya, city),
      post_images (secure_url, sort_order),
      stays (stay_type, area, bedrooms),
      vehicles (vehicle_type, fuel_type, transmission, seats),
      activities (activity_type)
    `, { count: 'exact' });


    if(allowedIds && allowedIds.length > 0) {
      dbQuery = dbQuery.in('id', allowedIds);
    }

    // Filter by type
    if (query.category === 'stay' && query.stay_type) {
      dbQuery = dbQuery.eq('stays.stay_type', query.stay_type);
    } else if (query.category === 'vehicle' && query.vehicle_type) {
      dbQuery = dbQuery.eq('vehicles.vehicle_type', query.vehicle_type);
    } else if (query.category === 'activity' && query.activity_type) {
      dbQuery = dbQuery.eq('activities.activity_type', query.activity_type);
    }

    // Category filter
    if (query.category) {
      dbQuery = dbQuery.eq('category', query.category);
    }

    // Location filters
    if (query.wilaya) {
      dbQuery = dbQuery.eq('locations.wilaya', query.wilaya);
    }
    if (query.city) {
      dbQuery = dbQuery.eq('locations.city', query.city);
    }

    // Price filters
    if (query.min_price !== undefined) {
      dbQuery = dbQuery.gte('price', query.min_price);
    }
    if (query.max_price !== undefined) {
      dbQuery = dbQuery.lte('price', query.max_price);
    }

    // Text search
    if (query.q) {
      dbQuery = dbQuery.or(`title.ilike.%${query.q}%,description.ilike.%${query.q}%`);
    }

    // Sorting
    const sortBy = query.sort_by ?? 'created_at';
    const sortOrder = query.sort_order ?? 'desc';
    dbQuery = dbQuery.order(sortBy, { ascending: sortOrder === 'asc' });

    // Pagination
    dbQuery = dbQuery.range(offset, offset + limit - 1);

    const { data, error, count } = await dbQuery;

    if (error) {
      throw new ApiError(500, 'Search failed.', error.message);
    }

    // Get ratings for all posts
    const postIds = (data ?? []).map((p: any) => p.id);
    const ratings = await this.getPostRatings(postIds);

    // Transform results
    const results: SearchResult[] = (data ?? []).map((post: any) => {
      const images = post.post_images ?? [];
      console.log(`🔍 Post ${post.id} has ${images.length} images:`, images.map((i: any) => i.secure_url));
      const sortedImages = images.sort((a: any, b: any) => a.sort_order - b.sort_order);
      const postRating = ratings.get(post.id) ?? { average: 0, count: 0 };

      return {
        id: post.id,
        title: post.title,
        description: post.description,
        category: post.category,
        price: post.price,
        status: post.status,
        owner_id: post.owner_id,
        created_at: post.created_at,
        location: {
          wilaya: post.locations?.wilaya ?? '',
          city: post.locations?.city ?? '',
        },
        thumbnail_url: sortedImages.length > 0 ? sortedImages[0].secure_url : null,
        images: sortedImages.map((img: any) => ({
          secure_url: img.secure_url,
          sort_order: img.sort_order,
        })),
        average_rating: postRating.average,
        review_count: postRating.count,
      };
    });

    // Filter by minimum rating if specified
    let filteredResults = results;
    if (query.min_rating !== undefined) {
      filteredResults = results.filter((r) => r.average_rating >= (query.min_rating ?? 0));
    }

    return {
      results: filteredResults,
      total: count ?? 0,
    };
  }

  /**
   * Get batch ratings for posts
   */
  private async getPostRatings(postIds: number[]): Promise<Map<number, { average: number; count: number }>> {
    if (postIds.length === 0) return new Map();

    const { data } = await supabase
      .from('reviews')
      .select('post_id, rating')
      .in('post_id', postIds);

    const ratingsMap = new Map<number, { sum: number; count: number }>();
    
    (data ?? []).forEach((r) => {
      const existing = ratingsMap.get(r.post_id) ?? { sum: 0, count: 0 };
      ratingsMap.set(r.post_id, {
        sum: existing.sum + r.rating,
        count: existing.count + 1,
      });
    });

    const result = new Map<number, { average: number; count: number }>();
    ratingsMap.forEach((value, key) => {
      result.set(key, {
        average: Math.round((value.sum / value.count) * 10) / 10,
        count: value.count,
      });
    });

    return result;
  }

  /**
   * Get search suggestions (autocomplete)
   */
  async getSuggestions(q: string): Promise<string[]> {
    const { data } = await supabase
      .from('posts')
      .select('title')
      .eq('status', 'published')
      .ilike('title', `%${q}%`)
      .limit(5);

    return (data ?? []).map((p) => p.title);
  }

  /**
   * Get available locations
   */
  async getLocations(): Promise<{ wilaya: string; cities: string[] }[]> {
    const { data } = await supabase
      .from('locations')
      .select('wilaya, city');

    const locationMap = new Map<string, Set<string>>();
    
    (data ?? []).forEach((l) => {
      const cities = locationMap.get(l.wilaya) ?? new Set();
      cities.add(l.city);
      locationMap.set(l.wilaya, cities);
    });

    const result: { wilaya: string; cities: string[] }[] = [];
    locationMap.forEach((cities, wilaya) => {
      result.push({
        wilaya,
        cities: Array.from(cities).sort(),
      });
    });

    return result.sort((a, b) => a.wilaya.localeCompare(b.wilaya));
  }

  /**
   * Get featured/popular listings
   */
  async getFeaturedListings(limit = 10): Promise<SearchResult[]> {
    // Get posts with most bookings or reviews
    const { data: popularPosts } = await supabase
      .from('reviews')
      .select('post_id')
      .order('created_at', { ascending: false })
      .limit(100);

    const postCounts = new Map<number, number>();
    (popularPosts ?? []).forEach((r) => {
      postCounts.set(r.post_id, (postCounts.get(r.post_id) ?? 0) + 1);
    });

    const sortedPostIds = Array.from(postCounts.entries())
      .sort((a, b) => b[1] - a[1])
      .slice(0, limit)
      .map(([id]) => id);

    if (sortedPostIds.length === 0) {
      // No reviews yet, return recent listings
      const { results } = await this.search({ limit, sort_by: 'created_at', sort_order: 'desc' });
      return results;
    }

    const { data } = await supabase
      .from('posts')
      .select(`
        id,
        title,
        description,
        category,
        price,
        status,
        owner_id,
        created_at,
        locations (wilaya, city),
        post_images (secure_url, sort_order)
      `)
      .in('id', sortedPostIds)
      .eq('status', 'published');

    const ratings = await this.getPostRatings(sortedPostIds);

    return (data ?? []).map((post: any) => {
      const images = post.post_images ?? [];
      const sortedImages = images.sort((a: any, b: any) => a.sort_order - b.sort_order);
      const postRating = ratings.get(post.id) ?? { average: 0, count: 0 };

      return {
        id: post.id,
        title: post.title,
        description: post.description,
        category: post.category,
        price: post.price,
        status: post.status,
        owner_id: post.owner_id,
        created_at: post.created_at,
        location: {
          wilaya: post.locations?.wilaya ?? '',
          city: post.locations?.city ?? '',
        },
        thumbnail_url: sortedImages.length > 0 ? sortedImages[0].secure_url : null,
        images: sortedImages.map((img: any) => ({
          secure_url: img.secure_url,
          sort_order: img.sort_order,
        })),
        average_rating: postRating.average,
        review_count: postRating.count,
      };
    });
  }
}

export const searchService = new SearchService();
export default searchService;
