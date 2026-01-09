import { NextFunction, Request, Response } from 'express';
import { ZodError } from 'zod';
import { ApiError } from '../utils/apiError';
import env from '../config/env';

// Centralized error handler to keep responses consistent
export const errorHandler = (
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction
) => {
  if (err instanceof ZodError) {
    return res.status(400).json({
      message: 'Validation failed.',
      details: err.errors,
    });
  }

  const status = err instanceof ApiError ? err.statusCode : 500;
  const message = err.message || 'Something went wrong.';

  res.status(status).json({
    message,
    ...(err instanceof ApiError && err.details ? { details: err.details } : {}),
    ...(env.nodeEnv === 'development' ? { stack: err.stack } : {}),
  });
};
