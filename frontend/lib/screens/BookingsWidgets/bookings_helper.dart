import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/bookings.model.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';

/// Helper class for booking-related utility functions
class BookingsHelper {
  /// Get localized status label
  static String getStatusLabel(BuildContext context, String status) {
    final loc = AppLocalizations.of(context)!;
    switch (status) {
      case 'confirmed':
        return loc.bookings_confirmed;
      case 'pending':
        return loc.bookings_pending;
      case 'rejected':
        return loc.bookings_rejected;
      default:
        return status;
    }
  }

  /// Get status color based on status
  static Color getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppTheme.successColor;
      case 'pending':
        return AppTheme.neutralColor;
      case 'rejected':
        return AppTheme.failureColor;
      default:
        return AppTheme.neutralColor;
    }
  }

  /// Format month name
  static String getMonthName(int month) {
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

  /// Filter bookings based on selected filter
  static List<Map<String, dynamic>> getFilteredBookings(
    List<Booking> allBookings,
    List<Post> allPosts,
    String selectedFilter,
  ) {
    // First, exclude cancelled bookings
    final activeBookings = allBookings
        .where((booking) => booking.status != 'cancelled')
        .toList();

    List<Booking> filtered;

    if (selectedFilter == 'all') {
      filtered = activeBookings;
    } else {
      filtered = activeBookings
          .where((booking) => booking.status == selectedFilter)
          .toList();
    }

    return filtered
        .map((booking) {
          // Find the corresponding post - use postId from booking
          Post? post;
          try {
            post = allPosts.firstWhere((p) => p.id == booking.postId);
          } catch (_) {
            post = null;
          }

          if (post == null) {
            return null;
          }

          return {
            'booking': booking,
            'post': post,
            'imagePath': post.contentUrl ?? 'assets/images/placeholder.jpg',
            'status': booking.status,
            'title': post.title,
            'price': '${post.price} DZD',
            'date':
                '${booking.startTime.day}-${booking.endTime.day} ${getMonthName(booking.startTime.month)}, ${booking.startTime.year}',
          };
        })
        .whereType<Map<String, dynamic>>()
        .toList();
  }

  /// Format date range for display
  static String formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '';
    return '${start.day}-${end.day} ${getMonthName(start.month)}, ${start.year}';
  }
}
