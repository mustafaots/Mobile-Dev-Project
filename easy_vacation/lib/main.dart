import 'package:easy_vacation/classes/AYM/addReviewPage.dart';
import 'package:easy_vacation/classes/MAS/welcome_to_easyvacation/welcome_screen.dart';
import 'package:easy_vacation/classes/MUS/LoginScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen()
    );
  }
}
