import { BaseService } from './base.service';
import { Location } from '../types';

class LocationsService extends BaseService<Location> {
  constructor() {
    super('locations', 'id');
  }
}

export const locationsService = new LocationsService();
export default locationsService;
