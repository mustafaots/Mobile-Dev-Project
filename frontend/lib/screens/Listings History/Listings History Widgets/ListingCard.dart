import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/services/api/listing_service.dart';
import 'package:easy_vacation/screens/Listings%20History/Listings%20History%20Widgets/PostImage.dart';
import 'package:easy_vacation/screens/Listings%20History/PostHelpers.dart';
import 'package:easy_vacation/screens/ListingDetailsScreen.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';

class ListingCard extends StatelessWidget {
  final Listing listing;
  final String? userId;

  const ListingCard({
    super.key,
    required this.listing,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final postHelpers = PostHelpers(context);
    final loc = AppLocalizations.of(context)!;

    // Get first image URL from listing
    final imageUrl = listing.images.isNotEmpty ? listing.images.first : null;
    
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailsScreen(
              postId: listing.id,
              userId: userId,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
            // Listing Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: PostImage(
                imageUrl: imageUrl,
                category: listing.category,
              ),
            ),
            // Listing Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    listing.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                // Location
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: secondaryTextColor),
                    const SizedBox(width: 4),
                    Text('${listing.location.city}, ${listing.location.wilaya}',
                        style: TextStyle(fontSize: 14, color: secondaryTextColor)),
                  ],
                ),
                const SizedBox(height: 8),
                // Category-specific details
                _buildCategoryDetails(context, postHelpers),
                const SizedBox(height: 8),
                // Price with static rate based on category
                Text('${listing.price} DA/${_getRateLabel(loc)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    )),
                const SizedBox(height: 8),
                // Description
                if (listing.description != null && listing.description!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: secondaryTextColor.withOpacity(0.3)),
                      const SizedBox(height: 8),
                      Text(
                        listing.description!,
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
                        color: postHelpers.getCategoryColor(listing.category),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(postHelpers.getCategoryText(listing.category),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    const Spacer(),
                    Text(listing.createdAt != null ? postHelpers.formatDate(listing.createdAt!) : '',
                        style: TextStyle(fontSize: 12, color: secondaryTextColor)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ) );
  }

  Widget _buildCategoryDetails(BuildContext context, PostHelpers postHelpers) {
    final secondaryTextColor = context.secondaryTextColor;
    
    if (listing.category == 'stay' && listing.stayDetails != null) {
      final stay = listing.stayDetails!;
      return Row(
        children: [
          Icon(Icons.home, size: 14, color: secondaryTextColor),
          const SizedBox(width: 4),
          Text(
            '${stay.stayType} • ${stay.bedrooms} beds • ${stay.area} m²',
            style: TextStyle(fontSize: 14, color: secondaryTextColor),
          ),
        ],
      );
    } else if (listing.category == 'vehicle' && listing.vehicleDetails != null) {
      final vehicle = listing.vehicleDetails!;
      return Row(
        children: [
          Icon(Icons.directions_car, size: 14, color: secondaryTextColor),
          const SizedBox(width: 4),
          Text(
            '${vehicle.vehicleType} • ${vehicle.model} • ${vehicle.year}',
            style: TextStyle(fontSize: 14, color: secondaryTextColor),
          ),
        ],
      );
    } else if (listing.category == 'activity' && listing.activityDetails != null) {
      final activity = listing.activityDetails!;
      return Row(
        children: [
          Icon(Icons.hiking, size: 14, color: secondaryTextColor),
          const SizedBox(width: 4),
          Text(
            activity.activityType,
            style: TextStyle(fontSize: 14, color: secondaryTextColor),
          ),
        ],
      );
    }
    
    return const SizedBox.shrink();
  }

  /// Get static rate label based on category
  String _getRateLabel(AppLocalizations loc) {
    switch (listing.category.toLowerCase()) {
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
