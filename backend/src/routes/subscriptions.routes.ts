import { buildCrudRouter } from './crud.factory';
import { subscriptionsController } from '../controllers';

const subscriptionsRouter = buildCrudRouter(subscriptionsController);

export default subscriptionsRouter;
