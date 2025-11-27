import 'package:sqflite/sqflite.dart';

/// Repository for managing subscription data
class SubscriptionRepository {
  final Database db;

  SubscriptionRepository(this.db);

  /// Insert a new subscription
  Future<int> insertSubscription({
    required int subscriberId,
    required int hostId,
  }) async {
    return await db.insert('subscriptions', {
      'subscriber_id': subscriberId,
      'host_id': hostId,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get subscription by ID
  Future<Map<String, dynamic>?> getSubscriptionById(int id) async {
    final result = await db.query(
      'subscriptions',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all subscriptions
  Future<List<Map<String, dynamic>>> getAllSubscriptions() async {
    return await db.query('subscriptions');
  }

  /// Get subscriptions by subscriber
  Future<List<Map<String, dynamic>>> getSubscriptionsBySubscriber(
    int subscriberId,
  ) async {
    return await db.query(
      'subscriptions',
      where: 'subscriber_id = ?',
      whereArgs: [subscriberId],
    );
  }

  /// Get subscriptions by host
  Future<List<Map<String, dynamic>>> getSubscriptionsByHost(int hostId) async {
    return await db.query(
      'subscriptions',
      where: 'host_id = ?',
      whereArgs: [hostId],
    );
  }

  /// Check if user is subscribed to host
  Future<bool> isSubscribed(int subscriberId, int hostId) async {
    final result = await db.query(
      'subscriptions',
      where: 'subscriber_id = ? AND host_id = ?',
      whereArgs: [subscriberId, hostId],
    );
    return result.isNotEmpty;
  }

  /// Update subscription
  Future<int> updateSubscription(int id, Map<String, dynamic> values) async {
    return await db.update(
      'subscriptions',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete subscription
  Future<int> deleteSubscription(int id) async {
    return await db.delete('subscriptions', where: 'id = ?', whereArgs: [id]);
  }

  /// Delete subscription by subscriber and host
  Future<int> deleteSubscriptionByUsers(int subscriberId, int hostId) async {
    return await db.delete(
      'subscriptions',
      where: 'subscriber_id = ? AND host_id = ?',
      whereArgs: [subscriberId, hostId],
    );
  }
}
