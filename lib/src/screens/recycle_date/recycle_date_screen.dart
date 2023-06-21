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
  Map<String, DateTime?> selectedDates = {};
  DateTime? selectedDate;
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
    final wardDocsSnapshot = _firestoreService.wardSchedulesCollectionRef.doc(_wardNumber).snapshots();
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
    selectedDate = selectedDates?[_houseNumber];
    selectedDateNotifier.value = selectedDate;
  }

  void selectDate(DateTime date) {
    selectedDateNotifier.value = date;
  }

  Future<void> confirmSelection() async {
    if (selectedDateNotifier.value != null) {
      selectedDates[_houseNumber!] = selectedDateNotifier.value!;
      await _firestoreService.addWardScheduleAssignedDatesToDatabase(_wardNumber, selectedDates);
    }
    _showToast();
  }

  void _showToast() {
    SnackBarHelper.showSnackBar(context, 'Date assigned! You can go back now!');
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

  ListTile _showNote(String text) {
    return ListTile(
      leading: const Icon(Icons.info),
      subtitle: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  ValueListenableBuilder<DateTime?> _showCurrentlySelectedDate() {
    return ValueListenableBuilder(
      valueListenable: selectedDateNotifier,
      builder: (context, selectedDate, child) {
        if (selectedDate != null) {
          final String formattedDate = DateFormat.yMMMMd().format(selectedDate);
          return _showCurrentlySelectedDateCard(formattedDate, Colors.green);
        } else {
          return _showCurrentlySelectedDateCard('None', Colors.red);
        }
      },
    );
  }

  Card _showCurrentlySelectedDateCard(String text, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          'Currently selected date:\n$text',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: color,
        textColor: Colors.white,
      ),
    );
  }

  ElevatedButton _showConfirmButton() {
    return ElevatedButton(
      onPressed: () {
        confirmSelection();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[400],
      ),
      child: const Text('Confirm date'),
    );
  }

  ListView _showDatesOptions() {
    return ListView.builder(
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
    );
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
          child: selectedDates.isEmpty || (selectedDates.isNotEmpty && selectedDate != null)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: assignedDates.isNotEmpty
                      ? [
                          _showDatesOptions(),
                          const EmptySpace(heightFraction: 0.02),
                          _showConfirmButton(),
                          const EmptySpace(heightFraction: 0.1),
                          _showCurrentlySelectedDate(),
                          const EmptySpace(heightFraction: 0.1),
                          _showNote(
                              'The provided options for dates can change each month.\nDo regularly check for any changes.'),
                        ]
                      : [
                          _showNote(
                              'Please check again later.\nCurrenly no dates has been assigned for garbage collection for your ward.'),
                        ],
                )
              : Center(
                  child: _showNote(
                      "The garbage collection for your house number has already been completed for this month."),
                ),
        ),
      );
    } else {
      return const NoInternetScreen();
    }
  }
}
