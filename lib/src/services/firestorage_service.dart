import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(String path, File file) async {
    final storageRef = _storage.ref().child('images/$path');
    final uploadTask = storageRef.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } 
}
