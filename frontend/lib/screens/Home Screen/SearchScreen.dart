import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/ListingDetailsScreen.dart';
import 'package:easy_vacation/services/api/search_service.dart';
import 'package:easy_vacation/services/api/listing_service.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final String postCategory;
  final String? postType;
  final double? price;
  final List<DateTime>? date;
  final String? wilaya;
  final user_id;

  const SearchScreen({
    super.key,
    required this.postCategory,
    this.postType,
    this.price,
    this.date,
    this.wilaya,
    this.user_id
  });

  /// Fetch listings from Supabase via SearchService
  Future<List<Listing>> _searchListings() async {
    final response = await SearchService.instance.search(
      category: postCategory,
      wilaya: wilaya,
      maxPrice: price,
      limit: 50,
      stayType: postCategory == 'stay' ? postType : null,
      vehicleType: postCategory == 'vehicle' ? postType : null,
      activityType: postCategory == 'activity' ? postType : null,
      availabilityDates: date
    );

    if (!response.success) {
      throw Exception(response.message);
    }

    return response.data!.items;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final loc = AppLocalizations.of(context)!;

    return FutureBuilder<List<Listing>>(
      future: _searchListings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            ),
          );
        }

        if (snapshot.hasError) {
          return _errorState();
        }

        final listings = snapshot.data ?? [];

        if (listings.isEmpty) {
          return _emptyState(loc);
        }

        // Use Column with individual cards instead of ListView
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: List.generate(listings.length, (index) {
              final listing = listings[index];
              final imageUrl =
                  listing.images.isNotEmpty ? listing.images.first : null;

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            PostDetailsScreen(postId: listing.id!, userId: user_id,),
                        transitionsBuilder: (_, animation, __, child) =>
                            FadeTransition(opacity: animation, child: child),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _fallbackImage(),
                                )
                              : _fallbackImage(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  listing.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: textColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${listing.price} ${loc.dinars}',
                                  style: TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_border_outlined,
                                size: 20,
                                color: AppTheme.neutralColor
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '4.7',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  /// Fallback image if listing has no image
  Widget _fallbackImage() {
    return Image.asset(
      'assets/images/no_image.png',
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  /// Empty search results UI
  Widget _emptyState(AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              loc.no_matching_posts,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 85, 85, 85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Error UI
  Widget _errorState() {
    return const Padding(
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Error loading results',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}