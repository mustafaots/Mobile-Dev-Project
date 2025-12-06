import 'package:flutter/material.dart';

class FuelTypeDropdown extends StatelessWidget {
  final String? value;
  final List<String> fuelTypes;
  final ValueChanged<String?> onChanged;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardColor;
  
  const FuelTypeDropdown({
    Key? key,
    required this.value,
    required this.fuelTypes,
    required this.onChanged,
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
          value: value,
          decoration: InputDecoration(
            labelText: 'Fuel Type',
            labelStyle: TextStyle(color: secondaryTextColor),
            border: InputBorder.none,
            icon: Icon(Icons.local_gas_station, color: secondaryTextColor),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          items: fuelTypes.map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(_capitalize(type), style: TextStyle(color: textColor)),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select fuel type';
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
  
  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }
}