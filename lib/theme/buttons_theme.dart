import 'package:flutter/material.dart';
import 'package:logif/theme/app_theme.dart';

@immutable
class AppButtons {
  // Botão Primário
  final buttonPrimary = ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 25.0, vertical: 17.0)),
      shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
              width: 1.0,
              style: BorderStyle.solid,
              color: AppTheme.colors.darkPurple))),
      backgroundColor: MaterialStateProperty.all<Color>(AppTheme.colors.purple),
      textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)));

  // Botao Secundario
  final buttonSecondary = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(horizontal: 25.0, vertical: 17.0)),
    shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
            width: 1.0,
            style: BorderStyle.solid,
            color: AppTheme.colors.purple))),
    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    )),
  );

  // Botao em texto Tela de Login
  final textButton = ButtonStyle(
    textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    )),
  );

  // Botao "Ver Mais" dos cards
  final cardButton = ButtonStyle(
      elevation: MaterialStateProperty.all<double>(0),
      padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 15.0, vertical: 13.0)),
      shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
      backgroundColor: MaterialStateProperty.all<Color>(
          AppTheme.colors.darkBackgroundVariation),
      textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)));

  final navigationButton = ButtonStyle(
      elevation: MaterialStateProperty.all<double>(0),
      padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 50.0, vertical: 13.0)),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
      textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)));

  AppButtons();
}
