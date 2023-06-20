import 'package:cloud_firestore/cloud_firestore.dart';

class WardScheduleModel {
  final String wardNumber;
  final List<DateTime> assignedDates;
  final Map<String, DateTime>? selectedDates;

  WardScheduleModel({
    required this.wardNumber,
    required this.assignedDates,
    this.selectedDates,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'wardNumber': wardNumber,
      'assignedDates': assignedDates.toList(),
      'selectedDates': selectedDates,
    };
  }

  factory WardScheduleModel.fromMap(Map<String, dynamic> map) {
  return WardScheduleModel(
    wardNumber: map['wardNumber'] as String,
    assignedDates: List<DateTime>.from(
      (map['assignedDates'] as List<dynamic>).map<DateTime>(
        (x) => (x as Timestamp).toDate(),
      ),
    ),
    selectedDates: map['selectedDates'] != null
        ? Map<String, DateTime>.from(
            (map['selectedDates'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, (value as Timestamp).toDate()),
            ),
          )
        : null,
  );
}

}


