import 'package:flutter/material.dart';

class ProfileScreenComponents {
  static textButton(VoidCallback loadPicture, String text) {
    return TextButton(
      onPressed: loadPicture,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      child: Text(text),
    );
  }
}
