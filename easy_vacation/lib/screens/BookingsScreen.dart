import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/Home Screen/HomeScreen.dart';
import 'package:easy_vacation/screens/BookedPostScreen.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  late String _selectedFilter;

  // Sample booking data
  late List<Map<String, dynamic>> _allBookings;

  @override
  void initState() {
    super.initState();
    _selectedFilter = 'all';
    _initializeBookings();
  }

  void _initializeBookings() {
    _allBookings = [
      {
        'imagePath': 'assets/images/cozy_cabin.jpg',
        'status': 'confirmed',
        'title': 'Cozy Cabin in the Woods',
        'price': '7000 DZD',
        'date': '12-15 May, 2024',
      },
      {
        'imagePath': 'assets/images/beachfront_villa.jpg',
        'status': 'pending',
        'title': 'Beachfront Villa',
        'price': '25000 DZD',
        'date': '20-28 June, 2024',
      },
      {
        'imagePath': 'assets/images/city_loft.jpg',
        'status': 'canceled',
        'title': 'City Loft',
        'price': '8000 DZD',
        'date': '5-7 August, 2024',
      },
    ];
  }

  List<Map<String, dynamic>> _getFilteredBookings() {
    if (_selectedFilter == 'all') {
      return _allBookings;
    }
    return _allBookings
        .where((booking) => booking['status'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final loc = AppLocalizations.of(context)!;
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
                        children: filteredBookings.map((booking) {
                          return _buildBookingCard(
                            context: context,
                            imagePath: booking['imagePath'],
                            status: _getStatusLabel(context, booking['status']),
                            statusColor: _getStatusColor(booking['status']),
                            title: booking['title'],
                            price: booking['price'],
                            date: booking['date'],
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
                              builder: (context) => const BookedPostScreen(),
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
