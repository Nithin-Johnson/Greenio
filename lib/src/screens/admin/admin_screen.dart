import 'package:flutter/material.dart';
import 'package:greenio/src/models/user/user_model.dart';
import 'package:greenio/src/screens/admin/screens/date_assign/date_assign_screen.dart';
import 'package:greenio/src/screens/admin/screens/selected_date/selected_date_screen.dart';
import 'package:greenio/src/screens/admin/screens/ward_list/ward_list_screen.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/services/firestore_service.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'package:greenio/src/utils/navigation/navigation_utils.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _firestoreService = FirestoreService();

  void _goToWardList() {
    NavigationUtils.navigateTo(context, const WardListScreen());
  }

  void _goToDateAssign() {
    NavigationUtils.navigateTo(context, const DateAssignScreen());
  }

  void _goToSelectedDate() {
    NavigationUtils.navigateTo(context, const SelectedDateScreen());
  }

  InkWell _customButton({
    required String buttonText,
    required IconData trailingIcon,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.white,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(
            buttonText,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          leading: Icon(trailingIcon, color: Colors.white),
        ),
      ),
    );
  }

  _showNotes(String text) {
    return ListTile(
      leading: const Icon(Icons.info),
      subtitle: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = Provider.of<ConnectivityStatus>(context);
    if (connectivityStatus.isConnected) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Control Panel'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: StreamBuilder(
              stream: _firestoreService.getUserStreamDocSnapshot(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final userDoc = snapshot.data!.data() as Map<String, dynamic>;
                final user = UserModel.fromMap(userDoc);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (user.adminType == AdminType.ngo)
                      Column(
                        children: [
                          _customButton(
                              buttonText: 'Check Pending Donations List',
                              trailingIcon: Icons.list,
                              onTap: () {
                                _goToWardList();
                              }),
                          const EmptySpace(
                            heightFraction: 0.1,
                          ),
                          _showNotes('You can check the list of wards for which there is a pending donation.')
                        ],
                      ),
                    if (user.adminType == AdminType.nss)
                      Column(
                        children: [
                          const EmptySpace(heightFraction: 0.1),
                          _customButton(
                              buttonText: 'Assign Collection Dates',
                              trailingIcon: Icons.date_range_outlined,
                              onTap: () => _goToDateAssign()),
                          const EmptySpace(heightFraction: 0.01),
                          _showNotes('You can assign specific collection dates for each ward to schedule garbage collection.'),
                          const EmptySpace(heightFraction: 0.1),
                          _customButton(
                              buttonText: 'View Selected Dates',
                              trailingIcon: Icons.date_range,
                              onTap: () => _goToSelectedDate()),
                          const EmptySpace(heightFraction: 0.01),
                          _showNotes(
                              'You can view the dates selected by each household within each ward for garbage collection.'),
                        ],
                      ),
                  ],
                );
              }),
        ),
      );
    } else {
      return const NoInternetScreen();
    }
  }
}
