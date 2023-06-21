import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemUploadScreenComponents {
  static label(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      textAlign: TextAlign.left,
    );
  }

  static Card itemCategory({required String itemCategory}) {
    const inputDecoration = InputDecoration(focusColor: Colors.green, border: InputBorder.none, errorMaxLines: 2);
    return Card(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.green[300]!)),
      elevation: 2,
      color: Colors.green[100],
      child: ListTile(
        leading: const Icon(Icons.category_outlined),
        title: TextFormField(initialValue: itemCategory, decoration: inputDecoration, enabled: false, readOnly: true),
      ),
    );
  }

  static Card itemDescription({required TextEditingController itemDescriptionController}) {
    const inputDecoration = InputDecoration(
      focusColor: Colors.green,
      border: InputBorder.none,
      errorMaxLines: 2,
      hintText: 'Description of the item such as its working condition, etc',
    );
    return Card(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.green[300]!)),
      elevation: 2,
      color: Colors.green[100],
      child: ListTile(
        leading: const Icon(Icons.description_outlined),
        title: TextFormField(
          controller: itemDescriptionController,
          decoration: inputDecoration,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 5,
          textInputAction: TextInputAction.done,
          validator: (value) {
            return (value == null || value.isEmpty) ? 'Item description cannot be empty' : null;
          },
        ),
      ),
    );
  }

  static Widget pickupDate(ValueNotifier selectedDateNotifier, VoidCallback selectDate) {
    return ValueListenableBuilder(
      valueListenable: selectedDateNotifier,
      builder: (context, value, child) {
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.green[300]!)),
          elevation: 2,
          color: Colors.green[100],
          child: ListTile(
            leading: const Icon(Icons.calendar_today),
            title: TextFormField(
              readOnly: true,
              controller: TextEditingController(
                  text: value != null ? DateFormat('MMMM d yyyy (dd / MM / y)').format(value) : ''),
              decoration: const InputDecoration(border: InputBorder.none, hintText: 'Select a pickup date'),
              validator: (value) {
                return (value == null || value.isEmpty) ? 'Please select a date' : null;
              },
              onTap: selectDate,
            ),
          ),
        );
      },
    );
  }

  static textButton(VoidCallback loadPicture, String text) {
    return TextButton(
      onPressed: loadPicture,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      child: Text(text),
    );
  }
}
