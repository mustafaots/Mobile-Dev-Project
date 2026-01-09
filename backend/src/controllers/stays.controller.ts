import { CrudController } from './base.controller';
import { Stay } from '../types';
import { staysService } from '../services';
import { parseNumericId } from '../utils/parsers';
import { StayCreateInput, StayUpdateInput, staySchemas } from '../models';

class StaysController extends CrudController<Stay, StayCreateInput, StayUpdateInput> {
  constructor() {
    super(staysService, (value) => parseNumericId(value, 'post_id'), staySchemas);
  }
}

export const staysController = new StaysController();
export default staysController;
