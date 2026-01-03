import { Router } from 'express';
import { listingController } from '../controllers/listing.controller';
import { bookingController } from '../controllers/booking.controller';
import { reviewController } from '../controllers/review.controller';
import { imageController } from '../controllers/image.controller';
import { authenticate } from '../middleware/authenticate';

const router = Router();

// Public routes - IMPORTANT: specific routes BEFORE parameterized routes
router.get('/', listingController.search);
router.get('/owner/:ownerId', listingController.getByOwner);

// Availability and booking info (public)
// Note: These need to come after specific routes but before generic /:id

// Protected routes - MUST come before /:id route
router.get('/my/listings', authenticate, listingController.getMyListings);

// Generic :id route - MUST be last among GET routes
router.get('/:id', listingController.getById);
router.get('/:id/availability', bookingController.checkAvailability);
router.get('/:id/unavailable-dates', bookingController.getUnavailableDates);

// Reviews and ratings (public)
router.get('/:id/reviews', reviewController.getForListing);
router.get('/:id/ratings', reviewController.getRatingSummary);

// Images (public read)
router.get('/:id/images', imageController.getImages);

// Protected routes
router.use(authenticate);

router.post('/', listingController.create);
router.patch('/:id', listingController.update);
router.delete('/:id', listingController.delete);
router.post('/:id/publish', listingController.publish);
router.post('/:id/unpublish', listingController.unpublish);

// Images (protected)
router.post('/:id/images', imageController.uploadImages);
router.put('/:id/images/order', imageController.reorderImages);

export default router;
