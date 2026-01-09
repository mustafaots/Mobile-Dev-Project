import supabase from '../config/supabase';
import { ApiError } from '../utils/apiError';
import { Report } from '../types';
import { reportsService } from './reports.service';

export interface CreateReportInput {
  reporter_id: string;
  reported_id: string;
  reported_type: 'user' | 'post';
  reason: string;
  details?: string;
}

export interface ReportWithDetails extends Report {
  reporter: {
    user_id: string;
    first_name: string | null;
    last_name: string | null;
  };
}

class ReportManagementService {
  /**
   * Create a report
   */
  async createReport(input: CreateReportInput): Promise<ReportWithDetails> {
    // Build the query to check for existing reports
    let query = supabase
      .from('reports')
      .select('id')
      .eq('reporter_id', input.reporter_id);

    // Check based on type
    if (input.reported_type === 'user') {
      query = query.eq('reported_user_id', input.reported_id);
    } else {
      query = query.eq('reported_post_id', parseInt(input.reported_id, 10));
    }

    const { data: existingReports } = await query;

    if (existingReports && existingReports.length > 0) {
      throw new ApiError(400, 'You have already reported this item.');
    }

    // Create the report with the correct fields
    const reportData: Partial<Report> = {
      reporter_id: input.reporter_id,
      reason: input.reason,
      description: input.details ?? null,
      status: 'pending',
    };

    if (input.reported_type === 'user') {
      reportData.reported_user_id = input.reported_id;
      reportData.reported_post_id = null;
    } else {
      reportData.reported_post_id = parseInt(input.reported_id, 10);
      reportData.reported_user_id = null;
    }

    const report = await reportsService.create(reportData);

    return this.getReportById(report.id);
  }

  /**
   * Get report by ID
   */
  async getReportById(reportId: number): Promise<ReportWithDetails> {
    const report = await reportsService.getById(reportId);
    
    const { data: reporter } = await supabase
      .from('users')
      .select('user_id, first_name, last_name')
      .eq('user_id', report.reporter_id)
      .single();

    return {
      ...report,
      reporter: reporter ?? { user_id: report.reporter_id, first_name: 'Unknown', last_name: null },
    };
  }

  /**
   * Get reports by status (admin)
   */
  async getReportsByStatus(status: string): Promise<ReportWithDetails[]> {
    const { data, error } = await supabase
      .from('reports')
      .select('*')
      .eq('status', status)
      .order('created_at', { ascending: false });

    if (error) {
      throw new ApiError(500, 'Failed to fetch reports.', error.message);
    }

    const reports = await Promise.all(
      (data ?? []).map((r) => this.getReportById(r.id))
    );

    return reports;
  }

  /**
   * Update report status (admin)
   */
  async updateReportStatus(
    reportId: number,
    status: 'pending' | 'reviewed' | 'resolved' | 'dismissed'
  ): Promise<ReportWithDetails> {
    await reportsService.update(reportId, { status });
    return this.getReportById(reportId);
  }

  /**
   * Get my reports
   */
  async getMyReports(userId: string): Promise<ReportWithDetails[]> {
    const { data, error } = await supabase
      .from('reports')
      .select('*')
      .eq('reporter_id', userId)
      .order('created_at', { ascending: false });

    if (error) {
      throw new ApiError(500, 'Failed to fetch reports.', error.message);
    }

    const reports = await Promise.all(
      (data ?? []).map((r) => this.getReportById(r.id))
    );

    return reports;
  }
}

export const reportManagementService = new ReportManagementService();
export default reportManagementService;
