import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';

class ThemedCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  
  const ThemedCard({
    super.key,
    required this.child,
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: AppTheme.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}