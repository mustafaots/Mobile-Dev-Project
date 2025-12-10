import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/models/bookings.model.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/repositories/db_repositories/booking_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'bookings_state.dart';

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
