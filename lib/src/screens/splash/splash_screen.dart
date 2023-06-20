import 'package:flutter/material.dart';
import 'package:greenio/src/screens/splash/components/splash_body.dart';
import 'package:greenio/src/screens/splash/components/splash_timer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashScreenBody = SplashScreenBody();

  @override
  void initState() {
    splashTimer(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            splashScreenBody.splashScreenLogoImage,
            Column(
              children: [
                splashScreenBody.splashScreenText(text: 'Greenio'),
                splashScreenBody.splashScreenText(
                  text: 'Green for Good',
                  textStyle: splashScreenBody.splashTextStyle,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
