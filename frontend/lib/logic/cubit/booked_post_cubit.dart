import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/models/reviews.model.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/models/activities.model.dart';
import 'package:easy_vacation/models/post_images.model.dart';
import 'package:easy_vacation/repositories/db_repositories/booking_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/review_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/user_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/images_repository.dart';
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
      final bookings = await bookingRepository.getAllBookings();
      final booking = bookings.firstWhere((b) => b.postId == postId);

      final bookingDates =
          '${booking.startTime.day}/${booking.startTime.month} - ${booking.endTime.day}/${booking.endTime.month}/${booking.endTime.year}';

      final post = await postRepository.getPostById(postId);

      // If no post found, use dummy data
      if (post == null) {
        throw Exception('Post not found, using dummy data');
      }

      final host = await userRepository.getUserById(post.ownerId);

      List<Review> reviewsList = [];
      Map<String, User> reviewersMap = {};
      Stay? stay;
      Vehicle? vehicle;
      Activity? activity;
      List<PostImage> postImages = [];

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

      // Load category-specific details
      final category = (post.category).toLowerCase();
      switch (category) {
        case 'stay':
          stay = await postRepository.getStayByPostId(postId);
          stay ??= DummyDataProvider.getDummyStayDetails(postId);
          break;
        case 'vehicle':
          vehicle = await postRepository.getVehicleByPostId(postId);
          vehicle ??= DummyDataProvider.getDummyVehicleDetails(postId);
          break;
        case 'activity':
          activity = await postRepository.getActivityByPostId(postId);
          activity ??= DummyDataProvider.getDummyActivityDetails(postId);
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
        await bookingRepository.deleteBooking(booking.id!);
        emit(const BookedPostCanceled('Booking canceled successfully'));
      } else {
        emit(const BookedPostError('Invalid booking ID'));
      }
    } catch (e) {
      emit(const BookedPostError('Failed to cancel booking'));
    }
  }
}
