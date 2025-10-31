import 'package:easy_vacation/styles/RegistrationStyles.dart';
import 'package:flutter/material.dart';

Widget space(double h) => SizedBox(height: h);

Widget header2(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    child: Text(text, style: header_2),
  );
}

Widget screen_title(String text) {
  return Center(
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
