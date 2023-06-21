import 'package:flutter/material.dart';
import 'package:greenio/src/screens/authentication/verification/verification_screen.dart';
import 'package:greenio/src/services/firebase_service.dart';
import 'package:greenio/src/screens/wrappers/auth_wrapper.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});
  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final FirebaseAuthService _firebaseAuthentication = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firebaseAuthentication.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const VerificationScreen();          
        } else {
          return const AuthenticationWrapper();
        }
      },
    );
  }
}
