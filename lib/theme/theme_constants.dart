import 'package:flutter/material.dart';
import 'package:logif/theme/app_theme.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppTheme.colors.background,
  scaffoldBackgroundColor: AppTheme.colors.background,
  appBarTheme: AppBarTheme(
    backgroundColor: AppTheme.colors.darkBlue
  )
);

