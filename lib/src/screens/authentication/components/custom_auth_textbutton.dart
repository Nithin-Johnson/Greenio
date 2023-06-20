import 'package:flutter/material.dart';

class CustomAuthTextButton extends StatelessWidget {
  const CustomAuthTextButton({
    super.key,
    required this.onTap,
    required this.firstText,
    required this.secondText,
  });

  final String firstText;
  final String secondText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(firstText),
        const SizedBox(width: 1),
        GestureDetector(
          onTap: onTap,
          child: Text(
            secondText,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
