import 'package:flutter/material.dart';

class AuthenticationComponents {
  static Text heading({
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

  static Row toggleButton({
    required onTap,
    required firstText,
    required secondText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(firstText),
        const SizedBox(width: 3),
        GestureDetector(
          onTap: onTap,
          child: Text(
            secondText,
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
