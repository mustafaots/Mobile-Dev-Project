import 'package:easy_vacation/models/bookings.model.dart';
import 'package:easy_vacation/models/posts.model.dart';

abstract class BookingsListState {
  const BookingsListState();
}

class BookingsListInitial extends BookingsListState {
  const BookingsListInitial();
}

class BookingsListLoading extends BookingsListState {
  const BookingsListLoading();
}

class BookingsListLoaded extends BookingsListState {
  final List<Booking> allBookings;
  final List<Post> allPosts;
  final String selectedFilter;

  const BookingsListLoaded({
    required this.allBookings,
    required this.allPosts,
    required this.selectedFilter,
  });

  // CopyWith method for easier state updates
  BookingsListLoaded copyWith({
    List<Booking>? allBookings,
    List<Post>? allPosts,
    String? selectedFilter,
  }) {
    return BookingsListLoaded(
      allBookings: allBookings ?? this.allBookings,
      allPosts: allPosts ?? this.allPosts,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  // Get filtered bookings based on selected filter
  List<Map<String, dynamic>> getFilteredBookings() {
    List<Booking> filtered;

    if (selectedFilter == 'all') {
      filtered = allBookings;
    } else {
      filtered = allBookings
          .where((booking) => booking.status == selectedFilter)
          .toList();
    }

    return filtered.map((booking) {
      final post = allPosts.firstWhere(
        (p) => p.id == booking.postId,
        orElse: () => Post(
          ownerId: 0,
          category: 'unknown',
          title: 'Unknown Post',
          price: 0,
          locationId: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          availability: [],
        ),
      );

      return {
        'booking': booking,
        'post': post,
        'imagePath': post.contentUrl ?? 'assets/images/placeholder.jpg',
        'status': booking.status,
        'title': post.title,
        'price': '${post.price} DZD',
        'date':
            '${booking.startTime.day}-${booking.endTime.day} ${_getMonthName(booking.startTime.month)}, ${booking.startTime.year}',
      };
    }).toList();
  }

  static String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}

class BookingsListError extends BookingsListState {
  final String message;

  const BookingsListError(this.message);
}
