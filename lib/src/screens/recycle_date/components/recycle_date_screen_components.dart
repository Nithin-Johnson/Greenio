import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecycleDateScreenComponents {
  static ListTile note(String text) {
    return ListTile(
      leading: const Icon(Icons.info),
      subtitle: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  static Card dateOptionsCard(DateTime date, bool isSelected, VoidCallback selectDate) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: isSelected ? Colors.green[400] : null,
        title: Text(
          DateFormat.yMMMMd().format(date),
          style: TextStyle(
            color: isSelected ? Colors.white : null,
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
        trailing: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
        onTap: selectDate,
      ),
    );
  }

  static ElevatedButton showConfirmButton(confirmSelection) {
    return ElevatedButton(
      onPressed: () async => await confirmSelection(),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400]),
      child: const Text('Confirm date'),
    );
  }

  static Card selectedDateCard(String text, Color color) {
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
}
