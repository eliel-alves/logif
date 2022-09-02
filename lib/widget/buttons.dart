import 'package:flutter/material.dart';
import 'package:logif/theme/app_theme.dart';

Widget primaryFullButton(String text, Function() onPressed) {
  return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(17),
            side: BorderSide(
                width: 1.0,
                style: BorderStyle.solid,
                color: AppTheme.colors.purple),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
        child: Text(text,
            style: TextStyle(
                color: AppTheme.colors.purple,
                fontSize: 16.0,
                fontWeight: FontWeight.w500)),
        onPressed: onPressed,
      ));
}
