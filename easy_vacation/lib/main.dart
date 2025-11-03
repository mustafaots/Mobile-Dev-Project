import 'package:easy_vacation/classes/AYM/ProfilePage.dart';
import 'package:easy_vacation/classes/AYM/addReviewPage.dart';
import 'package:easy_vacation/classes/AYM/notification_tourist.dart';
import 'package:easy_vacation/classes/DAN/home_screen.dart';
import 'package:easy_vacation/classes/DAN/vehicules.dart';
import 'package:easy_vacation/classes/MAS/welcome_screen.dart';
import 'package:easy_vacation/classes/MUS/LoginScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
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
      theme: ThemeData(
        primaryColor: AppTheme.primaryColor,
        scaffoldBackgroundColor: Colors.white, // Force white background
        appBarTheme: const AppBarTheme(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const LoginScreen(), // Or your desired home screen
    );
  }
}