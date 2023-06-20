import 'package:firebase_auth/firebase_auth.dart';

extension FirebaseAuthExceptionExtension on FirebaseAuthException {
  String getErrorMessage() {
    switch (code) {
      case 'email-already-in-use':
        return 'An account with this email address already exists.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'operation-not-allowed':
        return 'Sorry, this email/password account is not allowed to sign in.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'user-not-found':
        return 'No account found with this email address. Please check the email address and try again.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with this email address. Please sign in using a different provider/email.';
      case 'invalid-credential':
        return 'The provided credential is invalid or has expired. Please try again.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support for assistance.';
      case 'invalid-verification-code':
        return 'The verification code provided is invalid. Please check the code and try again.';
      case 'invalid-verification-id':
        return 'The verification ID provided is invalid. Please check the ID and try again.';
      default:
        return 'Oops! Something went wrong. Please try again later.';
    }
  }
}
