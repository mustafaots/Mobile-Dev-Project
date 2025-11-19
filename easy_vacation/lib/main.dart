import 'package:easy_vacation/screens/WelcomeScreen.dart';
import 'package:easy_vacation/screens/ProfileScreen.dart';
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
          foregroundColor: AppTheme.white,
          elevation: 0,
        ),
      ),
      home: const WelcomeScreen()
    );
  }
}

//const ProfileScreen(      postsCount: 24,
 //     followersCount: 128,
 //     followingCount: 56,
 //     isFollowing: false,), // Or your desired home screen