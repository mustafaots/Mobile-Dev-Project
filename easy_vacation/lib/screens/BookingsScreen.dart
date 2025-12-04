import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/bookings.model.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/repositories/db_repositories/booking_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/screens/Home Screen/HomeScreen.dart';
import 'package:easy_vacation/screens/BookedPostScreen.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/main.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  late String _selectedFilter;
  late BookingRepository _bookingRepository;
  late PostRepository _postRepository;
  late List<Booking> _allBookings;
  late List<Post> _allPosts;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedFilter = 'all';
    _allBookings = [];
    _allPosts = [];
    _initializeRepositories();
  }

  void _initializeRepositories() {
    try {
      _bookingRepository = appRepos['bookingRepo'] as BookingRepository;
      _postRepository = appRepos['postRepo'] as PostRepository;
      _loadBookings();
    } catch (e) {
      setState(() {
        _error = 'Failed to load bookings: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadBookings() async {
    try {
      final bookings = await _bookingRepository.getAllBookings();
      final posts = await _postRepository.getAllPosts();

      setState(() {
        _allBookings = bookings;
        _allPosts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load bookings: $e';
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getFilteredBookings() {
    List<Booking> filtered;

    if (_selectedFilter == 'all') {
      filtered = _allBookings;
    } else {
      filtered = _allBookings
          .where((booking) => booking.status == _selectedFilter)
          .toList();
    }

    return filtered.map((booking) {
      // Find the corresponding post
      final post = _allPosts.firstWhere(
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

  String _getMonthName(int month) {
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

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final loc = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: App_Bar(context, loc.bookings_title),
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: App_Bar(context, loc.bookings_title),
        body: Center(child: Text(_error!)),
      );
    }

    final filteredBookings = _getFilteredBookings();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, loc.bookings_title),
      body: SafeArea(
        child: Column(
          children: [
            // Filter chips
            _buildFilterChips(context),

            // Bookings list
            Expanded(
              child: filteredBookings.isEmpty
                  ? _buildEmptyState(context)
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
                            statusColor: _getStatusColor(bookingData['status']),
                            title: bookingData['title'],
                            price: bookingData['price'],
                            date: bookingData['date'],
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(BuildContext context, String status) {
    final loc = AppLocalizations.of(context)!;
    switch (status) {
      case 'confirmed':
        return loc.bookings_confirmed;
      case 'pending':
        return loc.bookings_pending;
      case 'canceled':
        return loc.bookings_canceled;
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return AppTheme.successColor;
      case 'pending':
        return AppTheme.neutralColor;
      case 'canceled':
        return AppTheme.failureColor;
      default:
        return AppTheme.neutralColor;
    }
  }

  Widget _buildFilterChips(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final loc = AppLocalizations.of(context)!;

    final filterOptions = [
      {'key': 'all', 'label': loc.bookings_all},
      {'key': 'pending', 'label': loc.bookings_pending},
      {'key': 'confirmed', 'label': loc.bookings_confirmed},
      {'key': 'canceled', 'label': loc.bookings_canceled},
    ];

    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: filterOptions.asMap().entries.map((entry) {
          final index = entry.key;
          final filter = entry.value;
          final isSelected = _selectedFilter == filter['key'];

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
                setState(() {
                  _selectedFilter = filter['key']!;
                });
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

  Widget _buildBookingCard({
    required BuildContext context,
    required String imagePath,
    required Booking booking,
    required String status,
    required Color statusColor,
    required String title,
    required String price,
    required String date,
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
                              builder: (context) =>
                                  BookedPostScreen(postId: booking.postId),
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

  Widget _buildEmptyState(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;
    final loc = AppLocalizations.of(context)!;

    final message = _selectedFilter == 'all'
        ? loc.bookings_emptyMessage
        : 'No ${_selectedFilter} bookings yet';

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
