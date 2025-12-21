import 'package:easy_vacation/screens/ReportUserScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? bio;
  final String subscriptionType;
  final int postsCount;
  final bool isFollowing;
  final int reviewsCount;
  final double overallRating;
  final int totalReviews;

  const ProfileScreen({
    super.key,
    this.userName = 'User',
    this.firstName,
    this.lastName,
    this.email,
    this.bio,
    this.subscriptionType = 'Free',
    this.postsCount = 0,
    this.isFollowing = false,
    this.reviewsCount = 0,
    this.overallRating = 4,
    this.totalReviews = 0,
  });

  String get displayName {
    if (firstName != null && firstName!.isNotEmpty) {
      if (lastName != null && lastName!.isNotEmpty) {
        return '$firstName $lastName';
      }
      return firstName!;
    }
    // Fall back to userName only if it's not an email
    if (userName.isNotEmpty && !userName.contains('@')) {
      return userName;
    }
    return 'User';
  }

  String get initials {
    if (firstName != null && firstName!.isNotEmpty) {
      if (lastName != null && lastName!.isNotEmpty) {
        return '${firstName![0]}${lastName![0]}'.toUpperCase();
      }
      return firstName![0].toUpperCase();
    }
    if (userName.isNotEmpty && !userName.contains('@')) {
      return userName[0].toUpperCase();
    }
    if (email != null && email!.isNotEmpty) {
      return email![0].toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;
    
    // TODO: Add localization
    // final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile', // TODO: Add localization - loc.profile_title
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: AppTheme.white),
            onPressed: () {
              _showOptionsMenu(context);
            },
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Profile Image and Stats
                    Row(
                      children: [
                        // Profile Image with Initials
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.primaryColor,
                              width: 2,
                            ),
                            color: AppTheme.primaryColor.withOpacity(0.1),
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Stats - Now with 3 columns
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatColumn(postsCount, 'Posts', context), // TODO: Add localization - loc.profile_posts
                              _buildRatingColumn(overallRating, 'Rating', context), // TODO: Add localization - loc.profile_rating
                              _buildStatColumn(totalReviews, 'Reviews', context), // TODO: Add localization - loc.profile_totalReviews
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // User Name and Bio
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bio ?? 'Sharing experiences and tips!',
                          style: TextStyle(fontSize: 14, color: textColor),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Content Tabs
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Tab Bar
                    Container(
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
                      child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              labelColor: AppTheme.primaryColor,
                              unselectedLabelColor: secondaryTextColor,
                              indicatorColor: AppTheme.primaryColor,
                              tabs: [
                                Tab(text: 'Posts'), // TODO: Add localization - loc.profile_posts
                                Tab(text: 'Reviews'), // TODO: Add localization - loc.profile_reviews
                              ],
                            ),
                            SizedBox(
                              height:
                                  400, // Increased height for better content display
                              child: TabBarView(
                                children: [
                                  // Posts Tab
                                  postsCount == 0
                                      ? _buildContentTab(
                                          'No posts yet', // TODO: Add localization - loc.profile_noPostsYet
                                          Icons.article,
                                          context,
                                        )
                                      : _buildPostsGrid(context),

                                  // Reviews Tab
                                  reviewsCount == 0
                                      ? _buildContentTab(
                                          'No reviews yet', // TODO: Add localization - loc.profile_noReviewsYet
                                          Icons.star,
                                          context,
                                        )
                                      : _buildReviewsList(context),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Additional Info Section
                    _buildInfoSection(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(int count, String label, BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: context.secondaryTextColor),
        ),
      ],
    );
  }

  // New method for rating column with stars
  Widget _buildRatingColumn(double rating, String label, BuildContext context) {
    return Column(
      children: [
        // Rating number with star icon
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              rating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: context.secondaryTextColor),
        ),
      ],
    );
  }

  Widget _buildContentTab(String message, IconData icon, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: context.secondaryTextColor.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: context.secondaryTextColor, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    // TODO: Add localization
    // final loc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: textColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About', // TODO: Add localization - loc.profile_about
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.location_on,
            'From', // TODO: Add localization - loc.profile_from
            'Casablanca, Morocco',
            context,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.calendar_today,
            'Member since', // TODO: Add localization - loc.profile_memberSince
            'January 2024',
            context,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.flag,
            'Countries visited', // TODO: Add localization - loc.profile_countriesVisited
            '12 countries',
            context,
          ),
          const SizedBox(height: 8),
          // New row for overall rating in the info section
          _buildInfoRow(
            Icons.star,
            'Overall Rating', // TODO: Add localization - loc.profile_overallRating
            '$overallRating/5.0 ($totalReviews reviews)', // TODO: Add localization for "reviews"
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value,
    BuildContext context,
  ) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12, color: context.secondaryTextColor),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: context.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Posts Grid
  Widget _buildPostsGrid(BuildContext context) {
    final List<Post> samplePosts = [
      Post(
        image: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
        title: 'Beautiful Beach Day',
        location: 'Bali, Indonesia',
        likes: 42,
        date: '2 days ago',
      ),
      Post(
        image: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
        title: 'Mountain Adventure',
        location: 'Swiss Alps',
        likes: 89,
        date: '1 week ago',
      ),
      Post(
        image: 'https://images.unsplash.com/photo-1549294413-26f195200c16',
        title: 'City Exploration',
        location: 'Tokyo, Japan',
        likes: 156,
        date: '2 weeks ago',
      ),
      Post(
        image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
        title: 'Desert Safari',
        location: 'Dubai, UAE',
        likes: 67,
        date: '3 weeks ago',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: samplePosts.length,
        itemBuilder: (context, index) {
          return _buildPostCard(samplePosts[index], context);
        },
      ),
    );
  }

  Widget _buildPostCard(Post post, BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    return GestureDetector(
      onTap: () {
        _showPostDetail(context, post);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: textColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                post.image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Post Details
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          post.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 12,
                        color: AppTheme.failureColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likes}',
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryTextColor,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        post.date,
                        style: TextStyle(
                          fontSize: 10,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reviews List
  Widget _buildReviewsList(BuildContext context) {
    final List<Review> sampleReviews = [
      Review(
        placeName: 'Luxury Beach Resort',
        location: 'Maldives',
        rating: 5,
        comment:
            'Absolutely stunning resort with incredible service. The overwater bungalows were worth every penny!',
        date: '1 week ago',
        helpful: 12,
      ),
      Review(
        placeName: 'Mountain Lodge',
        location: 'Switzerland',
        rating: 4,
        comment:
            'Beautiful views and cozy rooms. The food was excellent but a bit pricey.',
        date: '2 weeks ago',
        helpful: 8,
      ),
      Review(
        placeName: 'City Central Hotel',
        location: 'Tokyo, Japan',
        rating: 5,
        comment:
            'Perfect location for exploring the city. Staff was incredibly helpful and spoke excellent English.',
        date: '1 month ago',
        helpful: 15,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: sampleReviews.length,
      itemBuilder: (context, index) {
        return _buildReviewCard(sampleReviews[index], context);
      },
    );
  }

  Widget _buildReviewCard(Review review, BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    // TODO: Add localization
    // final loc = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: textColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    review.placeName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                _buildStarRating(review.rating),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: secondaryTextColor),
                const SizedBox(width: 4),
                Text(
                  review.location,
                  style: TextStyle(fontSize: 14, color: secondaryTextColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.comment,
              style: TextStyle(fontSize: 14, color: textColor, height: 1.4),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.thumb_up, size: 16, color: AppTheme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  '${review.helpful}',
                  style: TextStyle(fontSize: 12, color: secondaryTextColor),
                ),
                const SizedBox(width: 8),
                Text(
                  'helpful', // TODO: Add localization - loc.profile_helpful
                  style: TextStyle(fontSize: 12, color: secondaryTextColor),
                ),
                const Spacer(),
                Text(
                  review.date,
                  style: TextStyle(fontSize: 12, color: secondaryTextColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: AppTheme.primaryColor,
          size: 18,
        );
      }),
    );
  }

  void _showPostDetail(BuildContext context, Post post) {
    // TODO: Add localization
    // final loc = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (dialogContext) {
        final textColor = dialogContext.textColor;
        final secondaryTextColor = dialogContext.secondaryTextColor;

        return SizedBox(
          height: MediaQuery.of(dialogContext).size.height * 0.8,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Post Image
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(post.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Post Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            post.location,
                            style: TextStyle(
                              fontSize: 16,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'This was an amazing experience! The views were breathtaking and the local culture was incredibly rich. Highly recommend visiting this place for anyone looking for an adventure.',
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildActionButton(
                            Icons.favorite,
                            '${post.likes}',
                            dialogContext,
                          ),
                          const SizedBox(width: 16),
                          _buildActionButton(
                            Icons.comment,
                            '24',
                            dialogContext,
                          ),
                          const SizedBox(width: 16),
                          _buildActionButton(
                            Icons.share,
                            'share', // TODO: Add localization
                            dialogContext,
                          ),
                          const Spacer(),
                          Text(
                            post.date,
                            style: TextStyle(
                              fontSize: 12,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(IconData icon, String text, BuildContext context) {
    final secondaryTextColor = context.secondaryTextColor;

    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(height: 4),
        Text(text, style: TextStyle(fontSize: 12, color: secondaryTextColor)),
      ],
    );
  }

  void _showOptionsMenu(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    // TODO: Add localization
    // final loc = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (dialogContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.report, color: AppTheme.failureColor),
                title: Text(
                  'Report User', // TODO: Add localization - loc.profile_reportUser
                  style: TextStyle(color: AppTheme.failureColor),
                ),
                onTap: () {
                  Navigator.pop(dialogContext);
                  Navigator.push(
                    dialogContext,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const ReportUserScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.share, color: textColor),
                title: Text('Share Profile'), // TODO: Add localization - loc.profile_shareProfile
                onTap: () {
                  Navigator.pop(dialogContext);
                  // Handle share profile
                },
              ),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.all(16),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryTextColor.withOpacity(0.1),
                    foregroundColor: AppTheme
                        .black, // Changed to black for better visibility
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Cancel'), // TODO: Add localization - loc.profile_cancel
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Post model class
class Post {
  final String image;
  final String title;
  final String location;
  final int likes;
  final String date;

  Post({
    required this.image,
    required this.title,
    required this.location,
    required this.likes,
    required this.date,
  });
}

// Review model class
class Review {
  final String placeName;
  final String location;
  final int rating;
  final String comment;
  final String date;
  final int helpful;

  Review({
    required this.placeName,
    required this.location,
    required this.rating,
    required this.comment,
    required this.date,
    required this.helpful,
  });
}