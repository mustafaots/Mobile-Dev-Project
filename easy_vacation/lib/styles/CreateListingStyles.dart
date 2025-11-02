import 'package:easy_vacation/shared/colors.dart';
import 'package:flutter/material.dart';

ButtonStyle radio_button_style(bool isSelected) {
  return ElevatedButton.styleFrom(
    backgroundColor: white,
    foregroundColor: isSelected ? blue : black,
    side: BorderSide(
      color: isSelected ? blue : Colors.grey,
      width: 2,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: isSelected ? 3 : 0,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
  );
}
