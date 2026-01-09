import { buildCrudRouter } from './crud.factory';
import { locationsController } from '../controllers';

const locationsRouter = buildCrudRouter(locationsController);

export default locationsRouter;
