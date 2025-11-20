import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeData> {
  bool _isDarkTheme = false;

  ThemeCubit() : super(_buildLightTheme());

  static ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color.fromARGB(255, 29, 155, 240),
      scaffoldBackgroundColor: Colors.white,
      canvasColor: Colors.white,
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 29, 155, 240),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.black87),
        bodySmall: TextStyle(color: Color(0xFF6B7280)),
      ),
    );
  }

  static ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      canvasColor: Colors.grey[850]!,
      cardColor: Colors.grey[900],
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.grey),
      ),
    );
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    emit(_isDarkTheme ? _buildDarkTheme() : _buildLightTheme());
  }
}
