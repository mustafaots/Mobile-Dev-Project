import { BaseService } from './base.service';
import { PostImage } from '../types';

class PostImagesService extends BaseService<PostImage> {
  constructor() {
    super('post_images', 'id');
  }
}

export const postImagesService = new PostImagesService();
export default postImagesService;
