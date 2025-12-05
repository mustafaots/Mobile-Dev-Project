import 'package:flutter/material.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/models/activities.model.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/themes.dart';

class DetailsSection extends StatelessWidget {
  final Post? post;
  final String? category;
  final Stay? stay;
  final Vehicle? vehicle;
  final Activity? activity;
  final bool isLoading;

  const DetailsSection({
    super.key,
    this.post,
    this.category,
    this.stay,
    this.vehicle,
    this.activity,
    this.isLoading = false,
  });

  /// Get category-specific details based on loaded data
  List<Map<String, dynamic>> _getCategoryDetails(AppLocalizations loc) {
    if (post == null) return [];

    final details = <Map<String, dynamic>>[];

    // Add description if available
    if (post!.description != null && post!.description!.isNotEmpty) {
      details.add({
        'icon': Icons.description,
        'label': loc.details_description,
        'value': post!.description!,
      });
    }

    // Get the category from parameter or post
    final cat = (category ?? post?.category ?? '').toLowerCase();

    // Add category-specific details
    switch (cat) {
      case 'stay':
        if (stay != null) {
          details.addAll(_getStayDetails(loc));
        }
        break;
      case 'vehicle':
        if (vehicle != null) {
          details.addAll(_getVehicleDetails(loc));
        }
        break;
      case 'activity':
        if (activity != null) {
          details.addAll(_getActivityDetails(loc));
        }
        break;
    }

    return details;
  }

  /// Details for accommodation/stay listings
  List<Map<String, dynamic>> _getStayDetails(AppLocalizations loc) {
    if (stay == null) return [];

    return [
      {
        'icon': Icons.home,
        'label': loc.details_stayType,
        'value': stay!.stayType.replaceFirst(
          stay!.stayType[0],
          stay!.stayType[0].toUpperCase(),
        ),
      },
      {'icon': Icons.bed, 'label': loc.details_bedrooms, 'value': '${stay!.bedrooms}'},
      {'icon': Icons.square_foot, 'label': loc.details_area, 'value': '${stay!.area} m²'},
    ];
  }

  /// Details for vehicle rental listings
  List<Map<String, dynamic>> _getVehicleDetails(AppLocalizations loc) {
    if (vehicle == null) return [];

    final details = <Map<String, dynamic>>[
      {
        'icon': Icons.directions_car,
        'label': loc.details_vehicleType,
        'value': vehicle!.vehicleType.replaceFirst(
          vehicle!.vehicleType[0],
          vehicle!.vehicleType[0].toUpperCase(),
        ),
      },
      {'icon': Icons.card_travel, 'label': loc.details_model, 'value': vehicle!.model},
      {
        'icon': Icons.calendar_today,
        'label': loc.details_year,
        'value': '${vehicle!.year}',
      },
      {
        'icon': Icons.local_gas_station,
        'label': loc.details_fuelType,
        'value': vehicle!.fuelType.replaceFirst(
          vehicle!.fuelType[0],
          vehicle!.fuelType[0].toUpperCase(),
        ),
      },
      {
        'icon': Icons.car_rental,
        'label': loc.details_transmission,
        'value': vehicle!.transmission ? loc.details_automatic : loc.details_manual,
      },
      {'icon': Icons.people, 'label': loc.details_seats, 'value': '${vehicle!.seats}'},
    ];

    // Add features if available
    if (vehicle!.features != null && vehicle!.features!.isNotEmpty) {
      details.add({
        'icon': Icons.sensors,
        'label': loc.details_features,
        'value': vehicle!.features!.entries
            .map((e) => '${e.key}: ${e.value}')
            .join(', '),
      });
    }

    return details;
  }

  /// Details for activity listings
  List<Map<String, dynamic>> _getActivityDetails(AppLocalizations loc) {
    if (activity == null) return [];

    final details = <Map<String, dynamic>>[
      {
        'icon': Icons.info,
        'label': loc.details_activityType,
        'value': activity!.activityType.replaceFirst(
          activity!.activityType[0],
          activity!.activityType[0].toUpperCase(),
        ),
      },
    ];

    // Add requirements if available
    if (activity!.requirements.isNotEmpty) {
      for (var entry in activity!.requirements.entries) {
        details.add({
          'icon': Icons.check_circle,
          'label': _formatRequirementLabel(entry.key),
          'value': entry.value.toString(),
        });
      }
    }

    return details;
  }

  String _formatRequirementLabel(String key) {
    // Convert camelCase or snake_case to Title Case
    return key
        .replaceAll(RegExp(r'_'), ' ')
        .replaceAll(RegExp(r'([A-Z])'), ' \$1')
        .trim()
        .split(' ')
        .map(
          (word) =>
              word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;
    final loc = AppLocalizations.of(context)!;
    final details = _getCategoryDetails(loc);

    // Always show details section if post is not null
    if (post == null) {
      return const SizedBox.shrink();
    }

    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
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
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              loc,
            ),

          // Additional Info Section
          const SizedBox(height: 12),
          _buildPriceSection(context, textColor, secondaryTextColor, cardColor, loc),
        ],
      ),
    );
  }

  Widget _buildEmptyDetailsPlaceholder(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
    Color cardColor,
    AppLocalizations loc,
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
              loc.details_noAdditionalDetails,
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
    AppLocalizations loc,
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
                loc.details_price,
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
                    '\$${post!.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    ' / ${_getPriceUnit(loc)}',
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
              post?.status == 'active' ? loc.details_available : loc.details_unavailable,
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

  String _getPriceUnit(AppLocalizations loc) {
    final cat = (category ?? post?.category ?? '').toLowerCase();
    switch (cat) {
      case 'stay':
        return loc.details_pricePerNight;
      case 'vehicle':
        return loc.details_pricePerDay;
      case 'activity':
        return loc.details_pricePerPerson;
      default:
        return loc.details_pricePerUnit;
    }
  }
}
