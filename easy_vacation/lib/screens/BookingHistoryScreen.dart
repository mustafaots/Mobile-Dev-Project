import 'package:easy_vacation/screens/HomeScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/theme_helper.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Booking History',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const HomeScreen(),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
            },
            icon: Icon(Icons.home_filled, size: 40),
            color: AppTheme.primaryColor,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Simple filter chips
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ['All', 'Upcoming', 'Completed', 'Cancelled']
                      .map(
                        (filter) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: filter == 'All',
                            onSelected: (_) {},
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              // Booking list
              Expanded(
                child: ListView(
                  children: [
                    _buildBookingCard(
                      context,
                      'Beachfront Villa',
                      'May 15 - 20, 2024',
                      'Completed',
                      '12,000 DZD',
                      'assets/images/beachfront_cottage.jpg',
                    ),
                    _buildBookingCard(
                      context,
                      'Mountain Cabin',
                      'June 1 - 5, 2024',
                      'Upcoming',
                      '8,500 DZD',
                      'assets/images/living_room.jpg',
                    ),
                    _buildBookingCard(
                      context,
                      'City Apartment',
                      'April 10 - 12, 2024',
                      'Completed',
                      '6,000 DZD',
                      'assets/images/bedroom_ocean_view.jpg',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(
    BuildContext context,
    String title,
    String dates,
    String status,
    String price,
    String imagePath,
  ) {
    final cardColor = context.cardColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: textColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Property Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Booking Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dates,
                    style: TextStyle(fontSize: 14, color: secondaryTextColor),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppTheme.successColor;
      case 'upcoming':
        return AppTheme.primaryColor;
      case 'cancelled':
        return AppTheme.failureColor;
      default:
        return AppTheme.grey;
    }
  }
}
