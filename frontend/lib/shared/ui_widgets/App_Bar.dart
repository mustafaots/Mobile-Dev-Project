import 'package:flutter/material.dart';

AppBar App_Bar(BuildContext context, String title) {
  final theme = Theme.of(context);
  final appBarTheme = theme.appBarTheme;
  final canPop = Navigator.canPop(context);
  
  return AppBar(
    leading: canPop
        ? IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: appBarTheme.foregroundColor ?? appBarTheme.iconTheme?.color,
            ),
            onPressed: () => Navigator.of(context).pop(),
          )
        : null,
    title: Text(
      title,
      style: TextStyle(
        color: appBarTheme.foregroundColor, // Use AppBar theme foreground color
        fontWeight: FontWeight.bold,
        fontSize: 23,
      ),
    ),
    backgroundColor: appBarTheme.backgroundColor, // Use AppBar theme background color
    elevation: appBarTheme.elevation ?? 0,
    iconTheme: appBarTheme.iconTheme ?? IconThemeData(color: appBarTheme.foregroundColor),
    actionsIconTheme: appBarTheme.actionsIconTheme ?? IconThemeData(color: appBarTheme.foregroundColor),
  );
}

