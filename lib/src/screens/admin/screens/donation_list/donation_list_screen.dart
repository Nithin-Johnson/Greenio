import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenio/src/models/item/item_model.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DonationListScreen extends StatefulWidget {
  final CollectionReference itemCollectionRef;
  final String houseNumber;
  final String wardNumber;

  const DonationListScreen(
      {super.key, required this.wardNumber, required this.houseNumber, required this.itemCollectionRef});

  @override
  State<DonationListScreen> createState() => _DonationListScreenState();
}

class _DonationListScreenState extends State<DonationListScreen> {
  Card _itemCard(DonationItemModel item) {
    return Card(
      color: Colors.green[400],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(item.imageUrl),
            backgroundColor: Colors.green[200],
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
            ),
          ),
          title: Text(
            'Item Category: ${item.category}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
          ),
          onTap: () => _viewMoreDetails(item),
        ),
      ),
    );
  }

  void _viewMoreDetails(DonationItemModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.green[400],
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green[200]!, width: 5.0),
                          borderRadius: BorderRadius.circular(12)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(item.imageUrl, fit: BoxFit.cover),
                      ),
                    ),
                    const EmptySpace(heightFraction: 0.01,),
                    _showExpansionTile('Item Category', item.category),
                    const EmptySpace(heightFraction: 0.01,),
                    _showExpansionTile('Item Description', item.description),
                    const EmptySpace(heightFraction: 0.01,),
                    _showExpansionTile(
                        'Item Pickup Date', DateFormat('MMMM d yyyy (dd / MM / y)').format(item.pickupDate)),
                    _showMarkAsCollectedButton(item),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Card _showExpansionTile(titleText, subtitleText) {
    return Card(
      color: Colors.green[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        iconColor: Colors.black,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        collapsedIconColor: Colors.white,
        collapsedTextColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          titleText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        children: [
          Card(
            color: Colors.green[400],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(
                subtitleText,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }

  _showMarkAsCollectedButton(DonationItemModel item) {
    return Center(
      child: ElevatedButton(
        onPressed: () => updateItemCollected(item),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        child: const Text('Mark as Collected'),
      ),
    );
  }

  void updateItemCollected(DonationItemModel item) {
    DocumentReference documentRef = widget.itemCollectionRef.doc(item.id);
    documentRef.update({'isCollected': true}).then((_) {}).catchError((error){});
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = Provider.of<ConnectivityStatus>(context);
    if (connectivityStatus.isConnected) {
      return Scaffold(
        appBar: AppBar(title: const Text('Items')),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: widget.itemCollectionRef.where('isCollected', isEqualTo: false).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No items found.'));
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data!.docs[index];
                  final DonationItemModel donatedItem = DonationItemModel.fromMap(item.data() as Map<String, dynamic>);
                  return _itemCard(donatedItem);
                },
              );
            },
          ),
        ),
      );
    } else {
      return const NoInternetScreen();
    }
  }
}
