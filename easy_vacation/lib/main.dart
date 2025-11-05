import 'package:easy_vacation/classes/AYM/UserProfileScreen.dart';
import 'package:easy_vacation/classes/AYM/AddReviewScreen.dart';
import 'package:easy_vacation/classes/AYM/NotificationsScreen.dart';
import 'package:easy_vacation/classes/DAN/HomeScreen.dart';
import 'package:easy_vacation/classes/DAN/Vehicles.dart';
import 'package:easy_vacation/classes/MAS/WelcomeScreen.dart';
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
      home: const EasyVacationWelcome(), // Or your desired home screen
    );
  }
}