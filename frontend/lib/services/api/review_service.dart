import 'package:easy_vacation/models/reviews.model.dart';
import 'package:easy_vacation/services/api/api_client.dart';
import 'package:easy_vacation/services/api/api_config.dart';
import 'package:easy_vacation/services/api/api_response.dart';

/// Review with additional details
class ReviewWithDetails {
  final Review review;
  final String? reviewerName;
  final String? reviewerAvatar;
  final String? listingTitle;

  ReviewWithDetails({
    required this.review,
    this.reviewerName,
    this.reviewerAvatar,
    this.listingTitle,
  });

  factory ReviewWithDetails.fromJson(Map<String, dynamic> json) {
    return ReviewWithDetails(
      review: Review.fromMap(json),
      reviewerName: json['reviewer_name'],
      reviewerAvatar: json['reviewer_avatar'],
      listingTitle: json['listing_title'] ?? json['post_title'],
    );
  }
}

/// Rating summary for a listing
class RatingSummary {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution;

  RatingSummary({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  factory RatingSummary.fromJson(Map<String, dynamic> json) {
    final distribution = <int, int>{};
    if (json['distribution'] != null) {
      (json['distribution'] as Map<String, dynamic>).forEach((key, value) {
        distribution[int.parse(key)] = value as int;
      });
    }

    return RatingSummary(
      averageRating: (json['average'] ?? json['average_rating'] ?? 0).toDouble(),
      totalReviews: json['total'] ?? json['total_reviews'] ?? 0,
      ratingDistribution: distribution,
    );
  }
}

/// Request model for creating a review
class CreateReviewRequest {
  final int listingId;
  final int rating;
  final String? comment;

  CreateReviewRequest({
    required this.listingId,
    required this.rating,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'post_id': listingId,
      'rating': rating,
      if (comment != null) 'comment': comment,
    };
  }
}

/// Review Service for managing reviews with the backend
class ReviewService {
  static ReviewService? _instance;
  final ApiClient _apiClient;

  ReviewService._internal({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient.instance;

  /// Get singleton instance
  static ReviewService get instance {
    _instance ??= ReviewService._internal();
    return _instance!;
  }

  /// Public constructor for testing with a custom ApiClient
  factory ReviewService.test(ApiClient apiClient) {
    return ReviewService._internal(apiClient: apiClient);
  }

  /// Get reviews for a listing (public)
  /// 
  /// GET /api/listings/:id/reviews
  Future<ApiResponse<List<ReviewWithDetails>>> getReviewsForListing(int listingId) async {
    try {
      final response = await _apiClient.get('${ApiConfig.listings}/$listingId/reviews');
      final reviews = (response['data'] as List<dynamic>? ?? response as List<dynamic>)
          .map((json) => ReviewWithDetails.fromJson(json))
          .toList();
      return ApiResponse.success(reviews);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get rating summary for a listing (public)
  /// 
  /// GET /api/listings/:id/ratings
  Future<ApiResponse<RatingSummary>> getRatingSummary(int listingId) async {
    try {
      final response = await _apiClient.get('${ApiConfig.listings}/$listingId/ratings');
      final summary = RatingSummary.fromJson(response['data'] ?? response);
      return ApiResponse.success(summary);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get user's reviews
  /// 
  /// GET /api/reviews/my
  Future<ApiResponse<List<ReviewWithDetails>>> getMyReviews() async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.reviews}/my',
        requiresAuth: true,
      );
      final reviews = (response['data'] as List<dynamic>? ?? response as List<dynamic>)
          .map((json) => ReviewWithDetails.fromJson(json))
          .toList();
      return ApiResponse.success(reviews);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Create a review
  /// 
  /// POST /api/reviews
  Future<ApiResponse<Review>> createReview(CreateReviewRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.reviews,
        body: request.toJson(),
        requiresAuth: true,
      );
      final review = Review.fromMap(response['data'] ?? response);
      return ApiResponse.success(review);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Update a review
  /// 
  /// PATCH /api/reviews/:id
  Future<ApiResponse<Review>> updateReview(int id, {int? rating, String? comment}) async {
    try {
      final body = <String, dynamic>{};
      if (rating != null) body['rating'] = rating;
      if (comment != null) body['comment'] = comment;

      final response = await _apiClient.patch(
        '${ApiConfig.reviews}/$id',
        body: body,
        requiresAuth: true,
      );
      final review = Review.fromMap(response['data'] ?? response);
      return ApiResponse.success(review);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Delete a review
  /// 
  /// DELETE /api/reviews/:id
  Future<ApiResponse<void>> deleteReview(int id) async {
    try {
      await _apiClient.delete(
        '${ApiConfig.reviews}/$id',
        requiresAuth: true,
      );
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }


  // Check if user can add review for a certain post
  Future<ApiResponse<bool>> canReviewPost(int postId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.reviews}/can-review/$postId',
        requiresAuth: true,
      );

      final canReview = response['data']?['canReview'] as bool? ?? false;

      return ApiResponse.success(canReview);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
