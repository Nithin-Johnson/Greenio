import 'package:flutter/material.dart';
import 'package:greenio/src/screens/authentication/components/authentication_components.dart';
import 'package:greenio/src/screens/authentication/login/components/login_screen_components.dart';
import 'package:greenio/src/screens/authentication/login/components/login_user.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'package:greenio/src/utils/widgets/custom_button.dart';
import 'package:greenio/src/utils/widgets/snackbar_helper.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback toggleScreen;
  const LoginScreen({Key? key, required this.toggleScreen}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _onLoginButtonPressed() async {
    _showLoading();
    await LoginUser.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      onSuccess: onLoginSuccess,
      onFailure: onLoginFailure,
    );
  }

  void _showLoading() {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void onLoginSuccess() {
    Navigator.of(context).pop();
  }

  void onLoginFailure(String message) {
    Navigator.of(context).pop();
    SnackBarHelper.showSnackBar(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = Provider.of<ConnectivityStatus>(context);
    if (connectivityStatus.isConnected) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        backgroundColor: Colors.green[50],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AuthenticationComponents.heading(text: 'Hello again!', fontSize: 50, isBold: true),
                  const EmptySpace(heightFraction: 0.01),
                  AuthenticationComponents.heading(text: 'Welcome back, you have been missed!', fontSize: 20),
                  const EmptySpace(heightFraction: 0.03),
                  LoginScreenComponents.emailTextField(_emailController),
                  const EmptySpace(heightFraction: 0.001),
                  LoginScreenComponents.passwordTextField(_passwordController),
                  const EmptySpace(heightFraction: 0.03),
                  CustomElevatedButton(text: 'Sign in', onPressed: _onLoginButtonPressed),
                  const EmptySpace(heightFraction: 0.02),
                  LoginScreenComponents.toggleButton(widget.toggleScreen),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return const NoInternetScreen();
    }
  }
}
