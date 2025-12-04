import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/models/reviews.model.dart';
import 'package:easy_vacation/models/users.model.dart';

abstract class BookedPostState {
  const BookedPostState();
}

class BookedPostInitial extends BookedPostState {
  const BookedPostInitial();
}

class BookedPostLoading extends BookedPostState {
  const BookedPostLoading();
}

class BookedPostLoaded extends BookedPostState {
  final Post? post;
  final User? host;
  final List<Review> reviews;
  final Map<int, User> reviewers;
  final String bookingDates;
  final String bookingStatus;

  const BookedPostLoaded({
    this.post,
    this.host,
    this.reviews = const [],
    this.reviewers = const {},
    required this.bookingDates,
    required this.bookingStatus,
  });

  // CopyWith method for easier state updates
  BookedPostLoaded copyWith({
    Post? post,
    User? host,
    List<Review>? reviews,
    Map<int, User>? reviewers,
    String? bookingDates,
    String? bookingStatus,
  }) {
    return BookedPostLoaded(
      post: post ?? this.post,
      host: host ?? this.host,
      reviews: reviews ?? this.reviews,
      reviewers: reviewers ?? this.reviewers,
      bookingDates: bookingDates ?? this.bookingDates,
      bookingStatus: bookingStatus ?? this.bookingStatus,
    );
  }
}

class BookedPostCanceling extends BookedPostState {
  final Post? post;
  final User? host;
  final List<Review> reviews;
  final Map<int, User> reviewers;
  final String bookingDates;
  final String bookingStatus;

  const BookedPostCanceling({
    this.post,
    this.host,
    this.reviews = const [],
    this.reviewers = const {},
    required this.bookingDates,
    required this.bookingStatus,
  });
}

class BookedPostCanceled extends BookedPostState {
  final String message;

  const BookedPostCanceled(this.message);
}

class BookedPostError extends BookedPostState {
  final String message;

  const BookedPostError(this.message);
}
