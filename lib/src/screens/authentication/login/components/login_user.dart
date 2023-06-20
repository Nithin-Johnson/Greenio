import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenio/src/services/firebase_service.dart';
import 'package:greenio/src/utils/exceptions/firebase_exception.dart';

typedef AuthCallback = void Function();
typedef SnackBarCallback = void Function(String message);

class LoginUser {
  static Future signInWithEmailAndPassword({
    required String email,
    required String password,
    required AuthCallback onSuccess,
    required SnackBarCallback onFailure,
  }) async {
    final FirebaseAuthService authService = FirebaseAuthService();
    try {
      await authService.signInWithEmailAndPassword(email: email, password: password);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onFailure(e.getErrorMessage());
    }
  }
}
