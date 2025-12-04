import 'package:flutter/material.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/themes.dart';

class DetailsSection extends StatelessWidget {
  final Post? post;
  final String? category;

  const DetailsSection({super.key, this.post, this.category});

  /// Get category-specific details based on the provided category
  List<Map<String, dynamic>> _getCategoryDetails() {
    if (post == null) return [];

    final details = <Map<String, dynamic>>[];

    // Add description if available
    if (post!.description != null && post!.description!.isNotEmpty) {
      details.add({
        'icon': Icons.description,
        'label': 'Description',
        'value': post!.description!,
      });
    }

    // Get the category from parameter or post
    final cat = (category ?? post?.category ?? '').toLowerCase();

    // Add category-specific details
    switch (cat) {
      case 'stay':
        details.addAll(_getStayDetails());
        break;
      case 'vehicle':
        details.addAll(_getVehicleDetails());
        break;
      case 'activity':
        details.addAll(_getActivityDetails());
        break;
    }

    return details;
  }

  /// Details for accommodation/stay listings
  List<Map<String, dynamic>> _getStayDetails() {
    return [
      {
        'icon': Icons.home,
        'label': 'Property',
        'value': 'Premium Accommodation',
      },
      {'icon': Icons.bed, 'label': 'Bedrooms', 'value': '3'},
      {'icon': Icons.bathtub, 'label': 'Bathrooms', 'value': '2'},
      {'icon': Icons.group, 'label': 'Max Guests', 'value': '6'},
      {'icon': Icons.square_foot, 'label': 'Size', 'value': '150 m²'},
      {'icon': Icons.kitchen, 'label': 'Kitchen', 'value': 'Fully Equipped'},
      {'icon': Icons.wifi, 'label': 'WiFi', 'value': 'High Speed'},
      {'icon': Icons.local_parking, 'label': 'Parking', 'value': 'Free'},
      {'icon': Icons.pool, 'label': 'Pool', 'value': 'Private Pool'},
      {'icon': Icons.beach_access, 'label': 'Beach Access', 'value': 'Direct'},
    ];
  }

  /// Details for vehicle rental listings
  List<Map<String, dynamic>> _getVehicleDetails() {
    return [
      {'icon': Icons.directions_car, 'label': 'Type', 'value': 'SUV'},
      {'icon': Icons.calendar_today, 'label': 'Year', 'value': '2023'},
      {
        'icon': Icons.local_gas_station,
        'label': 'Fuel Type',
        'value': 'Diesel',
      },
      {'icon': Icons.speed, 'label': 'Mileage', 'value': '15,000 km'},
      {'icon': Icons.people, 'label': 'Seats', 'value': '5'},
      {'icon': Icons.car_rental, 'label': 'Transmission', 'value': 'Automatic'},
      {'icon': Icons.ac_unit, 'label': 'Air Conditioning', 'value': 'Yes'},
      {
        'icon': Icons.sensors,
        'label': 'Features',
        'value': 'GPS, Backup Camera',
      },
      {'icon': Icons.card_travel, 'label': 'Insurance', 'value': 'Included'},
      {
        'icon': Icons.assignment,
        'label': 'License Required',
        'value': 'International',
      },
    ];
  }

  /// Details for activity listings
  List<Map<String, dynamic>> _getActivityDetails() {
    return [
      {'icon': Icons.schedule, 'label': 'Duration', 'value': '4 Hours'},
      {'icon': Icons.group, 'label': 'Group Size', 'value': '2-10 People'},
      {'icon': Icons.terrain, 'label': 'Difficulty', 'value': 'Moderate'},
      {'icon': Icons.language, 'label': 'Languages', 'value': 'EN, FR, AR'},
      {
        'icon': Icons.card_giftcard,
        'label': 'Includes',
        'value': 'Equipment & Guide',
      },
      {'icon': Icons.person, 'label': 'Age Requirement', 'value': '18+'},
      {'icon': Icons.local_dining, 'label': 'Meals', 'value': 'Lunch Included'},
      {'icon': Icons.camera_alt, 'label': 'Photos Included', 'value': 'Yes'},
      {
        'icon': Icons.assistant_direction,
        'label': 'Guide',
        'value': 'Professional',
      },
      {
        'icon': Icons.info,
        'label': 'Meeting Point',
        'value': 'Specified on Booking',
      },
    ];
  }

  String _getCategoryTitle() {
    final cat = (category ?? post?.category ?? '').toLowerCase();
    switch (cat) {
      case 'stay':
        return 'Stay Details';
      case 'vehicle':
        return 'Vehicle Details';
      case 'activity':
        return 'Activity Details';
      default:
        return 'Listing Details';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;
    final details = _getCategoryDetails();

    // Always show details section if post is not null
    if (post == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            _getCategoryTitle(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),

          // Details Grid
          if (details.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: secondaryTextColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: List.generate(details.length, (index) {
                  final detail = details[index];
                  final isLast = index == details.length - 1;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Icon
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Icon(
                                  detail['icon'] as IconData,
                                  color: AppTheme.primaryColor,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Label and Value
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    detail['label'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    detail['value'] as String,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // Trailing icon or badge
                            if (detail.containsKey('badge'))
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.successColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  detail['badge'] as String,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.successColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Divider
                      if (!isLast)
                        Divider(
                          color: secondaryTextColor.withOpacity(0.1),
                          height: 1,
                          indent: 56,
                        ),
                    ],
                  );
                }),
              ),
            )
          else
            _buildEmptyDetailsPlaceholder(
              context,
              textColor,
              secondaryTextColor,
              cardColor,
            ),

          // Additional Info Section
          const SizedBox(height: 12),
          _buildPriceSection(context, textColor, secondaryTextColor, cardColor),
        ],
      ),
    );
  }

  Widget _buildEmptyDetailsPlaceholder(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
    Color cardColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: secondaryTextColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.info_outline, color: secondaryTextColor, size: 32),
            const SizedBox(height: 8),
            Text(
              'No additional details available',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
    Color cardColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '\$${post!.price?.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    ' / ${_getPriceUnit()}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              post?.status == 'active' ? 'Available' : 'Unavailable',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: post?.status == 'active'
                    ? AppTheme.successColor
                    : AppTheme.failureColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPriceUnit() {
    final cat = (category ?? post?.category ?? '').toLowerCase();
    switch (cat) {
      case 'stay':
        return 'night';
      case 'vehicle':
        return 'day';
      case 'activity':
        return 'person';
      default:
        return 'unit';
    }
  }
}
