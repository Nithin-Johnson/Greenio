import 'package:flutter/material.dart';
import 'package:greenio/src/models/ward_schedule/ward_schedule_model.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/services/firestore_service.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SelectedDateScreen extends StatefulWidget {
  const SelectedDateScreen({super.key});

  @override
  State<SelectedDateScreen> createState() => _SelectedDateScreenState();
}

class _SelectedDateScreenState extends State<SelectedDateScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = Provider.of<ConnectivityStatus>(context);
    if (connectivityStatus.isConnected) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Selected Date for Recycling'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: _firestoreService.getWardStreamQuerySnapshot(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final wardNumbers = snapshot.data!.docs;
              if (wardNumbers.isEmpty) {
                return const Center(
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text(
                      'No dates available',
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text('Currenly no dates has been assigned for garbage collection for in any ward.'),
                  ),
                );
              }
              return ListView.builder(
                itemCount: wardNumbers.length,
                itemBuilder: (BuildContext context, int index) {
                  final wardNumberDoc = wardNumbers[index];
                  final wardNumber = wardNumberDoc.id;
                  final WardScheduleModel wardSchedule = WardScheduleModel.fromMap(wardNumberDoc.data());
                  final Map<String, DateTime>? selectedDates = wardSchedule.selectedDates;

                  // Display the ward number and selected dates for each house number
                  return selectedDates == null
                      ? _showExpansionTileForNone(wardNumber)
                      : _showExpansionTileForDate(wardNumber, selectedDates);
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

  _showExpansionTileForNone(String wardNumber) {
    return Card(
      color: Colors.green[400],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: ListTile(
          title: Text(
            'Ward Number: $wardNumber',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        iconColor: Colors.white,
        textColor: Colors.white,
        collapsedIconColor: Colors.white,
        collapsedTextColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text(
                'No house numbers has selected date',
                style: TextStyle(fontWeight: FontWeight.w200),
              ),
            ),
          )
        ],
      ),
    );
  }
}

_showExpansionTileForDate(String wardNumber, Map<String, DateTime> selectedDates) {
  return Card(
    color: Colors.green[400],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ExpansionTile(
      title: ListTile(
        title: Text(
          'Ward Number: $wardNumber',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      iconColor: Colors.white,
      textColor: Colors.white,
      collapsedIconColor: Colors.white,
      collapsedTextColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: selectedDates.entries.map((e) {
            final houseNumber = e.key;
            final formattedDate = DateFormat('MMMM d yyyy (dd / MM / y)').format(e.value);
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                collapsedIconColor: Colors.black,
                collapsedTextColor: Colors.black,
                iconColor: Colors.black,
                textColor: Colors.black,
                title: Text(
                  'House Number: $houseNumber',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                children: [
                  Card(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    child: ListTile(
                      title: Text('Selected Date: $formattedDate'),
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}
