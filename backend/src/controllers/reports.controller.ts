import { CrudController } from './base.controller';
import { Report } from '../types';
import { reportsService } from '../services';
import { parseNumericId } from '../utils/parsers';
import { ReportCreateInput, ReportUpdateInput, reportSchemas } from '../models';

class ReportsController extends CrudController<Report, ReportCreateInput, ReportUpdateInput> {
  constructor() {
    super(reportsService, (value) => parseNumericId(value, 'id'), reportSchemas);
  }
}

export const reportsController = new ReportsController();
export default reportsController;
