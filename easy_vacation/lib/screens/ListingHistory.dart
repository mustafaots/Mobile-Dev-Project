import 'package:easy_vacation/l10n/app_localizations.dart';
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
  final List<Post> _userPosts = [
    Post(
      id: '1',
      image: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4',
      title: 'Beautiful Beach Day in Bali',
      location: 'Bali, Indonesia',
      description:
          'Spent an amazing week in this beautiful beachfront villa. The sunsets were absolutely breathtaking!',
      likes: 42,
      comments: 8,
      date: '2 days ago',
      status: 'active',
    ),
    Post(
      id: '2',
      image: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
      title: 'Mountain Adventure in Swiss Alps',
      location: 'Swiss Alps',
      description:
          'Hiking through the Swiss Alps was an unforgettable experience. The crisp mountain air and stunning views made every step worth it.',
      likes: 89,
      comments: 15,
      date: '1 week ago',
      status: 'active',
    ),
    Post(
      id: '3',
      image: 'https://images.unsplash.com/photo-1549294413-26f195200c16',
      title: 'City Exploration - Tokyo',
      location: 'Tokyo, Japan',
      description:
          'Tokyo never fails to amaze me. From ancient temples to futuristic technology, this city has it all.',
      likes: 156,
      comments: 23,
      date: '2 weeks ago',
      status: 'active',
    ),
    Post(
      id: '4',
      image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945',
      title: 'Desert Safari Experience',
      location: 'Dubai, UAE',
      description:
          'An incredible desert safari experience with traditional Bedouin culture and amazing dune bashing.',
      likes: 67,
      comments: 12,
      date: '3 weeks ago',
      status: 'draft',
    ),
  ];

  String _currentFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;

    final filteredPosts = _currentFilter == 'all'
        ? _userPosts
        : _userPosts.where((post) => post.status == _currentFilter).toList();
    
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: App_Bar(context, loc.listingHistory_title),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Chips
            _buildFilterSection(context),

            // Posts List
            Expanded(
              child: filteredPosts.isEmpty
                  ? _buildEmptyState(context)
                  : _buildPostsList(filteredPosts, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(loc.listingHistory_all, loc.listingHistory_all, context),
            const SizedBox(width: 8),
            _buildFilterChip(loc.listingHistory_active, loc.listingHistory_active, context),
            const SizedBox(width: 8),
            _buildFilterChip(loc.listingHistory_drafts, loc.listingHistory_drafts, context),
            const SizedBox(width: 8),
            _buildFilterChip(loc.listingHistory_archived, loc.listingHistory_archived, context),
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

  Widget _buildEmptyState(BuildContext context) {
    final secondaryTextColor = context.secondaryTextColor;
    final loc = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article,
            size: 80,
            color: secondaryTextColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            loc.listingHistory_noPostsFound,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currentFilter == 'all'
                ? loc.listingHistory_noPostsYet
                : loc.listingHistory_noFilterPosts(_currentFilter),
            style: TextStyle(fontSize: 16, color: secondaryTextColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPostsList(List<Post> posts, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return _buildPostCard(posts[index], context);
      },
    );
  }

  Widget _buildPostCard(Post post, BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final loc = AppLocalizations.of(context)!;

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
          // Post Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  post.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
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
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: secondaryTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      post.location,
                      style: TextStyle(fontSize: 14, color: secondaryTextColor),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Description
                Text(
                  post.description,
                  style: TextStyle(fontSize: 14, color: textColor, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Stats and Date
                Row(
                  children: [
                    // Likes
                    _buildStatItem(Icons.favorite, '${post.likes}', context),
                    const SizedBox(width: 16),

                    // Comments
                    _buildStatItem(Icons.comment, '${post.comments}', context),

                    const Spacer(),

                    // Date
                    Text(
                      post.date,
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

  Widget _buildStatItem(IconData icon, String count, BuildContext context) {
    final secondaryTextColor = context.secondaryTextColor;

    return Row(
      children: [
        Icon(icon, size: 16, color: secondaryTextColor),
        const SizedBox(width: 4),
        Text(count, style: TextStyle(fontSize: 14, color: secondaryTextColor)),
      ],
    );
  }

  Color _getStatusColor(String status, BuildContext context) {
    final secondaryTextColor = context.secondaryTextColor;

    switch (status) {
      case 'active':
        return AppTheme.successColor;
      case 'draft':
        return AppTheme.neutralColor;
      case 'archived':
        return secondaryTextColor;
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
      case 'archived':
        return loc.listingHistory_archived;
      default:
        return status;
    }
  }

  void _handlePostAction(String action, Post post) {
    switch (action) {
      case 'edit':
        _editPost(post);
        break;
      case 'delete':
        _deletePost(post);
        break;
      case 'publish':
        _publishPost(post);
        break;
      case 'archive':
        _archivePost(post);
        break;
    }
  }

  void _editPost(Post post) {
    // Navigate to edit post screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.of(context)!.listingHistory_editing} ${post.title}'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _deletePost(Post post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.listingHistory_deletePost),
        content: Text(
          AppLocalizations.of(context)!.listingHistory_deletePostConfirm(post.title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.profile_cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _userPosts.removeWhere((p) => p.id == post.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.listingHistory_postDeleted),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.failureColor),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _publishPost(Post post) {
    setState(() {
      final index = _userPosts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        _userPosts[index] = post.copyWith(status: 'active');
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.listingHistory_postPublished),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _archivePost(Post post) {
    setState(() {
      final index = _userPosts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        _userPosts[index] = post.copyWith(status: 'archived');
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.listingHistory_postArchived),
        backgroundColor: AppTheme.neutralColor,
      ),
    );
  }
}

class Post {
  final String id;
  final String image;
  final String title;
  final String location;
  final String description;
  final int likes;
  final int comments;
  final String date;
  final String status;

  Post({
    required this.id,
    required this.image,
    required this.title,
    required this.location,
    required this.description,
    required this.likes,
    required this.comments,
    required this.date,
    required this.status,
  });

  Post copyWith({String? status}) {
    return Post(
      id: id,
      image: image,
      title: title,
      location: location,
      description: description,
      likes: likes,
      comments: comments,
      date: date,
      status: status ?? this.status,
    );
  }
}
