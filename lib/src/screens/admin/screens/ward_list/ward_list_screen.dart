import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenio/src/models/user/user_model.dart';
import 'package:greenio/src/screens/admin/screens/donation_list/donation_list_screen.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/services/firestore_service.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'package:greenio/src/utils/navigation/navigation_utils.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';
import 'package:provider/provider.dart';

class WardListScreen extends StatefulWidget {
  const WardListScreen({Key? key}) : super(key: key);

  @override
  State<WardListScreen> createState() => _WardListScreenState();
}

class _WardListScreenState extends State<WardListScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _refreshScreen() async {
    setState(() {});
  }

  Stream<List<String>> _getFilteredWardNumbers() {
    return _firestoreService.getUsersQuerySnapshot().asyncMap((snapshot) async {
      final filteredWardNumbers = <String>{};
      for (final userDoc in snapshot.docs) {
        final UserModel user = UserModel.fromMap(userDoc.data());
        final wardNumber = user.wardNumber ?? '';
        final items = await getCollectedItems(userDoc.id);
        if (items.docs.isNotEmpty) filteredWardNumbers.add(wardNumber);
      }
      return filteredWardNumbers.toList()..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    });
  }

  Stream<List<String>> _getFilteredHouseNumbers(String wardNumber) {
    return _firestoreService.getUsersQuerySnapshot().asyncMap((snapshot) async {
      final filteredHouseNumbers = <String>{};
      for (final userDoc in snapshot.docs) {
        final UserModel user = UserModel.fromMap(userDoc.data());
        final houseNumber = user.houseNumber ?? '';
        final itemsQuerySnapshot = await getCollectedItems(userDoc.id);
        if (itemsQuerySnapshot.docs.isNotEmpty && user.wardNumber == wardNumber) filteredHouseNumbers.add(houseNumber);
      }
      return filteredHouseNumbers.toList()..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCollectedItems(userID) async {
    final querySnapshot = await _firestoreService.userCollectionRef
        .doc(userID)
        .collection('Items')
        .where('isCollected', isEqualTo: false)
        .get();
    return querySnapshot;
  }

  Widget _buildExpansionTile(String wardNumber) {
    return StreamBuilder<List<String>>(
      stream: _getFilteredHouseNumbers(wardNumber),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const EmptySpace();
        }
        final filteredHouseNumbers = snapshot.data ?? [];
        return Card(
          color: Colors.green[400],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            title: Text(
              'Ward Number: $wardNumber',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            iconColor: Colors.white,
            textColor: Colors.white,
            collapsedIconColor: Colors.white,
            collapsedTextColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: filteredHouseNumbers.length,
                itemBuilder: (context, index) {
                  final houseNumber = filteredHouseNumbers[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text('House Number: $houseNumber'),
                      onTap: () => _goToDonationListScreen(wardNumber, houseNumber),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _goToDonationListScreen(String wardNumber, String houseNumber) {
    _firestoreService.userCollectionRef
        .where('wardNumber', isEqualTo: wardNumber)
        .where('houseNumber', isEqualTo: houseNumber)
        .limit(1)
        .get()
        .then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          final document = querySnapshot.docs.first;
          final itemCollectionRef = document.reference.collection('Items');
          NavigationUtils.navigateTo(
              context,
              DonationListScreen(
                  wardNumber: wardNumber, houseNumber: houseNumber, itemCollectionRef: itemCollectionRef));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = Provider.of<ConnectivityStatus>(context);
    if (connectivityStatus.isConnected) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pending Donations Ward List')),
        body: RefreshIndicator(          
          onRefresh: _refreshScreen,
          backgroundColor: Colors.green,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<List<String>>(
              stream: _getFilteredWardNumbers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(
                    child: ListTile(
                      leading: Icon(Icons.info),
                      title: Text('No pending donations', style: TextStyle(fontSize: 20)),
                      subtitle: Text('Please check again later.\nCurrenly there is no pending donations from anyone.'),
                    ),
                  );
                }
                final filteredWardNumbers = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: filteredWardNumbers.length,
                  itemBuilder: (context, index) {
                    final wardNumber = filteredWardNumbers[index];
                    return _buildExpansionTile(wardNumber);
                  },
                );
              },
            ),
          ),
        ),
      );
    } else {
      return const NoInternetScreen();
    }
  }
}
