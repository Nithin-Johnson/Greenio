import 'package:flutter/material.dart';
import 'package:greenio/Screens/SignUpScreen/UserInfoScreen/body_userinfo.dart';

class ScreenUserInfo extends StatelessWidget {
  const ScreenUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text('User Information'),
        centerTitle: true,
      ),
      body: const BodyUserInfo(),
      resizeToAvoidBottomInset: false,
    );
  }
}
