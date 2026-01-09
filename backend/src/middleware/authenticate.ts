import { NextFunction, Request, Response } from 'express';
import { ApiError } from '../utils/apiError';
import { authService } from '../services';
import { asyncHandler } from './asyncHandler';

export const authenticate = asyncHandler(async (req: Request, _res: Response, next: NextFunction) => {
  const header = req.headers.authorization;

  if (!header || !header.startsWith('Bearer ')) {
    throw new ApiError(401, 'Missing bearer token.');
  }

  const token = header.replace('Bearer ', '').trim();

  if (!token) {
    throw new ApiError(401, 'Invalid bearer token.');
  }

  const user = await authService.getUserFromToken(token);

  (req as any).user = user;

  next();
});
