import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/models/reviews.model.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/models/activities.model.dart';
import 'package:easy_vacation/models/post_images.model.dart';
import 'package:easy_vacation/models/locations.model.dart';

abstract class ListingDetailsState {
  const ListingDetailsState();
}

class ListingDetailsInitial extends ListingDetailsState {
  const ListingDetailsInitial();
}

class ListingDetailsLoading extends ListingDetailsState {
  const ListingDetailsLoading();
}

class ListingDetailsLoaded extends ListingDetailsState {
  final Post? post;
  final User? host;
  final List<Review> reviews;
  final Map<String, User> reviewers;
  final Stay? stay;
  final Vehicle? vehicle;
  final Activity? activity;
  final List<PostImage> postImages;
  final Location? location;

  const ListingDetailsLoaded({
    this.post,
    this.host,
    this.reviews = const [],
    this.reviewers = const {},
    this.stay,
    this.vehicle,
    this.activity,
    this.postImages = const [],
    this.location,
  });

  ListingDetailsLoaded copyWith({
    Post? post,
    User? host,
    List<Review>? reviews,
    Map<String, User>? reviewers,
    Stay? stay,
    Vehicle? vehicle,
    Activity? activity,
    List<PostImage>? postImages,
    Location? location,
  }) {
    return ListingDetailsLoaded(
      post: post ?? this.post,
      host: host ?? this.host,
      reviews: reviews ?? this.reviews,
      reviewers: reviewers ?? this.reviewers,
      stay: stay ?? this.stay,
      vehicle: vehicle ?? this.vehicle,
      activity: activity ?? this.activity,
      postImages: postImages ?? this.postImages,
      location: location ?? this.location,
    );
  }
}

class ListingDetailsError extends ListingDetailsState {
  final String message;

  const ListingDetailsError(this.message);
}
