import supabase from '../config/supabase';
import { ApiError } from '../utils/apiError';
import { LoginInput, RegisterInput } from '../models';
import { usersService } from './users.service';

class AuthService {
  async register(payload: RegisterInput) {
    const { email, password, first_name, last_name } = payload;

    const { data, error } = await supabase.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
    });

    if (error || !data.user) {
      throw new ApiError(400, 'Unable to create user account.', error?.message);
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

    return { user: data.user, session: data.session };
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
      redirectTo: `${process.env.FRONTEND_URL || 'http://localhost:3000'}/reset-password`,
    });

    if (error) {
      throw new ApiError(400, 'Unable to send reset email.', error.message);
    }

    return { message: 'Password reset email sent successfully.' };
  }
}

export const authService = new AuthService();
export default authService;
