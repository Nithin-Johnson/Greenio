import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greenio/src/services/firebase_service.dart';
import 'package:greenio/src/utils/exceptions/firebase_exception.dart';

Future<void> signOutUser(context) async {
  try {
    await FirebaseAuthService().signOut();    
  } on FirebaseAuthException catch (e) {    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(e.getErrorMessage()),
      ),
    );
  }
}
