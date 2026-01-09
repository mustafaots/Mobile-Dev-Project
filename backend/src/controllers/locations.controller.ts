import { CrudController } from './base.controller';
import { Location } from '../types';
import { locationsService } from '../services';
import { parseNumericId } from '../utils/parsers';
import { LocationCreateInput, LocationUpdateInput, locationSchemas } from '../models';

class LocationsController extends CrudController<Location, LocationCreateInput, LocationUpdateInput> {
  constructor() {
    super(locationsService, (value) => parseNumericId(value, 'id'), locationSchemas);
  }
}

export const locationsController = new LocationsController();
export default locationsController;
