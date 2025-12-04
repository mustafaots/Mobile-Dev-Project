import 'package:sqflite/sqflite.dart';

class PostImagesRepository {
  final Database db;

  PostImagesRepository(this.db);

  /// Insert a new image for a post
  Future<int> insertImage({
    required int postId,
    required List<int> imageBytes,
  }) async {
    return await db.insert('post_images', {
      'post_id': postId,
      'image': imageBytes,
    });
  }

  /// Get image record by its ID
  Future<Map<String, dynamic>?> getImageById(int id) async {
    final result =
        await db.query('post_images', where: 'id = ?', whereArgs: [id]);

    return result.isNotEmpty ? result.first : null;
  }

  /// Get image by post ID
  Future<Map<String, dynamic>?> getImageByPostId(int postId) async {
    final result = await db.query(
      'post_images',
      where: 'post_id = ?',
      whereArgs: [postId],
      limit: 1,
    );

    return result.isNotEmpty ? result.first : null;
  }

  /// Get all images
  Future<List<Map<String, dynamic>>> getAllImages() async {
    return await db.query('post_images');
  }

  /// Update image for a post
  Future<int> updateImage({
    required int postId,
    required List<int> imageBytes,
  }) async {
    return await db.update(
      'post_images',
      {'image': imageBytes},
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  /// Delete image by post ID
  Future<int> deleteImageByPostId(int postId) async {
    return await db.delete(
      'post_images',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  /// Delete image by ID
  Future<int> deleteImageById(int id) async {
    return await db.delete(
      'post_images',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
