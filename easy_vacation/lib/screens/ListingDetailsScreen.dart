import 'package:easy_vacation/screens/BookingsScreen.dart';
import 'package:easy_vacation/screens/HomeScreen.dart';
import 'package:easy_vacation/screens/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';

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

  static const List<String> _weekDays = [
    'Su',
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
  ];

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Listing Details',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        backgroundColor: backgroundColor,
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
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageGallery(),
                  _buildTitleSection(context),
                  _buildHostInfo(context),
                  _buildReviewsSection(context),
                  _buildAvailabilitySection(context),
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

  Widget _buildHeader(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.bookmark_border, color: backgroundColor, size: 24),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.share, color: backgroundColor, size: 24),
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
            {
              'path': 'assets/images/beachfront_cottage.jpg',
              'alt': 'A beautiful beachfront cottage with a porch',
            },
            {
              'path': 'assets/images/living_room.jpg',
              'alt': 'The cozy living room of the cottage with a fireplace',
            },
            {
              'path': 'assets/images/bedroom_ocean_view.jpg',
              'alt': 'A bedroom with a view of the ocean',
            },
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

  Widget _buildTitleSection(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
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
              color: textColor,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Escape to our charming beachfront villa, where you can relax and enjoy the sound of the waves. Perfect for a romantic getaway or a small family vacation.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: secondaryTextColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildHeader(context),
        ],
      ),
    );
  }

  Widget _buildHostInfo(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Host Profile Picture with Blue Ring and Gesture Detector
          GestureDetector(
            onTap: () {
              _navigateToProfile(
                context,
                userName: 'Ali',
                userEmail: 'ali@example.com',
                userImage: 'assets/images/host_Ali.jpg',
                postsCount: 24,
                followersCount: 128,
                followingCount: 56,
                reviewsCount: 127,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(.5), // This creates the ring space
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryColor, width: 2),
              ),
              child: Container(
                width: 52, // Reduced to account for padding
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/host_Ali.jpg'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: backgroundColor, width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hosted by Ali',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: AppTheme.neutralColor, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '4.9 (127 reviews)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: secondaryTextColor,
                        ),
                        overflow: TextOverflow.ellipsis,
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
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    final textColor = context.textColor;
    
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
                color: textColor,
              ),
            ),
          ),
          _buildReviewItem(
            context,
            'assets/images/reviewer_alex.jpg',
            'Alex Johnson',
            4.5,
            'Absolutely stunning view and the villa was immaculate. Ali was a fantastic host!',
            postsCount: 18,
            followersCount: 89,
            followingCount: 45,
            reviewsCount: 23,
          ),
          _buildReviewItem(
            context,
            'assets/images/reviewer_maria.jpg',
            'Maria Garcia',
            5.0,
            'A perfect getaway. The location is unbeatable. Highly recommended.',
            postsCount: 32,
            followersCount: 156,
            followingCount: 78,
            reviewsCount: 45,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(
    BuildContext context,
    String avatarPath,
    String name,
    double rating,
    String comment, {
    int postsCount = 0,
    int followersCount = 0,
    int followingCount = 0,
    int reviewsCount = 0,
  }) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer Profile Picture with Blue Ring and Gesture Detector
          GestureDetector(
            onTap: () {
              _navigateToProfile(
                context,
                userName: name,
                userEmail:
                    '${name.toLowerCase().replaceAll(' ', '.')}@example.com',
                userImage: avatarPath,
                postsCount: postsCount,
                followersCount: followersCount,
                followingCount: followingCount,
                reviewsCount: reviewsCount,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(.5), // Ring space
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryColor, width: 1.5),
              ),
              child: Container(
                width: 37, // Reduced to account for padding
                height: 37,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(avatarPath),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: backgroundColor, width: 1.5),
                ),
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                _buildStarRating(rating),
                const SizedBox(height: 8),
                Text(
                  comment,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: secondaryTextColor,
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
            i <= rating
                ? Icons.star
                : (i - 0.5 <= rating ? Icons.star_half : Icons.star_border),
            color: AppTheme.neutralColor,
            size: 16,
          ),
      ],
    );
  }

  Widget _buildAvailabilitySection(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
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
                color: textColor,
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
                    Icon(Icons.chevron_left, color: secondaryTextColor),
                    Text(
                      'May 2024',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    Icon(Icons.chevron_right, color: secondaryTextColor),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCalendarGrid(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    return Column(
      children: [
        // Week days header
        Row(
          children: _weekDays
              .map(
                (day) => Expanded(
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: secondaryTextColor),
                  ),
                ),
              )
              .toList(),
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
                      color: isSelected
                          ? AppTheme.primaryColor.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isAvailable
                            ? (isSelected ? AppTheme.primaryColor : textColor)
                            : secondaryTextColor,
                        decoration: !isAvailable
                            ? TextDecoration.lineThrough
                            : null,
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
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

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
              color: textColor.withOpacity(0.1),
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
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const BookingsScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        return SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.fastOutSlowIn,
                                ),
                              ),
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
                style: AppTheme.primaryButtonStyle,
                child: Text(
                  'Reserve Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: backgroundColor,
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
                  backgroundColor: backgroundColor,
                  foregroundColor: secondaryTextColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, size: 20, color: secondaryTextColor),
                    const SizedBox(width: 4),
                    Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: secondaryTextColor,
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

  void _navigateToProfile(
    BuildContext context, {
    required String userName,
    required String userEmail,
    required String userImage,
    required int postsCount,
    required int followersCount,
    required int followingCount,
    required int reviewsCount,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ProfileScreen(
          userName: userName,
          userEmail: userEmail,
          userImage: userImage,
          postsCount: postsCount,
          followersCount: followersCount,
          followingCount: followingCount,
          reviewsCount: reviewsCount,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
