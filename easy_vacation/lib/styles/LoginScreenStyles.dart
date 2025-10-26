import 'dart:ui';
import 'package:flutter/material.dart';


var blue = Color.fromARGB(255, 36, 112, 255);
var grey = const Color.fromARGB(255, 118, 118, 118);

var header_1 = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 30
);

var header_2 = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20
);

var header_3 = TextStyle(
  color: grey,
  fontSize: 15
);





var app_bar_style = TextStyle(
  color: Colors.white,
  fontSize: 30,
  fontWeight: FontWeight.w500
);

var app_title_style = TextStyle(
  color: blue,
  fontSize: 35,
  fontWeight: FontWeight.w500
);

var signin_link_style = TextStyle(
  fontSize: 20
);

var forgotpassword_link_style = TextStyle(
  color: blue
);

InputDecoration input_decor( String text , Icon icon ){
  return InputDecoration(
    labelText: text,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30), // <-- round edges here
      borderSide: const BorderSide(color: Colors.grey),
    ),
    prefixIcon: icon
  );
}

var login_button_style = ButtonStyle(
  minimumSize: MaterialStateProperty.all(const Size(double.infinity, 60)), // width, height
  backgroundColor: MaterialStateProperty.all(blue),       // button background color
  foregroundColor: MaterialStateProperty.all(Colors.white), // text color
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50),
    ),
  ),
);

var login_text_style = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold
);