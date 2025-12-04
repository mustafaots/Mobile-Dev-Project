import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/models/bookings.model.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/repositories/db_repositories/booking_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'bookings_list_state.dart';

class BookingsListCubit extends Cubit<BookingsListState> {
  final BookingRepository bookingRepository;
  final PostRepository postRepository;

  BookingsListCubit({
    required this.bookingRepository,
    required this.postRepository,
  }) : super(const BookingsListInitial());

  Future<void> loadBookings() async {
    emit(const BookingsListLoading());
    try {
      final bookings = await bookingRepository.getAllBookings();
      final posts = await postRepository.getAllPosts();

      // If no bookings, show dummy data
      if (bookings.isEmpty || posts.isEmpty) {
        final dummyBookings = _getDummyBookings();
        final dummyPosts = _getDummyPosts();

        emit(
          BookingsListLoaded(
            allBookings: dummyBookings,
            allPosts: dummyPosts,
            selectedFilter: 'all',
          ),
        );
        return;
      }

      emit(
        BookingsListLoaded(
          allBookings: bookings,
          allPosts: posts,
          selectedFilter: 'all',
        ),
      );
    } catch (e) {
      // On error, also show dummy data
      final dummyBookings = _getDummyBookings();
      final dummyPosts = _getDummyPosts();

      emit(
        BookingsListLoaded(
          allBookings: dummyBookings,
          allPosts: dummyPosts,
          selectedFilter: 'all',
        ),
      );
    }
  }

  void filterBookings(String filterStatus) {
    final state = this.state;
    if (state is BookingsListLoaded) {
      emit(state.copyWith(selectedFilter: filterStatus));
    }
  }

  Future<void> refreshBookings() async {
    final state = this.state;
    if (state is BookingsListLoaded) {
      try {
        final bookings = await bookingRepository.getAllBookings();
        final posts = await postRepository.getAllPosts();

        // If no bookings, show dummy data
        if (bookings.isEmpty || posts.isEmpty) {
          final dummyBookings = _getDummyBookings();
          final dummyPosts = _getDummyPosts();

          emit(
            state.copyWith(allBookings: dummyBookings, allPosts: dummyPosts),
          );
          return;
        }

        emit(state.copyWith(allBookings: bookings, allPosts: posts));
      } catch (e) {
        // On error, also show dummy data
        final dummyBookings = _getDummyBookings();
        final dummyPosts = _getDummyPosts();

        emit(state.copyWith(allBookings: dummyBookings, allPosts: dummyPosts));
      }
    }
  }

  List<Booking> _getDummyBookings() {
    final now = DateTime.now();
    return [
      Booking(
        id: 1,
        postId: 1,
        clientId: 100,
        status: 'confirmed',
        bookedAt: now.subtract(const Duration(days: 5)),
        startTime: now.add(const Duration(days: 2)),
        endTime: now.add(const Duration(days: 5)),
      ),
      Booking(
        id: 2,
        postId: 2,
        clientId: 100,
        status: 'pending',
        bookedAt: now.subtract(const Duration(days: 1)),
        startTime: now.add(const Duration(days: 10)),
        endTime: now.add(const Duration(days: 12)),
      ),
      Booking(
        id: 3,
        postId: 3,
        clientId: 100,
        status: 'confirmed',
        bookedAt: now.subtract(const Duration(days: 10)),
        startTime: now.subtract(const Duration(days: 2)),
        endTime: now.add(const Duration(days: 3)),
      ),
    ];
  }

  List<Post> _getDummyPosts() {
    final now = DateTime.now();
    return [
      Post(
        id: 1,
        ownerId: 50,
        category: 'stay',
        title: 'Luxury Beach Villa',
        description:
            'Beautiful beachfront villa with private pool and ocean views',
        price: 250.0,
        locationId: 1,
        contentUrl: 'assets/images/placeholder.jpg',
        status: 'active',
        isPaid: false,
        createdAt: now,
        updatedAt: now,
        availability: [],
      ),
      Post(
        id: 2,
        ownerId: 51,
        category: 'vehicle',
        title: 'Luxury Mercedes SUV',
        description: 'Premium SUV with advanced features and full insurance',
        price: 150.0,
        locationId: 2,
        contentUrl: 'assets/images/placeholder.jpg',
        status: 'active',
        isPaid: false,
        createdAt: now,
        updatedAt: now,
        availability: [],
      ),
      Post(
        id: 3,
        ownerId: 52,
        category: 'activity',
        title: 'Mountain Hiking Adventure',
        description: 'Guided hiking tour through scenic mountain trails',
        price: 80.0,
        locationId: 3,
        contentUrl: 'assets/images/placeholder.jpg',
        status: 'active',
        isPaid: false,
        createdAt: now,
        updatedAt: now,
        availability: [],
      ),
    ];
  }
}
