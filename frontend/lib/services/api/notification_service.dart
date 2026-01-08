import 'package:easy_vacation/services/api/api_client.dart';
import 'package:easy_vacation/services/api/api_response.dart';

/// Service for handling notification-related API operations
class NotificationService {
  static NotificationService? _instance;

  // Private constructor
  NotificationService._();

  /// Get singleton instance
  static NotificationService get instance {
    _instance ??= NotificationService._();
    return _instance!;
  }

  /// Register FCM token for a user
  Future<ApiResponse<void>> registerFCMToken(String userId, String token) async {
    try {
      final response = await ApiClient.instance.post(
        '/notifications/register-token',
        body: {
          'userId': userId,
          'fcmToken': token,
          'platform': 'mobile', // or 'web' if needed
        },
        requiresAuth: true,
      );

      return ApiResponse.success(response);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Unregister FCM token for a user (logout)
  Future<ApiResponse<void>> unregisterFCMToken(String userId) async {
    try {
      final response = await ApiClient.instance.post(
        '/notifications/unregister-token',
        body: {'userId': userId},
        requiresAuth: true,
      );

      return ApiResponse.success(response);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Send notification to specific user
  Future<ApiResponse<void>> sendNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        '/notifications/send',
        body: {
          'userId': userId,
          'title': title,
          'body': body,
          'data': data ?? {},
        },
        requiresAuth: true,
      );

      return ApiResponse.success(response);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Send notification to multiple users
  Future<ApiResponse<void>> sendBulkNotification({
    required List<String> userIds,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        '/notifications/send-bulk',
        body: {
          'userIds': userIds,
          'title': title,
          'body': body,
          'data': data ?? {},
        },
        requiresAuth: true,
      );

      return ApiResponse.success(response);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Send notification to topic
  Future<ApiResponse<void>> sendTopicNotification({
    required String topic,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await ApiClient.instance.post(
        '/notifications/send-topic',
        body: {
          'topic': topic,
          'title': title,
          'body': body,
          'data': data ?? {},
        },
        requiresAuth: true,
      );

      return ApiResponse.success(response);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get user's notification history
  Future<ApiResponse<List<Map<String, dynamic>>>> getUserNotifications(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await ApiClient.instance.get(
        '/notifications/user/$userId',
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
        requiresAuth: true,
      );

      return ApiResponse.success(List<Map<String, dynamic>>.from(response));
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Mark notification as read
  Future<ApiResponse<void>> markAsRead(String notificationId) async {
    try {
      final response = await ApiClient.instance.patch(
        '/notifications/$notificationId/read',
      );

      return ApiResponse.success(response);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Mark all notifications as read for a user
  Future<ApiResponse<void>> markAllAsRead(String userId) async {
    try {
      final response = await ApiClient.instance.patch(
        '/notifications/user/$userId/read-all',
      );

      return ApiResponse.success(response);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Delete notification
  Future<ApiResponse<void>> deleteNotification(String notificationId) async {
    try {
      final response = await ApiClient.instance.delete(
        '/notifications/$notificationId',
      );

      return ApiResponse.success(response);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get notification statistics
  Future<ApiResponse<Map<String, dynamic>>> getNotificationStats(String userId) async {
    try {
      final response = await ApiClient.instance.get(
        '/notifications/stats/$userId',
      );

      return ApiResponse.success(Map<String, dynamic>.from(response));
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Accept booking request from notification
  Future<ApiResponse<Map<String, dynamic>>> acceptBookingRequest(String bookingId) async {
    try {
      final response = await ApiClient.instance.post(
        '/notifications/booking/$bookingId/accept',
        requiresAuth: true,
      );

      return ApiResponse.success(Map<String, dynamic>.from(response));
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Reject booking request from notification
  Future<ApiResponse<Map<String, dynamic>>> rejectBookingRequest(String bookingId) async {
    try {
      final response = await ApiClient.instance.post(
        '/notifications/booking/$bookingId/reject',
        requiresAuth: true,
      );

      return ApiResponse.success(Map<String, dynamic>.from(response));
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}