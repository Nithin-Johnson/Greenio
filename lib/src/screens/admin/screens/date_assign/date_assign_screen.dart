import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenio/src/models/ward_schedule/ward_schedule_model.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/services/firestore_service.dart';
import 'package:greenio/src/utils/connectivity/internet_connectivity.dart';
import 'package:greenio/src/utils/constants/cheriyanad_ward_list.dart';
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
  List<String> wardNumbers = [];
  Map<String, String> wardNumbersMap = cheriyanadWardList;

  Map<String, List<DateTime>> wardDatesMap = {};

  late ValueNotifier<String?> selectedWardNotifier;
  late ValueNotifier<List<DateTime>> selectedDatesNotifier;

  late Stream<QuerySnapshot> wardScheduleStream;

  ValueNotifier<bool> assignedDatesEmpty = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    selectedWardNotifier = ValueNotifier<String?>(null);
    selectedDatesNotifier = ValueNotifier<List<DateTime>>([]);
    wardNumbers = wardNumbersMap.keys.toList();
    wardScheduleStream = _firestoreService.getWardStreamQuerySnapshot();
  }

  @override
  void dispose() {
    selectedWardNotifier.dispose();
    selectedDatesNotifier.dispose();
    super.dispose();
  }

  void uploadDates(String wardNumber, List<DateTime> dates) async {
    final WardScheduleModel wardSchedule = WardScheduleModel(wardNumber: wardNumber, assignedDates: dates);
    await _firestoreService.addWardScheduleToDatabase(wardSchedule).then((_) {
      selectedWardNotifier.value = null;
      selectedDatesNotifier.value = [];
      wardDatesMap[wardNumber] = dates;
      assignedDatesEmpty.value = false;
    }).catchError((error) {});
  }

  _showDuplicateDatesAlert() {
    SnackBarHelper.showSnackBar(context, "Duplicate date selected");
  }

  _labelText(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  StreamBuilder<QuerySnapshot> _showAlreadyAssignedDatesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: wardScheduleStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text('No assigned dates');
        }
        if (snapshot.hasData) {
          final wardScheduleDocs = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: wardScheduleDocs.length,
            itemBuilder: (context, index) {
              final wardNumber = wardScheduleDocs[index].id;
              final wardName = wardNumbersMap[wardNumber];
              return FutureBuilder<Map<String, dynamic>?>(
                future: _getWardScheduleFromDatabase(wardNumber),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final assignedDates = snapshot.data;
                  if (assignedDates == null || assignedDates.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final wardSchedule = WardScheduleModel.fromMap(assignedDates);
                  final dates = wardSchedule.assignedDates;
                  if (dates.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final formattedDates =
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
                                      title: Text(date.toString()),
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

  Future<Map<String, dynamic>?> _getWardScheduleFromDatabase(wardNumber) async {
    final wardScheduleDocSnapshot = await _firestoreService.wardSchedulesCollectionRef.doc(wardNumber).get();
    return wardScheduleDocSnapshot.data();
  }

  Widget _showUploadDatesButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            final wardNumber = selectedWardNotifier.value;
            final dates = selectedDatesNotifier.value;
            if (wardNumber != null && dates.length >= 3) {
              uploadDates(wardNumber, dates);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[400],
          ),
          child: const Text('Upload Dates'),
        ),
      ),
    );
  }

  ValueListenableBuilder<List<DateTime>> _showSelectedDates() {
    return ValueListenableBuilder<List<DateTime>>(
      valueListenable: selectedDatesNotifier,
      builder: (context, value, child) {
        if (value.isEmpty) {
          return const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(
              'No selected dates',
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 14),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: value.length,
          itemBuilder: (context, index) {
            final date = value[index];
            final formattedDate = DateFormat('MMMM d yyyy (dd / MM / y)').format(date);
            return Card(
              color: Colors.green[300],
              child: ListTile(
                title: Text(
                  formattedDate.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    selectedDatesNotifier.value = List.of(value)..removeAt(index);
                  },
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

  Widget _showDatePickerButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
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
                  colorScheme: ColorScheme.light(
                    primary: Colors.green[400]!,
                    onPrimary: Colors.white,
                    onSurface: Colors.black,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (pickedDate != null) {
            final pickedDateFormatted = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
            final isDuplicateDate = selectedDatesNotifier.value.contains(pickedDateFormatted);
            if (!isDuplicateDate) {
              selectedDatesNotifier.value = [...selectedDatesNotifier.value, pickedDateFormatted];
            } else {
              _showDuplicateDatesAlert();
            }
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
        child: const Text('Pick a Date'),
      ),
    );
  }

  ValueListenableBuilder<String?> _showDropDownMenu() {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedWardNotifier,
      builder: (context, value, child) {
        return DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            value: value,
            items: wardNumbers.map((wardNumber) {
              final wardName = wardNumbersMap[wardNumber]!;
              return DropdownMenuItem<String>(
                value: wardNumber,
                child: Text(
                  '$wardNumber: $wardName',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }).toList(),
            onChanged: (value) {
              selectedWardNotifier.value = value;
            },
            hint: const Text(
              'Select a Ward Number',
              style: TextStyle(color: Colors.white),
            ),
            isExpanded: true,
            style: const TextStyle(color: Colors.white),
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(color: Colors.green[400], borderRadius: BorderRadius.circular(8)),
              elevation: 2,
              padding: const EdgeInsets.only(left: 5, right: 20),
            ),
            dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.green[300]),
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(Colors.green),
                  thumbVisibility: MaterialStateProperty.all(true),
                )),
            iconStyleData: const IconStyleData(iconEnabledColor: Colors.white),
          ),
        );
      },
    );
  }

  _clearAssignedDates() async {
    final wardSchedulesCollectionRef = _firestoreService.wardSchedulesCollectionRef;
    final querySnapshot = await wardSchedulesCollectionRef.get();
    for (var docSnapshot in querySnapshot.docs) {
      wardSchedulesCollectionRef.doc(docSnapshot.id).update({'assignedDates': []});
    }
    assignedDatesEmpty.value = true;
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
                _showDropDownMenu(),
                const Divider(),
                const EmptySpace(heightFraction: 0.03),
                const Divider(),
                _labelText('Select three dates:'),
                _showDatePickerButton(context),
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
                ValueListenableBuilder(
                  valueListenable: assignedDatesEmpty,
                  builder: (context, value, child) {
                    return !assignedDatesEmpty.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _labelText('Assigned Dates:'),
                              IconButton(
                                  onPressed: () async => _clearAssignedDates(), icon: const Icon(Icons.delete_forever))
                            ],
                          )
                        : _labelText('Assigned Dates: None');
                  },
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
