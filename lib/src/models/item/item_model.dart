import 'package:cloud_firestore/cloud_firestore.dart';

class DonationItemModel {
  final String? id;
  final String category;
  final String description;
  final String imageUrl;
  final DateTime pickupDate;
  final DateTime postedTime;
  bool isCollected;

  DonationItemModel({
    this.id,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.pickupDate,
    required this.postedTime,
    this.isCollected = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'pickupDate': pickupDate,
      'postedTime': postedTime,
      'isCollected': isCollected,
    };
  }

  factory DonationItemModel.fromMap(Map<String, dynamic> map) {
    return DonationItemModel(
      id: map['id'] != null ? map['id'] as String : null,
      category: map['category'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      pickupDate: (map['pickupDate'] as Timestamp).toDate(),
      postedTime: (map['postedTime'] as Timestamp).toDate(),
      isCollected: map['isCollected'] as bool,
    );
  }
}
