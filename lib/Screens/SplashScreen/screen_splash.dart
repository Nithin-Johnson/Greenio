import 'package:flutter/material.dart';
import 'package:greenio/Screens/WelcomeScreen/screen_welcome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const WelcomeScreen();
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
              width: 200, // set the width of the image
              height: 200, // set the height of the image
              fit: BoxFit.contain, // set the fit of the image
            ),
            const SizedBox(
              height: 70,
            ),
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
