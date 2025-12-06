import 'package:easy_vacation/screens/Create%20Listing%20Screen/Common%20Details/Common%20Post%20Widgets/WilayaDropdown.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Common%20Details/CommonFormLogic.dart';
import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/ui_widgets/FormField.dart';
import 'package:easy_vacation/shared/themes.dart';

class LocationSection extends StatelessWidget {
  final CommonFormController formController;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardColor;
  final Color categoryColor;
  final VoidCallback onSelectLocation;
  final GlobalKey<FormState> formKey;
  
  const LocationSection({
    Key? key,
    required this.formController,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardColor,
    required this.categoryColor,
    required this.onSelectLocation,
    required this.formKey,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: secondaryTextColor.withOpacity(0.2)),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    color: categoryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Map Selection Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onSelectLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.white,
                  foregroundColor: categoryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: categoryColor.withOpacity(
                          formController.selectedLatitude == null ? 0.3 : 1.0),
                    ),
                  ),
                ),
                icon: Icon(formController.selectedLatitude == null 
                    ? Icons.map 
                    : Icons.location_on),
                label: Text(
                  formController.selectedLatitude == null
                      ? 'Select Location on Map'
                      : 'Location Selected (${formController.selectedLatitude!.toStringAsFixed(4)}, ${formController.selectedLongitude!.toStringAsFixed(4)})',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Wilaya Dropdown
            WilayaDropdown(
              controller: formController.wilayaController,
              wilayas: formController.wilayas,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              cardColor: cardColor,
            ),
            const SizedBox(height: 16),

            // Row for City and Address
            Row(
              children: [
                Expanded(
                  child: buildFormField(
                    context,
                    controller: formController.cityController,
                    label: 'City',
                    icon: Icons.location_city,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Please enter city'
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: buildFormField(
                    context,
                    controller: formController.addressController,
                    label: 'Address',
                    icon: Icons.home,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Please enter address'
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}