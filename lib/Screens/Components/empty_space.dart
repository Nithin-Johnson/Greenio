import 'package:flutter/material.dart';

Widget emptySpace(BuildContext context,
    {double heightMultiplier = 0, double widthMultiplier = 0}) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * heightMultiplier,
    width: MediaQuery.of(context).size.width * widthMultiplier,
  );
}
