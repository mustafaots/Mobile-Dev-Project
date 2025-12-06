import 'package:flutter/material.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/shared/themes.dart';

class CommonHeader extends StatelessWidget {
  final CreatePostData postData;
  final Color textColor;
  final Color secondaryTextColor;
  
  const CommonHeader({
    Key? key,
    required this.postData,
    required this.textColor,
    required this.secondaryTextColor,
  }) : super(key: key);
  
  Color get _categoryColor {
    switch (postData.category) {
      case 'stay':
        return AppTheme.primaryColor;
      case 'activity':
        return AppTheme.successColor;
      case 'vehicle':
        return AppTheme.neutralColor;
      default:
        return AppTheme.primaryColor;
    }
  }
  
  IconData get _categoryIcon {
    switch (postData.category) {
      case 'stay':
        return Icons.house_outlined;
      case 'activity':
        return Icons.hiking_outlined;
      case 'vehicle':
        return Icons.directions_car_outlined;
      default:
        return Icons.category_outlined;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _categoryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _categoryIcon,
              color: _categoryColor,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Complete Your Listing',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add location, photos, and availability',
            style: TextStyle(
              fontSize: 16,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}