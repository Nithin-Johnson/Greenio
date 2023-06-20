import 'package:flutter/material.dart';

class NavigationUtils {
  NavigationUtils._();

  static void navigateTo(BuildContext context, Widget nextScreen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  static void replaceWith(BuildContext context, Widget nextScreen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  static void navigateAndRemoveUntil(BuildContext context, Widget nextScreen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
      (Route<dynamic> route) => false,
    );
  }
}
