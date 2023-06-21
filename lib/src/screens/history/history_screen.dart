import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenio/src/models/item/item_model.dart';
import 'package:greenio/src/screens/history/components/history_screen_components.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/services/firestore_service.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'package:greenio/src/utils/widgets/snackbar_helper.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late Stream<QuerySnapshot> _itemStream;

  @override
  void initState() {
    super.initState();
    _itemStream = _firestoreService.getUserDonatedItemQuerySnapshot();
  }

  _onImageTapped(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(            
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green[400]!, width: 5.0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(DonationItemModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.warning_rounded, color: Colors.red, size: 40),
          title: const Text('Cancel donation', style: TextStyle(color: Colors.red)),
          content: const Text('Are you sure you want to delete this item and cancel the donation?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.green),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteItemFromDatabase(item);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteItemFromDatabase(item) async {
    try {
      await _firestoreService.deleteItem(item);
    } catch (e) {
      SnackBarHelper.showSnackBar(context, e.toString());
    }
  }

  Widget _buildHistoryList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _itemStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snapshot.data!.docs;
        return items.isNotEmpty
            ? HistoryScreenComponents.showHistoryLists(items, _onImageTapped, _showDeleteConfirmationDialog)
            : HistoryScreenComponents.showEmptyHistory();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = Provider.of<ConnectivityStatus>(context);
    return connectivityStatus.isConnected
        ? Scaffold(
            appBar: AppBar(title: const Text('History')),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildHistoryList(),
            ),
          )
        : const NoInternetScreen();
  }
}
