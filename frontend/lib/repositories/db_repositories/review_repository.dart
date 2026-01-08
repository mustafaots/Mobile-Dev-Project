import 'package:easy_vacation/services/api/review_service.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/reviews.model.dart';

/// Repository for managing review data
class ReviewRepository {
  final Database db;
  final ReviewService reviewService;

  ReviewRepository(this.db, {ReviewService? reviewService})
    : reviewService = reviewService ?? ReviewService.instance;

  /// Insert a new review
  Future<int> insertReview(Review review) async {
    return await db.insert('reviews', review.toMap());
  }

  /// Get review by ID
  Future<Review?> getReviewById(int id) async {
    final result = await db.query('reviews', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Review.fromMap(result.first) : null;
  }

  /// Get all reviews
  Future<List<Review>> getAllReviews() async {
    final results = await db.query('reviews');
    return results.map((map) => Review.fromMap(map)).toList();
  }

  /// Get reviews by post ID
  Future<List<Review>> getReviewsByPostId(int postId) async {
    try {
      // Try fetching from backend
      final response = await reviewService.getReviewsForListing(postId);

      if (response.isSuccess && response.data != null) {
        final reviews = response.data!.map((item) => item.review).toList();
        return reviews;
      }
    } catch (_) {}

    // Fallback: fetch from local database
    return await db.query('reviews', where: 'post_id = ?', whereArgs: [postId])
        .then((results) => results.map((map) => Review.fromMap(map)).toList());
  }

  /// Get reviews by reviewer ID
  Future<List<Review>> getReviewsByReviewerId(int reviewerId) async {
    final results = await db.query(
      'reviews',
      where: 'reviewer_id = ?',
      whereArgs: [reviewerId],
    );
    return results.map((map) => Review.fromMap(map)).toList();
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
  Future<int> updateReview(int id, Review review) async {
    final values = review.toMap();
    values.remove('id'); // Remove ID to avoid updating it
    return await db.update('reviews', values, where: 'id = ?', whereArgs: [id]);
  }

  /// Delete review
  Future<int> deleteReview(int id) async {
    return await db.delete('reviews', where: 'id = ?', whereArgs: [id]);
  }
}
