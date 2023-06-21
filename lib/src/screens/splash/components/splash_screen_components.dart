import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenio/src/screens/wrappers/main_wrapper.dart';
import 'package:greenio/src/utils/constants/assets_path.dart';
import 'package:greenio/src/utils/navigation/navigation_utils.dart';

// class SplashScreenBody {
//   static Widget splashScreenText({required String text, TextStyle? textStyle}) {
//     return Text(
//       text,
//       style: textStyle ?? TextStyle(fontSize: 38, color: Colors.green[300]),
//     );
//   }

//   TextStyle get splashTextStyle => GoogleFonts.sacramento(fontSize: 38, color: Colors.green[300]);

//   Image get splashScreenLogoImage => Image.asset(appLogoImagePath, width: 200, height: 200);
// }

class SplashScreenComponents {
  static TextStyle get splashTextStyle => GoogleFonts.sacramento(fontSize: 38, color: Colors.green[300]);
  static Image get splashScreenLogoImage => Image.asset(appLogoImagePath, width: 200, height: 200);

  static Widget splashScreenText({required String text, TextStyle? textStyle}) {
    return Text(
      text,
      style: textStyle ?? TextStyle(fontSize: 38, color: Colors.green[300]),
    );
  }

  static Timer splashTimer(BuildContext context) {
    return Timer(const Duration(seconds: 3), () {
      NavigationUtils.replaceWith(context, const MainWrapper());
    });
  }
}
