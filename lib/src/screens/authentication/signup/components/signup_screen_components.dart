import 'package:flutter/material.dart';
import 'package:greenio/src/screens/authentication/components/authentication_components.dart';
import 'package:greenio/src/screens/authentication/signup/components/signup_validators.dart';
import 'package:greenio/src/utils/widgets/custom_textform_field.dart';

class SignupScreenComponents {
  static Widget emailTextField(emailController) {
    return CustomTextFormFieldTile(
      controller: emailController,
      hintText: 'Email',
      prefixIcon: Icons.mail,
      validator: validateEmail,
      isEnabled: true,
    );
  }

  static Widget passwordTextField(passwordController) {
    return CustomTextFormFieldTile(
      controller: passwordController,
      hintText: 'Password',
      prefixIcon: Icons.password,
      isPassword: true,
      validator: validatePassword,
      isEnabled: true,
    );
  }

  static Widget rePasswordTextField(passwordController, rePasswordController) {
    return CustomTextFormFieldTile(
      controller: rePasswordController,
      hintText: 'Re-enter Password',
      prefixIcon: Icons.password,
      enableDoneAction: true,
      isPassword: true,
      isEnabled: true,
      validator: (value) {
        return validateRePassword.validateMatch(passwordController.text, value!);
      },
    );
  }

  static toggleButton(toggleScreen) {
    return AuthenticationComponents.toggleButton(
        onTap: toggleScreen, firstText: 'Already have an account?', secondText: 'Sign in');
  }
}
