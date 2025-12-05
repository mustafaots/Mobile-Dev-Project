import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/theme_helper.dart';

class DetailsHelper {
  static const List<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Format requirement label by converting snake_case to Title Case
  static String formatRequirementLabel(String key) {
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

  /// Get month name from date
  static String getMonthName(DateTime date) {
    return monthNames[date.month - 1];
  }

  /// Format date to readable string (e.g., "Jan 15")
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${getMonthName(date)} ${date.day}';
  }

  /// Get price unit label based on category
  static String getPriceUnit(String? category) {
    final cat = (category ?? '').toLowerCase();
    switch (cat) {
      case 'stay':
        return 'Per Night';
      case 'vehicle':
        return 'Per Day';
      case 'activity':
        return 'Per Person';
      default:
        return 'Price';
    }
  }

  /// Get icon name based on detail type
  static String getDetailIcon(String label) {
    switch (label.toLowerCase()) {
      case 'description':
        return 'description';
      case 'stay type':
        return 'home';
      case 'bedrooms':
        return 'bed';
      case 'area':
        return 'square_foot';
      case 'vehicle type':
        return 'directions_car';
      case 'model':
        return 'card_travel';
      case 'year':
        return 'calendar_today';
      case 'fuel type':
        return 'local_gas_station';
      case 'transmission':
        return 'car_rental';
      case 'seats':
        return 'people';
      case 'features':
        return 'sensors';
      case 'activity type':
        return 'info';
      default:
        return 'check_circle';
    }
  }

  /// Get detail item color based on theme
  static Color getDetailItemColor(BuildContext context) {
    return context.secondaryTextColor;
  }

  /// Get detail item icon color based on theme
  static Color getDetailIconColor(BuildContext context) {
    return context.primaryColor;
  }
}
