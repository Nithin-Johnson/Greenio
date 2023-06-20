import 'package:flutter/material.dart';
import 'package:greenio/src/models/user/user_model.dart';
import 'package:greenio/src/screens/about/about_screen.dart';
import 'package:greenio/src/screens/admin/admin_screen.dart';
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

  _displayName(text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  _showButtons({required Widget nextScreen, required IconData prefixIcon, required String title}) {
    return InkWell(
      splashColor: Colors.green,
      onTap: () => NavigationUtils.navigateTo(context, nextScreen),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.green[200]!),
        ),
        elevation: 2,
        color: Colors.green[500],
        child: ListTile(
          leading: Icon(prefixIcon),
          title: Text(title),
          textColor: Colors.white,
          iconColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = Provider.of<ConnectivityStatus>(context);
    if (connectivityStatus.isConnected) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('More'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const EmptySpace(
                  heightFraction: 0.02
                ),
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
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.green,
                          backgroundImage: user.picture != null ? NetworkImage(user.picture!) : null,
                          child: user.picture == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                )
                              : null,
                        ),
                        _displayName(user.fullName ?? ''),
                        if (user.adminType == AdminType.ngo || user.adminType == AdminType.nss)
                          InkWell(
                            splashColor: Colors.green,
                            onTap: () => NavigationUtils.navigateTo(context, const AdminScreen()),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.green[200]!),
                                ),
                                color: Colors.red,
                                child: const ListTile(
                                  iconColor: Colors.white,
                                  textColor: Colors.white,
                                  leading: Icon(Icons.admin_panel_settings),
                                  title: Text('Administrator Panel'),
                                )),
                          ),
                      ],
                    );
                  },
                ),
                const Divider(thickness: 2),
                _showButtons(
                  nextScreen: const ProfileScreen(),
                  prefixIcon: Icons.account_box_outlined,
                  title: 'Profile',
                ),
                _showButtons(
                  nextScreen: const AboutScreen(),
                  prefixIcon: Icons.info_outline_rounded,
                  title: 'About',
                ),
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
