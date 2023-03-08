import 'package:flutter/material.dart';
import 'package:greenio/Screens/HomeScreen/DonateScreen/body_donate.dart';

class ScreenDonate extends StatelessWidget {
  const ScreenDonate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DONATE'),
        centerTitle: true,
      ),
      body: const BodyDonate(),
    );
  }
}
