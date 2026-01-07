import { Router } from 'express';
import activitiesRouter from './activities.routes';
import authRouter from './auth.routes';
import bookingsRouter from './bookings.routes';
import locationsRouter from './locations.routes';
import postImagesRouter from './postImages.routes';
import postsRouter from './posts.routes';
import reportsRouter from './reports.routes';
import reviewsRouter from './reviews.routes';
import staysRouter from './stays.routes';
import subscriptionsRouter from './subscriptions.routes';
import usersRouter from './users.routes';
import vehiclesRouter from './vehicles.routes';
import listingsRouter from './listings.routes';
import profileRouter from './profile.routes';
import imagesRouter from './images.routes';
import searchRouter from './search.routes';
import notificationRouter from './notification.routes';
import { profileController } from '../controllers/profile.controller';

const router = Router();

// Auth
router.use('/auth', authRouter);

// Business logic routes (these should be preferred for Flutter app)
router.use('/listings', listingsRouter);
router.use('/profile', profileRouter);
router.use('/images', imagesRouter);
router.use('/search', searchRouter);
router.use('/notifications', notificationRouter);

// Public profile route
router.get('/users/:id/profile', profileController.getPublicProfile);

// Base CRUD routes (for admin/debugging)
router.use('/activities', activitiesRouter);
router.use('/bookings', bookingsRouter);
router.use('/locations', locationsRouter);
router.use('/post-images', postImagesRouter);
router.use('/posts', postsRouter);
router.use('/reports', reportsRouter);
router.use('/reviews', reviewsRouter);
router.use('/stays', staysRouter);
router.use('/subscriptions', subscriptionsRouter);
router.use('/users', usersRouter);
router.use('/vehicles', vehiclesRouter);

export default router;
