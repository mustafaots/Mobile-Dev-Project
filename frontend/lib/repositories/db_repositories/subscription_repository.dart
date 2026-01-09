import 'package:sqflite/sqflite.dart';
import '../../models/subscriptions.model.dart';

/// Repository for managing subscription data
class SubscriptionRepository {
  final Database db;

  SubscriptionRepository(this.db);

  /// Insert a new subscription
  Future<int> insertSubscription(Subscription subscription) async {
    return await db.insert('subscriptions', subscription.toMap());
  }

  /// Get subscription by ID
  Future<Subscription?> getSubscriptionById(int id) async {
    final result = await db.query(
      'subscriptions',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Subscription.fromMap(result.first) : null;
  }

  /// Get all subscriptions
  Future<List<Subscription>> getAllSubscriptions() async {
    final results = await db.query('subscriptions');
    return results.map((map) => Subscription.fromMap(map)).toList();
  }

  /// Get latest subscription by subscriber
  Future<Subscription?> getLatestSubscriptionBySubscriber(
    String subscriberId,
  ) async {
    final result = await db.query(
      'subscriptions',
      where: 'subscriber_id = ?',
      whereArgs: [subscriberId],
      orderBy: 'created_at DESC',
      limit: 1,
    );
    return result.isNotEmpty ? Subscription.fromMap(result.first) : null;
  }

  /// Get subscriptions by subscriber
  Future<List<Subscription>> getSubscriptionsBySubscriber(
    String subscriberId,
  ) async {
    final results = await db.query(
      'subscriptions',
      where: 'subscriber_id = ?',
      whereArgs: [subscriberId],
    );
    return results.map((map) => Subscription.fromMap(map)).toList();
  }

  /// Get subscriptions by plan
  Future<List<Subscription>> getSubscriptionsByPlan(String plan) async {
    final results = await db.query(
      'subscriptions',
      where: 'plan = ?',
      whereArgs: [plan],
    );
    return results.map((map) => Subscription.fromMap(map)).toList();
  }

  /// Update subscription
  Future<int> updateSubscription(int id, Subscription subscription) async {
    final values = subscription.toMap();
    values.remove('id'); // Remove ID to avoid updating it
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
