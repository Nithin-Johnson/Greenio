import 'package:flutter/material.dart';

import 'package:greenio/Screens/WelcomeScreen/body_welcome.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BodyWelcome(),
    );
  }
}
