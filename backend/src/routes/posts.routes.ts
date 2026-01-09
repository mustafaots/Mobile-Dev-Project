import { buildCrudRouter } from './crud.factory';
import { postsController } from '../controllers';

const postsRouter = buildCrudRouter(postsController);

export default postsRouter;
