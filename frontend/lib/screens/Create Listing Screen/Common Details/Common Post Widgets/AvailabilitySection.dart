import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Common%20Details/Common%20Post%20Widgets/AvailabilityList.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Common%20Details/CommonFormLogic.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';


class AvailabilitySection extends StatelessWidget {
  final CommonFormController formController;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardColor;
  final Color categoryColor;
  final VoidCallback onAddAvailability;
  final VoidCallback onUpdate;
  
  const AvailabilitySection({
    Key? key,
    required this.formController,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardColor,
    required this.categoryColor,
    required this.onAddAvailability,
    required this.onUpdate,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: secondaryTextColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today,
                  color: categoryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                t.availability_section,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            t.availability_description,
            style: TextStyle(
              fontSize: 14,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          AvailabilityList(
            availabilityIntervals: formController.availabilityIntervals,
            onRemoveInterval: (index) {
              formController.removeAvailabilityInterval(index);
              onUpdate();
            },
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
            cardColor: cardColor,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onAddAvailability,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.white,
              foregroundColor: categoryColor,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: categoryColor.withOpacity(0.3),
                ),
              ),
            ),
            icon: const Icon(Icons.add),
            label: Text(t.add_availability_button),
          ),
        ],
      ),
    );
  }
}