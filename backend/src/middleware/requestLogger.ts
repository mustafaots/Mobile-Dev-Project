import { NextFunction, Request, Response } from 'express';

export const requestLogger = (req: Request, res: Response, next: NextFunction) => {
  const startedAt = Date.now();

  const logRequest = () => {
    const duration = Date.now() - startedAt;
    const timestamp = new Date(startedAt).toISOString();
    console.info(`[${timestamp}] ${req.method} ${req.originalUrl} (${duration}ms)`);
  };

  res.on('finish', logRequest);
  res.on('close', logRequest);

  next();
};
