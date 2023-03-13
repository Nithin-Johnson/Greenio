import 'package:flutter/material.dart';

import 'package:greenio/Screens/WelcomeScreen/body_welcome.dart';

class ScreenWelcome extends StatelessWidget {
  const ScreenWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BodyWelcome(),
      resizeToAvoidBottomInset: false,
    );
  }
}
