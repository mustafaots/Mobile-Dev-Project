import { Request, Response } from 'express';
import { reportManagementService, CreateReportInput } from '../services/report.service';
import { asyncHandler } from '../middleware/asyncHandler';
import { z } from 'zod';
import { ApiError } from '../utils/apiError';

// Validation schemas
const createReportSchema = z.object({
  reported_id: z.string().uuid(),
  reported_type: z.enum(['user', 'post']),
  reason: z.string().min(3).max(100),
  details: z.string().max(1000).optional(),
});

class ReportController {
  /**
   * Create a new report
   * POST /api/reports
   */
  create = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const validated = createReportSchema.parse(req.body);
    
    const input: CreateReportInput = {
      ...validated,
      reporter_id: user.id,
    };

    const report = await reportManagementService.createReport(input);

    res.status(201).json({
      success: true,
      data: report,
    });
  });

  /**
   * Get my reports
   * GET /api/reports/my
   */
  getMyReports = asyncHandler(async (req: Request, res: Response) => {
    const user = (req as any).user;
    if (!user) {
      throw new ApiError(401, 'Authentication required.');
    }

    const reports = await reportManagementService.getMyReports(user.id);

    res.json({
      success: true,
      data: reports,
    });
  });
}

export const reportController = new ReportController();
export default reportController;
