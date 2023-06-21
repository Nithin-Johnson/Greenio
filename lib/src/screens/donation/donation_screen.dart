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
  final firestoreService = FirestoreService();

  void _goToItemUploadScreen(String itemCategory) {
    NavigationUtils.navigateTo(context, ItemUploadScreen(itemCategory: itemCategory));
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = Provider.of<ConnectivityStatus>(context);
    if (connectivityStatus.isConnected) {
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
                  return DonationScreenComponents.profileNotCompleteWarning();
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const EmptySpace(heightFraction: 0.05),
                      DonationScreenComponents.heading(),
                      const EmptySpace(heightFraction: 0.1),
                      DonationScreenComponents.itemCategories(context, goToItemUploadScreen: _goToItemUploadScreen),
                      const EmptySpace(heightFraction: 0.2),
                      DonationScreenComponents.helpText(),
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
