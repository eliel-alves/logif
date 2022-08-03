import 'package:logif/theme/buttons_theme.dart';
import 'package:logif/theme/colors_theme.dart';
import 'package:logif/theme/typography_theme.dart';
import 'package:flutter/material.dart';

@immutable
class AppTheme {
  static const colors = AppColors();
  static AppTypo typo = AppTypo();
  static AppButtons buttons = AppButtons();

  const AppTheme._();

  static ThemeData define() {
    return ThemeData(
      fontFamily: "Inter",
    );
  }
}