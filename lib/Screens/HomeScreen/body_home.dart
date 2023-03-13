import 'package:flutter/material.dart';
import 'package:greenio/Screens/Components/empty_space.dart';
import 'package:greenio/Screens/HomeScreen/DonateScreen/screen_donate.dart';
import 'package:greenio/Screens/HomeScreen/RecycleScreen/screen_recycle.dart';

class BodyHome extends StatelessWidget {
  const BodyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          emptySpace(context, heightMultiplier: 0.1),
          const Text(
            'What you can do',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text('Let\'s make a better world'),
          emptySpace(context, heightMultiplier: 0.15),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Images/DonateImage.png',
                  width: 140,
                  height: 140,
                ),
                emptySpace(context, widthMultiplier: 0.1),
                const Text(
                  'Donate',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const ScreenDonate();
                }),
              );
            },
          ),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Recycle',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                emptySpace(context, widthMultiplier: 0.1),
                Image.asset(
                  'assets/Images/RecycleImage.png',
                  width: 140,
                  height: 140,
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const ScreenRecycle();
                }),
              );
            },
          ),
          emptySpace(context, heightMultiplier: 0.19),
        ],
      ),
    );
  }
}
