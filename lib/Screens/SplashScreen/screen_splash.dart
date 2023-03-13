import 'package:flutter/material.dart';
import 'package:greenio/Screens/WelcomeScreen/screen_welcome.dart';

import '../Components/empty_space.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const ScreenWelcome();
      }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Images/SplashScreenLogo.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            emptySpace(context, heightMultiplier: 0.1),
            const Text(
              'GREENIO',
              style: TextStyle(
                color: Color.fromRGBO(52, 195, 88, 100),
                fontSize: 38,
              ),
            ),
            const Text('Green for Good',
                style: TextStyle(
                  fontFamily: 'Sacramento',
                  fontSize: 38,
                  color: Color.fromRGBO(52, 195, 88, 100),
                ))
          ],
        ),
      ),
    );
  }
}
