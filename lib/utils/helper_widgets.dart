import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget addVerticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

Widget addHorizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}

Widget addSpace() {
  return const Spacer();
}

class Utils {
  static String dateConverter(Timestamp time) {
    DateTime date = time.toDate();
    final formatter = DateFormat('dd/MM/yyyy');
    String dateFormatted = formatter.format(date);

    return dateFormatted;
  }
}
