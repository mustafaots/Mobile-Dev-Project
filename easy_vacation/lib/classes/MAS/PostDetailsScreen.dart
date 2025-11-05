import 'package:flutter/material.dart';
import 'package:easy_vacation/classes/MAS/BookingsScreen.dart';
import 'package:easy_vacation/shared/themes.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  // Move static data to class level to avoid rebuilding
  static const List<List<String>> _calendarDays = [
    ['28', '29', '30', '1', '2', '3', '4'],
    ['5', '6', '7', '8', '9', '10', '11'],
    ['12', '13', '14', '15', '16', '17', '18'],
    ['19', '20', '21', '22', '23', '24', '25'],
    ['26', '27', '28', '29', '30', '31', '1'],
  ];

  static const List<String> _weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Listing Details',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),

        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageGallery(),
                  _buildTitleSection(),
                  _buildHostInfo(),
                  _buildReviewsSection(),
                  _buildAvailabilitySection(),
                  const SizedBox(height: 112),
                ],
              ),
            ),
            _buildBottomActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.bookmark_border, color: AppTheme.white, size: 24),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share, color: AppTheme.white, size: 24),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
    );
  }

  Widget _buildImageGallery() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (context, index) {
          final images = const [
            {'path': 'assets/images/beachfront_cottage.jpg', 'alt': 'A beautiful beachfront cottage with a porch'},
            {'path': 'assets/images/living_room.jpg', 'alt': 'The cozy living room of the cottage with a fireplace'},
            {'path': 'assets/images/bedroom_ocean_view.jpg', 'alt': 'A bedroom with a view of the ocean'},
          ];
          return Container(
            width: 300,
            margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(images[index]['path']!),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Serene Oceanfront Villa',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Escape to our charming beachfront villa, where you can relax and enjoy the sound of the waves. Perfect for a romantic getaway or a small family vacation.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildHeader(),
        ],
      ),
    );
  }

  Widget _buildHostInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              image: const DecorationImage(
                image: AssetImage('assets/images/host_Ali.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hosted by Ali',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '4.9 (127 reviews)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '6000 DZD/night',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              'Reviews',
              style: AppTheme.header2.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.black,
              ),
            ),
          ),
          _buildReviewItem(
            'assets/images/reviewer_alex.jpg',
            'Alex Johnson',
            4.5,
            'Absolutely stunning view and the villa was immaculate. Ali was a fantastic host!',
          ),
          _buildReviewItem(
            'assets/images/reviewer_maria.jpg',
            'Maria Garcia',
            5.0,
            'A perfect getaway. The location is unbeatable. Highly recommended.',
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String avatarPath, String name, double rating, String comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(avatarPath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                _buildStarRating(rating),
                const SizedBox(height: 8),
                Text(
                  comment,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++)
          Icon(
            i <= rating ? Icons.star : (i - 0.5 <= rating ? Icons.star_half : Icons.star_border),
            color: Colors.amber,
            size: 16,
          ),
      ],
    );
  }

  Widget _buildAvailabilitySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              'Availability',
              style: AppTheme.header2.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.black,
              ),
            ),
          ),
          Container(
            decoration: AppTheme.cardDecoration,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.chevron_left, color: AppTheme.grey),
                    Text(
                      'May 2024',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.black,
                      ),
                    ),
                    Icon(Icons.chevron_right, color: AppTheme.grey),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCalendarGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Column(
      children: [
        // Week days header
        Row(
          children: _weekDays.map((day) => Expanded(
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.grey,
              ),
            ),
          )).toList(),
        ),
        const SizedBox(height: 8),
        
        // Calendar days
        for (int row = 0; row < _calendarDays.length; row++)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: _calendarDays[row].asMap().entries.map((entry) {
                String day = entry.value;
                bool isAvailable = !['13', '14', '23', '24'].contains(day);
                bool isSelected = ['7', '8', '9', '10'].contains(day);
                
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor.withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isAvailable 
                            ? (isSelected ? AppTheme.primaryColor : AppTheme.black)
                            : AppTheme.grey,
                        decoration: !isAvailable ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.lightGrey,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const MyBookingsScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.fastOutSlowIn,
                          )),
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
                style: AppTheme.primaryButtonStyle,
                child: const Text(
                  'Reserve Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 112,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.white,
                  foregroundColor: AppTheme.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 4),
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}