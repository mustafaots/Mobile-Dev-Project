import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/RateDropdown.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Stays%20Post%20Details/Stay%20Widgets/StayTypeDropdown.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Stays%20Post%20Details/StayFormLogic.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/ui_widgets/FormField.dart';


class StayDetailsCard extends StatelessWidget {
  final StayFormController formController;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardColor;
  final ValueChanged<String?> onRateChanged;
  final ValueChanged<String?> onStayTypeChanged;
  
  const StayDetailsCard({
    Key? key,
    required this.formController,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardColor,
    required this.onRateChanged,
    required this.onStayTypeChanged,
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
            validator: (value) => value == null || value.trim().isEmpty
                ? loc.field_title_error
                : null,
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

          // Stay Type
          StayTypeDropdown(
            value: formController.selectedStayType,
            stayTypes: formController.stayTypes,
            onChanged: onStayTypeChanged,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
            cardColor: cardColor,
          ),
          const SizedBox(height: 16),

          // Area
          buildFormField(
            context,
            controller: formController.areaController,
            label: loc.area_label,
            icon: Icons.square_foot,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc.area_error_required;
              }
              final parsed = double.tryParse(value);
              if (parsed == null) {
                return loc.area_error_invalid;
              }
              if (parsed <= 0) {
                return loc.area_error_positive;
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          // Bedrooms
          buildFormField(
            context,
            controller: formController.bedroomsController,
            label: loc.bedrooms_label,
            icon: Icons.bed,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc.bedrooms_error_required;
              }
              final parsed = int.tryParse(value);
              if (parsed == null) {
                return loc.bedrooms_error_invalid;
              }
              if (parsed <= 0) {
                return loc.bedrooms_error_positive;
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 16),

          // Price and Rate
          Row(
            children: [
              Expanded(
                flex: 2,
                child: buildFormField(
                  context,
                  controller: formController.priceController,
                  label: loc.price_label,
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
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: RateDropdown(
                  value: formController.selectedPriceRate,
                  priceRates: formController.priceRates,
                  onChanged: onRateChanged,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                  cardColor: cardColor
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}