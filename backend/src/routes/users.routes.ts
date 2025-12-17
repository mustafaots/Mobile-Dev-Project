import { buildCrudRouter } from './crud.factory';
import { usersController } from '../controllers';

const usersRouter = buildCrudRouter(usersController);

export default usersRouter;
