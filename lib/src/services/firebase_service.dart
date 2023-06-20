import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  Stream<User?> get userChanges => _firebaseAuth.userChanges();

  Future<void> registerWithEmailAndPassword({required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;
    final GoogleSignInAuthentication googleAuthentication = await googleUser.authentication;

    final googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuthentication.accessToken,
      idToken: googleAuthentication.idToken,
    );

    await _firebaseAuth.signInWithCredential(googleCredential);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }
}
