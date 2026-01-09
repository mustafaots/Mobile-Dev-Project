import { buildCrudRouter } from './crud.factory';
import { vehiclesController } from '../controllers';

const vehiclesRouter = buildCrudRouter(vehiclesController);

export default vehiclesRouter;
