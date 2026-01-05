import 'package:easy_vacation/services/api/review_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/models/reviews.model.dart';
import 'package:easy_vacation/repositories/db_repositories/review_repository.dart';
import 'add_review_state.dart';

class AddReviewCubit extends Cubit<AddReviewState> {
  final ReviewRepository reviewRepository;

  AddReviewCubit({required this.reviewRepository}) : super(const AddReviewInitial());

  /// Submit a review to the database
  Future<void> submitReview({
    required int postId,
    required String reviewerId,
    required int rating,
    String? comment,
  }) async {
    if (rating < 1 || rating > 5) {
      emit(const AddReviewValidationError('Rating must be between 1 and 5'));
      return;
    }

    if (comment != null && comment.trim().isEmpty && comment.isNotEmpty) {
      emit(const AddReviewValidationError(
        'Comment cannot be empty or whitespace only',
      ));
      return;
    }

    emit(const AddReviewLoading());

    try {
      // Send to remote backend first
      final request = CreateReviewRequest(
        listingId: postId,
        rating: rating,
        comment: comment?.trim(),
      );

      final response = await ReviewService.instance.createReview(request);

      if (!response.success || response.data == null) {
        emit(AddReviewFailure(response.message ?? 'Failed to submit review'));
        return;
      }

      final remoteReview = response.data!;

      // save to local database
      await reviewRepository.insertReview(remoteReview);

      // emit success with backend review
      emit(AddReviewSuccess(remoteReview));
    } catch (e) {
      emit(AddReviewFailure('Failed to submit review: ${e.toString()}'));
    }
  }

  /// Get reviews for a specific post
  Future<List<Review>> getReviewsForPost(int postId) async {
    try {
      return await reviewRepository.getReviewsByPostId(postId);
    } catch (e) {
      emit(AddReviewFailure('Failed to fetch reviews: ${e.toString()}'));
      return [];
    }
  }

  /// Get average rating for a post
  Future<double> getAverageRating(int postId) async {
    try {
      return await reviewRepository.getAverageRatingForPost(postId);
    } catch (e) {
      emit(AddReviewFailure('Failed to fetch average rating: ${e.toString()}'));
      return 0.0;
    }
  }

  /// Reset state to initial
  void reset() {
    emit(const AddReviewInitial());
  }
}
