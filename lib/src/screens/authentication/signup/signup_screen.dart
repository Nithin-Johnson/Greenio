import 'dart:async';
import 'package:flutter/material.dart';
import 'package:greenio/src/models/user/user_model.dart';
import 'package:greenio/src/screens/authentication/components/authentication_components.dart';
import 'package:greenio/src/screens/authentication/signup/components/signup_screen_components.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/services/firestore_service.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'package:greenio/src/utils/widgets/custom_button.dart';
import 'package:greenio/src/utils/widgets/snackbar_helper.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';
import 'package:greenio/src/screens/authentication/signup/components/signup_user.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback toggleScreen;

  const SignUpScreen({
    Key? key,
    required this.toggleScreen,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _onSignUpButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _showLoading();
      await SignupUser.registerWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        onSuccess: onSignUpSuccess,
        onFailure: onSignUpFailure,
      );
      UserModel user = UserModel(emailAddress: _emailController.text.trim());
      _firestoreService.addUserDocToDatabase(user);
    }
  }

  void _showLoading() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void onSignUpSuccess() {
    Navigator.of(context).pop();
  }

  void onSignUpFailure(String message) {
    SnackBarHelper.showSnackBar(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = Provider.of<ConnectivityStatus>(context);
    if (connectivityStatus.isConnected) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Sign up'),
        ),
        backgroundColor: Colors.green[50],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    AuthenticationComponents.heading(text: 'Hello there!', fontSize: 50, isBold: true),
                    const EmptySpace(heightFraction: 0.01),
                    AuthenticationComponents.heading(text: 'Register below with your details', fontSize: 20),
                    const EmptySpace(heightFraction: 0.03),
                    SignupScreenComponents.emailTextField(_emailController),
                    const EmptySpace(heightFraction: 0.001),
                    SignupScreenComponents.passwordTextField(_passwordController),
                    const EmptySpace(heightFraction: 0.001),
                    SignupScreenComponents.rePasswordTextField(_passwordController, _rePasswordController),
                    const EmptySpace(heightFraction: 0.03),
                    CustomElevatedButton(text: 'Sign Up', onPressed: _onSignUpButtonPressed),
                    const EmptySpace(heightFraction: 0.02),
                    SignupScreenComponents.toggleButton(widget.toggleScreen),
                  ],
                ),
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
