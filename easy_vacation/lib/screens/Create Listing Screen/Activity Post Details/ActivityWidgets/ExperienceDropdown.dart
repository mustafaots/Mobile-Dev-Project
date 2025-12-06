import 'package:flutter/material.dart';

class ExperienceDropdown extends StatelessWidget {
  final TextEditingController controller;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardColor;
  
  const ExperienceDropdown({
    Key? key,
    required this.controller,
    required this.options,
    required this.onChanged,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardColor,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Handle empty value
    final currentValue = controller.text.isEmpty 
        ? null 
        : (options.contains(controller.text) ? controller.text : null);
    
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
          value: currentValue,
          decoration: InputDecoration(
            labelText: 'Experience Level',
            labelStyle: TextStyle(color: secondaryTextColor),
            border: InputBorder.none,
            icon: Icon(Icons.school, color: secondaryTextColor),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          hint: Text('Select experience', style: TextStyle(color: secondaryTextColor)),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option, style: TextStyle(color: textColor)),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select experience level';
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