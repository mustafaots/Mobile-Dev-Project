import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';

/// A customized CircularProgressIndicator that uses the app's primary color
/// with a thicker, rounded stroke.
class AppProgressIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;

  const AppProgressIndicator({
    super.key,
    this.size = 40,
    this.strokeWidth = 10,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        strokeCap: StrokeCap.round,
        color: color ?? AppTheme.primaryColor,
        backgroundColor: (color ?? AppTheme.primaryColor).withOpacity(0.2),
      ),
    );
  }
}
