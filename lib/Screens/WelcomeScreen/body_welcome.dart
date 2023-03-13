import 'package:flutter/material.dart';
import 'package:greenio/Screens/Components/empty_space.dart';
import 'package:greenio/Screens/Components/full_width_bottom_button.dart';

import '../SignUpScreen/screen_signup.dart';

class BodyWelcome extends StatefulWidget {
  const BodyWelcome({super.key});

  @override
  State<BodyWelcome> createState() => _BodyWelcomeState();
}

class _BodyWelcomeState extends State<BodyWelcome> {
  void onButtonPressed() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const SignUpScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 30),
                      child: const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    emptySpace(context, heightMultiplier: 0.25),
                    const Text('Continue with'),
                    emptySpace(context, heightMultiplier: 0.01),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Facebook',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    emptySpace(context, heightMultiplier: 0.01),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Google',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    emptySpace(context, heightMultiplier: 0.3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Sign in'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            fullWidthBottomButton(
              buttonText: 'create an account',
              onPressed: onButtonPressed,
            )
          ],
        ),
      ),
    );
  }
}
