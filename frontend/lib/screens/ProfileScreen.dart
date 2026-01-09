import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/services/api/listing_service.dart';
import 'package:easy_vacation/services/api/api_service_locator.dart';
import 'package:easy_vacation/screens/ListingDetailsScreen.dart';
import 'package:easy_vacation/screens/Listings%20History/Listings%20History%20Widgets/PostImage.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/app_progress_indicator.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? userId;

  const ProfileScreen({
    super.key,
    this.userName = 'User',
    this.firstName,
    this.lastName,
    this.email,
    this.userId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Listing> _userListings = [];
  bool _isLoading = true;

  String get displayName {
    if (widget.firstName != null && widget.firstName!.isNotEmpty) {
      if (widget.lastName != null && widget.lastName!.isNotEmpty) {
        return '${widget.firstName} ${widget.lastName}';
      }
      return widget.firstName!;
    }
    if (widget.userName.isNotEmpty && !widget.userName.contains('@')) {
      return widget.userName;
    }
    return 'User';
  }

  String get initials {
    if (widget.firstName != null && widget.firstName!.isNotEmpty) {
      if (widget.lastName != null && widget.lastName!.isNotEmpty) {
        return '${widget.firstName![0]}${widget.lastName![0]}'.toUpperCase();
      }
      return widget.firstName![0].toUpperCase();
    }
    if (widget.userName.isNotEmpty && !widget.userName.contains('@')) {
      return widget.userName[0].toUpperCase();
    }
    if (widget.email != null && widget.email!.isNotEmpty) {
      return widget.email![0].toUpperCase();
    }
    return '?';
  }

  @override
  void initState() {
    super.initState();
    _loadUserListings();
  }

  Future<void> _loadUserListings() async {
    if (widget.userId == null) {
      print('❌ ProfileScreen: userId is null');
      setState(() => _isLoading = false);
      return;
    }

    try {
      print('🔍 ProfileScreen: Loading listings for user ${widget.userId}');
      final listingService = ApiServiceLocator.listings;
      final response = await listingService.getListingsByOwner(widget.userId!);
      
      print('📥 ProfileScreen: Response success=${response.success}, data count=${response.data?.length ?? 0}');
      
      if (response.success && response.data != null) {
        for (var listing in response.data!) {
          print('📦 Listing ${listing.id}: ${listing.title}, images: ${listing.images.length} - ${listing.images}');
        }
        if (mounted) {
          setState(() {
            _userListings = response.data!;
            _isLoading = false;
          });
        }
      } else {
        print('❌ ProfileScreen: API error -');
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      print('❌ ProfileScreen: Exception - $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          loc.profile_title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Profile Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primaryColor, width: 2),
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Name and Posts Count
                    Expanded(
                      child: Column(
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
                          const SizedBox(height: 4),
                          Text(
                            _isLoading 
                                ? '...'
                                : '${_userListings.length} ${loc.profile_posts}',
                            style: TextStyle(fontSize: 14, color: secondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Posts Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.grid_view, color: AppTheme.primaryColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          loc.profile_posts,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildPostsContent(context, textColor, secondaryTextColor, loc),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostsContent(BuildContext context, Color textColor, Color secondaryTextColor, AppLocalizations loc) {
    if (_isLoading) {
      return const SizedBox(height: 200, child: Center(child: AppProgressIndicator()));
    }

    if (_userListings.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article_outlined, size: 48, color: secondaryTextColor.withValues(alpha: 0.5)),
              const SizedBox(height: 8),
              Text(loc.profile_noPostsYet, style: TextStyle(color: secondaryTextColor, fontSize: 16)),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _userListings.length,
      itemBuilder: (context, index) => _buildListingCard(_userListings[index], context, textColor, secondaryTextColor),
    );
  }

  Widget _buildListingCard(Listing listing, BuildContext context, Color textColor, Color secondaryTextColor) {
    final imageUrl = listing.images.isNotEmpty ? listing.images.first : null;
    print('🖼️ ProfileScreen ListingCard ${listing.id}: imageUrl = $imageUrl');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostDetailsScreen(postId: listing.id, userId: widget.userId)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: context.scaffoldBackgroundColor,
          boxShadow: [BoxShadow(color: textColor.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              width: double.infinity,
              child: PostImage(
                imageUrl: imageUrl,
                category: listing.category,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(listing.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppTheme.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                          child: Text(listing.category.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                        ),
                        const Spacer(),
                        Text('${listing.price.toStringAsFixed(0)} DA', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                      ],
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

