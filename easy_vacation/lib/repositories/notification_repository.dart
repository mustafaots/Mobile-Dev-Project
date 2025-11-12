import 'base_repository.dart';

/// Repository for managing notification data
class NotificationRepository extends BaseRepository {
  /// Insert a new notification
  Future<int> insertNotification({
    required int userId,
    required String message,
    String? type,
    bool isRead = false,
  }) async {
    return await db.insert('notifications', {
      'user_id': userId,
      'message': message,
      'type': type,
      'is_read': isRead ? 1 : 0,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get notification by ID
  Future<Map<String, dynamic>?> getNotificationById(int id) async {
    final result = await db.query(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all notifications
  Future<List<Map<String, dynamic>>> getAllNotifications() async {
    return await db.query('notifications');
  }

  /// Get notifications by user ID
  Future<List<Map<String, dynamic>>> getNotificationsByUserId(
    int userId,
  ) async {
    return await db.query(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Get unread notifications for a user
  Future<List<Map<String, dynamic>>> getUnreadNotificationsByUserId(
    int userId,
  ) async {
    return await db.query(
      'notifications',
      where: 'user_id = ? AND is_read = ?',
      whereArgs: [userId, 0],
    );
  }

  /// Mark notification as read
  Future<int> markNotificationAsRead(int id) async {
    return await db.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Update notification
  Future<int> updateNotification(int id, Map<String, dynamic> values) async {
    return await db.update(
      'notifications',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete notification
  Future<int> deleteNotification(int id) async {
    return await db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }
}
