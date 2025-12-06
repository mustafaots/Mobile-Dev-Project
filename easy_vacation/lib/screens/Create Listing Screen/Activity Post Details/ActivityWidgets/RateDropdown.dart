import 'package:flutter/material.dart';

class RateDropdown extends StatelessWidget {
  final String value;
  final List<String> priceRates;
  final ValueChanged<String?> onChanged;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardColor;
  final FormFieldValidator<String>? validator;
  
  const RateDropdown({
    Key? key,
    required this.value,
    required this.priceRates,
    required this.onChanged,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardColor,
    this.validator,
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
          value: value.isEmpty ? null : value, // Handle empty string
          decoration: InputDecoration(
            labelText: 'Rate',
            labelStyle: TextStyle(color: secondaryTextColor),
            border: InputBorder.none,
            icon: Icon(Icons.schedule, color: secondaryTextColor),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          hint: Text('Select rate', style: TextStyle(color: secondaryTextColor)), // Add hint
          items: priceRates.map((rate) {
            return DropdownMenuItem<String>(
              value: rate,
              child: Text('/$rate', style: TextStyle(color: textColor)),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator ?? (value) {
            if (value == null || value.isEmpty) {
              return 'Please select rate';
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