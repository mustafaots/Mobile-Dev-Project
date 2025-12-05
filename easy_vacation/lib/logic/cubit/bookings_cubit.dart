import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/models/bookings.model.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/repositories/db_repositories/booking_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'bookings_state.dart';
import 'dummy_data.dart';

class BookingsCubit extends Cubit<BookingsState> {
  final BookingRepository bookingRepository;
  final PostRepository postRepository;

  BookingsCubit({required this.bookingRepository, required this.postRepository})
    : super(const BookingsInitial());

  Future<void> loadBookings() async {
    emit(const BookingsLoading());
    try {
      final bookings = await bookingRepository.getAllBookings();
      final posts = await postRepository.getAllPosts();

      // If no bookings found, use dummy data
      if (bookings.isEmpty) {
        throw Exception('No bookings found, using dummy data');
      }

      emit(BookingsLoaded(allBookings: bookings, allPosts: posts));
    } catch (e) {
      // Fallback to dummy data on error
      try {
        final dummyBookings = _generateDummyBookings();
        final dummyPosts = _generateDummyPosts();

        emit(BookingsLoaded(allBookings: dummyBookings, allPosts: dummyPosts));
      } catch (_) {
        emit(BookingsError('Failed to load bookings: ${e.toString()}'));
      }
    }
  }

  List<Booking> _generateDummyBookings() {
    final now = DateTime.now();
    return [
      Booking(
        id: 1,
        postId: 1,
        clientId: 10,
        startTime: now.add(const Duration(days: 5)),
        endTime: now.add(const Duration(days: 10)),
        status: 'confirmed',
        bookedAt: now,
      ),
      Booking(
        id: 2,
        postId: 2,
        clientId: 11,
        startTime: now.add(const Duration(days: 2)),
        endTime: now.add(const Duration(days: 7)),
        status: 'pending',
        bookedAt: now,
      ),
      Booking(
        id: 3,
        postId: 3,
        clientId: 12,
        startTime: now.subtract(const Duration(days: 5)),
        endTime: now.subtract(const Duration(days: 2)),
        status: 'confirmed',
        bookedAt: now,
      ),
    ];
  }

  List<Post> _generateDummyPosts() {
    return [
      DummyDataProvider.getDummyPost(1),
      DummyDataProvider.getDummyPost(2),
      DummyDataProvider.getDummyPost(3),
    ];
  }

  void setFilter(String filter) {
    final currentState = state;
    if (currentState is BookingsLoaded) {
      emit(currentState.copyWith(selectedFilter: filter));
    }
  }

  void reloadBookings() {
    loadBookings();
  }
}
