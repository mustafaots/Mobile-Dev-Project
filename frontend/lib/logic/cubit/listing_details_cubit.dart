import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/models/reviews.model.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/models/activities.model.dart';
import 'package:easy_vacation/models/post_images.model.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/review_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/user_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/images_repository.dart';
import 'package:easy_vacation/services/api/profile_service.dart';
import 'package:easy_vacation/services/api/listing_service.dart';
import 'listing_details_state.dart';
import 'dummy_data.dart';

class ListingDetailsCubit extends Cubit<ListingDetailsState> {
  final PostRepository postRepository;
  final ReviewRepository reviewRepository;
  final UserRepository userRepository;
  final PostImagesRepository imagesRepository;

  ListingDetailsCubit({
    required this.postRepository,
    required this.reviewRepository,
    required this.userRepository,
    required this.imagesRepository,
  }) : super(const ListingDetailsInitial());

  Future<void> loadPostDetails(int postId) async {
    emit(const ListingDetailsLoading());
    try {
      // Load post
      final post = await postRepository.getPostById(postId);

      User? host;
      List<Review> reviewsList = [];
      Map<String, User> reviewersMap = {};
      Stay? stay;
      Vehicle? vehicle;
      Activity? activity;
      List<PostImage> postImages = [];

      // If no post found, use dummy data
      if (post == null) {
        throw Exception('Post not found, using dummy data');
      }

      // Load host info - first try local DB, then fall back to API
      host = await userRepository.getUserById(post.ownerId);
      if (host == null) {
        final apiResponse = await ProfileService.instance.getUserById(
          post.ownerId,
        );
        if (apiResponse.isSuccess && apiResponse.data != null) {
          host = apiResponse.data;
          try {
            await userRepository.insertUser(host!);
          } catch (_) {}
        }
      }

      // Load reviews
      reviewsList = await reviewRepository.getReviewsByPostId(post.id!);

      // Load reviewer info for each review
      for (var review in reviewsList) {
        final reviewer = await userRepository.getUserById(review.reviewerId);
        if (reviewer != null) {
          reviewersMap[review.reviewerId] = reviewer;
        }
      }

      // Load post images by postId using imagesRepository
      final imageDataList = await imagesRepository.getAllImagesByPostId(
        post.id!,
      );
      postImages = imageDataList
          .map((imageData) => PostImage.fromMap(imageData))
          .toList();

      // Load category-specific details - first try local DB, then fall back to API
      final category = (post.category).toLowerCase();
      switch (category) {
        case 'stay':
          stay = await postRepository.getStayByPostId(post.id!);
          // If not in local DB, try to fetch from API
          if (stay == null) {
            final apiResponse = await ListingService.instance.getListingById(
              post.id!,
            );
            if (apiResponse.isSuccess &&
                apiResponse.data?.stayDetails != null) {
              stay = apiResponse.data!.stayDetails;
              // Save to local DB for future use
              if (stay != null) {
                try {
                  await postRepository.insertStay(stay!);
                } catch (_) {}
              }
            }
          }
          break;
        case 'vehicle':
          vehicle = await postRepository.getVehicleByPostId(post.id!);
          // If not in local DB, try to fetch from API
          if (vehicle == null) {
            final apiResponse = await ListingService.instance.getListingById(
              post.id!,
            );
            if (apiResponse.isSuccess &&
                apiResponse.data?.vehicleDetails != null) {
              vehicle = apiResponse.data!.vehicleDetails;
              // Save to local DB for future use
              if (vehicle != null) {
                try {
                  await postRepository.insertVehicle(vehicle!);
                } catch (_) {}
              }
            }
          }
          break;
        case 'activity':
          activity = await postRepository.getActivityByPostId(post.id!);
          // If not in local DB, try to fetch from API
          if (activity == null) {
            final apiResponse = await ListingService.instance.getListingById(
              post.id!,
            );
            if (apiResponse.isSuccess &&
                apiResponse.data?.activityDetails != null) {
              activity = apiResponse.data!.activityDetails;
              // Save to local DB for future use
              if (activity != null) {
                try {
                  await postRepository.insertActivity(activity!);
                } catch (_) {}
              }
            }
          }
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
          postImages: postImages,
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
            postImages: const [],
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
