import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenio/src/models/item/item_model.dart';
import 'package:greenio/src/models/user/user_model.dart';
import 'package:greenio/src/models/ward_schedule/ward_schedule_model.dart';
import 'package:greenio/src/services/firebase_service.dart';

class FirestoreService {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final CollectionReference<Map<String, dynamic>> _usersCollectionRef = FirebaseFirestore.instance.collection('Users');
  final CollectionReference<Map<String, dynamic>> _wardSchedulesCollectionRef =
      FirebaseFirestore.instance.collection('WardSchedule');

  static final FirestoreService _instance = FirestoreService._();
  factory FirestoreService() => _instance;
  FirestoreService._();

  String get currentUserId => _authService.currentUser!.uid;
  CollectionReference<Map<String, dynamic>> get userCollectionRef => _usersCollectionRef;
  CollectionReference<Map<String, dynamic>> get wardSchedulesCollectionRef => _wardSchedulesCollectionRef;

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsersQuerySnapshot() {
    return _usersCollectionRef.snapshots();
  }

  Future<void> addUserDocToDatabase(UserModel user) async {
    await _usersCollectionRef.doc(currentUserId).set(user.toMap());
  }

  Future<void> updateUserProfile(UserModel userProfile) async {
    await _usersCollectionRef.doc(currentUserId).update(userProfile.toMap());
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStreamDocSnapshot() {
    final userStreamSnapshot = _usersCollectionRef.doc(currentUserId).snapshots();
    return userStreamSnapshot;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserFutureDocSnapshot() async {
    final userFutureSnapshot = await _usersCollectionRef.doc(currentUserId).get();
    return userFutureSnapshot;
  }

  Future<void> addUserItemToDatabase(DonationItemModel donatedItem) async {
    final itemRef = _usersCollectionRef.doc(currentUserId).collection('Items');
    final itemDocRef = await itemRef.add(donatedItem.toMap());
    await itemDocRef.update({'id': itemDocRef.id});
  }

  CollectionReference<Map<String, dynamic>> getUserItemCollectionRef() {
    return _usersCollectionRef.doc(currentUserId).collection('Items');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserDonatedItemQuerySnapshot() {
    return _usersCollectionRef.doc(currentUserId).collection('Items').snapshots();
  }

  Future<void> deleteItem(DonationItemModel item) async {
    await _usersCollectionRef.doc(currentUserId).collection('Items').doc(item.id).delete();
  }

  Future<void> addWardScheduleToDatabase(WardScheduleModel wardSchedule) async {
    await _wardSchedulesCollectionRef.doc(wardSchedule.wardNumber).set(wardSchedule.toMap());
  }

  Future<void> addWardScheduleAssignedDatesToDatabase(String wardNumber, Map<String, DateTime?> selectedDates) async {
    await _wardSchedulesCollectionRef.doc(wardNumber).update({
      'selectedDates': selectedDates,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getWardStreamQuerySnapshot() {
    final wardStreamQuerySnapshot = _wardSchedulesCollectionRef.snapshots();
    return wardStreamQuerySnapshot;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getWardStreamDocSnapshot(String wardNumber) {
    final wardStreamDocSnapshot = _wardSchedulesCollectionRef.doc(wardNumber).snapshots();
    return wardStreamDocSnapshot;
  }

}
