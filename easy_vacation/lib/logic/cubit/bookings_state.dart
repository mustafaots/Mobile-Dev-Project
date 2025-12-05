import 'package:easy_vacation/models/bookings.model.dart';
import 'package:easy_vacation/models/posts.model.dart';

abstract class BookingsState {
  const BookingsState();
}

class BookingsInitial extends BookingsState {
  const BookingsInitial();
}

class BookingsLoading extends BookingsState {
  const BookingsLoading();
}

class BookingsLoaded extends BookingsState {
  final List<Booking> allBookings;
  final List<Post> allPosts;
  final String selectedFilter;

  const BookingsLoaded({
    required this.allBookings,
    required this.allPosts,
    this.selectedFilter = 'all',
  });

  BookingsLoaded copyWith({
    List<Booking>? allBookings,
    List<Post>? allPosts,
    String? selectedFilter,
  }) {
    return BookingsLoaded(
      allBookings: allBookings ?? this.allBookings,
      allPosts: allPosts ?? this.allPosts,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

class BookingsError extends BookingsState {
  final String message;

  const BookingsError(this.message);
}
