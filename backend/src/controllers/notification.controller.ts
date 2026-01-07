import { Request, Response } from 'express';
import { NotificationService, NotificationPayload } from '../services/notification.service';
import { bookingManagementService } from '../services/booking.service';
import { ApiError } from '../utils/apiError';

export class NotificationController {
  /**
   * Register FCM token for a user
   */
  static async registerFCMToken(req: Request, res: Response) {
    try {
      const { userId, fcmToken, platform = 'mobile' } = req.body;

      if (!userId || !fcmToken) {
        throw new ApiError(400, 'User ID and FCM token are required');
      }

      await NotificationService.registerFCMToken(userId, fcmToken, platform);

      res.status(200).json({
        success: true,
        message: 'FCM token registered successfully',
      });
    } catch (error) {
      if (error instanceof ApiError) {
        res.status(error.statusCode).json({
          success: false,
          message: error.message,
        });
      } else {
        res.status(500).json({
          success: false,
          message: 'Internal server error',
        });
      }
    }
  }

  /**
   * Unregister FCM token for a user
   */
  static async unregisterFCMToken(req: Request, res: Response) {
    try {
      const { userId } = req.body;

      if (!userId) {
        throw new ApiError(400, 'User ID is required');
      }

      await NotificationService.unregisterFCMToken(userId);

      res.status(200).json({
        success: true,
        message: 'FCM token unregistered successfully',
      });
    } catch (error) {
      if (error instanceof ApiError) {
        res.status(error.statusCode).json({
          success: false,
          message: error.message,
        });
      } else {
        res.status(500).json({
          success: false,
          message: 'Internal server error',
        });
      }
    }
  }

  /**
   * Send notification to a specific user
   */
  static async sendNotification(req: Request, res: Response) {
    try {
      const { userId, title, body, data } = req.body;

      if (!userId || !title || !body) {
        throw new ApiError(400, 'User ID, title, and body are required');
      }

      const payload: NotificationPayload = {
        title,
        body,
        data: data || {},
      };

      await NotificationService.sendToUser(userId, payload);

      res.status(200).json({
        success: true,
        message: 'Notification sent successfully',
      });
    } catch (error) {
      if (error instanceof ApiError) {
        res.status(error.statusCode).json({
          success: false,
          message: error.message,
        });
      } else {
        res.status(500).json({
          success: false,
          message: 'Internal server error',
        });
      }
    }
  }

  /**
   * Send notification to multiple users
   */
  static async sendBulkNotification(req: Request, res: Response) {
    try {
      const { userIds, title, body, data } = req.body;

      if (!userIds || !Array.isArray(userIds) || userIds.length === 0 || !title || !body) {
        throw new ApiError(400, 'User IDs array, title, and body are required');
      }

      const payload: NotificationPayload = {
        title,
        body,
        data: data || {},
      };

      await NotificationService.sendToUsers(userIds, payload);

      res.status(200).json({
        success: true,
        message: `Notification sent to ${userIds.length} users successfully`,
      });
    } catch (error) {
      if (error instanceof ApiError) {
        res.status(error.statusCode).json({
          success: false,
          message: error.message,
        });
      } else {
        res.status(500).json({
          success: false,
          message: 'Internal server error',
        });
      }
    }
  }

  /**
   * Send notification to a topic
   */
  static async sendTopicNotification(req: Request, res: Response) {
    try {
      const { topic, title, body, data } = req.body;

      if (!topic || !title || !body) {
        throw new ApiError(400, 'Topic, title, and body are required');
      }

      const payload: NotificationPayload = {
        title,
        body,
        data: data || {},
      };

      await NotificationService.sendToTopic(topic, payload);

      res.status(200).json({
        success: true,
        message: 'Topic notification sent successfully',
      });
    } catch (error) {
      if (error instanceof ApiError) {
        res.status(error.statusCode).json({
          success: false,
          message: error.message,
        });
      } else {
        res.status(500).json({
          success: false,
          message: 'Internal server error',
        });
      }
    }
  }

  /**
   * Get user's notifications
   */
  static async getUserNotifications(req: Request, res: Response) {
    try {
      const { userId } = req.params;
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 20;

      if (!userId) {
        throw new ApiError(400, 'User ID is required');
      }

      const result = await NotificationService.getUserNotifications(userId, page, limit);

      res.status(200).json({
        success: true,
        data: result.notifications,
        pagination: {
          page,
          limit,
          total: result.total,
          totalPages: Math.ceil(result.total / limit),
        },
      });
    } catch (error) {
      if (error instanceof ApiError) {
        res.status(error.statusCode).json({
          success: false,
          message: error.message,
        });
      } else {
        res.status(500).json({
          success: false,
          message: 'Internal server error',
        });
      }
    }
  }

  /**
   * Mark notification as read
   */
  static async markAsRead(req: Request, res: Response) {
    try {
      const { notificationId } = req.params;
      const { userId } = req.body;

      if (!notificationId || !userId) {
        throw new ApiError(400, 'Notification ID and User ID are required');
      }

      await NotificationService.markAsRead(notificationId, userId);

      res.status(200).json({
        success: true,
        message: 'Notification marked as read',
      });
    } catch (error) {
      if (error instanceof ApiError) {
        res.status(error.statusCode).json({
          success: false,
          message: error.message,
        });
      } else {
        res.status(500).json({
          success: false,
          message: 'Internal server error',
        });
      }
    }
  }

  /**
   * Mark all notifications as read for a user
   */
  static async markAllAsRead(req: Request, res: Response) {
    try {
      const { userId } = req.params;

      if (!userId) {
        throw new ApiError(400, 'User ID is required');
      }

      await NotificationService.markAllAsRead(userId);

      res.status(200).json({
        success: true,
        message: 'All notifications marked as read',
      });
    } catch (error) {
      if (error instanceof ApiError) {
        res.status(error.statusCode).json({
          success: false,
          message: error.message,
        });
      } else {
        res.status(500).json({
          success: false,
          message: 'Internal server error',
        });
      }
    }
  }

  /**
   * Delete notification
   */
  static async deleteNotification(req: Request, res: Response) {
    try {
      const { notificationId } = req.params;
      const { userId } = req.body;

      if (!notificationId || !userId) {
        throw new ApiError(400, 'Notification ID and User ID are required');
      }

      await NotificationService.deleteNotification(notificationId, userId);

      res.status(200).json({
        success: true,
        message: 'Notification deleted successfully',
      });
    } catch (error) {
      if (error instanceof ApiError) {
        res.status(error.statusCode).json({
          success: false,
          message: error.message,
        });
      } else {
        res.status(500).json({
          success: false,
          message: 'Internal server error',
        });
      }
    }
  }

  /**
   * Get notification statistics for a user
   */
  static async getNotificationStats(req: Request, res: Response) {
    try {
      const { userId } = req.params;

      if (!userId) {
        throw new ApiError(400, 'User ID is required');
      }

      const stats = await NotificationService.getNotificationStats(userId);

      res.status(200).json({
        success: true,
        data: stats,
      });
    } catch (error) {
      if (error instanceof ApiError) {
        res.status(error.statusCode).json({
          success: false,
          message: error.message,
        });
      } else {
        res.status(500).json({
          success: false,
          message: 'Internal server error',
        });
      }
    }
  }

  /**
   * Accept booking request from notification
   */
  static async acceptBookingRequest(req: Request, res: Response) {
    try {
      const { bookingId } = req.params;
      const user = (req as any).user;

      if (!user) {
        throw new ApiError(401, 'Authentication required');
      }

      if (!bookingId) {
        throw new ApiError(400, 'Booking ID is required');
      }

      const bookingIdNum = parseInt(bookingId, 10);
      const booking = await bookingManagementService.confirmBooking(bookingIdNum, user.id);

      // Send notification to client about acceptance
      try {
        await NotificationService.sendToUser(booking.client.user_id, {
          title: 'Booking Confirmed',
          body: `Your booking for "${booking.post.title}" has been confirmed!`,
          data: {
            type: 'booking_confirmed',
            booking_id: bookingId,
            post_id: booking.post.id.toString(),
          },
        });
      } catch (notificationError) {
        console.error('Failed to send booking confirmation notification:', notificationError);
      }

      res.status(200).json({
        success: true,
        message: 'Booking request accepted successfully',
        data: booking,
      });
    } catch (error) {
      if (error instanceof ApiError) {
        res.status(error.statusCode).json({
          success: false,
          message: error.message,
        });
      } else {
        res.status(500).json({
          success: false,
          message: 'Internal server error',
        });
      }
    }
  }

  /**
   * Reject booking request from notification
   */
  static async rejectBookingRequest(req: Request, res: Response) {
    try {
      const { bookingId } = req.params;
      const user = (req as any).user;

      if (!user) {
        throw new ApiError(401, 'Authentication required');
      }

      if (!bookingId) {
        throw new ApiError(400, 'Booking ID is required');
      }

      const bookingIdNum = parseInt(bookingId, 10);
      const booking = await bookingManagementService.cancelBooking(bookingIdNum, user.id);

      // Send notification to client about rejection
      try {
        await NotificationService.sendToUser(booking.client.user_id, {
          title: 'Booking Request Declined',
          body: `Unfortunately, your booking request for "${booking.post.title}" has been declined.`,
          data: {
            type: 'booking_rejected',
            booking_id: bookingId,
            post_id: booking.post.id.toString(),
          },
        });
      } catch (notificationError) {
        console.error('Failed to send booking rejection notification:', notificationError);
      }

      res.status(200).json({
        success: true,
        message: 'Booking request rejected successfully',
        data: booking,
      });
    } catch (error) {
      if (error instanceof ApiError) {
        res.status(error.statusCode).json({
          success: false,
          message: error.message,
        });
      } else {
        res.status(500).json({
          success: false,
          message: 'Internal server error',
        });
      }
    }
  }
}