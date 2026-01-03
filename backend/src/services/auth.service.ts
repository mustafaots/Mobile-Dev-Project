import supabase from '../config/supabase';
import { ApiError } from '../utils/apiError';
import { LoginInput, RegisterInput } from '../models';
import { usersService } from './users.service';
import { createClient } from '@supabase/supabase-js';

class AuthService {
  async register(payload: RegisterInput) {
    const { email, password, first_name, last_name, phone } = payload;

    const { data, error } = await supabase.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      phone: phone || undefined,
    });

    if (error || !data.user) {
      console.error('Supabase auth error:', error);
      throw new ApiError(400, 'Unable to create user account.', error?.message || 'Unknown error');
    }

    const profile = await usersService.create({
      user_id: data.user.id,
      first_name: first_name ?? null,
      last_name: last_name ?? null,
      phone: phone ?? null,
      is_verified: false,
      is_suspended: false,
    });

    // Log the user in to get session tokens
    const { data: loginData, error: loginError } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (loginError || !loginData.session) {
      // User created but login failed - return without session
      console.error('Auto-login after registration failed:', loginError);
      return { 
        user: data.user, 
        profile,
        session: null,
      };
    }

    return { 
      user: data.user, 
      profile, 
      session: loginData.session,
    };
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


  async changePassword(userId: string, email: string, currentPassword: string, newPassword: string) {
    const { error: signInError } = await supabase.auth.signInWithPassword({
      email,
      password: currentPassword,
    });

    if (signInError) {
      throw new ApiError(401, 'Current password is incorrect.');
    }

    // Update password
    const { error } = await supabase.auth.admin.updateUserById(userId, {
      password: newPassword,
    });

    if (error) {
      throw new ApiError(400, 'Unable to update password.', error.message);
    }

    return { message: 'Password changed successfully.' };
  }

  /**
   * Send email verification link to the user's email
   */
  async sendEmailVerification(userId: string) {
    const { data: userData, error: userError } = await supabase.auth.admin.getUserById(userId);

    if (userError || !userData.user) {
      throw new ApiError(404, 'User not found.');
    }

    const email = userData.user.email;
    if (!email) {
      throw new ApiError(400, 'User does not have an email address.');
    }

    // Check if already verified
    if (userData.user.email_confirmed_at) {
      return { message: 'Email is already verified.', already_verified: true };
    }

    // Send verification email using Supabase's resend functionality
    const { error } = await supabase.auth.resend({
      type: 'signup',
      email,
    });

    if (error) {
      throw new ApiError(400, 'Unable to send verification email.', error.message);
    }

    return { message: 'Verification email sent. Please check your inbox.' };
  }

  /**
   * Get email verification status
   */
  async getEmailVerificationStatus(userId: string) {
    const { data, error } = await supabase.auth.admin.getUserById(userId);

    if (error || !data.user) {
      throw new ApiError(404, 'User not found.');
    }

    return {
      email: data.user.email ?? null,
      email_verified: !!data.user.email_confirmed_at,
    };
  }
}

export const authService = new AuthService();
export default authService;
