import 'package:flutter/material.dart';
import 'package:greenio/src/screens/splash/components/splash_screen_components.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SplashScreenComponents.splashTimer(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SplashScreenComponents.splashScreenLogoImage,
            Column(
              children: [
                SplashScreenComponents.splashScreenText(text: 'Greenio'),
                SplashScreenComponents.splashScreenText(
                    text: 'Green for Good', textStyle: SplashScreenComponents.splashTextStyle),
              ],
            )
          ],
        ),
      ),
    );
  }
}
