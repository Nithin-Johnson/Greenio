import 'dart:async';

import 'package:flutter/material.dart';
import 'package:greenio/src/navigation/navigation_bar.dart';
import 'package:greenio/src/services/firebase_service.dart';
import 'package:greenio/src/utils/widgets/custom_button.dart';
import 'package:greenio/src/utils/widgets/snackbar_helper.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  bool _isEmailVerified = false;
  bool _canResendEmail = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _isEmailVerified = _firebaseAuthService.currentUser!.emailVerified;
    if (!_isEmailVerified) {
      _sendVerificationEmail();
      _timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => _checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  Future<void> _sendVerificationEmail() async {
    try {
      final user = _firebaseAuthService.currentUser!;
      await user.sendEmailVerification();
      setState(() => _canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => _canResendEmail = true);
    } on Exception catch (e) {
      SnackBarHelper.showSnackBar(context, e.toString());
    }
  }

  Future _checkEmailVerified() async {
    await _firebaseAuthService.currentUser!.reload();
    setState(() {
      _isEmailVerified = _firebaseAuthService.currentUser!.emailVerified;
    });
    if (_isEmailVerified) {
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isEmailVerified
        ? const Navigation()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Verify your email'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.email,
                    size: 80,
                    color: Colors.green,
                  ),
                  const EmptySpace(heightFraction: 0.03,),
                  const Text(
                    'A verification email has been sent to your email address.\n\n Please check your email address.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const EmptySpace(heightFraction: 0.03,),
                  CustomElevatedButton(
                    text: 'Resend Email',
                    onPressed: _canResendEmail ? _sendVerificationEmail : (){},
                  ),
                ],
              ),
            ),
          );
  }
}
