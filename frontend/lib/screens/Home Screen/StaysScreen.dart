import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/ListingDetailsScreen.dart';
import 'package:easy_vacation/services/api/api_services.dart';
import 'package:easy_vacation/services/algorithms/featured_listings_algorithm.dart';
import 'package:easy_vacation/services/algorithms/paginated_listings_algorithm.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';

class StaysScreen extends StatefulWidget {
  final user_Id;
  const StaysScreen({super.key, this.user_Id});

  @override
  State<StaysScreen> createState() => _StaysScreenState();
}

class _StaysScreenState extends State<StaysScreen> {
  Future<List<Listing>>? _featuredFuture;
  PaginatedListingsAlgorithm? _paginatedAlgorithm;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Fetch featured listings (5 random)
    _featuredFuture = FeaturedListingsAlgorithm.instance.getFeaturedListings(
      category: 'stay',
      forceRefresh: true,
    );
    
    // Initialize paginated algorithm for recommended section
    // Use refresh() to reset and reload (in case of cached instance)
    _paginatedAlgorithm = PaginatedListingsFactory.getForCategory('stay', pageSize: 5);
    _paginatedAlgorithm!.addListener(_onPaginationUpdate);
    _paginatedAlgorithm!.refresh(); // Use refresh instead of loadInitial to reset state
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _paginatedAlgorithm?.removeListener(_onPaginationUpdate);
    super.dispose();
  }

  void _onPaginationUpdate() {
    if (mounted) setState(() {});
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final maxScroll = notification.metrics.maxScrollExtent;
      final currentScroll = notification.metrics.pixels;
      final threshold = 200.0;
      
      if (currentScroll >= maxScroll - threshold) {
        print('📜 Near bottom: $currentScroll / $maxScroll - Loading more...');
        _paginatedAlgorithm?.loadMore();
      }
    }
    return false; // Don't consume the notification
  }

  /// Build image widget from Cloudinary URL or fallback
  Widget _buildListingImage(Listing listing, double width, double height) {
    print('🖼️ StaysScreen._buildListingImage for listing ${listing.id}: ${listing.images.length} images');
    if (listing.images.isNotEmpty) {
      print('🖼️ First image URL: ${listing.images.first}');
    }
    
    // Check if listing has Cloudinary images
    if (listing.images.isNotEmpty) {
      final imageUrl = listing.images.first;
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/no_image.png',
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      );
    }
    
    // Fallback to placeholder image
    return Image.asset(
      'assets/images/no_image.png',
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final loc = AppLocalizations.of(context)!;

    // Show loading if not initialized yet
    if (_featuredFuture == null || _paginatedAlgorithm == null) {
      return Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
    }

    return FutureBuilder<List<Listing>>(
      future: _featuredFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && 
            _paginatedAlgorithm!.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }

        final featuredListings = snapshot.data ?? [];
        final recommendedListings = _paginatedAlgorithm!.listings;
        
        // Show empty state only if both are empty and not loading
        if (featuredListings.isEmpty && 
            recommendedListings.isEmpty && 
            !_paginatedAlgorithm!.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  loc.no_posts_yet,
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 85, 85, 85),
                    fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return NotificationListener<ScrollNotification>(
            onNotification: _onScrollNotification,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Featured Section (5 random listings, horizontal scroll)
                if (featuredListings.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      loc.stays_featured_title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 240,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: featuredListings.length,
                      itemBuilder: (context, index) {
                        final listing = featuredListings[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => PostDetailsScreen(
                                  postId: listing.id,
                                  userId: widget.user_Id,
                                ),
                                transitionsBuilder: (_, animation, __, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        width: 260,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 260 / 170,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: _buildListingImage(listing, 260, 170),
                              ),
                            ),
                            ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                listing.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              subtitle: Text(
                                '${listing.price}${loc.dinars}/${loc.night}',
                                style: TextStyle(color: secondaryTextColor),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star_border_outlined,
                                    color: AppTheme.neutralColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '4.5',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
                ],
              const SizedBox(height: 30),
              
              // Recommended Section (paginated, 5 at a time)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.recommended_title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Paginated listings
                    if (recommendedListings.isEmpty && _paginatedAlgorithm!.isLoading)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: CircularProgressIndicator(color: AppTheme.primaryColor),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recommendedListings.length,
                        itemBuilder: (context, index) {
                          final listing = recommendedListings[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => PostDetailsScreen(
                                    postId: listing.id,
                                    userId: widget.user_Id,
                                  ),
                                  transitionsBuilder: (_, animation, __, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(
                                    milliseconds: 300,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                AspectRatio(
                                  aspectRatio:
                                      (MediaQuery.of(context).size.width - 40) /
                                      200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: _buildListingImage(listing, double.infinity, 200),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    listing.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${listing.price}${loc.dinars}/${loc.night}',
                                    style: TextStyle(color: secondaryTextColor),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star_border_outlined,
                                        color: AppTheme.neutralColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '4.7',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          );
                        },
                      ),
                    
                    // Load More Button
                    if (_paginatedAlgorithm!.hasMore)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: _paginatedAlgorithm!.isLoading
                            ? CircularProgressIndicator(color: AppTheme.primaryColor)
                            : ElevatedButton(
                                onPressed: () {
                                  _paginatedAlgorithm!.loadMore();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  'Load More',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                        ),
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
}
