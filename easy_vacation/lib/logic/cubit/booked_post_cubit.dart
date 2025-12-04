import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/models/reviews.model.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/models/bookings.model.dart';
import 'package:easy_vacation/repositories/db_repositories/booking_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/review_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/user_repository.dart';
import 'booked_post_state.dart';

class BookedPostCubit extends Cubit<BookedPostState> {
  final BookingRepository bookingRepository;
  final PostRepository postRepository;
  final ReviewRepository reviewRepository;
  final UserRepository userRepository;

  BookedPostCubit({
    required this.bookingRepository,
    required this.postRepository,
    required this.reviewRepository,
    required this.userRepository,
  }) : super(const BookedPostInitial());

  Future<void> loadPostDetails(int postId) async {
    emit(const BookedPostLoading());
    try {
      // Load post
      final post = await postRepository.getPostById(postId);

      if (post == null) {
        // Show dummy data if post not found
        final dummyPost = _getDummyPost(postId);
        final dummyHost = _getDummyHost(dummyPost.ownerId);
        final dummyReviews = _getDummyReviews(postId);
        final dummyReviewers = _getDummyReviewers(dummyReviews);

        emit(
          BookedPostLoaded(
            post: dummyPost,
            host: dummyHost,
            reviews: dummyReviews,
            reviewers: dummyReviewers,
            bookingDates:
                '${DateTime.now().day}/12 - ${DateTime.now().day + 3}/12/2024',
            bookingStatus: 'confirmed',
          ),
        );
        return;
      }

      // Load host info
      final host = await userRepository.getUserById(post.ownerId);

      // Load reviews
      final reviews = await reviewRepository.getReviewsByPostId(post.id!);

      // Load reviewer info for each review
      final Map<int, User> reviewers = {};
      for (var review in reviews) {
        final reviewer = await userRepository.getUserById(review.reviewerId);
        if (reviewer != null) {
          reviewers[review.reviewerId] = reviewer;
        }
      }

      // Load booking info for dates and status
      final bookings = await bookingRepository.getAllBookings();
      final booking = bookings.lastWhere(
        (b) => b.postId == postId,
        orElse: () => throw Exception('Booking not found'),
      );

      final bookingDates =
          '${booking.startTime.day}/${booking.startTime.month} - ${booking.endTime.day}/${booking.endTime.month}/${booking.endTime.year}';

      emit(
        BookedPostLoaded(
          post: post,
          host: host,
          reviews: reviews,
          reviewers: reviewers,
          bookingDates: bookingDates,
          bookingStatus: booking.status,
        ),
      );
    } catch (e) {
      // On error, try to at least get the booking info if available
      String bookingDates =
          '${DateTime.now().day}/12 - ${DateTime.now().day + 3}/12/2024';
      String bookingStatus = 'pending';

      try {
        final bookings = await bookingRepository.getAllBookings();
        final booking =
            bookings.lastWhere(
                  (b) => b.postId == postId,
                  orElse: () => null as dynamic,
                )
                as Booking?;
        if (booking != null) {
          bookingDates =
              '${booking.startTime.day}/${booking.startTime.month} - ${booking.endTime.day}/${booking.endTime.month}/${booking.endTime.year}';
          bookingStatus = booking.status;
        }
      } catch (_) {
        // If even booking fetch fails, use defaults
      }

      // Show dummy data with correct booking info
      final dummyPost = _getDummyPost(postId);
      final dummyHost = _getDummyHost(dummyPost.ownerId);
      final dummyReviews = _getDummyReviews(postId);
      final dummyReviewers = _getDummyReviewers(dummyReviews);

      emit(
        BookedPostLoaded(
          post: dummyPost,
          host: dummyHost,
          reviews: dummyReviews,
          reviewers: dummyReviewers,
          bookingDates: bookingDates,
          bookingStatus: bookingStatus,
        ),
      );
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

  // Dummy data generators
  Post _getDummyPost(int postId) {
    final now = DateTime.now();

    // Generate different posts based on ID
    switch (postId % 3) {
      case 1:
        return Post(
          id: postId,
          ownerId: 50,
          category: 'stay',
          title: 'Luxury Beachfront Villa',
          description:
              'Stunning beachfront villa with private pool, ocean views, and direct beach access. Features 4 bedrooms, 3 bathrooms, modern kitchen, and outdoor entertainment area.',
          price: 250.0,
          locationId: 1,
          contentUrl: 'assets/images/placeholder.jpg',
          status: 'active',
          isPaid: false,
          createdAt: now,
          updatedAt: now,
          availability: [],
        );
      case 2:
        return Post(
          id: postId,
          ownerId: 51,
          category: 'vehicle',
          title: 'Premium Mercedes-Benz SUV',
          description:
              'Luxury SUV with advanced features, full insurance included, GPS navigation, premium sound system, leather interior, and panoramic roof.',
          price: 150.0,
          locationId: 2,
          contentUrl: 'assets/images/placeholder.jpg',
          status: 'active',
          isPaid: false,
          createdAt: now,
          updatedAt: now,
          availability: [],
        );
      default:
        return Post(
          id: postId,
          ownerId: 52,
          category: 'activity',
          title: 'Mountain Hiking Adventure',
          description:
              'Guided hiking tour through scenic mountain trails with professional guide, all equipment provided, includes lunch and water, 6-8 hour experience.',
          price: 80.0,
          locationId: 3,
          contentUrl: 'assets/images/placeholder.jpg',
          status: 'active',
          isPaid: false,
          createdAt: now,
          updatedAt: now,
          availability: [],
        );
    }
  }

  User _getDummyHost(int ownerId) {
    switch (ownerId % 3) {
      case 0:
        return User(
          id: ownerId,
          username: 'john_owner',
          email: 'john.owner@email.com',
          firstName: 'John',
          lastName: 'Anderson',
          phoneNumber: '+1234567890',
          profilePicture: 'assets/images/placeholder.jpg',
          isVerified: true,
          userType: 'host',
          createdAt: DateTime.now(),
        );
      case 1:
        return User(
          id: ownerId,
          username: 'sarah_owner',
          email: 'sarah.owner@email.com',
          firstName: 'Sarah',
          lastName: 'Wilson',
          phoneNumber: '+1234567891',
          profilePicture: 'assets/images/placeholder.jpg',
          isVerified: true,
          userType: 'host',
          createdAt: DateTime.now(),
        );
      default:
        return User(
          id: ownerId,
          username: 'mike_owner',
          email: 'mike.owner@email.com',
          firstName: 'Mike',
          lastName: 'Johnson',
          phoneNumber: '+1234567892',
          profilePicture: 'assets/images/placeholder.jpg',
          isVerified: true,
          userType: 'host',
          createdAt: DateTime.now(),
        );
    }
  }

  List<Review> _getDummyReviews(int postId) {
    final now = DateTime.now();
    return [
      Review(
        id: 1,
        postId: postId,
        reviewerId: 100,
        rating: 5,
        comment: 'Excellent experience! Would definitely recommend to anyone.',
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      Review(
        id: 2,
        postId: postId,
        reviewerId: 101,
        rating: 4,
        comment:
            'Great property and very responsive host. Minor issues with Wi-Fi.',
        createdAt: now.subtract(const Duration(days: 15)),
      ),
    ];
  }

  Map<int, User> _getDummyReviewers(List<Review> reviews) {
    final reviewers = <int, User>{};
    for (var review in reviews) {
      switch (review.reviewerId % 2) {
        case 0:
          reviewers[review.reviewerId] = User(
            id: review.reviewerId,
            username: 'alex_traveler',
            email: 'reviewer1@email.com',
            firstName: 'Alex',
            lastName: 'Thompson',
            phoneNumber: '+1234567893',
            profilePicture: 'assets/images/placeholder.jpg',
            isVerified: true,
            userType: 'tourist',
            createdAt: DateTime.now(),
          );
          break;
        default:
          reviewers[review.reviewerId] = User(
            id: review.reviewerId,
            username: 'emma_adventure',
            email: 'reviewer2@email.com',
            firstName: 'Emma',
            lastName: 'Davis',
            phoneNumber: '+1234567894',
            profilePicture: 'assets/images/placeholder.jpg',
            isVerified: true,
            userType: 'tourist',
            createdAt: DateTime.now(),
          );
      }
    }
    return reviewers;
  }
}
