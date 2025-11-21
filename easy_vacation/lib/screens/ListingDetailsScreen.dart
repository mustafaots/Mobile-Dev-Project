import 'package:easy_vacation/screens/BookingsScreen.dart';
import 'package:easy_vacation/screens/ProfileScreen.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
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

    return Scaffold(
      appBar: App_Bar(context, 'Listing Details'),
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
    final cardColor = context.cardColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: AssetImage('assets/images/host_Ali.jpg'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  width: 2,
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: AppTheme.neutralColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '4.9 (127 reviews)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Super Host',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '6000 DZD',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                'per night',
                style: TextStyle(
                  fontSize: 12,
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    final textColor = context.textColor;
    final cardColor = context.cardColor;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: AppTheme.neutralColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
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
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    return GestureDetector(
      onTap: () {
        _navigateToProfile(
          context,
          userName: name,
          userEmail: '${name.toLowerCase().replaceAll(' ', '.')}@example.com',
          userImage: avatarPath,
          postsCount: postsCount,
          followersCount: followersCount,
          followingCount: followingCount,
          reviewsCount: reviewsCount,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: secondaryTextColor.withOpacity(0.1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reviewer Profile Picture
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(avatarPath),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        _buildStarRating(rating),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      comment,
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryTextColor,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '2 days ago',
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryTextColor.withOpacity(0.7),
                      ),
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
        const SizedBox(width: 4),
        Text(
          rating.toString(),
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.neutralColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection(BuildContext context) {
    final textColor = context.textColor;
    final cardColor = context.cardColor;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: AppTheme.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Availability',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCalendarGrid(context),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    
    return Column(
      children: [
        // Month selector
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
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
        ),
        const SizedBox(height: 16),
        
        // Week days header
        Row(
          children: _weekDays
              .map(
                (day) => Expanded(
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14, 
                      color: secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),

        // Calendar days
        for (int row = 0; row < _calendarDays.length; row++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: _calendarDays[row].asMap().entries.map((entry) {
                String day = entry.value;
                bool isAvailable = !['13', '14', '23', '24'].contains(day);
                bool isSelected = ['7', '8', '9', '10'].contains(day);

                return Expanded(
                  child: Container(
                    height: 36,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: AppTheme.primaryColor, width: 1.5)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isAvailable
                              ? (isSelected ? AppTheme.primaryColor : textColor)
                              : secondaryTextColor,
                          decoration: !isAvailable
                              ? TextDecoration.lineThrough
                              : null,
                        ),
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
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, -4),
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
                          position: Tween<Offset>(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Reserve Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 60,
              child: IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: cardColor,
                  foregroundColor: textColor,
                  minimumSize: const Size(0, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: secondaryTextColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                icon: const Icon(Icons.edit, size: 20),
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
            position: Tween<Offset>(
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