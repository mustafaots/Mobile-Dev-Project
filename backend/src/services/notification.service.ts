import { messaging } from 'firebase-admin';
import { supabase } from '../config';

export interface NotificationPayload {
  title: string;
  body: string;
  data?: { [key: string]: string };
}

export interface FCMToken {
  id: string;
  user_id: string;
  fcm_token: string;
  platform: string;
  created_at: string;
  updated_at: string;
}

export class NotificationService {
  /**
   * Register FCM token for a user
   */
  static async registerFCMToken(
    userId: string,
    fcmToken: string,
    platform: string = 'mobile'
  ): Promise<void> {
    try {
      // Check if token already exists for this user
      const { data: existingToken } = await supabase
        .from('fcm_tokens')
        .select('id')
        .eq('user_id', userId)
        .eq('fcm_token', fcmToken)
        .single();

      if (existingToken) {
        // Update existing token
        await supabase
          .from('fcm_tokens')
          .update({
            updated_at: new Date().toISOString(),
            platform,
          })
          .eq('id', existingToken.id);
      } else {
        // Insert new token
        await supabase
          .from('fcm_tokens')
          .insert({
            user_id: userId,
            fcm_token: fcmToken,
            platform,
          });
      }
    } catch (error) {
      console.error('Error registering FCM token:', error);
      throw new Error('Failed to register FCM token');
    }
  }

  /**
   * Unregister FCM token for a user
   */
  static async unregisterFCMToken(userId: string): Promise<void> {
    try {
      await supabase
        .from('fcm_tokens')
        .delete()
        .eq('user_id', userId);
    } catch (error) {
      console.error('Error unregistering FCM token:', error);
      throw new Error('Failed to unregister FCM token');
    }
  }

  /**
   * Send notification to a specific user
   */
  static async sendToUser(
    userId: string,
    payload: NotificationPayload
  ): Promise<void> {
    try {
      // Get FCM tokens for the user
      const { data: tokens, error } = await supabase
        .from('fcm_tokens')
        .select('fcm_token')
        .eq('user_id', userId);

      if (error || !tokens || tokens.length === 0) {
        console.warn(`No FCM tokens found for user ${userId}`);
        return;
      }

      // Send to all tokens
      const tokensList = tokens.map((t: any) => t.fcm_token);

      await this.sendMulticast(tokensList, payload);

      // Store notification in database
      await this.storeNotification(userId, payload);

    } catch (error) {
      console.error('Error sending notification to user:', error);
      throw new Error('Failed to send notification');
    }
  }

  /**
   * Send notification to multiple users
   */
  static async sendToUsers(
    userIds: string[],
    payload: NotificationPayload
  ): Promise<void> {
    try {
      // Get FCM tokens for all users
      const { data: tokens, error } = await supabase
        .from('fcm_tokens')
        .select('fcm_token, user_id')
        .in('user_id', userIds);

      if (error || !tokens || tokens.length === 0) {
        console.warn('No FCM tokens found for the specified users');
        return;
      }

      // Group tokens by user
      const userTokensMap = new Map<string, string[]>();
      tokens.forEach((token: any) => {
        if (!userTokensMap.has(token.user_id)) {
          userTokensMap.set(token.user_id, []);
        }
        userTokensMap.get(token.user_id)!.push(token.fcm_token);
      });

      // Send to all tokens
      const allTokens = tokens.map((t: any) => t.fcm_token);
      await this.sendMulticast(allTokens, payload);

      // Store notifications in database
      for (const userId of userIds) {
        await this.storeNotification(userId, payload);
      }

    } catch (error) {
      console.error('Error sending notifications to users:', error);
      throw new Error('Failed to send notifications');
    }
  }

  /**
   * Send notification to a topic
   */
  static async sendToTopic(
    topic: string,
    payload: NotificationPayload
  ): Promise<void> {
    try {
      const message: messaging.Message = {
        topic,
        notification: {
          title: payload.title,
          body: payload.body,
        },
        data: payload.data,
      };

      const response = await messaging().send(message);
      console.log('Successfully sent topic notification:', response);

    } catch (error) {
      console.error('Error sending topic notification:', error);
      throw new Error('Failed to send topic notification');
    }
  }

  /**
   * Send multicast notification
   */
  private static async sendMulticast(
    tokens: string[],
    payload: NotificationPayload
  ): Promise<void> {
    try {
      const message: messaging.MulticastMessage = {
        tokens,
        notification: {
          title: payload.title,
          body: payload.body,
        },
        data: payload.data,
      };

      const response = await messaging().sendMulticast(message);

      // Handle failed tokens
      if (response.failureCount > 0) {
        const failedTokens: string[] = [];
        response.responses.forEach((resp, idx) => {
          if (!resp.success) {
            failedTokens.push(tokens[idx]);
          }
        });

        // Remove invalid tokens from database
        if (failedTokens.length > 0) {
          await this.removeInvalidTokens(failedTokens);
        }
      }

      console.log(`Successfully sent multicast notification to ${response.successCount} devices`);

    } catch (error) {
      console.error('Error sending multicast notification:', error);
      throw new Error('Failed to send multicast notification');
    }
  }

  /**
   * Store notification in database
   */
  private static async storeNotification(
    userId: string,
    payload: NotificationPayload
  ): Promise<void> {
    try {
      await supabase
        .from('notifications')
        .insert({
          user_id: userId,
          title: payload.title,
          body: payload.body,
          data: payload.data || {},
          type: payload.data?.type || 'general',
          is_read: false,
        });
    } catch (error) {
      console.error('Error storing notification:', error);
      // Don't throw here as the notification was already sent
    }
  }

  /**
   * Remove invalid FCM tokens
   */
  private static async removeInvalidTokens(tokens: string[]): Promise<void> {
    try {
      await supabase
        .from('fcm_tokens')
        .delete()
        .in('fcm_token', tokens);
    } catch (error) {
      console.error('Error removing invalid tokens:', error);
    }
  }

  /**
   * Get user's notifications
   */
  static async getUserNotifications(
    userId: string,
    page: number = 1,
    limit: number = 20
  ): Promise<{ notifications: any[]; total: number }> {
    try {
      const offset = (page - 1) * limit;

      const { data: notifications, error, count } = await supabase
        .from('notifications')
        .select('*', { count: 'exact' })
        .eq('user_id', userId)
        .order('created_at', { ascending: false })
        .range(offset, offset + limit - 1);

      if (error) {
        throw error;
      }

      return {
        notifications: notifications || [],
        total: count || 0,
      };
    } catch (error) {
      console.error('Error getting user notifications:', error);
      throw new Error('Failed to get notifications');
    }
  }

  /**
   * Mark notification as read
   */
  static async markAsRead(notificationId: string, userId: string): Promise<void> {
    try {
      const { error } = await supabase
        .from('notifications')
        .update({ is_read: true })
        .eq('id', notificationId)
        .eq('user_id', userId);

      if (error) {
        throw error;
      }
    } catch (error) {
      console.error('Error marking notification as read:', error);
      throw new Error('Failed to mark notification as read');
    }
  }

  /**
   * Mark all notifications as read for a user
   */
  static async markAllAsRead(userId: string): Promise<void> {
    try {
      const { error } = await supabase
        .from('notifications')
        .update({ is_read: true })
        .eq('user_id', userId)
        .eq('is_read', false);

      if (error) {
        throw error;
      }
    } catch (error) {
      console.error('Error marking all notifications as read:', error);
      throw new Error('Failed to mark all notifications as read');
    }
  }

  /**
   * Delete notification
   */
  static async deleteNotification(notificationId: string, userId: string): Promise<void> {
    try {
      const { error } = await supabase
        .from('notifications')
        .delete()
        .eq('id', notificationId)
        .eq('user_id', userId);

      if (error) {
        throw error;
      }
    } catch (error) {
      console.error('Error deleting notification:', error);
      throw new Error('Failed to delete notification');
    }
  }

  /**
   * Get notification statistics for a user
   */
  static async getNotificationStats(userId: string): Promise<{
    total: number;
    unread: number;
    today: number;
  }> {
    try {
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const todayStr = today.toISOString();

      // Get total count
      const { count: total } = await supabase
        .from('notifications')
        .select('*', { count: 'exact', head: true })
        .eq('user_id', userId);

      // Get unread count
      const { count: unread } = await supabase
        .from('notifications')
        .select('*', { count: 'exact', head: true })
        .eq('user_id', userId)
        .eq('is_read', false);

      // Get today's count
      const { count: todayCount } = await supabase
        .from('notifications')
        .select('*', { count: 'exact', head: true })
        .eq('user_id', userId)
        .gte('created_at', todayStr);

      return {
        total: total || 0,
        unread: unread || 0,
        today: todayCount || 0,
      };
    } catch (error) {
      console.error('Error getting notification stats:', error);
      throw new Error('Failed to get notification statistics');
    }
  }
}