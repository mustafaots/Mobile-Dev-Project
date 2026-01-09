import { CrudController } from './base.controller';
import { PostImage } from '../types';
import { postImagesService } from '../services';
import { parseNumericId } from '../utils/parsers';
import { PostImageCreateInput, PostImageUpdateInput, postImageSchemas } from '../models';

class PostImagesController extends CrudController<PostImage, PostImageCreateInput, PostImageUpdateInput> {
  constructor() {
    super(postImagesService, (value) => parseNumericId(value, 'id'), postImageSchemas);
  }
}

export const postImagesController = new PostImagesController();
export default postImagesController;
