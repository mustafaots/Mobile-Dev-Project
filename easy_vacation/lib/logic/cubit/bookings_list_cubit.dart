import 'package:flutter_bloc/flutter_bloc.dart';
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

      emit(
        BookingsListLoaded(
          allBookings: bookings,
          allPosts: posts,
          selectedFilter: 'all',
        ),
      );
    } catch (e) {
      emit(BookingsListError(e.toString()));
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
        emit(state.copyWith(allBookings: bookings, allPosts: posts));
      } catch (e) {
        emit(BookingsListError(e.toString()));
      }
    }
  }
}
