import 'package:easy_vacation/shared/colors.dart';
import 'package:flutter/material.dart';

var header_1 = TextStyle(fontWeight: FontWeight.bold, fontSize: 30);
var header_2 = TextStyle(fontWeight: FontWeight.w500, fontSize: 20);

var small_grey_text = TextStyle(color: grey, fontSize: 14);

var app_bar_style = TextStyle(
  color: Colors.white,
  fontSize: 30,
  fontWeight: FontWeight.w500,
);

var app_title_style = TextStyle(
  color: blue,
  fontSize: 35,
  fontWeight: FontWeight.w500,
);

InputDecoration input_decor(String text, Icon icon) {
  return InputDecoration(
    labelText: text,
    labelStyle: TextStyle(color: grey, fontSize: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: grey.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: blue),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: grey.withOpacity(0.3)),
    ),
    filled: true,
    fillColor: lightGrey,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    prefixIcon: icon,
    prefixIconColor: grey,
  );
}

var login_button_style = ButtonStyle(
  minimumSize: MaterialStateProperty.all(const Size(double.infinity, 60)),
  backgroundColor: MaterialStateProperty.all(blue),
  foregroundColor: MaterialStateProperty.all(Colors.white),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  elevation: MaterialStateProperty.all(2),
);

var login_text_style =
    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
