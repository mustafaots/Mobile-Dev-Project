import 'package:easy_vacation/models/reviews.model.dart';
import 'package:easy_vacation/models/users.model.dart';

abstract class ReviewsState {
  const ReviewsState();
}

class ReviewsInitial extends ReviewsState {
  const ReviewsInitial();
}

class ReviewsLoading extends ReviewsState {
  const ReviewsLoading();
}

class ReviewsLoaded extends ReviewsState {
  final List<Review> reviews;
  final Map<String, User> reviewers;
  final double averageRating;

  const ReviewsLoaded({
    required this.reviews,
    required this.reviewers,
    required this.averageRating,
  });

  ReviewsLoaded copyWith({
    List<Review>? reviews,
    Map<String, User>? reviewers,
    double? averageRating,
  }) {
    return ReviewsLoaded(
      reviews: reviews ?? this.reviews,
      reviewers: reviewers ?? this.reviewers,
      averageRating: averageRating ?? this.averageRating,
    );
  }
}

class ReviewsError extends ReviewsState {
  final String message;

  const ReviewsError(this.message);
}
