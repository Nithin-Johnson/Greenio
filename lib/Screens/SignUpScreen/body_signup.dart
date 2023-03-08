import 'package:flutter/material.dart';

class BodySignUp extends StatefulWidget {
  const BodySignUp({super.key});

  @override
  State<BodySignUp> createState() => _BodySignUpState();
}

class _BodySignUpState extends State<BodySignUp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Center(
          child: Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(80),
              backgroundColor: Colors.green),
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return const SignUpScreen();
            // }));
          },
          child: const Text(
            'Next',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
