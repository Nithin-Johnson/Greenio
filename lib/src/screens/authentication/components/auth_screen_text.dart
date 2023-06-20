
import 'package:flutter/material.dart';

Text authScreenText({
  required String text,
  required double fontSize,
  bool isBold = false,  
}) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : null,
    ),
  );
}
