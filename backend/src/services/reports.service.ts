import { BaseService } from './base.service';
import { Report } from '../types';

class ReportsService extends BaseService<Report> {
  constructor() {
    super('reports', 'id');
  }
}

export const reportsService = new ReportsService();
export default reportsService;
