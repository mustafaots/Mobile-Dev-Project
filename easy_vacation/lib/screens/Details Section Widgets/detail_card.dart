import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/theme_helper.dart';

class DetailCard extends StatelessWidget {
  final String label;
  final String value;
  final String? icon;
  final VoidCallback? onTap;

  const DetailCard({
    Key? key,
    required this.label,
    required this.value,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: context.cardColor,
          border: Border.all(
            color: context.secondaryTextColor.withOpacity(0.1),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconData(icon!),
                  color: context.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'description':
        return Icons.description;
      case 'home':
        return Icons.home;
      case 'bed':
        return Icons.bed;
      case 'square_foot':
        return Icons.square_foot;
      case 'directions_car':
        return Icons.directions_car;
      case 'card_travel':
        return Icons.card_travel;
      case 'calendar_today':
        return Icons.calendar_today;
      case 'local_gas_station':
        return Icons.local_gas_station;
      case 'car_rental':
        return Icons.car_rental;
      case 'people':
        return Icons.people;
      case 'sensors':
        return Icons.sensors;
      case 'info':
        return Icons.info;
      case 'check_circle':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }
}
