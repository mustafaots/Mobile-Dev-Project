import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/models/reviews.model.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/models/activities.model.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/review_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/user_repository.dart';
import 'listing_details_state.dart';
import 'dummy_data.dart';

class ListingDetailsCubit extends Cubit<ListingDetailsState> {
  final PostRepository postRepository;
  final ReviewRepository reviewRepository;
  final UserRepository userRepository;

  ListingDetailsCubit({
    required this.postRepository,
    required this.reviewRepository,
    required this.userRepository,
  }) : super(const ListingDetailsInitial());

  Future<void> loadPostDetails(int postId) async {
    emit(const ListingDetailsLoading());
    try {
      // Load post
      final post = await postRepository.getPostById(postId);

      User? host;
      List<Review> reviewsList = [];
      Map<int, User> reviewersMap = {};
      Stay? stay;
      Vehicle? vehicle;
      Activity? activity;

      // If no post found, use dummy data
      if (post == null) {
        throw Exception('Post not found, using dummy data');
      }

      // Load host info
      host = await userRepository.getUserById(post.ownerId);

      // Load reviews
      reviewsList = await reviewRepository.getReviewsByPostId(post.id!);

      // Load reviewer info for each review
      for (var review in reviewsList) {
        final reviewer = await userRepository.getUserById(review.reviewerId);
        if (reviewer != null) {
          reviewersMap[review.reviewerId] = reviewer;
        }
      }

      // Load category-specific details
      final category = (post.category).toLowerCase();
      switch (category) {
        case 'stay':
          stay = await postRepository.getStayByPostId(post.id!);
          stay ??= DummyDataProvider.getDummyStayDetails(post.id!);
          break;
        case 'vehicle':
          vehicle = await postRepository.getVehicleByPostId(post.id!);
          vehicle ??= DummyDataProvider.getDummyVehicleDetails(post.id!);
          break;
        case 'activity':
          activity = await postRepository.getActivityByPostId(post.id!);
          activity ??= DummyDataProvider.getDummyActivityDetails(post.id!);
          break;
      }

      emit(
        ListingDetailsLoaded(
          post: post,
          host: host,
          reviews: reviewsList,
          reviewers: reviewersMap,
          stay: stay,
          vehicle: vehicle,
          activity: activity,
        ),
      );
    } catch (e) {
      // Fallback to dummy data on error
      try {
        final dummyPost = DummyDataProvider.getDummyPost(postId);
        final dummyHost = DummyDataProvider.getDummyHost(dummyPost.ownerId);
        final dummyReviews = DummyDataProvider.getDummyReviews(postId);
        final dummyReviewers = DummyDataProvider.getDummyReviewers(
          dummyReviews,
        );

        // Generate dummy category-specific details
        Stay? dummyStay;
        Vehicle? dummyVehicle;
        Activity? dummyActivity;

        final category = (dummyPost.category).toLowerCase();
        switch (category) {
          case 'stay':
            dummyStay = DummyDataProvider.getDummyStayDetails(postId);
            break;
          case 'vehicle':
            dummyVehicle = DummyDataProvider.getDummyVehicleDetails(postId);
            break;
          case 'activity':
            dummyActivity = DummyDataProvider.getDummyActivityDetails(postId);
            break;
        }

        emit(
          ListingDetailsLoaded(
            post: dummyPost,
            host: dummyHost,
            reviews: dummyReviews,
            reviewers: dummyReviewers,
            stay: dummyStay,
            vehicle: dummyVehicle,
            activity: dummyActivity,
          ),
        );
      } catch (_) {
        emit(
          ListingDetailsError('Failed to load post details: ${e.toString()}'),
        );
      }
    }
  }
}
