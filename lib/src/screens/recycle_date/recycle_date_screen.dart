import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenio/src/models/user/user_model.dart';
import 'package:greenio/src/models/ward_schedule/ward_schedule_model.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/services/firestore_service.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'package:greenio/src/utils/widgets/snackbar_helper.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RecycleDateScreen extends StatefulWidget {
  const RecycleDateScreen({Key? key}) : super(key: key);

  @override
  State<RecycleDateScreen> createState() => _RecycleDateScreenState();
}

class _RecycleDateScreenState extends State<RecycleDateScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  late final UserModel user;
  late WardScheduleModel wardSchedule;

  late String _wardNumber;
  String? _houseNumber;
  List<DateTime> assignedDates = [];
  Map<String, DateTime> selectedDates = {};
  ValueNotifier<DateTime?> selectedDateNotifier = ValueNotifier<DateTime?>(null);

  StreamSubscription<DocumentSnapshot>? wardDatesSubscription;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  void dispose() {
    wardDatesSubscription?.cancel();
    super.dispose();
  }

  Future fetchUserData() async {
    final userDoc = await _firestoreService.getUserFutureDocSnapshot();
    user = UserModel.fromMap(userDoc.data()!);
    if (!user.isProfileComplete) {
      return;
    }
    _wardNumber = user.wardNumber!;
    final wardDocsSnapshot = _firestoreService.getWardStreamDocSnapshot(_wardNumber);
    wardDatesSubscription = wardDocsSnapshot.listen((wardDoc) async {
      if (wardDoc.exists) {
        wardSchedule = WardScheduleModel.fromMap(wardDoc.data()!);
        assignedDates = wardSchedule.assignedDates.toList();
        if (wardSchedule.selectedDates != null) {
          selectedDates = wardSchedule.selectedDates!;
          setSelectedDates(selectedDates, _wardNumber);
        }
      } else {
        assignedDates = [];
        setSelectedDates({}, _wardNumber);
      }
      setState(() {
        _houseNumber = user.houseNumber!;
      });
    });
  }

  void setSelectedDates(Map<String, dynamic>? selectedDates, String wardNumber) async {
    _houseNumber = user.houseNumber;    
    final selectedDate = selectedDates?[_houseNumber];
    selectedDateNotifier.value = selectedDate;
  }

  void selectDate(DateTime date) {
    selectedDateNotifier.value = date;
  }

  Future<void> confirmSelection() async {
    if (selectedDateNotifier.value != null) {
      // if (wardSchedule.selectedDates != null) {
      //   selectedDates = wardSchedule.selectedDates!;
      // }
      selectedDates[_houseNumber!] = selectedDateNotifier.value!;
      await _firestoreService.addWardScheduleAssignedDatesToDatabase(_wardNumber, selectedDates);
    }
    _showToast();
  }

  void _showToast() {
    SnackBarHelper.showSnackBar(context, 'Date assigned! You can go back now!');
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = Provider.of<ConnectivityStatus>(context);
    if (connectivityStatus.isConnected) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Select a Date'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              if (assignedDates.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: assignedDates.length,
                  itemBuilder: (context, index) {
                    final date = assignedDates[index];
                    return ValueListenableBuilder<DateTime?>(
                      valueListenable: selectedDateNotifier,
                      builder: (context, selectedDate, child) {
                        final isSelected = date == selectedDate;
                        return _showDates(date, isSelected);
                      },
                    );
                  },
                )
              else
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text(
                          'No dates available',
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(
                            'Please check again later.\nCurrenly no dates has been assigned for garbage collection for your ward.'),
                      ),
                    ],
                  ),
                ),
              const EmptySpace(
                heightFraction: 0.02,
              ),
              if (assignedDates.isNotEmpty)
                ElevatedButton(
                  onPressed: () {
                    confirmSelection();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[400],
                  ),
                  child: const Text('Confirm date'),
                ),
              const EmptySpace(
                heightFraction: 0.1,
              ),
              if (assignedDates.isNotEmpty)
                ValueListenableBuilder(
                  valueListenable: selectedDateNotifier,
                  builder: (context, selectedDate, child) {
                    if (selectedDate != null) {
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text(
                            'Currently selected date:\n${DateFormat.yMMMMd().format(selectedDate)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          tileColor: Colors.green[400],
                          textColor: Colors.white,
                        ),
                      );
                    } else {
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: const Text(
                            'Currently selected date: None',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          tileColor: Colors.red[400],
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    }
                  },
                ),
              const EmptySpace(heightFraction: 0.2),
              const ListTile(
                leading: Icon(Icons.info),
                subtitle: Text(
                    'Note: The provided options for dates can change each month. Do regularly check for any changes.'),
              ),
            ],
          ),
        ),
      );
    } else {
      return const NoInternetScreen();
    }
  }

  Card _showDates(DateTime date, bool isSelected) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: isSelected ? Colors.green[400] : null,
        title: Text(
          DateFormat.yMMMd().format(date),
          style: TextStyle(
            color: isSelected ? Colors.white : null,
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
        trailing: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
        onTap: () {
          selectDate(date);
        },
      ),
    );
  }
}
