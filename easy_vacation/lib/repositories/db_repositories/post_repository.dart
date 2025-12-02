import 'package:sqflite/sqflite.dart';

/// Repository for managing posts and post-related data (stays, activities, vehicles)
class PostRepository {
  final Database db;

  PostRepository(this.db);
  // ============= POSTS OPERATIONS =============

  /// Insert a new post
  Future<int> insertPost({
    required int ownerId,
    required String title,
    required String description,
    String? category,
    int? locationId,
    double? price,
    String? contentUrl,
    bool isPaid = false,
    String? status,
    String? availability,
  }) async {
    return await db.insert('posts', {
      'owner_id': ownerId,
      'title': title,
      'description': description,
      'category': category,
      'location_id': locationId,
      'price': price,
      'content_url': contentUrl,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'is_paid': isPaid ? 1 : 0,
      'status': status ?? 'active',
      'availability': availability,
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
    return await db.query('posts', where: 'owner_id = ?', whereArgs: [ownerId]);
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
    required int postId,
    String? stayType,
    double? area,
    int? bedrooms,
  }) async {
    return await db.insert('stays', {
      'post_id': postId,
      'stay_type': stayType,
      'area': area,
      'bedrooms': bedrooms,
    });
  }

  /// Get stay by ID
  Future<Map<String, dynamic>?> getStayById(int postId) async {
    final result = await db.query(
      'stays',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get stay by post ID
  Future<Map<String, dynamic>?> getStayByPostId(int postId) async {
    final result = await db.query(
      'stays',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all stays
  Future<List<Map<String, dynamic>>> getAllStays() async {
    return await db.query('stays');
  }

  /// Update stay
  Future<int> updateStay(int postId, Map<String, dynamic> values) async {
    return await db.update(
      'stays',
      values,
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  /// Delete stay
  Future<int> deleteStay(int postId) async {
    return await db.delete('stays', where: 'post_id = ?', whereArgs: [postId]);
  }

  // ============= ACTIVITIES OPERATIONS =============

  /// Insert a new activity
  Future<int> insertActivity({
    required int postId,
    String? activityType,
    String? requirements,
  }) async {
    return await db.insert('activities', {
      'post_id': postId,
      'activity_type': activityType,
      'requirements': requirements,
    });
  }

  /// Get activity by ID
  Future<Map<String, dynamic>?> getActivityById(int postId) async {
    final result = await db.query(
      'activities',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get activity by post ID
  Future<Map<String, dynamic>?> getActivityByPostId(int postId) async {
    final result = await db.query(
      'activities',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all activities
  Future<List<Map<String, dynamic>>> getAllActivities() async {
    return await db.query('activities');
  }

  /// Update activity
  Future<int> updateActivity(int postId, Map<String, dynamic> values) async {
    return await db.update(
      'activities',
      values,
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  /// Delete activity
  Future<int> deleteActivity(int postId) async {
    return await db.delete(
      'activities',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  // ============= VEHICLES OPERATIONS =============

  /// Insert a new vehicle
  Future<int> insertVehicle({
    required int postId,
    String? vehicleType,
    String? model,
    int? year,
    String? fuelType,
    bool? transmission,
    int? seats,
    String? features,
  }) async {
    return await db.insert('vehicles', {
      'post_id': postId,
      'vehicle_type': vehicleType,
      'model': model,
      'year': year,
      'fuel_type': fuelType,
      'transmission': transmission != null ? (transmission ? 1 : 0) : null,
      'seats': seats,
      'features': features,
    });
  }

  /// Get vehicle by ID
  Future<Map<String, dynamic>?> getVehicleById(int postId) async {
    final result = await db.query(
      'vehicles',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get vehicle by post ID
  Future<Map<String, dynamic>?> getVehicleByPostId(int postId) async {
    final result = await db.query(
      'vehicles',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all vehicles
  Future<List<Map<String, dynamic>>> getAllVehicles() async {
    return await db.query('vehicles');
  }

  /// Update vehicle
  Future<int> updateVehicle(int postId, Map<String, dynamic> values) async {
    return await db.update(
      'vehicles',
      values,
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  /// Delete vehicle
  Future<int> deleteVehicle(int postId) async {
    return await db.delete(
      'vehicles',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  // ============= POST_IMAGES OPERATIONS =============

  /// Insert a new post image
  Future<int> insertPostImage({
    required int postId,
    required List<int> image,
  }) async {
    return await db.insert('post_images', {'post_id': postId, 'image': image});
  }

  /// Get post image by post ID
  Future<Map<String, dynamic>?> getPostImageByPostId(int postId) async {
    final result = await db.query(
      'post_images',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all post images
  Future<List<Map<String, dynamic>>> getAllPostImages() async {
    return await db.query('post_images');
  }

  /// Update post image
  Future<int> updatePostImage(int postId, Map<String, dynamic> values) async {
    return await db.update(
      'post_images',
      values,
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  /// Delete post image
  Future<int> deletePostImage(int postId) async {
    return await db.delete(
      'post_images',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }
}
