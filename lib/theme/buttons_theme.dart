import 'package:flutter/material.dart';
import 'package:logif/theme/app_theme.dart';

@immutable
class AppButtons {
  // Botão Primário
  final buttonPrimary = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(
      const EdgeInsets.symmetric(horizontal: 25.0, vertical: 17.0)
    ),
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          width: 1.0,
          style: BorderStyle.solid,
          color: AppTheme.colors.primaryBorder
        )
      )
    ),
    backgroundColor: MaterialStateProperty.all<Color>(AppTheme.colors.primary),
    textStyle: MaterialStateProperty.all<TextStyle>(
      const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500
      )
    )
  );

  final buttonSecondary = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(
      const EdgeInsets.symmetric(horizontal: 25.0, vertical: 17.0)
    ),
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          width: 1.0,
          style: BorderStyle.solid,
          color: AppTheme.colors.primary
        )
      )
    ),
    backgroundColor: MaterialStateProperty.all<Color>(AppTheme.colors.secondary),
    textStyle: MaterialStateProperty.all<TextStyle>(
      const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      )
    ),
  );

  final textButton = ButtonStyle(
    textStyle: MaterialStateProperty.all<TextStyle>(
      const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      )
    ),
  );

  AppButtons();
}