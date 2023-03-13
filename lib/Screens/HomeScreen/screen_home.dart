import 'package:flutter/material.dart';
import 'package:greenio/Screens/HomeScreen/body_home.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: BodyHome(),
    );
  }
}
