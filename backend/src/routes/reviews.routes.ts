import { Router } from 'express';
import { reviewController } from '../controllers/review.controller';
import { authenticate } from '../middleware/authenticate';
import { buildCrudRouter } from './crud.factory';
import { reviewsController } from '../controllers';

const router = Router();

// Protected routes (must come before CRUD)
router.get('/my', authenticate, reviewController.getMyReviews);
router.post('/', authenticate, reviewController.create);
router.patch('/:id', authenticate, reviewController.update);
router.delete('/:id', authenticate, reviewController.delete);
router.get('/can-review/:id', authenticate, reviewController.canReviewPost);

// Attach CRUD router for basic read operations
const crudRouter = buildCrudRouter(reviewsController);
router.use(crudRouter);

export default router;
