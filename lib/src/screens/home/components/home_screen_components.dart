import 'package:flutter/material.dart';

class HomeScreenComponents {
  Text homeScreenHeading() => const Text(
        'What you can do',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      );

  Text homeScreenSubHeading() => const Text(
        "Let's make a better world",
      );

  InkWell homeScreenButton({
    required Function() onTap,
    required String leadingImage,
    required String buttonText,
    required IconData trailingIcon,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green[300]!)
        ),
        child: ListTile(          
          leading: CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(leadingImage),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green[200]!, width: 2),
              ),
            ),
          ),
          title: Text(
            buttonText,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          trailing: Icon(trailingIcon, color: Colors.white),
        ),
      ),
    );
  }

  alertDialogButton({
    required String buttonText,
    required MaterialColor backgroundColor,
    required Function() onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: backgroundColor,
      ),
      child: Text(buttonText),
    );
  }
}
