import { CrudController } from './base.controller';
import { Post } from '../types';
import { postsService } from '../services';
import { parseNumericId } from '../utils/parsers';
import { PostCreateInput, PostUpdateInput, postSchemas } from '../models';

class PostsController extends CrudController<Post, PostCreateInput, PostUpdateInput> {
  constructor() {
    super(postsService, (value) => parseNumericId(value, 'id'), postSchemas);
  }
}

export const postsController = new PostsController();
export default postsController;
