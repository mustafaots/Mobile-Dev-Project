import 'package:easy_vacation/services/api/api_client.dart';
import 'package:easy_vacation/services/api/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/models/reviews.model.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/repositories/db_repositories/review_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/user_repository.dart';
import 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewRepository reviewRepository;
  final UserRepository userRepository;

  ReviewsCubit({required this.reviewRepository, required this.userRepository})
    : super(const ReviewsInitial());

  /// Load reviews for a specific post
  Future<void> loadReviews(int postId) async {
    emit(const ReviewsLoading());
    try {
      // Fetch all reviews for the post
      final reviews = await reviewRepository.getReviewsByPostId(postId);

      // Fetch reviewer info for each review
      Map<String, User> reviewersMap = {};
      for (var review in reviews) {
        User? reviewer = await userRepository.getUserById(review.reviewerId);
        
        if (reviewer == null) {
          try {
            final response = await ApiClient.instance.get('/users/${review.reviewerId}');
            reviewer = User.fromMap(response['data']);
          } catch (_) {}
        }

        if (reviewer != null) {
          reviewersMap[review.reviewerId] = reviewer;
        }
      }

      final currentUserId = AuthService.instance.currentUser?.id;
      reviews.sort((a, b) {
        if (a.reviewerId == currentUserId) return -1; // current user's review comes first
        if (b.reviewerId == currentUserId) return 1;  // other reviews move back
        return 0;
      });

      // Calculate average rating
      double averageRating = 0.0;
      if (reviews.isNotEmpty) {
        final sum = reviews.fold<int>(0, (acc, review) => acc + review.rating);
        averageRating = sum / reviews.length;
      }

      emit(
        ReviewsLoaded(
          reviews: reviews,
          reviewers: reviewersMap,
          averageRating: averageRating,
        ),
      );
    } catch (e) {
      emit(ReviewsError('Failed to load reviews: ${e.toString()}'));
    }
  }

  /// Get reviews sorted by newest first
  List<Review> getReviewsSortedByDate() {
    if (state is! ReviewsLoaded) return [];
    final currentState = state as ReviewsLoaded;
    final sortedReviews = List<Review>.from(currentState.reviews);
    sortedReviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedReviews;
  }

  /// Get reviews sorted by highest rating first
  List<Review> getReviewsSortedByRating() {
    if (state is! ReviewsLoaded) return [];
    final currentState = state as ReviewsLoaded;
    final sortedReviews = List<Review>.from(currentState.reviews);
    sortedReviews.sort((a, b) => b.rating.compareTo(a.rating));
    return sortedReviews;
  }

  /// Get reviews filtered by rating
  List<Review> getReviewsByRating(int rating) {
    if (state is! ReviewsLoaded) return [];
    final currentState = state as ReviewsLoaded;
    return currentState.reviews
        .where((review) => review.rating == rating)
        .toList();
  }

  /// Get limited reviews (e.g., first 2 for display)
  List<Review> getLimitedReviews(int limit) {
    if (state is! ReviewsLoaded) return [];
    final currentState = state as ReviewsLoaded;
    return currentState.reviews.take(limit).toList();
  }

  /// Get reviewer by ID from loaded reviewers
  User? getReviewerById(int reviewerId) {
    if (state is! ReviewsLoaded) return null;
    final currentState = state as ReviewsLoaded;
    return currentState.reviewers[reviewerId];
  }

  /// Get all reviewers
  List<User> getAllReviewers() {
    if (state is! ReviewsLoaded) return [];
    final currentState = state as ReviewsLoaded;
    return currentState.reviewers.values.toList();
  }

  /// Get review count
  int getReviewCount() {
    if (state is! ReviewsLoaded) return 0;
    final currentState = state as ReviewsLoaded;
    return currentState.reviews.length;
  }

  /// Get reviews with reviewer data combined
  List<ReviewWithReviewer> getReviewsWithReviewerData() {
    if (state is! ReviewsLoaded) return [];
    final currentState = state as ReviewsLoaded;

    return currentState.reviews.map((review) {
      final reviewer = currentState.reviewers[review.reviewerId];
      return ReviewWithReviewer(review: review, reviewer: reviewer);
    }).toList();
  }

  /// Get reviewer profile picture URL by ID
  String? getReviewerProfilePictureUrl(int reviewerId) {
    if (state is! ReviewsLoaded) return null;
    final currentState = state as ReviewsLoaded;
    final reviewer = currentState.reviewers[reviewerId];

    // Return a default avatar if no specific image URL is available
    // The profile picture could be stored in a user_profiles table or as a URL in the User model
    // For now, we'll generate a placeholder using the username
    if (reviewer != null) {
      // You can customize this URL pattern based on your backend
      // Example: return 'https://api.example.com/profiles/${reviewer.id}/picture.jpg';
      // For now, return null so the UI can use a default avatar
      return null;
    }
    return null;
  }

  /// Get reviewer full name by ID
  String getReviewerFullName(int reviewerId) {
    if (state is! ReviewsLoaded) return 'Unknown';
    final currentState = state as ReviewsLoaded;
    final reviewer = currentState.reviewers[reviewerId];

    if (reviewer != null) {
      if (reviewer.firstName != null && reviewer.lastName != null) {
        return '${reviewer.firstName} ${reviewer.lastName}';
      }
      return reviewer.username;
    }
    return 'Unknown';
  }
}

/// Helper class to combine Review with Reviewer data
class ReviewWithReviewer {
  final Review review;
  final User? reviewer;

  ReviewWithReviewer({required this.review, required this.reviewer});
}
