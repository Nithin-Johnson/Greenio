import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenio/src/models/ward_schedule/ward_schedule_model.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/services/firestore_service.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'package:greenio/src/utils/constants/cheriyanad_ward_list.dart';
import 'package:greenio/src/utils/widgets/custom_button.dart';
import 'package:greenio/src/utils/widgets/custom_dropdown_menu.dart';
import 'package:greenio/src/utils/widgets/snackbar_helper.dart';
import 'package:greenio/src/utils/widgets/spacing_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateAssignScreen extends StatefulWidget {
  const DateAssignScreen({Key? key}) : super(key: key);

  @override
  State<DateAssignScreen> createState() => _DateAssignScreenState();
}

class _DateAssignScreenState extends State<DateAssignScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  String? selectedWardNumber;
  List<DateTime> selectedDates = [];
  Map<String, String> wardNumbersMap = cheriyanadWardList;

  Map<String, List<DateTime>> wardSchedulesDatesMap = {};

  ValueNotifier<String?> selectedWardNotifier = ValueNotifier<String?>(null);
  ValueNotifier<List<DateTime>> selectedDatesNotifier = ValueNotifier<List<DateTime>>([]);

  late Stream<QuerySnapshot> wardScheduleStream;

  @override
  void initState() {
    super.initState();
    wardScheduleStream = _firestoreService.getWardStreamQuerySnapshot();
  }

  @override
  void dispose() {
    selectedWardNotifier.dispose();
    selectedDatesNotifier.dispose();
    super.dispose();
  }

  _labelText(String label) {
    return Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }

  Widget _showDatePickerButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _onDatePickerButtonPressed,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
        child: const Text('Pick a Date'),
      ),
    );
  }

  Future<void> _onDatePickerButtonPressed() async {
    if (selectedDatesNotifier.value.length >= 3) {
      SnackBarHelper.showSnackBar(context, 'Only three dates are allowed');
      return;
    }
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                ColorScheme.light(primary: Colors.green[400]!, onPrimary: Colors.white, onSurface: Colors.black),
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: Colors.red)),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      final pickedDateFormatted = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      final isDuplicateDate = selectedDatesNotifier.value.contains(pickedDateFormatted);
      if (isDuplicateDate) {
        _showDuplicateDatesAlert();
      } else {
        selectedDatesNotifier.value = [...selectedDatesNotifier.value, pickedDateFormatted];
      }
    }
  }

  _showDuplicateDatesAlert() {
    SnackBarHelper.showSnackBar(context, "Duplicate date selected");
  }

  ValueListenableBuilder<List<DateTime>> _showSelectedDates() {
    return ValueListenableBuilder<List<DateTime>>(
      valueListenable: selectedDatesNotifier,
      builder: (context, datesList, child) {
        if (datesList.isEmpty) {
          return const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('No selected dates', style: TextStyle(fontWeight: FontWeight.w200, fontSize: 14)),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: datesList.length,
          itemBuilder: (context, index) {
            final date = datesList[index];
            final formattedDate = DateFormat('MMMM d yyyy (dd / MM / y)').format(date);
            return Card(
              color: Colors.green[300],
              child: ListTile(
                title: Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => selectedDatesNotifier.value = List.of(datesList)..removeAt(index),
                ),
                iconColor: Colors.white,
                textColor: Colors.white,
              ),
            );
          },
        );
      },
    );
  }

  Widget _showUploadDatesButton() {
    return CustomElevatedButton(
      text: 'Upload Dates',
      onPressed: () {
        final wardNumber = selectedWardNotifier.value;
        final datesList = selectedDatesNotifier.value;
        if (wardNumber != null && datesList.length >= 3) {
          uploadDates(wardNumber, datesList);
        }
      },
    );
  }

  void uploadDates(String wardNumber, List<DateTime> datesList) async {
    final WardScheduleModel wardSchedule = WardScheduleModel(wardNumber: wardNumber, assignedDates: datesList);
    await _firestoreService.addWardScheduleToDatabase(wardSchedule).then((_) {
      selectedWardNotifier.value = null;
      selectedDatesNotifier.value = [];
      wardSchedulesDatesMap[wardNumber] = datesList;
    }).catchError((error) {});
  }

  _clearAssignedDates() async {
    final wardSchedulesCollectionRef = _firestoreService.wardSchedulesCollectionRef;
    final querySnapshot = await wardSchedulesCollectionRef.get();
    if (querySnapshot.docs.isEmpty) return;
    _showWarningDialog(querySnapshot.docs, wardSchedulesCollectionRef);
  }

  _showWarningDialog(queryDocSnapshotDocs, wardSchedulesCollectionRef) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            Icons.warning_amber_outlined,
            size: 40,
            color: Colors.red,
          ),
          title: const Text(
            'Are you sure?',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text('Are you sure you want to delete all assigned dates?'),
          actions: [
            TextButton(onPressed: _popDialog, child: const Text('Cancel')),
            TextButton(
                onPressed: () async => _deleteAssignedDates(queryDocSnapshotDocs, wardSchedulesCollectionRef),
                child: const Text('Delete')),
          ],
        );
      },
    );
  }

  _popDialog() {
    Navigator.pop(context);
  }

  _deleteAssignedDates(queryDocSnapshotDocs, wardSchedulesCollectionRef) async {
    try {
      for (var docSnapshot in queryDocSnapshotDocs) {
        await wardSchedulesCollectionRef.doc(docSnapshot.id).delete();
      }
      _showToast('Successfully deleted all assigned dates');
    } on Exception catch (e) {
      _showToast(e.toString());
    }
    _popDialog();
  }

  _showToast(String message) {
    SnackBarHelper.showSnackBar(context, message);
  }

  StreamBuilder<QuerySnapshot> _showAlreadyAssignedDatesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: wardScheduleStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text('No assigned dates');
        }
        if (snapshot.hasData) {
          final wardScheduleDocSnapshotList = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: wardScheduleDocSnapshotList.length,
            itemBuilder: (context, index) {
              final wardNumber = wardScheduleDocSnapshotList[index].id;
              final wardName = wardNumbersMap[wardNumber];
              return FutureBuilder<Map<String, dynamic>?>(
                future: _getWardScheduleDataFromDatabase(wardNumber),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const EmptySpace();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final Map<String, dynamic>? assignedDates = snapshot.data;
                  if (assignedDates == null || assignedDates.isEmpty) {
                    return const EmptySpace();
                  }
                  final WardScheduleModel wardSchedule = WardScheduleModel.fromMap(assignedDates);
                  final List<DateTime> dates = wardSchedule.assignedDates;
                  if (dates.isEmpty) {
                    return const EmptySpace();
                  }
                  final List<String> formattedDates =
                      dates.map((date) => DateFormat('MMMM d yyyy (dd / MM / y)').format(date)).toList();
                  return Card(
                    color: Colors.green[400],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ExpansionTile(
                      title: Text(
                        'Ward $wardNumber - $wardName',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      iconColor: Colors.white,
                      textColor: Colors.white,
                      collapsedIconColor: Colors.white,
                      collapsedTextColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      children: [
                        Column(
                          children: formattedDates
                              .map((date) => Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    child: ListTile(
                                      title: Text(date),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<Map<String, dynamic>?> _getWardScheduleDataFromDatabase(wardNumber) async {
    final wardScheduleDocSnapshot = await _firestoreService.wardSchedulesCollectionRef.doc(wardNumber).get();
    return wardScheduleDocSnapshot.data();
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = Provider.of<ConnectivityStatus>(context);
    if (connectivityStatus.isConnected) {
      return Scaffold(
        appBar: AppBar(title: const Text('Date collection')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _labelText('Select a Ward Number:'),
                CustomDropDownMenu(valueNotifier: selectedWardNotifier, items: wardNumbersMap),
                const Divider(),
                const EmptySpace(heightFraction: 0.03),
                const Divider(),
                _labelText('Select three dates:'),
                _showDatePickerButton(),
                const Divider(),
                const EmptySpace(heightFraction: 0.03),
                const Divider(),
                _labelText('Selected Dates:'),
                _showSelectedDates(),
                const Divider(),
                const EmptySpace(heightFraction: 0.03),
                _showUploadDatesButton(),
                const EmptySpace(heightFraction: 0.03),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _labelText('Assigned Dates:'),
                    IconButton(onPressed: () => _clearAssignedDates(), icon: const Icon(Icons.delete_forever))
                  ],
                ),
                _showAlreadyAssignedDatesList(),
                const Divider(),
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
