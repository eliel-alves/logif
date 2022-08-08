import 'package:flutter/material.dart';
import 'package:logif/theme/app_theme.dart';

ThemeData lightTheme = ThemeData(brightness: Brightness.light);

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppTheme.colors.darkBackground,
    scaffoldBackgroundColor: AppTheme.colors.darkBackground,
    appBarTheme: AppBarTheme(backgroundColor: AppTheme.colors.darkBlue));
