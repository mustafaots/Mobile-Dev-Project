import supabase from '../config/supabase';
import { ApiError } from '../utils/apiError';
import { LoginInput, RegisterInput } from '../models';
import { usersService } from './users.service';
import { createClient } from '@supabase/supabase-js';

class AuthService {
  /**
   * Convert local phone format (07/05/06...) to E.164 format for Supabase
   * Example: 0774403073 -> +213774403073 (Algeria country code)
   */
  private formatPhoneToE164(phone: string | undefined): string | undefined {
    if (!phone) return undefined;
    
    // If already in E.164 format, return as-is
    if (phone.startsWith('+')) return phone;
    
    // Convert local format (07/05/06...) to E.164 with Algeria country code (+213)
    // Remove leading 0 and add country code
    if (phone.startsWith('0')) {
      return '+213' + phone.substring(1);
    }
    
    return phone;
  }

  async register(payload: RegisterInput) {
    const { email, password, first_name, last_name, phone } = payload;

    // Convert phone to E.164 format for Supabase
    const e164Phone = this.formatPhoneToE164(phone);

    const { data, error } = await supabase.auth.admin.createUser({
      email,
      password,
      // Set to true so Supabase allows login. We track actual verification status
      // via is_verified field in the users table
      email_confirm: true,
      phone: e164Phone,
    });

    if (error || !data.user) {
      console.error('Supabase auth error:', error);
      
      // Handle specific error codes with user-friendly messages
      if (error?.code === 'email_exists') {
        throw new ApiError(409, 'An account with this email already exists. Please login or use a different email.');
      }
      if (error?.code === 'phone_exists') {
        throw new ApiError(409, 'An account with this phone number already exists.');
      }
      if (error?.code === 'weak_password') {
        throw new ApiError(400, 'Password is too weak. Please use a stronger password.');
      }
      
      throw new ApiError(400, 'Unable to create user account.', error?.message || 'Unknown error');
    }

    const profile = await usersService.create({
      user_id: data.user.id,
      first_name: first_name ?? null,
      last_name: last_name ?? null,
      // Note: phone is stored in Supabase Auth (auth.users), not in public.users table
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

    // Check if already verified in our users table
    const { data: profileData } = await supabase
      .from('users')
      .select('is_verified')
      .eq('user_id', userId)
      .single();

    if (profileData?.is_verified) {
      return { message: 'Email is already verified.', already_verified: true };
    }

    // Send magic link email
    // Note: Customize the "Magic Link" template in Supabase Dashboard to say "Verify your email"
    const { error } = await supabase.auth.signInWithOtp({
      email,
      options: {
        shouldCreateUser: false,
        emailRedirectTo: 'easyvacation://email-verified',
      }
    });

    if (error) {
      throw new ApiError(400, 'Unable to send verification email.', error.message);
    }

    return { message: 'Verification email sent. Please check your inbox.' };
  }

  /**
   * Confirm email verification - updates is_verified in users table
   */
  async confirmEmailVerification(userId: string) {
    const { data, error } = await supabase
      .from('users')
      .update({ is_verified: true })
      .eq('user_id', userId)
      .select()
      .single();

    if (error) {
      throw new ApiError(500, 'Failed to confirm email verification.', error.message);
    }

    return { 
      message: 'Email verified successfully.',
      is_verified: true 
    };
  }

  /**
   * Get email verification status from our own users table
   */
  async getEmailVerificationStatus(userId: string) {
    // Get user email from Supabase Auth
    const { data: authData, error: authError } = await supabase.auth.admin.getUserById(userId);

    if (authError || !authData.user) {
      throw new ApiError(404, 'User not found.');
    }

    // Get verification status from our users table
    const { data: userData, error: userError } = await supabase
      .from('users')
      .select('is_verified')
      .eq('user_id', userId)
      .single();

    if (userError) {
      throw new ApiError(404, 'User profile not found.');
    }

    return {
      email: authData.user.email ?? null,
      email_verified: userData.is_verified ?? false,
    };
  }
}

export const authService = new AuthService();
export default authService;
