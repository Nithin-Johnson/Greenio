import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenio/src/services/firebase_service.dart';
import 'package:greenio/src/utils/exceptions/firebase_exception.dart';
import 'package:greenio/src/utils/widgets/snackbar_helper.dart';

Future<void> signOutUser(context) async {
  try {
    await FirebaseAuthService().signOut();
  } on FirebaseAuthException catch (e) {
    SnackBarHelper.showSnackBar(context, e.getErrorMessage());    
  }
}
