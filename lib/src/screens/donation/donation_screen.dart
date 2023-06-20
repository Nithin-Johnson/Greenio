import 'package:flutter/material.dart';
import 'package:greenio/src/models/user/user_model.dart';
import 'package:greenio/src/screens/donation/components/donation_screen_components.dart';
import 'package:greenio/src/screens/item_upload/item_upload_screen.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/services/firestore_service.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'package:greenio/src/utils/navigation/navigation_utils.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';
import 'package:provider/provider.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({Key? key}) : super(key: key);

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final donationScreenComponents = DonationScreenComponents();
  final firestoreService = FirestoreService();

  void _moveToItemDetailsScreen(String itemCategory) {
    NavigationUtils.navigateTo(context, ItemUploadScreen(itemCategory: itemCategory));
  }

  Widget _showProfileNotCompleteWarning() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.warning, size: 60),
        Text(
          'Your profile is not complete! Please update your profile and try again.\nGo to More -> Profile',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = Provider.of<ConnectivityStatus>(context);
    if (connectivityStatus.isConnected) {
      final Size size = MediaQuery.of(context).size;
      return Scaffold(
        appBar: AppBar(title: const Text('Donate')),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: StreamBuilder(
              stream: firestoreService.getUserStreamDocSnapshot(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final user = snapshot.data!.data() as Map<String, dynamic>;
                final userData = UserModel.fromMap(user);
                if (!userData.isProfileComplete) {
                  return _showProfileNotCompleteWarning();
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const EmptySpace(heightFraction: 0.05),
                      donationScreenComponents.donationScreenHeading(),
                      const EmptySpace(heightFraction: 0.1),
                      donationScreenComponents.donationScreenItemCategories(context,
                          size: size, moveToItemDetailsScreen: _moveToItemDetailsScreen),
                      donationScreenComponents.donationScreenHelpText(),
                    ],
                  ),
                );
              }),
        ),
      );
    } else {
      return const NoInternetScreen();
    }
  }
}
