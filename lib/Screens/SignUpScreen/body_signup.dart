import 'package:flutter/material.dart';
import 'package:greenio/Screens/Components/empty_space.dart';
import 'package:greenio/Screens/Components/full_width_bottom_button.dart';
import 'package:greenio/Screens/SignUpScreen/UserInfoScreen/screen_userinfo.dart';

class BodySignUp extends StatefulWidget {
  const BodySignUp({super.key});

  @override
  State<BodySignUp> createState() => _BodySignUpState();
}

class _BodySignUpState extends State<BodySignUp> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  bool _passwordMatch = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  void _validatePasswordMatch() {
    setState(() {
      _passwordMatch = _passwordController.text == _rePasswordController.text;
    });
  }

  void onButtonPressed() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return const ScreenUserInfo();
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    emptySpace(context, heightMultiplier: 0.05),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        hintText: 'Enter a username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    emptySpace(context, heightMultiplier: 0.02),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    emptySpace(context, heightMultiplier: 0.02),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(),
                      ),
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (!_passwordMatch) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    emptySpace(context, heightMultiplier: 0.02),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Re-enter password',
                        hintText: 'Re-enter your password',
                        border: const OutlineInputBorder(),
                        suffixIcon: _passwordMatch
                            ? const Icon(
                                Icons.check,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                      ),
                      controller: _rePasswordController,
                      obscureText: true,
                      onChanged: (value) => _validatePasswordMatch(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please re-enter your password';
                        }
                        if (!_passwordMatch) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    emptySpace(context, heightMultiplier: 0.2),
                    Row(
                      children: [
                        const Text(
                          'Remember me',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        const Spacer(),
                        Switch(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                    emptySpace(context, heightMultiplier: 0.02),
                    const Text(
                      'By creating your account confirm that you agree with our',
                      textAlign: TextAlign.center,
                    ),
                    InkWell(
                      child: const Text(
                        'Terms and Conditions',
                      ),
                      onTap: () {
                        //_showTermsDialog();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        fullWidthBottomButton(
          buttonText: 'next',
          onPressed: onButtonPressed,
        )
      ],
    );
  }
}
