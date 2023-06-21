import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greenio/src/models/user/user_model.dart';
import 'package:greenio/src/models/ward_schedule/ward_schedule_model.dart';
import 'package:greenio/src/screens/no_internet/no_internet_screen.dart';
import 'package:greenio/src/screens/recycle_date/components/recycle_date_screen_components.dart';
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

  String checkRegulary = 'The provided options for dates can change each month.\nDo regularly check for any changes.';
  String noDates =
      'Please check again later.\nCurrenly no dates has been assigned for garbage collection for your ward.';
  String alreadyCollected = 'The garbage collection for your house number has already been completed for this month.';

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
    final wardDocsSnapshotStream = _firestoreService.wardSchedulesCollectionRef.doc(_wardNumber).snapshots();
    wardDatesSubscription = wardDocsSnapshotStream.listen((wardDocSnapshot) async {
      if (wardDocSnapshot.exists) {
        wardSchedule = WardScheduleModel.fromMap(wardDocSnapshot.data()!);
        assignedDates = wardSchedule.assignedDates;
        if (wardSchedule.selectedDates != null) {
          selectedDates = wardSchedule.selectedDates!;
          setSelectedDate(selectedDates);
        }
      } else {
        assignedDates = [];
        setSelectedDate({});
      }
      setState(() {
        _houseNumber = user.houseNumber!;
      });
    });
  }

  void setSelectedDate(Map<String, dynamic>? selectedDates) async {
    _houseNumber = user.houseNumber;
    selectedDate = selectedDates?[_houseNumber];
    selectedDateNotifier.value = selectedDate;
  }

  ValueListenableBuilder<DateTime?> _showCurrentlySelectedDate() {
    return ValueListenableBuilder(
      valueListenable: selectedDateNotifier,
      builder: (context, selectedDate, child) {
        if (selectedDate != null) {
          final String formattedDate = DateFormat.yMMMMd().format(selectedDate);
          return RecycleDateScreenComponents.selectedDateCard(formattedDate, Colors.green);
        } else {
          return RecycleDateScreenComponents.selectedDateCard('None', Colors.red);
        }
      },
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
            return RecycleDateScreenComponents.dateOptionsCard(date, isSelected, () => selectDate(date));
          },
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = Provider.of<ConnectivityStatus>(context);
    if (connectivityStatus.isConnected) {
      return Scaffold(
        appBar: AppBar(title: const Text('Select a Date')),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: (selectedDates.isEmpty || (selectedDates.isNotEmpty && selectedDate != null))
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: assignedDates.isNotEmpty
                      ? [
                          _showDatesOptions(),
                          const EmptySpace(heightFraction: 0.02),
                          RecycleDateScreenComponents.showConfirmButton(confirmSelection),
                          const EmptySpace(heightFraction: 0.1),
                          _showCurrentlySelectedDate(),
                          const EmptySpace(heightFraction: 0.1),
                          RecycleDateScreenComponents.note(checkRegulary),
                        ]
                      : [RecycleDateScreenComponents.note(noDates)],
                )
              : Center(child: RecycleDateScreenComponents.note(alreadyCollected)),
        ),
      );
    } else {
      return const NoInternetScreen();
    }
  }
}
