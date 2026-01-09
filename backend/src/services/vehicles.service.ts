import { BaseService } from './base.service';
import { Vehicle } from '../types';

class VehiclesService extends BaseService<Vehicle> {
  constructor() {
    super('vehicles', 'post_id');
  }
}

export const vehiclesService = new VehiclesService();
export default vehiclesService;
