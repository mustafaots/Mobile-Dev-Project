import 'dart:ui';
import 'package:flutter/material.dart';

var blue = Color.fromARGB(255, 36, 112, 255);
var grey = const Color.fromARGB(255, 118, 118, 118);
var lightGrey = const Color.fromARGB(255, 240, 240, 240);

var header_1 = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 30,
);

var header_2 = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
);

var header_3 = TextStyle(
  color: grey,
  fontSize: 14,
);

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

var signin_link_style = TextStyle(
  fontSize: 20,
);

var forgotpassword_link_style = TextStyle(
  color: blue,
);

InputDecoration input_decor(String text, Icon icon) {
  return InputDecoration(
    labelText: text,
    labelStyle: TextStyle(color: grey, fontSize: 14),
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
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    prefixIcon: icon,
    prefixIconColor: grey,
  );
}

var login_button_style = ButtonStyle(
  minimumSize: MaterialStateProperty.all(const Size(double.infinity, 60)),
  backgroundColor: MaterialStateProperty.all(blue),
  foregroundColor: MaterialStateProperty.all(Colors.white),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  elevation: MaterialStateProperty.all(2),
);

var login_text_style = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);