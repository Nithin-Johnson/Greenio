import 'dart:async';
import 'package:flutter/material.dart';
import 'package:greenio/src/models/user/user_model.dart';
import 'package:greenio/src/screens/authentication/components/auth_screen_text.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/services/firestore_service.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'package:greenio/src/utils/widgets/custom_button.dart';
import 'package:greenio/src/utils/widgets/custom_textform_field.dart';
import 'package:greenio/src/utils/widgets/snackbar_helper.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';
import 'package:greenio/src/screens/authentication/components/custom_auth_textbutton.dart';
import 'package:greenio/src/screens/authentication/signup/components/signup_user.dart';
import 'package:greenio/src/screens/authentication/signup/components/signup_validators.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback toggleScreenToLoginScreen;

  const SignUpScreen({
    Key? key,
    required this.toggleScreenToLoginScreen,
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

  Widget get _emailTextField => CustomTextFormFieldTile(
        controller: _emailController,
        hintText: 'Email',
        prefixIcon: Icons.mail,
        validator: validateEmail,
        isEnabled: true,
      );

  Widget get _passwordTextField => CustomTextFormFieldTile(
        controller: _passwordController,
        hintText: 'Password',
        prefixIcon: Icons.password,
        isPassword: true,
        validator: validatePassword,
        isEnabled: true,
      );

  Widget get _rePasswordTextField => CustomTextFormFieldTile(
        controller: _rePasswordController,
        hintText: 'Re-enter Password',
        prefixIcon: Icons.password,
        enableDoneAction: true,
        isPassword: true,
        isEnabled: true,
        validator: (value) {
          return validateRePassword.validateMatch(_passwordController.text, value!);
        },
      );

  CustomAuthTextButton _switchToLoginScreenButton() {
    return CustomAuthTextButton(
      onTap: widget.toggleScreenToLoginScreen,
      firstText: 'Already have an account?',
      secondText: 'Sign in',
    );
  }

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
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    authScreenText(text: 'Hello there!', fontSize: 50, isBold: true),
                    const EmptySpace(heightFraction: 0.01),
                    authScreenText(text: 'Register below with your details', fontSize: 20),
                    const EmptySpace(heightFraction: 0.03),
                    _emailTextField,
                    const EmptySpace(heightFraction: 0.001),
                    _passwordTextField,
                    const EmptySpace(heightFraction: 0.001),
                    _rePasswordTextField,
                    const EmptySpace(heightFraction: 0.03),
                    CustomElevatedButton(text: 'Sign Up', onPressed: _onSignUpButtonPressed),
                    const EmptySpace(heightFraction: 0.02),
                    _switchToLoginScreenButton(),
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
