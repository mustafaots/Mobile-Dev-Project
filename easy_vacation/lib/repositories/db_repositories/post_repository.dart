import 'package:easy_vacation/models/details.model.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/posts.model.dart';
import '../../models/stays.model.dart';
import '../../models/activities.model.dart';
import '../../models/vehicles.model.dart';
import '../../models/post_images.model.dart';

/// Repository for managing posts and post-related data (stays, activities, vehicles)
class PostRepository {
  final Database db;

  PostRepository(this.db);
  // ============= POSTS OPERATIONS =============

  /// Insert a new post
  Future<int> insertPost(Post post) async {
    return await db.insert('posts', post.toMap());
  }

  /// Get post by ID
  Future<Post?> getPostById(int id) async {
    final result = await db.query('posts', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Post.fromMap(result.first) : null;
  }

  /// Get all posts
  Future<List<Post>> getAllPosts() async {
    final results = await db.query('posts');
    return results.map((map) => Post.fromMap(map)).toList();
  }

  /// Get posts by owner
  Future<List<Post>> getPostsByOwner(int ownerId) async {
    final results = await db.query(
      'posts',
      where: 'owner_id = ?',
      whereArgs: [ownerId],
    );
    return results.map((map) => Post.fromMap(map)).toList();
  }

  /// Get posts by category
  Future<List<Post>> getPostsByCategory(String category) async {
    final results = await db.query(
      'posts',
      where: 'category = ?',
      whereArgs: [category],
    );
    return results.map((map) => Post.fromMap(map)).toList();
  }

  /// Get posts by location
  Future<List<Post>> getPostsByLocation(int locationId) async {
    final results = await db.query(
      'posts',
      where: 'location_id = ?',
      whereArgs: [locationId],
    );
    return results.map((map) => Post.fromMap(map)).toList();
  }

  /// Update post
  Future<int> updatePost(int id, Post post) async {
    final values = post.toMap();
    values.remove('id'); // Remove ID to avoid updating it
    return await db.update('posts', values, where: 'id = ?', whereArgs: [id]);
  }

  /// Delete post
  Future<int> deletePost(int id) async {
    return await db.delete('posts', where: 'id = ?', whereArgs: [id]);
  }

  // ============= STAYS OPERATIONS =============

  /// Insert a new stay
  Future<int> insertStay(Stay stay) async {
    return await db.insert('stays', stay.toMap());
  }

  /// Get stay by ID
  Future<Stay?> getStayById(int postId) async {
    final result = await db.query(
      'stays',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return result.isNotEmpty ? Stay.fromMap(result.first) : null;
  }

  /// Get stay by post ID
  Future<Stay?> getStayByPostId(int postId) async {
    final result = await db.query(
      'stays',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return result.isNotEmpty ? Stay.fromMap(result.first) : null;
  }

  /// Get all stays
  Future<List<Stay>> getAllStays() async {
    final results = await db.query('stays');
    return results.map((map) => Stay.fromMap(map)).toList();
  }

  /// Update stay
  Future<int> updateStay(int postId, Stay stay) async {
    final values = stay.toMap();
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
  Future<int> insertActivity(Activity activity) async {
    return await db.insert('activities', activity.toMap());
  }

  /// Get activity by ID
  Future<Activity?> getActivityById(int postId) async {
    final result = await db.query(
      'activities',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return result.isNotEmpty ? Activity.fromMap(result.first) : null;
  }

  /// Get activity by post ID
  Future<Activity?> getActivityByPostId(int postId) async {
    final result = await db.query(
      'activities',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return result.isNotEmpty ? Activity.fromMap(result.first) : null;
  }

  /// Get all activities
  Future<List<Activity>> getAllActivities() async {
    final results = await db.query('activities');
    return results.map((map) => Activity.fromMap(map)).toList();
  }

  /// Update activity
  Future<int> updateActivity(int postId, Activity activity) async {
    final values = activity.toMap();
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
  Future<int> insertVehicle(Vehicle vehicle) async {
    return await db.insert('vehicles', vehicle.toMap());
  }

  /// Get vehicle by ID
  Future<Vehicle?> getVehicleById(int postId) async {
    final result = await db.query(
      'vehicles',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return result.isNotEmpty ? Vehicle.fromMap(result.first) : null;
  }

  /// Get vehicle by post ID
  Future<Vehicle?> getVehicleByPostId(int postId) async {
    final result = await db.query(
      'vehicles',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return result.isNotEmpty ? Vehicle.fromMap(result.first) : null;
  }

  /// Get all vehicles
  Future<List<Vehicle>> getAllVehicles() async {
    final results = await db.query('vehicles');
    return results.map((map) => Vehicle.fromMap(map)).toList();
  }

  /// Update vehicle
  Future<int> updateVehicle(int postId, Vehicle vehicle) async {
    final values = vehicle.toMap();
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
  Future<int> insertPostImage(PostImage postImage) async {
    return await db.insert('post_images', postImage.toMap());
  }

  /// Get post image by post ID
  Future<PostImage?> getPostImageByPostId(int postId) async {
    final result = await db.query(
      'post_images',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return result.isNotEmpty ? PostImage.fromMap(result.first) : null;
  }

  /// Get all post images
  Future<List<PostImage>> getAllPostImages() async {
    final results = await db.query('post_images');
    return results.map((map) => PostImage.fromMap(map)).toList();
  }

  /// Update post image
  Future<int> updatePostImage(int postId, PostImage postImage) async {
    final values = postImage.toMap();
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

  /////////////////////////////////////////
  // METHODS TO HANDLE PASSING POST DATE //
  /////////////////////////////////////////

  Future<int> createCompletePost({
    required Post post,
    required Location location,
    List<String>? imagePaths,
    Stay? stay,
    Activity? activity,
    Vehicle? vehicle,
  }) async {
    // Start transaction
    await db.execute('BEGIN TRANSACTION');
    
    try {
      // 1. Insert location
      final locationMap = location.toMap();
      locationMap.remove('id'); // Remove ID so database auto-generates it
      final locationId = await db.insert('locations', locationMap);
      
      // 2. Create and insert post with location ID
      final postMap = post.toMap();
      postMap.remove('id'); // Remove ID so database auto-generates it
      postMap['location_id'] = locationId;
      final postId = await db.insert('posts', postMap); // <-- FIXED: This declares postId
      
      // 3. Insert category-specific data
      if (stay != null) {
        final stayMap = stay.toMap();
        stayMap['post_id'] = postId; // <-- Now postId is declared above
        await db.insert('stays', stayMap);
      } else if (activity != null) {
        final activityMap = activity.toMap();
        activityMap['post_id'] = postId; // <-- postId is available here
        await db.insert('activities', activityMap);
      } else if (vehicle != null) {
        final vehicleMap = vehicle.toMap();
        vehicleMap['post_id'] = postId; // <-- postId is available here
        await db.insert('vehicles', vehicleMap);
      }
      
      // 4. Insert images if any
      if (imagePaths != null && imagePaths.isNotEmpty) {
        for (final imagePath in imagePaths) {
          final postImage = PostImage(
            postId: postId, // <-- postId is available here
            imageData: imagePath,
          );
          await db.insert('post_images', postImage.toMap());
        }
      }
      
      // Commit transaction
      await db.execute('COMMIT');
      return postId; // <-- postId is available here
      
    } catch (e) {
      // Rollback on error
      await db.execute('ROLLBACK');
      rethrow;
    }
  }
}


