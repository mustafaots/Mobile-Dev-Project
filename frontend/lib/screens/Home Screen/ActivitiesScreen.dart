import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/ListingDetailsScreen.dart';
import 'package:easy_vacation/shared/ui_widgets/app_progress_indicator.dart';
import 'package:easy_vacation/services/api/api_services.dart';
import 'package:easy_vacation/shared/ui_widgets/listing_rating.dart';
import 'package:easy_vacation/services/sync/sync_manager.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';

class ActivitiesScreen extends StatefulWidget {
  final user_Id;
  const ActivitiesScreen({super.key, this.user_Id});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  late Future<List<Listing>> _activitiesFuture;

  @override
  void initState() {
    super.initState();
    // Force refresh to ensure we get the latest data with images
    _activitiesFuture = SyncManager.instance.listings.getListingsByCategory('activity', forceRefresh: true);
  }

  /// Build image widget from Cloudinary URL or fallback
  Widget _buildListingImage(Listing listing, double width, double height) {
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
          child: const Center(child: AppProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Image.asset(
          'assets/images/no_image.png',
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      );
    }
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

    return FutureBuilder<List<Listing>>(
      future: _activitiesFuture,  // Use cached future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: AppProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          final listings = snapshot.data!;
          if (listings.length == 0) {
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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  loc.activities_featured_title,
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
                  itemCount: listings.length,
                  itemBuilder: (context, index) {
                    final listing = listings[index];
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
                                "${listing.price}${loc.dinars}/${loc.person}",
                                style: TextStyle(color: secondaryTextColor),
                              ),
                              trailing: listing.id != null
                                  ? ListingRating(
                                      listingId: listing.id!,
                                      fontSize: 16,
                                      textColor: textColor,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listings.length,
                      itemBuilder: (context, index) {
                        final listing = listings[index];
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
                                  "${listing.price}${loc.dinars}/hour",
                                  style: TextStyle(color: secondaryTextColor),
                                ),
                                trailing: listing.id != null
                                    ? ListingRating(
                                        listingId: listing.id!,
                                        fontSize: 16,
                                        textColor: textColor,
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Center(child: Text("Couldn't get data"));
        }
      },
    );
  }
}
