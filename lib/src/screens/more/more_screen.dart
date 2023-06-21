import 'package:flutter/material.dart';
import 'package:greenio/src/models/user/user_model.dart';
import 'package:greenio/src/screens/about/about_screen.dart';
import 'package:greenio/src/screens/admin/admin_screen.dart';
import 'package:greenio/src/screens/more/components/more_screen_components.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/screens/profile/profile_screen.dart';
import 'package:greenio/src/services/firestore_service.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'package:greenio/src/utils/navigation/navigation_utils.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final _firestoreService = FirestoreService();

  _showAdminButton() {
    return MoreScreenComponents.showButton(
      onTap: () => NavigationUtils.navigateTo(context, const AdminScreen()),
      prefixIcon: Icons.admin_panel_settings,
      title: 'Administrator Panel',
      color: Colors.red,
    );
  }

  _showProfileButton() {
    return MoreScreenComponents.showButton(
      onTap: () => NavigationUtils.navigateTo(context, const ProfileScreen()),
      prefixIcon: Icons.account_box_outlined,
      title: 'Profile',
      color: Colors.green[500]!,
    );
  }

  _showAboutButton() {
    return MoreScreenComponents.showButton(
      onTap: () => NavigationUtils.navigateTo(context, const AboutScreen()),
      prefixIcon: Icons.info_outline_rounded,
      title: 'About',
      color: Colors.green[500]!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = Provider.of<ConnectivityStatus>(context);
    if (connectivityStatus.isConnected) {
      return Scaffold(
        appBar: AppBar(title: const Text('More')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const EmptySpace(heightFraction: 0.02),
                StreamBuilder(
                  stream: _firestoreService.getUserStreamDocSnapshot(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final userDoc = snapshot.data!.data() as Map<String, dynamic>;
                    final user = UserModel.fromMap(userDoc);
                    return Column(
                      children: [
                        MoreScreenComponents.displayProfilePicture(user),
                        MoreScreenComponents.displayName(user.fullName ?? ''),
                        if (user.adminType == AdminType.ngo || user.adminType == AdminType.govt) _showAdminButton(),
                      ],
                    );
                  },
                ),
                const Divider(thickness: 2),
                _showProfileButton(),
                _showAboutButton(),
              ],
            ),
          ),
        ),
      );
    } else {
      return const NoInternetScreen();
    }
  }
}
