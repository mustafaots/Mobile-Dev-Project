import 'base_repository.dart';

/// Repository for managing posts and post-related data (stays, activities, vehicles)
class PostRepository extends BaseRepository {
  // ============= POSTS OPERATIONS =============

  /// Insert a new post
  Future<int> insertPost({
    required int owner,
    required String title,
    required String description,
    String? category,
    int? locationId,
    bool isPaid = false,
  }) async {
    return await db.insert('posts', {
      'owner': owner,
      'title': title,
      'description': description,
      'category': category,
      'location_id': locationId,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'is_paid': isPaid ? 1 : 0,
    });
  }

  /// Get post by ID
  Future<Map<String, dynamic>?> getPostById(int id) async {
    final result = await db.query('posts', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all posts
  Future<List<Map<String, dynamic>>> getAllPosts() async {
    return await db.query('posts');
  }

  /// Get posts by owner
  Future<List<Map<String, dynamic>>> getPostsByOwner(int ownerId) async {
    return await db.query('posts', where: 'owner = ?', whereArgs: [ownerId]);
  }

  /// Get posts by category
  Future<List<Map<String, dynamic>>> getPostsByCategory(String category) async {
    return await db.query(
      'posts',
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  /// Get posts by location
  Future<List<Map<String, dynamic>>> getPostsByLocation(int locationId) async {
    return await db.query(
      'posts',
      where: 'location_id = ?',
      whereArgs: [locationId],
    );
  }

  /// Update post
  Future<int> updatePost(int id, Map<String, dynamic> values) async {
    values['updated_at'] = DateTime.now().toIso8601String();
    return await db.update('posts', values, where: 'id = ?', whereArgs: [id]);
  }

  /// Delete post
  Future<int> deletePost(int id) async {
    return await db.delete('posts', where: 'id = ?', whereArgs: [id]);
  }

  // ============= STAYS OPERATIONS =============

  /// Insert a new stay
  Future<int> insertStay({
    required int id,
    required double price,
    String? content,
  }) async {
    return await db.insert('stays', {
      'id': id,
      'price': price,
      'content': content,
    });
  }

  /// Get stay by ID
  Future<Map<String, dynamic>?> getStayById(int id) async {
    final result = await db.query('stays', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all stays
  Future<List<Map<String, dynamic>>> getAllStays() async {
    return await db.query('stays');
  }

  /// Update stay
  Future<int> updateStay(int id, Map<String, dynamic> values) async {
    return await db.update('stays', values, where: 'id = ?', whereArgs: [id]);
  }

  /// Delete stay
  Future<int> deleteStay(int id) async {
    return await db.delete('stays', where: 'id = ?', whereArgs: [id]);
  }

  // ============= ACTIVITIES OPERATIONS =============

  /// Insert a new activity
  Future<int> insertActivity({
    required int id,
    required double price,
    String? content,
  }) async {
    return await db.insert('activities', {
      'id': id,
      'price': price,
      'content': content,
    });
  }

  /// Get activity by ID
  Future<Map<String, dynamic>?> getActivityById(int id) async {
    final result = await db.query(
      'activities',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all activities
  Future<List<Map<String, dynamic>>> getAllActivities() async {
    return await db.query('activities');
  }

  /// Update activity
  Future<int> updateActivity(int id, Map<String, dynamic> values) async {
    return await db.update(
      'activities',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete activity
  Future<int> deleteActivity(int id) async {
    return await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  // ============= VEHICLES OPERATIONS =============

  /// Insert a new vehicle
  Future<int> insertVehicle({
    required int id,
    required double price,
    String? content,
  }) async {
    return await db.insert('vehicles', {
      'id': id,
      'price': price,
      'content': content,
    });
  }

  /// Get vehicle by ID
  Future<Map<String, dynamic>?> getVehicleById(int id) async {
    final result = await db.query('vehicles', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all vehicles
  Future<List<Map<String, dynamic>>> getAllVehicles() async {
    return await db.query('vehicles');
  }

  /// Update vehicle
  Future<int> updateVehicle(int id, Map<String, dynamic> values) async {
    return await db.update(
      'vehicles',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete vehicle
  Future<int> deleteVehicle(int id) async {
    return await db.delete('vehicles', where: 'id = ?', whereArgs: [id]);
  }
}
