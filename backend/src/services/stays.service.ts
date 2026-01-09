import { BaseService } from './base.service';
import { Stay } from '../types';

class StaysService extends BaseService<Stay> {
  constructor() {
    super('stays', 'post_id');
  }
}

export const staysService = new StaysService();
export default staysService;
