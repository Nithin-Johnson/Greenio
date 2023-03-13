import 'package:flutter/material.dart';
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          const Text(
            'What you can do',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text('Let\'s make a better world'),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/Images/DonateImage.png',
                  width: 140,
                  height: 140,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.02,
                ),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ScreenDonate();
              }));
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
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.02,
                ),
                Image.asset(
                  'assets/Images/RecycleImage.png',
                  width: 140,
                  height: 140,
                ),
              ],
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const ScreenRecycle();
              }));
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.19,
          )
        ],
      ),
    );
  }
}
