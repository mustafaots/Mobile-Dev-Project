import 'base_repository.dart';

/// Repository for managing review data
class ReviewRepository extends BaseRepository {
  /// Insert a new review
  Future<int> insertReview({
    required int postId,
    required int reviewerId,
    required int rating,
    String? comment,
  }) async {
    return await db.insert('reviews', {
      'post_id': postId,
      'reviewer_id': reviewerId,
      'rating': rating,
      'comment': comment,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get review by ID
  Future<Map<String, dynamic>?> getReviewById(int id) async {
    final result = await db.query('reviews', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all reviews
  Future<List<Map<String, dynamic>>> getAllReviews() async {
    return await db.query('reviews');
  }

  /// Get reviews by post ID
  Future<List<Map<String, dynamic>>> getReviewsByPostId(int postId) async {
    return await db.query('reviews', where: 'post_id = ?', whereArgs: [postId]);
  }

  /// Get reviews by reviewer ID
  Future<List<Map<String, dynamic>>> getReviewsByReviewerId(
    int reviewerId,
  ) async {
    return await db.query(
      'reviews',
      where: 'reviewer_id = ?',
      whereArgs: [reviewerId],
    );
  }

  /// Get average rating for a post
  Future<double> getAverageRatingForPost(int postId) async {
    final result = await db.rawQuery(
      'SELECT AVG(rating) as avg_rating FROM reviews WHERE post_id = ?',
      [postId],
    );
    if (result.isNotEmpty && result.first['avg_rating'] != null) {
      return result.first['avg_rating'] as double;
    }
    return 0.0;
  }

  /// Update review
  Future<int> updateReview(int id, Map<String, dynamic> values) async {
    return await db.update('reviews', values, where: 'id = ?', whereArgs: [id]);
  }

  /// Delete review
  Future<int> deleteReview(int id) async {
    return await db.delete('reviews', where: 'id = ?', whereArgs: [id]);
  }
}
