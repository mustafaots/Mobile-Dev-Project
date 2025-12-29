import supabase from '../config/supabase';
import { ApiError } from '../utils/apiError';
import { LoginInput, RegisterInput } from '../models';
import { usersService } from './users.service';
import { createClient } from '@supabase/supabase-js';

class AuthService {
  async register(payload: RegisterInput) {
    const { email, password, first_name, last_name } = payload;

    const { data, error } = await supabase.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
    });

    if (error || !data.user) {
      console.error('Supabase auth error:', error);
      throw new ApiError(400, 'Unable to create user account.', error?.message || 'Unknown error');
    }

    const profile = await usersService.create({
      user_id: data.user.id,
      first_name: first_name ?? null,
      last_name: last_name ?? null,
      is_verified: false,
      is_suspended: false,
    });

    return { user: data.user, profile };
  }

  async login(payload: LoginInput) {
    const { data, error } = await supabase.auth.signInWithPassword(payload);

    if (error || !data.session) {
      throw new ApiError(401, 'Invalid credentials.', error?.message);
    }

    // Fetch the user's profile to include first_name and last_name
    const profile = await usersService.getById(data.user.id);

    return { user: data.user, session: data.session, profile };
  }

  async getUserFromToken(token: string) {
    const { data, error } = await supabase.auth.getUser(token);

    if (error || !data.user) {
      throw new ApiError(401, 'Invalid or expired token.', error?.message);
    }

    return data.user;
  }

  async forgotPassword(email: string) {
    const { error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: 'easyvacation://reset-password',
    });

    if (error) {
      throw new ApiError(400, 'Unable to send reset email.', error.message);
    }

    return { message: 'Password reset email sent successfully.' };
  }


  async resetPassword(token: string, newPassword: string) {
    // Create client with service_role key (server only!)
    const supabaseAdmin = createClient(
      process.env.SUPABASE_URL!,
      process.env.SUPABASE_SERVICE_ROLE_KEY! // Must be server-side
    );

    // Get user from token
    const { data: userData, error: getUserError } = await supabaseAdmin.auth.getUser(token);
    if (getUserError || !userData.user) {
      throw new ApiError(400, 'Invalid or expired token.');
    }
    const userId = userData.user.id;
    // Reset password using admin API
    const { error } = await supabaseAdmin.auth.admin.updateUserById(userId, {
      password: newPassword,
    });
    if (error) throw new ApiError(400, 'Unable to reset password.', error.message);

    return { message: 'Password updated successfully.' };
  }
}

export const authService = new AuthService();
export default authService;
