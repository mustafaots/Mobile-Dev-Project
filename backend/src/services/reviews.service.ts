import { BaseService } from './base.service';
import { Review } from '../types';

class ReviewsService extends BaseService<Review> {
  constructor() {
    super('reviews', 'id');
  }
}

export const reviewsService = new ReviewsService();
export default reviewsService;
