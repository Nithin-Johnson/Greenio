import 'package:flutter/material.dart';

ThemeData defaultLightTheme() {
  return ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.green,
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: Colors.green,
      selectedItemColor: Colors.green[50],
      unselectedItemColor: Colors.green[200],
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: MaterialStateColor.resolveWith(
        (states) => states.contains(MaterialState.focused) ? Colors.green : Colors.grey,
      ),
    ),
  );
}
