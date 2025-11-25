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
    int? bedrooms,
    int? bathrooms,
    int? maxGuests,
    String? amenities,
    String? checkInTime,
    String? checkOutTime,
    double? sizeSqft,
  }) async {
    return await db.insert('stays', {
      'post_id': postId,
      'stay_type': stayType,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'max_guests': maxGuests,
      'amenities': amenities,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'size_sqft': sizeSqft,
    });
  }

  /// Get stay by ID
  Future<Map<String, dynamic>?> getStayById(int id) async {
    final result = await db.query('stays', where: 'id = ?', whereArgs: [id]);
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
    required int postId,
    String? activityType,
    int? durationHours,
    String? difficultyLevel,
    int? minAge,
    String? includedItems,
    String? requirements,
    int? groupSizeMax,
  }) async {
    return await db.insert('activities', {
      'post_id': postId,
      'activity_type': activityType,
      'duration_hours': durationHours,
      'difficulty_level': difficultyLevel,
      'min_age': minAge,
      'included_items': includedItems,
      'requirements': requirements,
      'group_size_max': groupSizeMax,
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
    required int postId,
    String? vehicleType,
    String? make,
    String? model,
    int? year,
    String? fuelType,
    String? transmission,
    int? seats,
    String? features,
    int? mileageKm,
  }) async {
    return await db.insert('vehicles', {
      'post_id': postId,
      'vehicle_type': vehicleType,
      'make': make,
      'model': model,
      'year': year,
      'fuel_type': fuelType,
      'transmission': transmission,
      'seats': seats,
      'features': features,
      'mileage_km': mileageKm,
    });
  }

  /// Get vehicle by ID
  Future<Map<String, dynamic>?> getVehicleById(int id) async {
    final result = await db.query('vehicles', where: 'id = ?', whereArgs: [id]);
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
