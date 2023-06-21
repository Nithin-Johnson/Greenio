import 'package:flutter/material.dart';
import 'package:greenio/src/screens/authentication/login/login_screen.dart';
import 'package:greenio/src/screens/authentication/signup/signup_screen.dart';

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});
  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool showLoginScreen = true;

  void toggleScreen() {
    setState(() => showLoginScreen = !showLoginScreen);
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(toggleScreen: toggleScreen);
    } else {
      return SignUpScreen(toggleScreen: toggleScreen);
    }
  }
}
