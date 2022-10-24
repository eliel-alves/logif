import 'package:flutter/material.dart';

import 'package:logif/theme/app_theme.dart';

@immutable
class AppTypo {
  // Texto para Títulos
  final title = const TextStyle(
      fontFamily: 'Syne', fontSize: 20, fontWeight: FontWeight.w700);

  // Texto do Quiz
  final quizTitle = const TextStyle(
      fontFamily: 'Syne', fontSize: 24, fontWeight: FontWeight.w700);

  // Texto para Subtítulos
  final subtitle = const TextStyle(
      fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600);

  final lightIconText = TextStyle(
      fontFamily: 'Inter',
      color: AppTheme.colors.dark,
      fontSize: 16,
      fontWeight: FontWeight.w500);

  final normal = const TextStyle(
      fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w400);

  final normalBold = const TextStyle(
      fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold);

  final littleText = TextStyle(
      fontFamily: 'Inter',
      color: AppTheme.colors.lightGrey,
      fontSize: 12,
      fontWeight: FontWeight.w400);

  final badgeText = TextStyle(
      fontFamily: 'Inter',
      color: AppTheme.colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 1);

  // Texto Barra Lateral
  final sidebarMenuItem = TextStyle(
      fontFamily: 'Syne',
      color: AppTheme.colors.light,
      fontSize: 14,
      fontWeight: FontWeight.w600);

  final scaffoldTitle = TextStyle(
      fontFamily: 'Syne',
      color: AppTheme.colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w700);

  AppTypo();
}
