import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/bloc/theme/theme_cubit.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, themeData) {
        final themeCubit = context.read<ThemeCubit>();
        final isDark = themeCubit.isDarkTheme; // Use cubit's state

        return GestureDetector(
          onTap: () {
            themeCubit.toggleTheme();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 70,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isDark ? Colors.grey[800] : Colors.grey[300],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Sun and Moon Icons in the background
                Positioned(
                  left: 8,
                  top: 7.5,
                  child: Icon(
                    Icons.wb_sunny,
                    color: isDark ? Colors.grey[500] : Colors.orange,
                    size: 20,
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 7.5,
                  child: Icon(
                    Icons.nightlight_round,
                    color: isDark ? Colors.blue : Colors.grey[500],
                    size: 20,
                  ),
                ),
                
                // Toggle knob
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: isDark ? 35 : 5,
                  top: 2.5,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.blue : Colors.orange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isDark ? Icons.nightlight_round : Icons.wb_sunny,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}