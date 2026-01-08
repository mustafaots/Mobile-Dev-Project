import 'package:easy_vacation/services/api/booking_service.dart';

abstract class ReceivedBookingsState {
  const ReceivedBookingsState();
}

class ReceivedBookingsInitial extends ReceivedBookingsState {
  const ReceivedBookingsInitial();
}

class ReceivedBookingsLoading extends ReceivedBookingsState {
  const ReceivedBookingsLoading();
}

class ReceivedBookingsLoaded extends ReceivedBookingsState {
  final List<BookingWithDetails> bookings;
  final String selectedFilter;

  const ReceivedBookingsLoaded({
    required this.bookings,
    this.selectedFilter = 'all',
  });

  ReceivedBookingsLoaded copyWith({
    List<BookingWithDetails>? bookings,
    String? selectedFilter,
  }) {
    return ReceivedBookingsLoaded(
      bookings: bookings ?? this.bookings,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

class ReceivedBookingsError extends ReceivedBookingsState {
  final String message;

  const ReceivedBookingsError(this.message);
}

class ReceivedBookingsActionInProgress extends ReceivedBookingsState {
  final List<BookingWithDetails> bookings;
  final int bookingId;
  final String action; // 'accept' or 'reject'

  const ReceivedBookingsActionInProgress({
    required this.bookings,
    required this.bookingId,
    required this.action,
  });
}
