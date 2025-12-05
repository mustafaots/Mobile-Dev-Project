import 'dart:io';
import 'dart:typed_data';

import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/repositories/db_repositories/images_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/location_repository.dart';
import 'package:easy_vacation/repositories/db_repositories/post_repository.dart';
import 'package:easy_vacation/repositories/repo_factory.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/activities.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/models/locations.model.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:flutter/material.dart';

class ListingsHistory extends StatefulWidget {
  const ListingsHistory({super.key});

  @override
  State<ListingsHistory> createState() => _ListingsHistoryState();
}

class _ListingsHistoryState extends State<ListingsHistory> {
  List<Post> _userPosts = [];
  bool _isLoading = true;
  String _currentFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadUserPosts();
  }

  Future<void> _loadUserPosts() async {
    try {
      // Get current user ID (you need to implement this based on your auth system)
      final currentUserId = await _getCurrentUserId();
      
      final postRepo = await RepoFactory.getRepository<PostRepository>('postRepo');
      
      // Get posts by owner ID from database
      final posts = await postRepo.getPostsByOwner(currentUserId);
      
      setState(() {
        _userPosts = posts;
        _isLoading = false;
      });
      
    } catch (e) {
      print('Error loading posts: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading your listings: $e')),
      );
    }
  }

  // TODO: Implement this based on your authentication system
  Future<int> _getCurrentUserId() async {
    // For now, return a hardcoded user ID (change this to get actual logged-in user)
    // You should integrate with your UserRepository or SharedPreferences
    return 1; // Change this to actual logged-in user ID
  }

  // Update the _getPostDetails method in ListingHistory.dart

  Future<Map<String, dynamic>> _getPostDetails(Post post) async {
    try {
      final postRepo = await RepoFactory.getRepository<PostRepository>('postRepo');
      final locationRepo = await RepoFactory.getRepository<LocationRepository>('locationRepo');
      final imageRepo = await RepoFactory.getRepository<PostImagesRepository>('imageRepo');
      
      Map<String, dynamic> details = {'post': post};
      
      // Get category-specific details
      switch (post.category) {
        case 'stay':
          final stay = await postRepo.getStayByPostId(post.id!);
          details['stay_details'] = stay;
          break;
        case 'activity':
          final activity = await postRepo.getActivityByPostId(post.id!);
          details['activity_details'] = activity;
          break;
        case 'vehicle':
          final vehicle = await postRepo.getVehicleByPostId(post.id!);
          details['vehicle_details'] = vehicle;
          break;
      }
      
      // Get location
      final location = await locationRepo.getLocationById(post.locationId);
      details['location'] = location;
      
      // Get FIRST image for this post
      // Try to get image from PostImagesRepository first
      final imageMap = await imageRepo.getImageByPostId(post.id!);
      if (imageMap != null && imageMap['image'] != null) {
        // The image is stored as BLOB in the database
        details['first_image_bytes'] = imageMap['image'] as List<int>;
      } else {
        // If no image in images_repository, try post_repository
        final postImage = await postRepo.getPostImageByPostId(post.id!);
        if (postImage != null) {
          details['first_image_path'] = postImage.imageData; // This could be file path
        }
      }
      
      return details;
    } catch (e) {
      print('Error getting post details: $e');
      return {'post': post};
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, loc.listingHistory_title),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Chips
            _buildFilterSection(context),

            // Posts List or Loading/Empty State
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    
    // Only show filter section if we have posts
    if (_userPosts.isEmpty) return SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(loc.listingHistory_all, 'all', context),
            const SizedBox(width: 8),
            _buildFilterChip(loc.listingHistory_active, 'active', context),
            const SizedBox(width: 8),
            _buildFilterChip(loc.listingHistory_drafts, 'draft', context),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, BuildContext context) {
    final isSelected = _currentFilter == value;
    final backgroundColor = context.scaffoldBackgroundColor;
    final secondaryTextColor = context.secondaryTextColor;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _currentFilter = value;
        });
      },
      backgroundColor: backgroundColor,
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : secondaryTextColor,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? AppTheme.primaryColor
              : secondaryTextColor.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading your listings...'),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final filteredPosts = _currentFilter == 'all'
        ? _userPosts
        : _userPosts.where((post) => post.status == _currentFilter).toList();

    if (filteredPosts.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildPostsList(filteredPosts, context);
  }

  Widget _buildEmptyState(BuildContext context) {
    final secondaryTextColor = context.secondaryTextColor;
    final loc = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 80,
              color: secondaryTextColor.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              _userPosts.isEmpty
                  ? 'You have no listings'
                  : 'No ${_currentFilter == 'all' ? '' : _currentFilter} listings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _userPosts.isEmpty
                  ? 'Create your first listing to share with travelers'
                  : 'You have no ${_currentFilter == 'all' ? '' : _currentFilter} listings',
              style: TextStyle(fontSize: 16, color: secondaryTextColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (_userPosts.isEmpty)
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to create listing screen
                  Navigator.pushNamed(context, '/create-listing');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.add),
                label: Text('Create First Listing'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsList(List<Post> posts, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return FutureBuilder<Map<String, dynamic>>(
          future: _getPostDetails(posts[index]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildPostCardSkeleton();
            }
            if (snapshot.hasError) {
              return _buildPostCard(posts[index], null, context);
            }
            return _buildPostCard(posts[index], snapshot.data, context);
          },
        );
      },
    );
  }

  Widget _buildPostCardSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: 200,
                  color: Colors.grey.shade300,
                ),
                SizedBox(height: 8),
                Container(
                  height: 16,
                  width: 150,
                  color: Colors.grey.shade300,
                ),
                SizedBox(height: 12),
                Container(
                  height: 40,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Replace the image section in _buildPostCard method
// Update the image section in _buildPostCard method
  Widget _buildPostCard(Post post, Map<String, dynamic>? details, BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final loc = AppLocalizations.of(context)!;

    final location = details?['location'] as Location?;
    final categoryDetails = details?['${post.category}_details'];
    final firstImageBytes = details?['first_image_bytes'] as List<int>?;
    final firstImagePath = details?['first_image_path'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Post Image - UPDATED SECTION
          Stack(
            children: [
              // Check if we have an image
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: _buildPostImage(firstImageBytes, firstImagePath, post.category),
              ),

              // Status Badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(post.status, context),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getStatusText(post.status, context),
                    style: TextStyle(
                      fontSize: 12,
                      color: backgroundColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Post Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Menu
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        post.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: secondaryTextColor),
                      onSelected: (value) => _handlePostAction(value, post),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(loc.listingHistory_editPost),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(loc.listingHistory_deletePost),
                        ),
                        if (post.status == 'draft')
                          PopupMenuItem(
                            value: 'publish',
                            child: Text(loc.listingHistory_publish),
                          ),
                        if (post.status == 'active')
                          PopupMenuItem(
                            value: 'archive',
                            child: Text(loc.listingHistory_archive),
                          ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Location
                if (location != null)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${location.city}, ${location.wilaya}',
                        style: TextStyle(fontSize: 14, color: secondaryTextColor),
                      ),
                    ],
                  ),

                const SizedBox(height: 8),

                // Category-specific details
                if (categoryDetails != null)
                  _buildCategoryDetails(categoryDetails, post.category, context),

                const SizedBox(height: 8),

                // Price
                Row(
                  children: [
                    Icon(Icons.monetization_on, size: 16, color: AppTheme.successColor),
                    const SizedBox(width: 4),
                    Text(
                      '${post.price} DA',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.successColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Description
                if (post.description != null && post.description!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: secondaryTextColor.withOpacity(0.3)),
                      const SizedBox(height: 8),
                      Text(
                        post.description!,
                        style: TextStyle(fontSize: 14, color: textColor, height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                const SizedBox(height: 12),

                // Date and Category
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(post.category),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getCategoryText(post.category),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(post.createdAt),
                      style: TextStyle(fontSize: 12, color: secondaryTextColor),
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

  // Add this helper method to _ListingsHistoryState class
  Widget _buildPostImage(List<int>? imageBytes, String? imagePath, String category) {
    // Try to show image from bytes first (BLOB from database)
    if (imageBytes != null && imageBytes.isNotEmpty) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: Image.memory(
          Uint8List.fromList(imageBytes),
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildImagePlaceholder(category);
          },
        ),
      );
    }
    
    // Try to show image from file path
    if (imagePath != null && imagePath.isNotEmpty) {
      final file = File(imagePath);
      if (file.existsSync()) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          child: Image.file(
            file,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildImagePlaceholder(category);
            },
          ),
        );
      }
    }
    
    // If no image available, show placeholder
    return _buildImagePlaceholder(category);
  }

  Widget _buildImagePlaceholder(String category) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _getCategoryColor(category).withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Center(
        child: Icon(
          _getCategoryIcon(category),
          size: 48,
          color: _getCategoryColor(category).withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildCategoryDetails(dynamic details, String category, BuildContext context) {
    final secondaryTextColor = context.secondaryTextColor;
    
    switch (category) {
      case 'stay':
        final stay = details as Stay;
        return Text(
          '${stay.stayType} • ${stay.area} m² • ${stay.bedrooms} bedroom${stay.bedrooms > 1 ? 's' : ''}',
          style: TextStyle(fontSize: 14, color: secondaryTextColor),
        );
      case 'activity':
        final activity = details as Activity;
        return Text(
          '${activity.activityType} • Activity',
          style: TextStyle(fontSize: 14, color: secondaryTextColor),
        );
      case 'vehicle':
        final vehicle = details as Vehicle;
        return Text(
          '${vehicle.vehicleType} • ${vehicle.model} • ${vehicle.year}',
          style: TextStyle(fontSize: 14, color: secondaryTextColor),
        );
      default:
        return SizedBox.shrink();
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'stay':
        return Icons.house;
      case 'activity':
        return Icons.hiking;
      case 'vehicle':
        return Icons.directions_car;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'stay':
        return AppTheme.primaryColor;
      case 'activity':
        return AppTheme.successColor;
      case 'vehicle':
        return AppTheme.neutralColor;
      default:
        return Colors.grey;
    }
  }

  String _getCategoryText(String category) {
    switch (category) {
      case 'stay':
        return 'Stay';
      case 'activity':
        return 'Activity';
      case 'vehicle':
        return 'Vehicle';
      default:
        return 'Other';
    }
  }

  Color _getStatusColor(String status, BuildContext context) {
    final secondaryTextColor = context.secondaryTextColor;

    switch (status) {
      case 'active':
        return AppTheme.successColor;
      case 'draft':
        return AppTheme.neutralColor;
      default:
        return secondaryTextColor;
    }
  }

  String _getStatusText(String status, BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    switch (status) {
      case 'active':
        return loc.listingHistory_published;
      case 'draft':
        return loc.listingHistory_draft;
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  void _handlePostAction(String action, Post post) async {
    final postRepo = await RepoFactory.getRepository<PostRepository>('postRepo');
    final loc = AppLocalizations.of(context)!;

    switch (action) {
      case 'edit':
        _editPost(post);
        break;
      case 'delete':
        _deletePost(post, postRepo);
        break;
      case 'publish':
        await _updatePostStatus(post, 'active', postRepo, loc.listingHistory_postPublished);
        break;
      case 'archive':
        await _updatePostStatus(post, 'archived', postRepo, loc.listingHistory_postArchived);
        break;
    }
  }

  void _editPost(Post post) {
    // Navigate to edit post screen
    // You'll need to implement this based on your navigation structure
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing ${post.title}'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Future<void> _deletePost(Post post, PostRepository postRepo) async {
    final loc = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.listingHistory_deletePost),
        content: Text(loc.listingHistory_deletePostConfirm(post.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.profile_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.failureColor),
            child: Text(loc.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await postRepo.deletePost(post.id!);
        setState(() {
          _userPosts.removeWhere((p) => p.id == post.id);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.listingHistory_postDeleted),
            backgroundColor: AppTheme.successColor,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting post: $e'),
            backgroundColor: AppTheme.failureColor,
          ),
        );
      }
    }
  }

  Future<void> _updatePostStatus(Post post, String newStatus, PostRepository postRepo, String successMessage) async {
    try {
      final updatedPost = Post(
        id: post.id,
        ownerId: post.ownerId,
        category: post.category,
        title: post.title,
        description: post.description,
        price: post.price,
        locationId: post.locationId,
        contentUrl: post.contentUrl,
        isPaid: post.isPaid,
        createdAt: post.createdAt,
        updatedAt: DateTime.now(),
        status: newStatus,
        availability: post.availability,
      );

      await postRepo.updatePost(post.id!, updatedPost);
      
      setState(() {
        final index = _userPosts.indexWhere((p) => p.id == post.id);
        if (index != -1) {
          _userPosts[index] = updatedPost;
        }
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating post: $e'),
          backgroundColor: AppTheme.failureColor,
        ),
      );
    }
  }
}