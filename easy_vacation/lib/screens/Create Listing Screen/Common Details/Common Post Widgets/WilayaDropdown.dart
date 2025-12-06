import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class WilayaDropdown extends StatelessWidget {
  final TextEditingController controller;
  final List<String> wilayas;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardColor;
  
  const WilayaDropdown({
    Key? key,
    required this.controller,
    required this.wilayas,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardColor,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: secondaryTextColor.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: DropdownButtonFormField<String>(
          value: controller.text.isNotEmpty ? controller.text : null,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.wilaya_label,
            labelStyle: TextStyle(color: secondaryTextColor),
            border: InputBorder.none,
            icon: Icon(Icons.location_city, color: secondaryTextColor),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          items: wilayas.map((wilaya) {
            return DropdownMenuItem<String>(
              value: wilaya,
              child: Text(wilaya, style: TextStyle(color: textColor)),
            );
          }).toList(),
          onChanged: (value) {
            controller.text = value!;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.wilaya_validation;
            }
            return null;
          },
          style: TextStyle(color: textColor),
          dropdownColor: cardColor,
          icon: Icon(Icons.arrow_drop_down, color: secondaryTextColor),
        ),
      ),
    );
  }
}