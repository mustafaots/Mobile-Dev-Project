import { buildCrudRouter } from './crud.factory';
import { staysController } from '../controllers';

const staysRouter = buildCrudRouter(staysController);

export default staysRouter;
