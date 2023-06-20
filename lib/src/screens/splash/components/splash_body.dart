import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenio/src/utils/constants/assets_path.dart';

class SplashScreenBody {
  Widget splashScreenText({required String text, TextStyle? textStyle}) {
    return Text(
      text,
      style: textStyle ?? TextStyle(fontSize: 38, color: Colors.green[300]),
    );
  }

  TextStyle get splashTextStyle => GoogleFonts.sacramento(fontSize: 38, color: Colors.green[300]);

  Image get splashScreenLogoImage => Image.asset(appLogoImagePath, width: 200, height: 200);
}
