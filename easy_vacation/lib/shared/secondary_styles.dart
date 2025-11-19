import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';

var header_1 = TextStyle(fontWeight: FontWeight.bold, fontSize: 30);
var header_2 = TextStyle(fontWeight: FontWeight.w500, fontSize: 20);

var small_grey_text = TextStyle(color: AppTheme.grey, fontSize: 14);

var app_bar_style = TextStyle(
  color: AppTheme.white,
  fontSize: 30,
  fontWeight: FontWeight.w500,
);

var app_title_style = TextStyle(
  color: AppTheme.primaryColor,
  fontSize: 35,
  fontWeight: FontWeight.w500,
);

InputDecoration input_decor(String text, Icon icon) {
  return InputDecoration(
    labelText: text,
    labelStyle: TextStyle(color: AppTheme.grey, fontSize: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppTheme.grey.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppTheme.primaryColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppTheme.grey.withOpacity(0.3)),
    ),
    filled: true,
    fillColor: AppTheme.lightGrey,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    prefixIcon: icon,
    prefixIconColor: AppTheme.grey,
  );
}

var login_button_style = ButtonStyle(
  minimumSize: WidgetStateProperty.all(const Size(double.infinity, 60)),
  backgroundColor: WidgetStateProperty.all(AppTheme.primaryColor),
  foregroundColor: WidgetStateProperty.all(AppTheme.white),
  shape: WidgetStateProperty.all(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  elevation: WidgetStateProperty.all(2),
);

var login_text_style =
    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

ButtonStyle radio_button_style(bool isSelected) {
  return ElevatedButton.styleFrom(
    backgroundColor: AppTheme.white,
    foregroundColor: isSelected ? AppTheme.primaryColor : AppTheme.black,
    side: BorderSide(
      color: isSelected ? AppTheme.primaryColor : AppTheme.grey,
      width: 2,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: isSelected ? 3 : 0,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
  );
}
