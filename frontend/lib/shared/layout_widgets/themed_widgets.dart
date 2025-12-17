import 'package:flutter/material.dart';
import 'package:easy_vacation/shared/themes.dart';

class ThemedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const ThemedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  // Common text styles
  static const TextStyle heading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppTheme.black,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppTheme.grey,
  );

  static const TextStyle bodyBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppTheme.black,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppTheme.grey,
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}

class ThemedIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final BoxDecoration? decoration;

  const ThemedIcon(
    this.icon, {
    super.key,
    this.size = 20,
    this.color,
    this.decoration,
  });

  // Common styles
  static BoxDecoration circleDecoration({Color? backgroundColor}) {
    return BoxDecoration(
      color: backgroundColor ?? AppTheme.lightGrey,
      shape: BoxShape.circle,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Icon(
      icon,
      size: size,
      color: color ?? AppTheme.grey,
    );

    if (decoration != null) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: decoration,
        child: iconWidget,
      );
    }

    return iconWidget;
  }
}