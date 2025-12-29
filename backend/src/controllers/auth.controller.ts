import { Request, Response } from 'express';
import { asyncHandler } from '../middleware';
import { authService, usersService } from '../services';
import { authSchemas } from '../models';
import { ApiError } from '../utils/apiError';

class AuthController {
  register = asyncHandler(async (req: Request, res: Response) => {
    const payload = authSchemas.register.parse(req.body);
    const result = await authService.register(payload);
    res.status(201).json(result);
  });

  login = asyncHandler(async (req: Request, res: Response) => {
    const payload = authSchemas.login.parse(req.body);
    const result = await authService.login(payload);
    res.json(result);
  });

  profile = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Unauthorized.');
    }
    
    // Fetch the user's profile to include first_name and last_name
    const profile = await usersService.getById(user.id);
    
    res.json({ user, profile });
  });

  forgotPassword = asyncHandler(async (req: Request, res: Response) => {
    const { email } = req.body;
    if (!email) {
      throw new ApiError(400, 'Email is required.');
    }
    const result = await authService.forgotPassword(email);
    res.json(result);
  });

  resetPassword = asyncHandler(async (req: Request, res: Response) => {
    const { token, new_password } = req.body;
    if (!token || !new_password) {
      throw new ApiError(400, 'Token and new password are required.');
    }
    const result = await authService.resetPassword(token, new_password);
    res.json(result);
  });

  changePassword = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;

    if (!user) {
      throw new ApiError(401, 'Unauthorized.');
    }
    const { current_password, new_password } = req.body;
    if (!current_password || !new_password) {
      throw new ApiError(400, 'Current and new passwords are required.');
    }

    const result = await authService.changePassword(
      user.id,
      user.email,
      current_password,
      new_password
    );

    res.json(result);
  });
}

export const authController = new AuthController();
export default authController;
