import 'package:sqflite/sqflite.dart';

/// Repository for managing subscription data
class SubscriptionRepository {
  final Database db;

  SubscriptionRepository(this.db);

  /// Insert a new subscription
  Future<int> insertSubscription({
    required int subscriberId,
    String? plan,
  }) async {
    return await db.insert('subscriptions', {
      'subscriber_id': subscriberId,
      'plan': plan ?? 'free',
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

  /// Get latest subscription by subscriber
  Future<Map<String, dynamic>?> getLatestSubscriptionBySubscriber(
    int subscriberId,
  ) async {
    final result = await db.query(
      'subscriptions',
      where: 'subscriber_id = ?',
      whereArgs: [subscriberId],
      orderBy: 'created_at DESC',
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
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

  /// Get subscriptions by plan
  Future<List<Map<String, dynamic>>> getSubscriptionsByPlan(String plan) async {
    return await db.query(
      'subscriptions',
      where: 'plan = ?',
      whereArgs: [plan],
    );
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
}
