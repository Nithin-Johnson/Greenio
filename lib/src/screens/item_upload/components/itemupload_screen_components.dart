import 'package:flutter/material.dart';
import 'package:greenio/src/services/firestore_service.dart';

class ItemUploadScreenComponents {
  final firestoreService = FirestoreService();

  static itemLabelText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      textAlign: TextAlign.left,
    );
  }

  static itemCategory({required String itemCategory}) {
    const inputDecoration = InputDecoration(
      focusColor: Colors.green,
      border: InputBorder.none,
      errorMaxLines: 2,
    );
    return Card(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.green[300]!)),
      elevation: 2,
      color: Colors.green[100],
      child: ListTile(
        leading: const Icon(Icons.category_outlined),
        title: TextFormField(
          initialValue: itemCategory,
          decoration: inputDecoration,
          enabled: false,
          readOnly: true,
        ),
      ),
    );
  }

  static itemDescription({required TextEditingController itemDescriptionController}) {
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
            if (value == null || value.isEmpty) {
              return 'Item description cannot be empty';
            }
            return null;
          },
        ),
      ),
    );
  }
}
