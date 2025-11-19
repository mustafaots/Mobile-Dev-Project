import 'base_repository.dart';

/// Repository for managing subscription data
class SubscriptionRepository extends BaseRepository {
  /// Insert a new subscription
  Future<int> insertSubscription({
    required int subscriber,
    required String plan,
    required DateTime expiresAt,
    bool isActive = true,
  }) async {
    return await db.insert('subscriptions', {
      'subscriber': subscriber,
      'plan': plan,
      'created_at': DateTime.now().toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'is_active': isActive ? 1 : 0,
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
    int subscriber,
  ) async {
    return await db.query(
      'subscriptions',
      where: 'subscriber = ?',
      whereArgs: [subscriber],
    );
  }

  /// Get all active subscriptions
  Future<List<Map<String, dynamic>>> getActiveSubscriptions() async {
    return await db.query(
      'subscriptions',
      where: 'is_active = ?',
      whereArgs: [1],
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
