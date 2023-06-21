import 'package:flutter/material.dart';
import 'package:greenio/src/screens/authentication/components/authentication_components.dart';
import 'package:greenio/src/utils/widgets/custom_textform_field.dart';

class LoginScreenComponents {
  static Widget emailTextField(emailController) {
    return CustomTextFormFieldTile(
      controller: emailController,
      hintText: 'Email',
      prefixIcon: Icons.mail,
      isEnabled: true,
    );
  }

  static Widget passwordTextField(passwordController) {
    return CustomTextFormFieldTile(
      controller: passwordController,
      hintText: 'Password',
      prefixIcon: Icons.password,
      enableDoneAction: true,
      isPassword: true,
      isEnabled: true,
    );
  }

  static toggleButton(toggleScreen) {
    return AuthenticationComponents.toggleButton(
        onTap: toggleScreen, firstText: 'Not a member?', secondText: 'Register now');
  }
}
