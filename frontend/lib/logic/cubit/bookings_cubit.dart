import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/models/bookings.model.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/repositories/db_repositories/booking_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/services/sync/booking_sync_service.dart';
import 'package:easy_vacation/services/api/booking_service.dart';
import 'bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState> {
  final BookingRepository bookingRepository;
  final PostRepository postRepository;
  final dynamic userId;

  BookingsCubit({
    required this.bookingRepository,
    required this.postRepository,
    this.userId,
  }) : super(const BookingsInitial());

  Future<void> loadBookings() async {
    emit(const BookingsLoading());
    try {
      // Use sync service to get bookings from API (filtered by current user)
      final syncService = await BookingSyncService.getInstance();
      final myBookingsWithDetails = await syncService.getMyBookings(
        forceRefresh: true,
      );

      // Extract just the Booking objects
      final bookings = myBookingsWithDetails.map((bwd) => bwd.booking).toList();
      final posts = await postRepository.getAllPosts();

      emit(BookingsLoaded(allBookings: bookings, allPosts: posts));
    } catch (e) {
      emit(BookingsError('Failed to load bookings: ${e.toString()}'));
    }
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
