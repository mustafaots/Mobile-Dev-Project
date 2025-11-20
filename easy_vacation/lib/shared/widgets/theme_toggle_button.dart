import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/bloc/theme/theme_cubit.dart';
import 'package:easy_vacation/shared/themes.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ElevatedButton(
      onPressed: () {
        context.read<ThemeCubit>().toggleTheme();
      },
      child: Icon(
        Icons.brightness_6,
        color: isDark ? Colors.black : AppTheme.white,
      ),
    );
  }
}
