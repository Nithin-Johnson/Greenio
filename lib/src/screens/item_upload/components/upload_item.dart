import 'package:flutter/material.dart';
import 'package:greenio/src/models/item/item_model.dart';
import 'package:greenio/src/services/firestore_service.dart';

typedef SnackBarCallback = void Function(String message);

class UploadDonationItem {
  static uploadDonationItemToDatabase({
    required DonationItemModel donatedItem,
    required VoidCallback onSuccess,
    required SnackBarCallback onFailure,
  }) async {
    final FirestoreService firestoreService = FirestoreService();
    try {
      await firestoreService.addUserItemToDatabase(donatedItem);
      onSuccess();      
    } catch (e) {
      onFailure(e.toString());
    }
  }
}
