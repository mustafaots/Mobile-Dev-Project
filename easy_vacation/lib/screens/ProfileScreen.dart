import 'package:easy_vacation/repositories/report_repository.dart';
import 'package:easy_vacation/screens/HomeScreen.dart';
import 'package:easy_vacation/screens/ReportUserScreen.dart';
import 'package:easy_vacation/screens/BlockedUserScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userImage;
  final String subscriptionType;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final bool isFollowing;
  final int reviewsCount;

  const ProfileScreen({
    super.key,
    this.userName = 'USERNAME',
    this.userEmail = 'EXAMPLE@EMAIL.COM',
    this.userImage = 'https://lh3.googleusercontent.com/aida-public/AB6AXuB8oBGBPI4UQgunUlLsbeG4LUCDyQOMJF7C52rKedX1NSZNqWTIc_lLUZgNjYD16keoTwuGfxpaqSo405BelcjMCKal_PA_rxLg1_Ebw5cFfY7t-FGo11kuFKWJmzypIC5g2e7mNvNHwNlyorCpzomh0rpWo3MMEK5Kurz-muMtXrh3LGps3M_ldfNF0Hxm3atFKU1TCfxRQ22nMiHRVvyXelgdHD0FjrVmHRk1ExmxHsazhYbgIfMNEN73JZr0JnuGPsfkjy6ZaNw',
    this.subscriptionType = 'Free',
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.isFollowing = false,
    this.reviewsCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppTheme.black,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        backgroundColor: AppTheme.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const HomeScreen(),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                )
              );
            },
            icon: Icon(Icons.home_filled, size: 40, ),
            color: AppTheme.primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: AppTheme.primaryColor),
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
                        // Profile Image
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.primaryColor,
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(userImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        
                        // Stats
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatColumn(postsCount, 'Posts'),
                              _buildStatColumn(followersCount, 'Followers'),
                              _buildStatColumn(followingCount, 'Following'),
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
                          userName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Travel enthusiast exploring the world one destination at a time. Sharing my experiences and tips!',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.black,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Follow/Unfollow logic
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isFollowing 
                                  ? AppTheme.white 
                                  : AppTheme.primaryColor,
                              foregroundColor: isFollowing 
                                  ? AppTheme.primaryColor 
                                  : AppTheme.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: isFollowing 
                                    ? BorderSide(color: AppTheme.primaryColor)
                                    : BorderSide.none,
                              ),
                            ),
                            child: Text(
                              isFollowing ? 'Following' : 'Follow',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.grey.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Message logic
                            },
                            icon: Icon(
                              Icons.message,
                              color: AppTheme.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.black.withOpacity(0.1),
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
                              unselectedLabelColor: AppTheme.grey,
                              indicatorColor: AppTheme.primaryColor,
                              tabs: const [
                                Tab(text: 'Posts'),
                                Tab(text: 'Reviews'),
                              ],
                            ),
                            SizedBox(
                              height: 400, // Increased height for better content display
                              child: TabBarView(
                                children: [
                                  // Posts Tab
                                  postsCount == 0 
                                    ? _buildContentTab('No posts yet', Icons.article) 
                                    : _buildPostsGrid(),
                                  
                                  // Reviews Tab
                                  reviewsCount == 0 
                                    ? _buildContentTab('No reviews yet', Icons.star) 
                                    : _buildReviewsList(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Additional Info Section
                    _buildInfoSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(int count, String label) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildContentTab(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: AppTheme.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: AppTheme.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.black,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.location_on, 'From', 'Casablanca, Morocco'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.calendar_today, 'Member since', 'January 2024'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.flag, 'Countries visited', '12 countries'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.grey,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Posts Grid
  Widget _buildPostsGrid() {
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
    return GestureDetector(
      onTap: () {
        _showPostDetail(context, post);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppTheme.white,
          boxShadow: [
            BoxShadow(
              color: AppTheme.black.withOpacity(0.1),
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
                      color: AppTheme.black,
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
                        color: AppTheme.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          post.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.grey,
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
                          color: AppTheme.grey,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        post.date,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.grey,
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
  Widget _buildReviewsList() {
    final List<Review> sampleReviews = [
      Review(
        placeName: 'Luxury Beach Resort',
        location: 'Maldives',
        rating: 5,
        comment: 'Absolutely stunning resort with incredible service. The overwater bungalows were worth every penny!',
        date: '1 week ago',
        helpful: 12,
      ),
      Review(
        placeName: 'Mountain Lodge',
        location: 'Switzerland',
        rating: 4,
        comment: 'Beautiful views and cozy rooms. The food was excellent but a bit pricey.',
        date: '2 weeks ago',
        helpful: 8,
      ),
      Review(
        placeName: 'City Central Hotel',
        location: 'Tokyo, Japan',
        rating: 5,
        comment: 'Perfect location for exploring the city. Staff was incredibly helpful and spoke excellent English.',
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withOpacity(0.1),
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
                      color: AppTheme.black,
                    ),
                  ),
                ),
                _buildStarRating(review.rating),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 14,
                  color: AppTheme.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  review.location,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.black,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.thumb_up,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '${review.helpful}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Helpful',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.grey,
                  ),
                ),
                const Spacer(),
                Text(
                  review.date,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.grey,
                  ),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
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
                          color: AppTheme.black,
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
                              color: AppTheme.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'This was an amazing experience! The views were breathtaking and the local culture was incredibly rich. Highly recommend visiting this place for anyone looking for an adventure.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.black,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildActionButton(Icons.favorite, '${post.likes}'),
                          const SizedBox(width: 16),
                          _buildActionButton(Icons.comment, '24'),
                          const SizedBox(width: 16),
                          _buildActionButton(Icons.share, 'Share'),
                          const Spacer(),
                          Text(
                            post.date,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.grey,
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

  Widget _buildActionButton(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.grey,
          ),
        ),
      ],
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.report, color: AppTheme.failureColor),
                title: Text(
                  'Report User',
                  style: TextStyle(color: AppTheme.failureColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const ReportUserScreen(),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    )
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.block, color: AppTheme.failureColor),
                title: Text(
                  'Block User',
                  style: TextStyle(color: AppTheme.failureColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => BlockUserScreen(userName: userName),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    )
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.share, color: AppTheme.black),
                title: Text('Share Profile'),
                onTap: () {
                  Navigator.pop(context);
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
                    backgroundColor: AppTheme.grey.withOpacity(0.1),
                    foregroundColor: AppTheme.black, // Changed to black for better visibility
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel'),
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