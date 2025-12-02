import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = context.scaffoldBackgroundColor;
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.bookmark_border, color: backgroundColor, size: 24),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.share, color: backgroundColor, size: 24),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}
