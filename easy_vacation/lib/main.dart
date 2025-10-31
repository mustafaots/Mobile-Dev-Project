import 'package:easy_vacation/classes/ConfirmListingScreen.dart';
import 'package:easy_vacation/classes/LoginScreen.dart';
import 'package:easy_vacation/classes/SignUpScreen.dart';
import 'package:easy_vacation/classes/CreateListingScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConfirmAndPostScreen()
    );
  }
}

