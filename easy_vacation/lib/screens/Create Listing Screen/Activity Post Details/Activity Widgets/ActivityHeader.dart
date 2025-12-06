import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';

class ActivityHeader extends StatelessWidget {
  final Color textColor;
  final Color secondaryTextColor;
  
  const ActivityHeader({
    Key? key,
    required this.textColor,
    required this.secondaryTextColor,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.hiking_outlined,
              color: AppTheme.successColor,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Activity Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Provide details about your activity',
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