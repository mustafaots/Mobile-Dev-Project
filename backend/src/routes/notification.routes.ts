import { Router } from 'express';
import { NotificationController } from '../controllers/notification.controller';

const router = Router();

/**
 * @route POST /notifications/register-token
 * @desc Register FCM token for a user
 * @access Private
 */
router.post('/register-token', NotificationController.registerFCMToken);

/**
 * @route POST /notifications/unregister-token
 * @desc Unregister FCM token for a user
 * @access Private
 */
router.post('/unregister-token', NotificationController.unregisterFCMToken);

/**
 * @route POST /notifications/send
 * @desc Send notification to a specific user
 * @access Private
 */
router.post('/send', NotificationController.sendNotification);

/**
 * @route POST /notifications/send-bulk
 * @desc Send notification to multiple users
 * @access Private
 */
router.post('/send-bulk', NotificationController.sendBulkNotification);

/**
 * @route POST /notifications/send-topic
 * @desc Send notification to a topic
 * @access Private
 */
router.post('/send-topic', NotificationController.sendTopicNotification);

/**
 * @route GET /notifications/user/:userId
 * @desc Get user's notifications with pagination
 * @access Private
 */
router.get('/user/:userId', NotificationController.getUserNotifications);

/**
 * @route PATCH /notifications/:notificationId/read
 * @desc Mark notification as read
 * @access Private
 */
router.patch('/:notificationId/read', NotificationController.markAsRead);

/**
 * @route PATCH /notifications/user/:userId/read-all
 * @desc Mark all notifications as read for a user
 * @access Private
 */
router.patch('/user/:userId/read-all', NotificationController.markAllAsRead);

/**
 * @route DELETE /notifications/:notificationId
 * @desc Delete notification
 * @access Private
 */
router.delete('/:notificationId', NotificationController.deleteNotification);

/**
 * @route GET /notifications/stats/:userId
 * @desc Get notification statistics for a user
 * @access Private
 */
router.get('/stats/:userId', NotificationController.getNotificationStats);

/**
 * @route POST /notifications/booking/:bookingId/accept
 * @desc Accept a booking request from notification
 * @access Private
 */
router.post('/booking/:bookingId/accept', NotificationController.acceptBookingRequest);

/**
 * @route POST /notifications/booking/:bookingId/reject
 * @desc Reject a booking request from notification
 * @access Private
 */
router.post('/booking/:bookingId/reject', NotificationController.rejectBookingRequest);

export default router;