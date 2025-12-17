import { CrudController } from './base.controller';
import { Review } from '../types';
import { reviewsService } from '../services';
import { parseNumericId } from '../utils/parsers';
import { ReviewCreateInput, ReviewUpdateInput, reviewSchemas } from '../models';

class ReviewsController extends CrudController<Review, ReviewCreateInput, ReviewUpdateInput> {
  constructor() {
    super(reviewsService, (value) => parseNumericId(value, 'id'), reviewSchemas);
  }
}

export const reviewsController = new ReviewsController();
export default reviewsController;
