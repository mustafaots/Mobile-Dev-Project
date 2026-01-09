import { buildCrudRouter } from './crud.factory';
import { activitiesController } from '../controllers';

const activitiesRouter = buildCrudRouter(activitiesController);

export default activitiesRouter;
