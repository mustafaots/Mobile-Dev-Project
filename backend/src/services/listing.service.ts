import supabase from '../config/supabase';
import { ApiError } from '../utils/apiError';
import { Post, Location, Stay, Vehicle, Activity, PostImage, Json } from '../types';
import { postsService } from './posts.service';
import { locationsService } from './locations.service';
import { staysService } from './stays.service';
import { vehiclesService } from './vehicles.service';
import { activitiesService } from './activities.service';
import { imageService } from './image.service';

export interface CreateListingInput {
  // Post fields
  owner_id: string;
  category: 'stay' | 'vehicle' | 'activity';
  title: string;
  description?: string;
  price: number;
  status?: string;
  availability?: string;

  // Location
  location: {
    wilaya: string;
    city: string;
    address: string;
    latitude: number;
    longitude: number;
  };

  // Category-specific details
  stay_details?: {
    stay_type: string;
    area?: number;
    bedrooms?: number;
  };

  vehicle_details?: {
    vehicle_type: string;
    model?: string;
    year?: number;
    fuel_type?: string;
    transmission?: boolean;
    seats?: number;
    features?: unknown;
  };

  activity_details?: {
    activity_type: string;
    requirements?: unknown;
  };

  // Images as base64 strings
  images?: string[];
}

export interface ListingWithDetails extends Post {
  location: Location;
  images: PostImage[];
  stay_details?: Stay;
  vehicle_details?: Vehicle;
  activity_details?: Activity;
  average_rating?: number;
  review_count?: number;
}

export interface SearchFilters {
  category?: string;
  wilaya?: string;
  city?: string;
  min_price?: number;
  max_price?: number;
  stay_type?: string;
  vehicle_type?: string;
  activity_type?: string;
  owner_id?: string;
  status?: string;
}

class ListingService {
  /**
   * Create a complete listing with location, category details, and images
   */
  async createListing(input: CreateListingInput): Promise<ListingWithDetails> {
    // 1. Create location
    const location = await locationsService.create({
      wilaya: input.location.wilaya,
      city: input.location.city,
      address: input.location.address,
      latitude: input.location.latitude,
      longitude: input.location.longitude,
    });

    // 2. Create post
    const post = await postsService.create({
      owner_id: input.owner_id,
      category: input.category,
      title: input.title,
      description: input.description ?? null,
      price: input.price,
      location_id: location.id,
      status: input.status ?? 'draft',
      availability: input.availability ?? '[]',
    });

    // 3. Create category-specific details
    let stay_details: Stay | undefined;
    let vehicle_details: Vehicle | undefined;
    let activity_details: Activity | undefined;

    if (input.category === 'stay' && input.stay_details) {
      stay_details = await staysService.create({
        post_id: post.id,
        stay_type: input.stay_details.stay_type,
        area: input.stay_details.area ?? null,
        bedrooms: input.stay_details.bedrooms ?? null,
      });
    } else if (input.category === 'vehicle' && input.vehicle_details) {
      vehicle_details = await vehiclesService.create({
        post_id: post.id,
        vehicle_type: input.vehicle_details.vehicle_type,
        model: input.vehicle_details.model ?? null,
        year: input.vehicle_details.year ?? null,
        fuel_type: input.vehicle_details.fuel_type ?? null,
        transmission: input.vehicle_details.transmission ?? false,
        seats: input.vehicle_details.seats ?? null,
        features: (input.vehicle_details.features ?? []) as Json,
      });
    } else if (input.category === 'activity' && input.activity_details) {
      activity_details = await activitiesService.create({
        post_id: post.id,
        activity_type: input.activity_details.activity_type,
        requirements: (input.activity_details.requirements ?? {}) as Json,
      });
    }

    // 4. Upload images
    let images: PostImage[] = [];
    if (input.images && input.images.length > 0) {
      const uploaded = await imageService.uploadImages(post.id, input.images);
      images = uploaded as unknown as PostImage[];
    }

    return {
      ...post,
      location,
      images,
      stay_details,
      vehicle_details,
      activity_details,
    };
  }

  /**
   * Get listing by ID with all related data
   */
  async getListingById(postId: number): Promise<ListingWithDetails> {
    const post = await postsService.getById(postId);
    const location = await locationsService.getById(post.location_id);
    const images = await imageService.getPostImages(postId);

    // Get category-specific details
    let stay_details: Stay | undefined;
    let vehicle_details: Vehicle | undefined;
    let activity_details: Activity | undefined;

    try {
      if (post.category === 'stay') {
        stay_details = await staysService.getById(postId);
      } else if (post.category === 'vehicle') {
        vehicle_details = await vehiclesService.getById(postId);
      } else if (post.category === 'activity') {
        activity_details = await activitiesService.getById(postId);
      }
    } catch {
      // Details might not exist
    }

    // Get average rating
    const { data: ratingData } = await supabase
      .from('reviews')
      .select('rating')
      .eq('post_id', postId);

    const ratings = ratingData ?? [];
    const average_rating =
      ratings.length > 0
        ? ratings.reduce((sum, r) => sum + r.rating, 0) / ratings.length
        : undefined;

    return {
      ...post,
      location,
      images,
      stay_details,
      vehicle_details,
      activity_details,
      average_rating,
      review_count: ratings.length,
    };
  }

  /**
   * Search listings with filters
   */
  async searchListings(
    filters: SearchFilters,
    limit = 20,
    offset = 0
  ): Promise<{ listings: ListingWithDetails[]; total: number }> {
    let query = supabase
      .from('posts')
      .select(
        `
        *,
        location:locations(*),
        images:post_images(*)
      `,
        { count: 'exact' }
      );

    // Only filter by status if explicitly provided
    if (filters.status) {
      query = query.eq('status', filters.status);
    }

    if (filters.category) {
      query = query.eq('category', filters.category);
    }

    if (filters.owner_id) {
      query = query.eq('owner_id', filters.owner_id);
    }

    if (filters.min_price !== undefined) {
      query = query.gte('price', filters.min_price);
    }

    if (filters.max_price !== undefined) {
      query = query.lte('price', filters.max_price);
    }

    if (filters.wilaya) {
      query = query.eq('location.wilaya', filters.wilaya);
    }

    if (filters.city) {
      query = query.eq('location.city', filters.city);
    }

    query = query
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    const { data, error, count } = await query;

    if (error) {
      throw new ApiError(500, 'Failed to search listings.', error.message);
    }

    const listings = (data ?? []).map((item: any) => ({
      ...item,
      location: item.location,
      images: item.images ?? [],
    }));

    return { listings, total: count ?? 0 };
  }

  /**
   * Get listings by owner
   */
  async getOwnerListings(ownerId: string): Promise<ListingWithDetails[]> {
    const { listings } = await this.searchListings({ owner_id: ownerId, status: undefined as any }, 100, 0);
    return listings;
  }

  /**
   * Update listing
   */
  async updateListing(
    postId: number,
    updates: Partial<CreateListingInput>
  ): Promise<ListingWithDetails> {
    // Update post fields
    if (updates.title || updates.description || updates.price || updates.status || updates.availability) {
      await postsService.update(postId, {
        ...(updates.title && { title: updates.title }),
        ...(updates.description !== undefined && { description: updates.description }),
        ...(updates.price !== undefined && { price: updates.price }),
        ...(updates.status && { status: updates.status }),
        ...(updates.availability && { availability: updates.availability }),
      });
    }

    // Update location
    const post = await postsService.getById(postId);
    if (updates.location) {
      await locationsService.update(post.location_id, updates.location);
    }

    // Update category-specific details
    if (updates.stay_details) {
      try {
        await staysService.update(postId, updates.stay_details as Partial<Stay>);
      } catch {
        await staysService.create({ post_id: postId, ...updates.stay_details } as any);
      }
    }

    if (updates.vehicle_details) {
      try {
        const vehicleData = {
          ...updates.vehicle_details,
          features: updates.vehicle_details.features as Json | undefined,
        };
        await vehiclesService.update(postId, vehicleData as Partial<Vehicle>);
      } catch {
        await vehiclesService.create({ post_id: postId, ...updates.vehicle_details } as any);
      }
    }

    if (updates.activity_details) {
      try {
        const activityData = {
          ...updates.activity_details,
          requirements: updates.activity_details.requirements as Json | undefined,
        };
        await activitiesService.update(postId, activityData as Partial<Activity>);
      } catch {
        await activitiesService.create({ post_id: postId, ...updates.activity_details } as any);
      }
    }

    // Handle new images - only upload base64 images, skip URLs
    if (updates.images && updates.images.length > 0) {
      const newImages = updates.images.filter(img => 
        !img.startsWith('http://') && !img.startsWith('https://')
      );
      if (newImages.length > 0) {
        await imageService.uploadImages(postId, newImages);
      }
    }

    return this.getListingById(postId);
  }

  /**
   * Delete listing and all related data
   */
  async deleteListing(postId: number): Promise<void> {
    const post = await postsService.getById(postId);

    // Delete images from Cloudinary
    await imageService.deletePostImages(postId);

    // Delete category-specific details (cascade should handle this)
    // Delete reviews (cascade should handle this)
    // Delete bookings (cascade should handle this)

    // Delete post
    await postsService.remove(postId);

    // Delete orphaned location
    await locationsService.remove(post.location_id);
  }

  /**
   * Publish a draft listing
   */
  async publishListing(postId: number): Promise<ListingWithDetails> {
    await postsService.update(postId, { status: 'published' });
    return this.getListingById(postId);
  }

  /**
   * Unpublish a listing
   */
  async unpublishListing(postId: number): Promise<ListingWithDetails> {
    await postsService.update(postId, { status: 'draft' });
    return this.getListingById(postId);
  }
}

export const listingService = new ListingService();
export default listingService;
