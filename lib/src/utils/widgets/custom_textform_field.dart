import 'package:flutter/material.dart';

class CustomTextFormFieldTile extends StatelessWidget {
  final TextEditingController controller;
  final bool isEnabled;
  final bool enableDoneAction;
  final bool isPassword;
  final String? hintText;
  final String? Function(String?)? validator;
  final IconData prefixIcon;
  final TextInputType? keyboardType;

  const CustomTextFormFieldTile({
    super.key,
    required this.controller,
    required this.isEnabled,
    this.enableDoneAction = false,
    this.isPassword = false,
    this.hintText,
    this.validator,
    required this.prefixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(        
        focusColor: Colors.green,
        border: InputBorder.none,
        hintText: hintText,
        errorMaxLines: 2,
      );

    return Card(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.green[300]!)),
      elevation: 2,
      color: Colors.green[100],
      child: ListTile(
        leading: Icon(prefixIcon),
        title: TextFormField(
          controller: controller,
          enabled: isEnabled,
          keyboardType: keyboardType,
          textInputAction: enableDoneAction ? TextInputAction.done : TextInputAction.next,
          obscureText: isPassword,
          enableSuggestions: !isPassword,
          validator: validator,
          decoration: inputDecoration,
        ),
      ),
    );
  }
}
