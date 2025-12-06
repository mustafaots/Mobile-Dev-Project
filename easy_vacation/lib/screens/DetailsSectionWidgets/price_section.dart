import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';

class PriceSection extends StatelessWidget {
  final double? price;
  final String? category;
  final bool isAvailable;

  const PriceSection({
    Key? key,
    required this.price,
    required this.category,
    this.isAvailable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (price == null || price == 0) return const SizedBox.shrink();

    final priceUnit = _getPriceUnit(category, loc);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        border: Border.all(
          color: context.secondaryTextColor.withOpacity(0.1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
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
                  color: context.secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${price!.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                priceUnit,
                style: TextStyle(
                  fontSize: 12,
                  color: context.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isAvailable
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isAvailable ? loc.details_available : loc.details_unavailable,
                  style: TextStyle(
                    fontSize: 12,
                    color: isAvailable ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getPriceUnit(String? category, AppLocalizations loc) {
    final cat = (category ?? '').toLowerCase();
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
