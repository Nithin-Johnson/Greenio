import 'package:flutter/material.dart';
import 'package:greenio/src/screens/donation/donation_screen.dart';
import 'package:greenio/src/screens/home/components/home_screen_components.dart';
import 'package:greenio/src/screens/home/components/signout_user.dart';
import 'package:greenio/src/screens/recycle/recycle_screen.dart';

import 'package:greenio/src/utils/constants/assets_path.dart';
import 'package:greenio/src/utils/navigation/navigation_utils.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeScreenComponents = HomeScreenComponents();

  _onSignOutButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            homeScreenComponents.alertDialogButton(
              buttonText: 'Cancel',
              backgroundColor: Colors.green,
              onPressed: _onCancelPressed(ctx),
            ),
            homeScreenComponents.alertDialogButton(
              buttonText: 'Logout',
              backgroundColor: Colors.red,
              onPressed: _onLogoutPressed(ctx),
            ),
          ],
        );
      },
    );
  }

  _onCancelPressed(ctx) => () {
        Navigator.of(ctx).pop();
      };

  _onLogoutPressed(ctx) => () {
        Navigator.of(ctx).pop();
        signOutUser(context);
      };

  _goToDonationScreen() {
    NavigationUtils.navigateTo(context, const DonationScreen());
  }

  _goToRecycleScreen() {
    NavigationUtils.navigateTo(context, const RecycleScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: _onSignOutButtonPressed,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [                
                const EmptySpace(heightFraction: 0.02,),
                homeScreenComponents.homeScreenHeading(),
                const EmptySpace(heightFraction: 0.01,),
                homeScreenComponents.homeScreenSubHeading(),
                const EmptySpace(heightFraction: 0.15,),
                homeScreenComponents.homeScreenButton(
                    onTap: _goToDonationScreen,
                    leadingImage: donationButtonImagePath,
                    buttonText: 'Donate',
                    trailingIcon: Icons.volunteer_activism_outlined),
                const EmptySpace(heightFraction: 0.1,),
                homeScreenComponents.homeScreenButton(
                  onTap: _goToRecycleScreen,
                  leadingImage: recyclerButtonImagePath,
                  buttonText: 'Recycle',
                  trailingIcon: Icons.recycling_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
