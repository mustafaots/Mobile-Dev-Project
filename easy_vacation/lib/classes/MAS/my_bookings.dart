import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Filter chips
            _buildFilterChips(),
            
            // Bookings list
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildBookingCard(
                      imagePath: 'assets/images/cozy_cabin.jpg',
                      status: 'Confirmed',
                      statusColor: Colors.green,
                      title: 'Cozy Cabin in the Woods',
                      price: '7000 DZD',
                      date: '12-15 May, 2024',
                    ),
                    _buildBookingCard(
                      imagePath: 'assets/images/beachfront_villa.jpg',
                      status: 'Pending',
                      statusColor: Colors.orange,
                      title: 'Beachfront Villa',
                      price: '25000 DZD',
                      date: '20-28 June, 2024',
                    ),
                    _buildBookingCard(
                      imagePath: 'assets/images/city_loft.jpg',
                      status: 'Canceled',
                      statusColor: Colors.red,
                      title: 'City Loft',
                      price: '8000 DZD',
                      date: '5-7 August, 2024',
                    ),
                    
                    // Empty state
                    _buildEmptyState(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'My Bookings',
              textAlign: TextAlign.center,
              style: AppTheme.header2.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.black,
              ),
            ),
          ),
          const SizedBox(width: 48), // Spacer for balance
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final List<String> filters = ['All', 'Pending', 'Confirmed', 'Canceled'];
    
    return SizedBox(
      height: 40,
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
              onSelected: (_) {},
              backgroundColor: AppTheme.white,
              selectedColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.white : AppTheme.black,
                fontWeight: FontWeight.w500,
              ),
              shape: StadiumBorder(
                side: BorderSide(color: AppTheme.grey.withOpacity(0.3)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBookingCard({
    required String imagePath,
    required String status,
    required Color statusColor,
    required String title,
    required String price,
    required String date,
  }) {
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
                    color: AppTheme.black,
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
                              color: AppTheme.grey,
                            ),
                          ),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.grey,
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
                          minimumSize: MaterialStateProperty.all(const Size(0, 36)),
                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 8)),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(fontSize: 14),
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

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(48),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          Icon(
            Icons.luggage,
            size: 64,
            color: AppTheme.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No Bookings Yet',
            style: AppTheme.header2.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You have no upcoming or past bookings. Time to plan your next adventure!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.grey,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: () {},
              style: AppTheme.primaryButtonStyle,
              child: const Text('Explore Stays'),
            ),
          ),
        ],
      ),
    );
  }
}