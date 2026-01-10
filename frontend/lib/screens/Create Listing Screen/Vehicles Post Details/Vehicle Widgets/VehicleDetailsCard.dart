import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Vehicles%20Post%20Details/Vehicle%20Widgets/FuelTypeDropdown.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Vehicles%20Post%20Details/Vehicle%20Widgets/TransmissionSelector.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Vehicles%20Post%20Details/Vehicle%20Widgets/VehicleTypeDropdown.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Vehicles%20Post%20Details/VehicleFormLogic.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/ui_widgets/FormField.dart';

class VehicleDetailsCard extends StatelessWidget {
  final VehicleFormController formController;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardColor;
  final ValueChanged<String?> onVehicleTypeChanged;
  final ValueChanged<String?> onFuelTypeChanged;
  final ValueChanged<bool> onTransmissionChanged;
  
  const VehicleDetailsCard({
    Key? key,
    required this.formController,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardColor,
    required this.onVehicleTypeChanged,
    required this.onFuelTypeChanged,
    required this.onTransmissionChanged,
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

          // Model
          buildFormField(
            context,
            controller: formController.modelController,
            label: loc.model_label,
            icon: Icons.badge,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc.model_error;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Year
          buildFormField(
            context,
            controller: formController.yearController,
            label: loc.year_label,
            icon: Icons.calendar_today,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc.year_error_empty;
              }
              if (int.tryParse(value) == null) {
                return loc.year_error_invalid;
              }
              final year = int.parse(value);
              if (year < 1900 || year > DateTime.now().year + 1) {
                return loc.year_error_range(DateTime.now().year + 1);
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          // Transmission
          TransmissionSelector(
            isAutomatic: formController.isAutomaticTransmission,
            onChanged: onTransmissionChanged,
            textColor: textColor,
            cardColor: cardColor,
          ),
          const SizedBox(height: 16),

          // Number of Seats
          buildFormField(
            context,
            controller: formController.seatsController,
            label: loc.seats_label,
            icon: Icons.airline_seat_recline_normal,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc.seats_error_empty;
              }
              if (int.tryParse(value) == null) {
                return loc.seats_error_invalid;
              }
              final seats = int.parse(value);
              if (seats < 1 || seats > 100) {
                return loc.seats_error_range;
              }
              return null;
            },
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 16),

          // Price (per day for vehicles)
          buildFormField(
            context,
            controller: formController.priceController,
            label: '${loc.price_label} (${loc.details_pricePerDay})',
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

          // Vehicle Type (dropdown at the bottom)
          VehicleTypeDropdown(
            value: formController.selectedVehicleType,
            vehicleTypes: formController.vehicleTypes,
            onChanged: onVehicleTypeChanged,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
            cardColor: cardColor,
          ),
          const SizedBox(height: 16),

          // Fuel Type (dropdown at the bottom)
          FuelTypeDropdown(
            value: formController.selectedFuelType,
            fuelTypes: formController.fuelTypes,
            onChanged: onFuelTypeChanged,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
            cardColor: cardColor,
          ),
        ],
      ),
    );
  }
}