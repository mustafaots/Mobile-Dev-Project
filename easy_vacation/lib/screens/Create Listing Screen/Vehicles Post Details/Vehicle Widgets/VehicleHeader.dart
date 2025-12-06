import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';

class VehicleHeader extends StatelessWidget {
  final Color textColor;
  final Color secondaryTextColor;
  
  const VehicleHeader({
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
              color: AppTheme.neutralColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.directions_car_outlined,
              color: AppTheme.neutralColor,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Vehicle Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Provide details about your vehicle',
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