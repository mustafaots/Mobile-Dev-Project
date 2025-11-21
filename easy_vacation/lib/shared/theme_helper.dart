import 'package:flutter/material.dart';

extension ThemeHelper on BuildContext {
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;

  Color get cardColor => Theme.of(this).cardColor;

  Color get primaryColor => Theme.of(this).primaryColor;

  Color get appBarColor =>
      Theme.of(this).appBarTheme.backgroundColor ?? Theme.of(this).primaryColor;

  TextStyle? get bodyMediumStyle => Theme.of(this).textTheme.bodyMedium;

  Color get textColor => isDarkTheme ? Colors.white : Colors.black87;

  Color get secondaryTextColor =>
      isDarkTheme ? Colors.grey : const Color(0xFF6B7280);

}
