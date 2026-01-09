import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/services/sync/booking_sync_service.dart';
import 'package:easy_vacation/services/api/booking_service.dart';
import 'received_bookings_state.dart';

class ReceivedBookingsCubit extends Cubit<ReceivedBookingsState> {
  ReceivedBookingsCubit() : super(const ReceivedBookingsInitial());

  Future<void> loadReceivedBookings() async {
    emit(const ReceivedBookingsLoading());
    try {
      final syncService = await BookingSyncService.getInstance();
      final receivedBookings = await syncService.getReceivedBookings(
        forceRefresh: true,
      );

      emit(ReceivedBookingsLoaded(bookings: receivedBookings));
    } catch (e) {
      emit(ReceivedBookingsError('Failed to load received bookings: ${e.toString()}'));
    }
  }

  void setFilter(String filter) {
    final currentState = state;
    if (currentState is ReceivedBookingsLoaded) {
      emit(currentState.copyWith(selectedFilter: filter));
    }
  }

  Future<bool> acceptBooking(int bookingId) async {
    final currentState = state;
    if (currentState is ReceivedBookingsLoaded) {
      emit(ReceivedBookingsActionInProgress(
        bookings: currentState.bookings,
        bookingId: bookingId,
        action: 'accept',
      ));

      try {
        final syncService = await BookingSyncService.getInstance();
        final result = await syncService.confirmBooking(bookingId);

        if (result.isSuccess) {
          // Reload bookings to get updated status
          await loadReceivedBookings();
          return true;
        } else {
          emit(ReceivedBookingsLoaded(bookings: currentState.bookings));
          return false;
        }
      } catch (e) {
        emit(ReceivedBookingsLoaded(bookings: currentState.bookings));
        return false;
      }
    }
    return false;
  }

  Future<bool> rejectBooking(int bookingId) async {
    final currentState = state;
    if (currentState is ReceivedBookingsLoaded) {
      emit(ReceivedBookingsActionInProgress(
        bookings: currentState.bookings,
        bookingId: bookingId,
        action: 'reject',
      ));

      try {
        final syncService = await BookingSyncService.getInstance();
        final result = await syncService.cancelBooking(bookingId);

        if (result.isSuccess) {
          // Reload bookings to get updated status
          await loadReceivedBookings();
          return true;
        } else {
          emit(ReceivedBookingsLoaded(bookings: currentState.bookings));
          return false;
        }
      } catch (e) {
        emit(ReceivedBookingsLoaded(bookings: currentState.bookings));
        return false;
      }
    }
    return false;
  }

  void reloadBookings() {
    loadReceivedBookings();
  }
}
