import { BaseService } from './base.service';
import { Post } from '../types';

class PostsService extends BaseService<Post> {
  constructor() {
    super('posts', 'id');
  }
}

export const postsService = new PostsService();
export default postsService;
