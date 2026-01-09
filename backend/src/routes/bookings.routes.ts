import { Router } from 'express';
import { bookingController } from '../controllers/booking.controller';
import { authenticate } from '../middleware/authenticate';
import { buildCrudRouter } from './crud.factory';
import { bookingsController } from '../controllers';

const router = Router();

// All booking routes require authentication
router.use(authenticate);

// Business logic routes (must come before CRUD)
router.get('/my', bookingController.getMyBookings);
router.get('/received', bookingController.getReceivedBookings);
router.post('/:id/cancel', bookingController.cancel);
router.post('/:id/confirm', bookingController.confirm);
router.post('/:id/complete', bookingController.complete);

// Attach CRUD routes for basic operations
const crudRouter = buildCrudRouter(bookingsController);
router.use(crudRouter);

export default router;
