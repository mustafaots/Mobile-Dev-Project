import { Json, Timestamp, UUID } from './common';

export interface Activity {
  post_id: number;
  activity_type: string;
  requirements: Json;
}

export interface Booking {
  id: number;
  post_id: number;
  client_id: UUID;
  status: string;
  booked_at: Timestamp;
  start_time: Timestamp;
  end_time: Timestamp;
}

// Alias for more intuitive usage in services
export interface BookingWithDates extends Omit<Booking, 'start_time' | 'end_time'> {
  start_date: string;
  end_date: string;
  total_price: number;
}

export interface Location {
  id: number;
  wilaya: string;
  city: string;
  address: string;
  latitude: number;
  longitude: number;
  created_at: Timestamp;
  updated_at: Timestamp;
}

export interface PostImage {
  id: number;
  post_id: number;
  public_id: string;
  secure_url: string;
  width: number | null;
  height: number | null;
  format: string | null;
  bytes: number | null;
  sort_order: number;
  created_at: Timestamp;
}

export interface Post {
  id: number;
  owner_id: UUID;
  category: string;
  title: string;
  description: string | null;
  price: number;
  location_id: number;
  is_paid: boolean;
  created_at: Timestamp;
  updated_at: Timestamp;
  status: string;
  availability: string;
}

export interface Report {
  id: number;
  reporter_id: UUID;
  reported_post_id: number | null;
  reported_user_id: UUID | null;
  reason: string;
  description: string | null;
  status: string;
  created_at: Timestamp;
}

export interface Review {
  id: number;
  post_id: number;
  reviewer_id: UUID;
  rating: number;
  comment: string | null;
  created_at: Timestamp;
}

// Alias for services using user_id instead of reviewer_id
export interface ReviewInput {
  post_id: number;
  user_id: UUID;
  rating: number;
  comment: string | null;
}

export interface Stay {
  post_id: number;
  stay_type: string;
  area: number | null;
  bedrooms: number | null;
}

export interface Subscription {
  id: number;
  subscriber_id: UUID;
  plan: string;
  created_at: Timestamp;
  updated_at: Timestamp;
}

// This maps to the actual 'users' table in the database
export interface User {
  user_id: UUID;
  first_name: string | null;
  last_name: string | null;
  is_verified: boolean;
  is_suspended: boolean;
}

// Backward compatibility alias
export type UserProfile = User;

// Computed field for display
export interface UserWithFullName extends User {
  full_name: string;
}

export interface Vehicle {
  post_id: number;
  vehicle_type: string;
  model: string | null;
  year: number | null;
  fuel_type: string | null;
  transmission: boolean;
  seats: number | null;
  features: Json;
}
