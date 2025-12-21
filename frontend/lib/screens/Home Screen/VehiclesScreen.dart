import 'dart:typed_data';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/main.dart';
import 'package:easy_vacation/repositories/db_repositories/images_repository.dart';
import 'package:easy_vacation/screens/ListingDetailsScreen.dart';
import 'package:easy_vacation/services/api/api_services.dart';
import 'package:easy_vacation/services/sync/sync_manager.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';

class VehiclesScreen extends StatefulWidget {
  final user_Id;
  const VehiclesScreen({super.key, this.user_Id});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  late Future<List<Listing>> _vehiclesFuture;
  final Map<int, Widget> _imageCache = {};

  @override
  void initState() {
    super.initState();
    _vehiclesFuture = SyncManager.instance.listings.getListingsByCategory('vehicle');
  }

  Future<Widget> getPostImageWidget(
    int postId,
    int cache_w,
    int cache_h,
    double width,
    double height,
  ) async {
    // Check image cache first
    if (_imageCache.containsKey(postId)) {
      return _imageCache[postId]!;
    }
    
    final imageRepo = appRepos['imageRepo'] as PostImagesRepository;
    final imageRow = await imageRepo.getImageByPostId(postId);

    Widget imageWidget;
    if (imageRow != null) {
      final bytes = imageRow['image'] as Uint8List;
      imageWidget = Image.memory(
        bytes,
        width: width,
        height: height,
        fit: BoxFit.cover,
        cacheWidth: cache_w,
        cacheHeight: cache_h,
      );
    } else {
      // Fallback image if no image in DB
      imageWidget = Image.asset(
        'assets/images/mercedes.jpg',
        width: width,
        height: height,
        fit: BoxFit.cover,
        cacheHeight: cache_h,
        cacheWidth: cache_w,
      );
    }
    
    _imageCache[postId] = imageWidget;
    return imageWidget;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final cardCacheW = (260 * dpr).toInt();
    final cardCacheH = (200 * dpr).toInt();
    final fullWidthCache = (MediaQuery.of(context).size.width * dpr).toInt();
    final loc = AppLocalizations.of(context)!;

    return FutureBuilder<List<Listing>>(
      future: _vehiclesFuture,  // Use cached future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
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
                  loc.vehicles_featured_title,
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
                                child: FutureBuilder<Widget>(
                                  future: getPostImageWidget(
                                    listing.id!,
                                    cardCacheW,
                                    cardCacheH,
                                    260,
                                    170,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (!snapshot.hasData) {
                                      return Image.asset(
                                        'assets/images/no_image.png',
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                      );
                                    }

                                    return snapshot.data!;
                                  },
                                ),
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
                                '${listing.price}${loc.dinars}/${loc.day}',
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
                                  child: FutureBuilder<Widget>(
                                    future: getPostImageWidget(
                                      listing.id!,
                                      fullWidthCache,
                                      cardCacheH,
                                      double.infinity,
                                      200,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      if (!snapshot.hasData) {
                                        return Image.asset(
                                          'assets/images/no_image.png',
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                        );
                                      }
                                      return snapshot.data!;
                                    },
                                  ),
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
                                  '${listing.price}${loc.dinars}/${loc.day}',
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
