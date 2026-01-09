import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/models/reviews.model.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/models/activities.model.dart';
import 'package:easy_vacation/models/post_images.model.dart';
import 'package:easy_vacation/models/locations.model.dart';
import 'package:easy_vacation/repositories/db_repositories/booking_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/review_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/user_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/images_repository.dart';
import 'package:easy_vacation/services/api/profile_service.dart';
import 'package:easy_vacation/services/api/listing_service.dart';
import 'package:easy_vacation/services/sync/booking_sync_service.dart';
import 'booked_post_state.dart';
import 'dummy_data.dart';

class BookedPostCubit extends Cubit<BookedPostState> {
  final BookingRepository bookingRepository;
  final PostRepository postRepository;
  final ReviewRepository reviewRepository;
  final UserRepository userRepository;
  final PostImagesRepository imagesRepository;

  BookedPostCubit({
    required this.bookingRepository,
    required this.postRepository,
    required this.reviewRepository,
    required this.userRepository,
    required this.imagesRepository,
  }) : super(const BookedPostInitial());

  Future<void> loadPostDetails(int postId) async {
    emit(const BookedPostLoading());
    try {
      // First try to get booking from API via sync service
      final syncService = await BookingSyncService.getInstance();
      final myBookings = await syncService.getMyBookings(forceRefresh: true);

      // Find the booking for this post
      final bookingWithDetails = myBookings.firstWhere(
        (bwd) => bwd.booking.postId == postId,
        orElse: () => throw Exception('Booking not found in API'),
      );
      final booking = bookingWithDetails.booking;

      final bookingDates =
          '${booking.startTime.day}/${booking.startTime.month} - ${booking.endTime.day}/${booking.endTime.month}/${booking.endTime.year}';

      final post = await postRepository.getPostById(postId);

      // If no post found, use dummy data
      if (post == null) {
        throw Exception('Post not found, using dummy data');
      }

      // Load host info - first try local DB, then fall back to API
      User? host = await userRepository.getUserById(post.ownerId);
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

      List<Review> reviewsList = [];
      Map<String, User> reviewersMap = {};
      Stay? stay;
      Vehicle? vehicle;
      Activity? activity;
      List<PostImage> postImages = [];
      Location? location;

      final reviews = await reviewRepository.getReviewsByPostId(postId);
      reviewsList = reviews;
      for (var review in reviewsList) {
        final reviewer = await userRepository.getUserById(review.reviewerId);
        if (reviewer != null) {
          reviewersMap[review.reviewerId] = reviewer;
        }
      }

      // Load post images by postId
      final imageDataList = await imagesRepository.getAllImagesByPostId(postId);
      postImages = imageDataList
          .map((imageData) => PostImage.fromMap(imageData))
          .toList();

      // Load location from API
      try {
        final locationResponse = await ListingService.instance.getListingById(
          postId,
        );
        if (locationResponse.isSuccess &&
            locationResponse.data?.location != null) {
          location = locationResponse.data!.location;
        }
      } catch (_) {}

      // Load category-specific details - first try local DB, then fall back to API
      final category = (post.category).toLowerCase();
      switch (category) {
        case 'stay':
          stay = await postRepository.getStayByPostId(postId);
          if (stay == null) {
            final apiResponse = await ListingService.instance.getListingById(
              postId,
            );
            if (apiResponse.isSuccess &&
                apiResponse.data?.stayDetails != null) {
              stay = apiResponse.data!.stayDetails;
              location ??= apiResponse.data!.location;
              if (stay != null) {
                try {
                  await postRepository.insertStay(stay!);
                } catch (_) {}
              }
            }
          }
          break;
        case 'vehicle':
          vehicle = await postRepository.getVehicleByPostId(postId);
          if (vehicle == null) {
            final apiResponse = await ListingService.instance.getListingById(
              postId,
            );
            if (apiResponse.isSuccess &&
                apiResponse.data?.vehicleDetails != null) {
              vehicle = apiResponse.data!.vehicleDetails;
              location ??= apiResponse.data!.location;
              if (vehicle != null) {
                try {
                  await postRepository.insertVehicle(vehicle!);
                } catch (_) {}
              }
            }
          }
          break;
        case 'activity':
          activity = await postRepository.getActivityByPostId(postId);
          if (activity == null) {
            final apiResponse = await ListingService.instance.getListingById(
              postId,
            );
            if (apiResponse.isSuccess &&
                apiResponse.data?.activityDetails != null) {
              activity = apiResponse.data!.activityDetails;
              location ??= apiResponse.data!.location;
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
        BookedPostLoaded(
          post: post,
          host: host,
          reviews: reviewsList,
          reviewers: reviewersMap,
          bookingDates: bookingDates,
          bookingStatus: booking.status,
          stay: stay,
          vehicle: vehicle,
          activity: activity,
          postImages: postImages,
          location: location,
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
          BookedPostLoaded(
            post: dummyPost,
            host: dummyHost,
            reviews: dummyReviews,
            reviewers: dummyReviewers,
            bookingDates:
                '${DateTime.now().day}/12 - ${DateTime.now().day + 3}/12/2024',
            bookingStatus: 'pending',
            stay: dummyStay,
            vehicle: dummyVehicle,
            activity: dummyActivity,
            postImages: const [],
          ),
        );
      } catch (_) {
        emit(
          BookedPostError('Failed to load booking details: ${e.toString()}'),
        );
      }
    }
  }

  Future<void> cancelBooking(int postId) async {
    // Get current loaded state to preserve data while canceling
    final currentState = state;
    if (currentState is BookedPostLoaded) {
      emit(
        BookedPostCanceling(
          post: currentState.post,
          host: currentState.host,
          reviews: currentState.reviews,
          reviewers: currentState.reviewers,
          bookingDates: currentState.bookingDates,
          bookingStatus: currentState.bookingStatus,
          stay: currentState.stay,
          vehicle: currentState.vehicle,
          activity: currentState.activity,
          postImages: currentState.postImages,
          location: currentState.location,
        ),
      );
    } else {
      // Fallback if state is not loaded
      emit(
        const BookedPostCanceling(
          bookingDates: 'Loading...',
          bookingStatus: 'pending',
        ),
      );
    }

    try {
      final bookings = await bookingRepository.getAllBookings();
      final booking = bookings.lastWhere((b) => b.postId == postId);

      if (booking.id != null) {
        // Cancel booking in Supabase via sync service
        final syncService = await BookingSyncService.getInstance();
        final result = await syncService.cancelBooking(booking.id!);

        if (result.isSuccess) {
          // Also delete from local database
          await bookingRepository.deleteBooking(booking.id!);
          emit(const BookedPostCanceled('Booking canceled successfully'));
        } else {
          emit(BookedPostError(result.message ?? 'Failed to cancel booking'));
        }
      } else {
        emit(const BookedPostError('Invalid booking ID'));
      }
    } catch (e) {
      emit(BookedPostError('Failed to cancel booking: ${e.toString()}'));
    }
  }
}
