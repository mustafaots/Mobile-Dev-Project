import { buildCrudRouter } from './crud.factory';
import { postImagesController } from '../controllers';

const postImagesRouter = buildCrudRouter(postImagesController);

export default postImagesRouter;
