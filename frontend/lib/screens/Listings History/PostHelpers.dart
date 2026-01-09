import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/activities.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:flutter/material.dart';

class PostHelpers {
  final BuildContext context;

  PostHelpers(this.context);

  // Category methods
  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'stay': return Icons.house;
      case 'activity': return Icons.hiking;
      case 'vehicle': return Icons.directions_car;
      default: return Icons.category;
    }
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'stay': return AppTheme.primaryColor;
      case 'activity': return AppTheme.successColor;
      case 'vehicle': return AppTheme.neutralColor;
      default: return Colors.grey;
    }
  }

  String getCategoryText(String category) {
    switch (category) {
      case 'stay': return 'Stay';
      case 'activity': return 'Activity';
      case 'vehicle': return 'Vehicle';
      default: return 'Other';
    }
  }

  // Status methods
  Color getStatusColor(String status) {
    switch (status) {
      case 'active': return AppTheme.successColor;
      case 'draft': return AppTheme.neutralColor;
      default: return context.secondaryTextColor;
    }
  }

  String getStatusText(String status) {
    final loc = AppLocalizations.of(context)!;
    switch (status) {
      case 'active': return loc.listingHistory_published;
      case 'draft': return loc.listingHistory_draft;
      default: return status;
    }
  }

  // Build category details
  Widget buildCategoryDetails(dynamic details, String category) {
    final secondaryTextColor = context.secondaryTextColor;
    switch (category) {
      case 'stay':
        final stay = details as Stay;
        return Text(
          '${stay.stayType} • ${stay.area} m² • ${stay.bedrooms} bedroom${stay.bedrooms > 1 ? 's' : ''}',
          style: TextStyle(fontSize: 14, color: secondaryTextColor),
        );
      case 'activity':
        final activity = details as Activity;
        return Text(
          '${activity.activityType} • Activity',
          style: TextStyle(fontSize: 14, color: secondaryTextColor),
        );
      case 'vehicle':
        final vehicle = details as Vehicle;
        return Text(
          '${vehicle.vehicleType} • ${vehicle.model} • ${vehicle.year}',
          style: TextStyle(fontSize: 14, color: secondaryTextColor),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // Build image placeholder
  Widget buildImagePlaceholder(String category) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: getCategoryColor(category).withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Center(
        child: Icon(
          getCategoryIcon(category),
          size: 48,
          color: getCategoryColor(category).withOpacity(0.5),
        ),
      ),
    );
  }

  // Format date
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) return '${(difference.inDays / 365).floor()} years ago';
    if (difference.inDays > 30) return '${(difference.inDays / 30).floor()} months ago';
    if (difference.inDays > 7) return '${(difference.inDays / 7).floor()} weeks ago';
    if (difference.inDays > 0) return '${difference.inDays} days ago';
    if (difference.inHours > 0) return '${difference.inHours} hours ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes} minutes ago';
    return 'Just now';
  }
}