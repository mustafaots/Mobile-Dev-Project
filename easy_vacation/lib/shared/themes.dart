// shared/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Colors - Use Flutter's standard colors for consistency
  static const Color primaryColor = Color.fromARGB(255, 29, 155, 240);
  static const Color white = Colors.white;
  static const Color black = Colors.black87;
  static const Color darkGrey = Color(0xFF374151);
  static const Color grey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color successColor = Colors.green;
  static const Color failureColor = Colors.red;
  static const Color neutralColor = Colors.amber;

  // Text Styles
  static const TextStyle header1 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 30,
    color: Colors.black87,
  );

  static const TextStyle header2 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: Colors.black87,
  );

  static const TextStyle smallGreyText = TextStyle(
    color: Color(0xFF6B7280),
    fontSize: 14,
  );

  static const TextStyle appBarStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle loginTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Input Decoration
  static InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 16),
      hintText: label,
      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      prefixIcon: Icon(icon, color: const Color(0xFF6B7280)),
    );
  }

  // Button Styles
  static final ButtonStyle primaryButtonStyle = ButtonStyle(
    minimumSize: WidgetStateProperty.all(const Size(double.infinity, 55)),
    backgroundColor: WidgetStateProperty.all(primaryColor),
    foregroundColor: WidgetStateProperty.all(white),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevation: WidgetStateProperty.all(2),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(vertical: 16),
    ),
  );

  static ButtonStyle radioButtonStyle(bool isSelected) {
    return ElevatedButton.styleFrom(
      backgroundColor: white,
      foregroundColor: isSelected ? primaryColor : black,
      side: BorderSide(
        color: isSelected ? primaryColor : const Color(0xFFD1D5DB),
        width: 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: isSelected ? 3 : 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    );
  }

  // Card Style
  static BoxDecoration cardDecoration = BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // App Bar Theme
  static AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: white,
    titleTextStyle: appBarStyle,
    elevation: 0,
    centerTitle: true,
  );
}