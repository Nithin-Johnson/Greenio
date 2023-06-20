import 'dart:async';
import 'package:flutter/material.dart';
import 'package:greenio/src/screens/wrappers/main_wrapper.dart';
import 'package:greenio/src/utils/navigation/navigation_utils.dart';


Timer splashTimer(BuildContext context) {

  return Timer(const Duration(seconds: 3), () {
    NavigationUtils.replaceWith(context, const MainWrapper());
  });
}
