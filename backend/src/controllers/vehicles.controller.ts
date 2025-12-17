import { CrudController } from './base.controller';
import { Vehicle } from '../types';
import { vehiclesService } from '../services';
import { parseNumericId } from '../utils/parsers';
import { VehicleCreateInput, VehicleUpdateInput, vehicleSchemas } from '../models';

class VehiclesController extends CrudController<Vehicle, VehicleCreateInput, VehicleUpdateInput> {
  constructor() {
    super(vehiclesService, (value) => parseNumericId(value, 'post_id'), vehicleSchemas);
  }
}

export const vehiclesController = new VehiclesController();
export default vehiclesController;
