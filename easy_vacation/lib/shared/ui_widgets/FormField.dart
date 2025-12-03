  import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';

Widget buildFormField( BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: textColor),
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: secondaryTextColor),
        prefixIcon: Icon(icon, color: secondaryTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: secondaryTextColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: secondaryTextColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: cardColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
    );
  }