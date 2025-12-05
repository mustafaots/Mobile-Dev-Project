import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/bookings.model.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/logic/cubit/bookings_cubit.dart';
import 'package:easy_vacation/logic/cubit/bookings_state.dart';
import 'package:easy_vacation/logic/cubit/dummy_data.dart';
import 'package:easy_vacation/repositories/db_repositories/booking_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/screens/Home Screen/HomeScreen.dart';
import 'package:easy_vacation/screens/BookedPostScreen.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/main.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bookingRepository = appRepos['bookingRepo'] as BookingRepository;
        final postRepository = appRepos['postRepo'] as PostRepository;

        return BookingsCubit(
          bookingRepository: bookingRepository,
          postRepository: postRepository,
        )..loadBookings();
      },
      child: const _BookingsScreenContent(),
    );
  }
}

class _BookingsScreenContent extends StatelessWidget {
  const _BookingsScreenContent();

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, loc.bookings_title),
      body: BlocBuilder<BookingsCubit, BookingsState>(
        builder: (context, state) {
          if (state is BookingsLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          if (state is BookingsError) {
            return Center(child: Text(state.message));
          }

          if (state is BookingsLoaded) {
            final filteredBookings = _getFilteredBookings(
              state.allBookings,
              state.allPosts,
              state.selectedFilter,
            );

            return SafeArea(
              child: Column(
                children: [
                  // Filter chips
                  _buildFilterChips(context, state.selectedFilter),

                  // Bookings list
                  Expanded(
                    child: filteredBookings.isEmpty
                        ? _buildEmptyState(context, state.selectedFilter)
                        : SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: filteredBookings.map((bookingData) {
                                return _buildBookingCard(
                                  context: context,
                                  imagePath: bookingData['imagePath'],
                                  booking: bookingData['booking'],
                                  status: _getStatusLabel(
                                    context,
                                    bookingData['status'],
                                  ),
                                  statusColor: _getStatusColor(
                                    bookingData['status'],
                                  ),
                                  title: bookingData['title'],
                                  price: bookingData['price'],
                                  date: bookingData['date'],
                                  onRefresh: () {
                                    context
                                        .read<BookingsCubit>()
                                        .reloadBookings();
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  static String _getStatusLabel(BuildContext context, String status) {
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

  static Color _getStatusColor(String status) {
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

  static List<Map<String, dynamic>> _getFilteredBookings(
    List<Booking> allBookings,
    List<Post> allPosts,
    String selectedFilter,
  ) {
    List<Booking> filtered;

    if (selectedFilter == 'all') {
      filtered = allBookings;
    } else {
      filtered = allBookings
          .where((booking) => booking.status == selectedFilter)
          .toList();
    }

    return filtered.map((booking) {
      // Find the corresponding post - use postId from booking
      Post post;
      try {
        post = allPosts.firstWhere((p) => p.id == booking.postId);
      } catch (e) {
        // If post not found, generate it from dummy data
        post = _getDummyPostForBooking(booking.postId);
      }

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

  static Post _getDummyPostForBooking(int postId) {
    return DummyDataProvider.getDummyPost(postId);
  }

  static Widget _buildFilterChips(BuildContext context, String selectedFilter) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final loc = AppLocalizations.of(context)!;

    final filterOptions = [
      {'key': 'all', 'label': loc.bookings_all},
      {'key': 'pending', 'label': loc.bookings_pending},
      {'key': 'confirmed', 'label': loc.bookings_confirmed},
      {'key': 'rejected', 'label': loc.bookings_rejected},
    ];

    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: filterOptions.asMap().entries.map((entry) {
          final index = entry.key;
          final filter = entry.value;
          final isSelected = selectedFilter == filter['key'];

          return Padding(
            padding: EdgeInsets.only(
              right: index < filterOptions.length - 1 ? 8 : 0,
            ),
            child: FilterChip(
              label: Text(filter['label']!),
              selected: isSelected,
              checkmarkColor: backgroundColor,
              selectedShadowColor: backgroundColor,
              onSelected: (_) {
                context.read<BookingsCubit>().setFilter(filter['key']!);
              },
              backgroundColor: backgroundColor,
              selectedColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? backgroundColor : textColor,
                fontWeight: FontWeight.w500,
              ),
              shape: StadiumBorder(
                side: BorderSide(color: secondaryTextColor.withOpacity(0.3)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static Widget _buildBookingCard({
    required BuildContext context,
    required String imagePath,
    required Booking booking,
    required String status,
    required Color statusColor,
    required String title,
    required String price,
    required String date,
    required VoidCallback onRefresh,
  }) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor; // Add this

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        // Replace AppTheme.cardDecoration
        color: cardColor, // Use theme card color
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppTheme.header2.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            price,
                            style: TextStyle(
                              fontSize: 16,
                              color: secondaryTextColor,
                            ),
                          ),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 16,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookedPostScreen(
                                postId: booking.postId,
                                onBookingCanceled: onRefresh,
                              ),
                            ),
                          );
                        },
                        style: AppTheme.primaryButtonStyle.copyWith(
                          minimumSize: WidgetStateProperty.all(
                            const Size(0, 36),
                          ),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.bookings_viewDetails,
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildEmptyState(BuildContext context, String selectedFilter) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;
    final loc = AppLocalizations.of(context)!;

    final message = selectedFilter == 'all'
        ? loc.bookings_emptyMessage
        : 'No ${selectedFilter} bookings yet';

    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.luggage, size: 64, color: secondaryTextColor),
            const SizedBox(height: 16),
            Text(
              loc.bookings_noBookingsYet,
              style: AppTheme.header2.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: secondaryTextColor),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const HomeScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  ),
                },
                style: AppTheme.primaryButtonStyle,
                child: Text(
                  loc.bookings_exploreStays,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
