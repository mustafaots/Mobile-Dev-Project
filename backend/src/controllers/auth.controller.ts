import { Request, Response } from 'express';
import { asyncHandler } from '../middleware';
import { authService } from '../services';
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
    res.json({ user });
  });

  forgotPassword = asyncHandler(async (req: Request, res: Response) => {
    const { email } = req.body;
    if (!email) {
      throw new ApiError(400, 'Email is required.');
    }
    const result = await authService.forgotPassword(email);
    res.json(result);
  });
}

export const authController = new AuthController();
export default authController;
