import 'package:flutter/material.dart';

Widget fullWidthBottomButton({
  required String buttonText,
  required void Function() onPressed,
}) {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(80),
      backgroundColor: Colors.green,
    ),
    onPressed: onPressed,
    child: Text(
      buttonText.toUpperCase(),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,        
      ),
    ),
  );
}
