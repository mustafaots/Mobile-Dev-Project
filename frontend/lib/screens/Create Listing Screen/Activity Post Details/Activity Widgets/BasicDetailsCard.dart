import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Activity%20Post%20Details/ActivityFormLogic.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/ui_widgets/FormField.dart';

class BasicDetailsCard extends StatelessWidget {
  final ActivityFormController formController;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardColor;
  final ValueChanged<String?> onActivityTypeChanged;

  const BasicDetailsCard({
    Key? key,
    required this.formController,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardColor,
    required this.onActivityTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

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
          buildFormField(
            context,
            controller: formController.titleController,
            label: loc.field_title,
            icon: Icons.title_outlined,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return loc.field_title_error;
              }
              if (value.trim().length < 3) {
                return loc.field_title_min_length;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          buildFormField(
            context,
            controller: formController.descriptionController,
            label: loc.field_description,
            icon: Icons.description_outlined,
            validator: (value) => value == null || value.trim().isEmpty
                ? loc.field_description_error
                : null,
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          // Price (per person for activities)
          buildFormField(
            context,
            controller: formController.priceController,
            label: '${loc.price_label} (${loc.details_pricePerPerson})',
            icon: Icons.money,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc.price_error_required;
              }
              final parsed = double.tryParse(value);
              if (parsed == null) {
                return loc.price_error_invalid;
              }
              if (parsed <= 0) {
                return loc.price_error_positive;
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 16),

          // Activity Type Dropdown (at the bottom)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: secondaryTextColor.withOpacity(0.3)),
            ),
            child: DropdownButtonFormField<String>(
              value: formController.selectedActivityType,
              decoration: InputDecoration(
                labelText: loc.activity_type_label,
                labelStyle: TextStyle(color: secondaryTextColor),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.hiking, color: secondaryTextColor),
              ),
              dropdownColor: cardColor,
              style: TextStyle(color: textColor),
              items: formController.activityTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    type[0].toUpperCase() + type.substring(1),
                    style: TextStyle(color: textColor),
                  ),
                );
              }).toList(),
              onChanged: onActivityTypeChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return loc.activity_type_error;
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
