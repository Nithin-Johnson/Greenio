import 'package:flutter/material.dart';
import 'package:greenio/src/utils/constants/assets_path.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';


class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(confirmationScreenImagePath),
              const EmptySpace(heightFraction: 0.1,),              
              const Text(
                'Confirmed!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const EmptySpace(heightFraction: 0.01,),
              const Text('We will be in touch with you shortly.')
            ],
          ),
        ),
      ),
    );
  }
}
