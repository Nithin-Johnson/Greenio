import 'package:flutter/material.dart';

BottomNavigationBarItem bottomNavigationBarItem({
  required IconData iconData,
  required IconData activeIconData,
  required String label,
}) {
  return BottomNavigationBarItem(
    icon: Icon(iconData),
    label: label,
    activeIcon: Icon(activeIconData),
    tooltip: label,
  );
}
