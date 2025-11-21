import 'package:easy_vacation/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Bookings',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter chips
            _buildFilterChips(context),

            // Bookings list
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildBookingCard(
                      context: context,
                      imagePath: 'assets/images/cozy_cabin.jpg',
                      status: 'Confirmed',
                      statusColor: AppTheme.successColor,
                      title: 'Cozy Cabin in the Woods',
                      price: '7000 DZD',
                      date: '12-15 May, 2024',
                    ),
                    _buildBookingCard(
                      context: context,
                      imagePath: 'assets/images/beachfront_villa.jpg',
                      status: 'Pending',
                      statusColor: AppTheme.neutralColor,
                      title: 'Beachfront Villa',
                      price: '25000 DZD',
                      date: '20-28 June, 2024',
                    ),
                    _buildBookingCard(
                      context: context,
                      imagePath: 'assets/images/city_loft.jpg',
                      status: 'Canceled',
                      statusColor: AppTheme.failureColor,
                      title: 'City Loft',
                      price: '8000 DZD',
                      date: '5-7 August, 2024',
                    ),

                    // Empty state
                    _buildEmptyState(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final List<String> filters = ['All', 'Pending', 'Confirmed', 'Canceled'];

    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: filters.asMap().entries.map((entry) {
          final index = entry.key;
          final filter = entry.value;
          final isSelected = index == 0; // First one selected by default

          return Padding(
            padding: EdgeInsets.only(right: index < filters.length - 1 ? 8 : 0),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              checkmarkColor: backgroundColor,
              selectedShadowColor: backgroundColor,
              onSelected: (_) {},
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
    final backgroundColor = context.scaffoldBackgroundColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppTheme.cardDecoration,
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
                        onPressed: () {},
                        style: AppTheme.primaryButtonStyle.copyWith(
                          minimumSize: WidgetStateProperty.all(
                            const Size(0, 36),
                          ),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 14,
                            color: backgroundColor,
                          ),
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
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(48),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          Icon(Icons.luggage, size: 64, color: secondaryTextColor),
          const SizedBox(height: 16),
          Text(
            'No Bookings Yet',
            style: AppTheme.header2.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You have no upcoming or past bookings. Time to plan your next adventure!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: secondaryTextColor),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: () => {
                ///////////////////////////////////////////////////////
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
                ///////////////////////////////////////////////////////
              },
              style: AppTheme.primaryButtonStyle,
              child: Text(
                'Explore Stays',
                style: TextStyle(color: backgroundColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
