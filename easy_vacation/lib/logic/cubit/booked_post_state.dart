import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/models/reviews.model.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/models/activities.model.dart';

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
  final Stay? stay;
  final Vehicle? vehicle;
  final Activity? activity;

  const BookedPostLoaded({
    this.post,
    this.host,
    this.reviews = const [],
    this.reviewers = const {},
    required this.bookingDates,
    required this.bookingStatus,
    this.stay,
    this.vehicle,
    this.activity,
  });

  // CopyWith method for easier state updates
  BookedPostLoaded copyWith({
    Post? post,
    User? host,
    List<Review>? reviews,
    Map<int, User>? reviewers,
    String? bookingDates,
    String? bookingStatus,
    Stay? stay,
    Vehicle? vehicle,
    Activity? activity,
  }) {
    return BookedPostLoaded(
      post: post ?? this.post,
      host: host ?? this.host,
      reviews: reviews ?? this.reviews,
      reviewers: reviewers ?? this.reviewers,
      bookingDates: bookingDates ?? this.bookingDates,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      stay: stay ?? this.stay,
      vehicle: vehicle ?? this.vehicle,
      activity: activity ?? this.activity,
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
  final Stay? stay;
  final Vehicle? vehicle;
  final Activity? activity;

  const BookedPostCanceling({
    this.post,
    this.host,
    this.reviews = const [],
    this.reviewers = const {},
    required this.bookingDates,
    required this.bookingStatus,
    this.stay,
    this.vehicle,
    this.activity,
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
