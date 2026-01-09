import 'package:bloc/bloc.dart';
import 'package:easy_vacation/services/sharedprefs.services.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeData> {
  bool _isDarkTheme = false;

  ThemeCubit() : super(_buildLightTheme()) {
    // Load saved theme on initialization
    _loadSavedTheme();
  }

  /// Load saved theme from SharedPreferences
  Future<void> _loadSavedTheme() async {
    try {
      final savedTheme = SharedPrefsService.getTheme();
      _isDarkTheme = savedTheme == 'dark';
      
      if (_isDarkTheme) {
        emit(_buildDarkTheme());
      } else {
        emit(_buildLightTheme());
      }
    } catch (e) {
      print('Error loading theme: $e');
      // Keep default light theme
    }
  }

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
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppTheme.primaryColor,
        circularTrackColor: AppTheme.primaryColor.withOpacity(0.2),
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
        backgroundColor: Color.fromARGB(255, 36, 36, 36),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppTheme.primaryColor,
        circularTrackColor: AppTheme.primaryColor.withOpacity(0.2),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.grey),
      ),
    );
  }

  /// Toggle theme and save to SharedPreferences
  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    
    // Save to SharedPreferences
    final themeToSave = _isDarkTheme ? 'dark' : 'light';
    SharedPrefsService.setTheme(themeToSave);
    
    // Emit new theme
    emit(_isDarkTheme ? _buildDarkTheme() : _buildLightTheme());
  }

  /// Get current theme mode
  bool get isDarkTheme => _isDarkTheme;

  /// Set theme directly
  void setTheme(bool isDark) {
    _isDarkTheme = isDark;
    
    // Save to SharedPreferences
    final themeToSave = _isDarkTheme ? 'dark' : 'light';
    SharedPrefsService.setTheme(themeToSave);
    
    // Emit new theme
    emit(_isDarkTheme ? _buildDarkTheme() : _buildLightTheme());
  }
}