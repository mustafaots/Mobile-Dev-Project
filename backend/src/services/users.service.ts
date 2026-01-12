import { BaseService } from './base.service';
import { User } from '../types';
import supabase from '../config/supabase';
import { ApiError } from '../utils/apiError';

// Extended user type with auth data
export interface UserWithAuth extends User {
  email: string | null;
  phone: string | null;
  phone_verified: boolean;
  email_verified: boolean;
  email_confirmed_at: string | null;
}

class UsersService extends BaseService<User> {
  constructor() {
    super('users', 'user_id');
  }

  /**
   * Get user by ID with email and phone from auth
   */
  async getByIdWithAuth(id: string): Promise<UserWithAuth> {
    // Get user from public.users table
    const user = await this.getById(id);

    // Get auth data (email, phone) from auth.users
    const { data: authData, error: authError } = await supabase.auth.admin.getUserById(id);

    if (authError) {
      console.error('Failed to fetch auth data for user:', authError);
      // Return user without auth data if fetch fails
      return {
        ...user,
        email: null,
        phone: null,
        phone_verified: false,
        email_verified: user.is_verified, // Use is_verified from users table
        email_confirmed_at: null,
      };
    }

    return {
      ...user,
      email: authData.user?.email ?? null,
      phone: authData.user?.phone ?? null,
      phone_verified: !!authData.user?.phone_confirmed_at,
      // Use is_verified from users table for consistency with /auth/email/status
      email_verified: user.is_verified,
      email_confirmed_at: authData.user?.email_confirmed_at ?? null,
    };
  }
}

export const usersService = new UsersService();
export default usersService;
