import 'dart:typed_data';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/screens/Listings%20History/Listings%20History%20Widgets/PostCardMenu.dart';
import 'package:easy_vacation/screens/Listings%20History/Listings%20History%20Widgets/PostCardSkeleton.dart';
import 'package:easy_vacation/screens/Listings%20History/Listings%20History%20Widgets/PostImage.dart';
import 'package:easy_vacation/screens/Listings%20History/PostDetailsService.dart';
import 'package:easy_vacation/screens/Listings%20History/PostHelpers.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final Function(Post) onPostRemoved;
  final Function(Post) onPostUpdated;

  const PostCard({
    super.key,
    required this.post,
    required this.onPostRemoved,
    required this.onPostUpdated,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final PostDetailsService _postDetailsService = PostDetailsService();
  Map<String, dynamic>? _postDetails;
  bool _isLoadingDetails = true;

  @override
  void initState() {
    super.initState();
    _loadPostDetails();
  }

  Future<void> _loadPostDetails() async {
    try {
      final details = await _postDetailsService.getPostDetails(widget.post);
      setState(() {
        _postDetails = details;
        _isLoadingDetails = false;
      });
    } catch (e) {
      setState(() => _isLoadingDetails = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingDetails) return const PostCardSkeleton();
    
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final postHelpers = PostHelpers(context);

    final location = _postDetails?['location'];
    final categoryDetails = _postDetails?['${widget.post.category}_details'];
    final imageBytes = _postDetails?['first_image_bytes'];
    final imagePath = _postDetails?['first_image_path'];
    final imageUrl = _postDetails?['first_image_url']; // Cloudinary URL

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
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: _buildPostImage(imageBytes, imagePath, imageUrl, widget.post.category),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: postHelpers.getStatusColor(widget.post.status),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    postHelpers.getStatusText(widget.post.status),
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
                        widget.post.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PostCardMenu(
                      post: widget.post,
                      onPostRemoved: widget.onPostRemoved,
                      onPostUpdated: widget.onPostUpdated,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Location
                if (location != null)
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: secondaryTextColor),
                      const SizedBox(width: 4),
                      Text('${location.city}, ${location.wilaya}',
                          style: TextStyle(fontSize: 14, color: secondaryTextColor)),
                    ],
                  ),
                const SizedBox(height: 8),
                // Category-specific details
                if (categoryDetails != null)
                  postHelpers.buildCategoryDetails(categoryDetails, widget.post.category),
                const SizedBox(height: 8),
                // Price with static rate based on category
                Row(
                  children: [
                    Icon(Icons.monetization_on, size: 16, color: AppTheme.successColor),
                    const SizedBox(width: 4),
                    Text('${widget.post.price} DA/${_getRateLabel(context)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.successColor,
                        )),
                  ],
                ),
                const SizedBox(height: 8),
                // Description
                if (widget.post.description != null && widget.post.description!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: secondaryTextColor.withOpacity(0.3)),
                      const SizedBox(height: 8),
                      Text(
                        widget.post.description!,
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
                        color: postHelpers.getCategoryColor(widget.post.category),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(postHelpers.getCategoryText(widget.post.category),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    const Spacer(),
                    Text(postHelpers.formatDate(widget.post.createdAt),
                        style: TextStyle(fontSize: 12, color: secondaryTextColor)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage(Uint8List? imageBytes, String? imagePath, String? imageUrl, String category) {
    return PostImage(
      imageBytes: imageBytes,
      imagePath: imagePath,
      imageUrl: imageUrl,
      category: category,
    );
  }

  /// Get static rate label based on category
  String _getRateLabel(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    switch (widget.post.category.toLowerCase()) {
      case 'stay':
        return loc.details_pricePerNight;
      case 'activity':
        return loc.details_pricePerPerson;
      case 'vehicle':
        return loc.details_pricePerDay;
      default:
        return loc.details_pricePerDay;
    }
  }
}