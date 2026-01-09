// shared/shared_styles.dart
import 'package:flutter/material.dart';

Widget space(double h) => SizedBox(height: h);

Widget header2(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    child: Text(
      text, 
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    ),
  );
}

Widget screenTitle(String text) {
  return Center(
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
  );
}