import 'package:flutter/material.dart';
import 'package:greenio/src/screens/authentication/components/auth_screen_text.dart';
import 'package:greenio/src/screens/authentication/login/components/login_user.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'package:greenio/src/utils/widgets/custom_button.dart';
import 'package:greenio/src/utils/widgets/custom_textform_field.dart';
import 'package:greenio/src/utils/widgets/snackbar_helper.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';
import 'package:greenio/src/screens/authentication/components/custom_auth_textbutton.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback toggleScreenToSignupScreen;
  const LoginScreen({Key? key, required this.toggleScreenToSignupScreen}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget get _emailTextField => CustomTextFormFieldTile(
        controller: _emailController,
        hintText: 'Email',
        prefixIcon: Icons.mail,
        isEnabled: true,
      );

  Widget get _passwordTextField => CustomTextFormFieldTile(
        controller: _passwordController,
        hintText: 'Password',
        prefixIcon: Icons.password,
        enableDoneAction: true,
        isPassword: true,
        isEnabled: true,
      );

  CustomAuthTextButton get _notAMemberRegister => CustomAuthTextButton(
        onTap: widget.toggleScreenToSignupScreen,
        firstText: 'Not a member?',
        secondText: 'Register now',
      );

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
        appBar: AppBar(title: const Text('Login'),),
        backgroundColor: Colors.green[50],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  authScreenText(text: 'Hello again!', fontSize: 50, isBold: true),
                  const EmptySpace(heightFraction: 0.01),
                  authScreenText(text: 'Welcome back, you have been missed!', fontSize: 20),
                  const EmptySpace(heightFraction: 0.03),
                  _emailTextField,
                  const EmptySpace(heightFraction: 0.001),
                  _passwordTextField,
                  const EmptySpace(heightFraction: 0.03),                    
                  CustomElevatedButton(text: 'Sign in', onPressed: _onLoginButtonPressed),
                  const EmptySpace(heightFraction: 0.02),
                  _notAMemberRegister,
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
