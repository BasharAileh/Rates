import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class Shop {
  final String shopID;
  final String shopName;
  final String shopLocation;
  final String phoneNumber;
  final String shopOwnerEmail;
  final String categoryID;
  final String shopOwnerID;
  final String shopImagePath;
  final String addedAt;

  Shop({
    required this.shopID,
    required this.shopName,
    required this.shopLocation,
    required this.phoneNumber,
    required this.shopOwnerEmail,
    required this.categoryID,
    required this.shopOwnerID,
    required this.shopImagePath,
    required this.addedAt,
  });

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      shopID: map['shopID'] ?? '',
      shopName: map['shopName'] ?? '',
      shopLocation: map['shopLocation'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      shopOwnerEmail: map['shopOwnerEmail'] ?? '',
      categoryID: map['categoryID'] ?? '',
      shopOwnerID: map['shopOwnerID'] ?? '',
      shopImagePath: map['shopImagePath'] ?? '',
      addedAt: map['addedAt'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Shop{shopID: $shopID, shopName: $shopName, shopLocation: $shopLocation, phoneNumber: $phoneNumber, shopOwnerEmail: $shopOwnerEmail, categoryID: $categoryID, shopOwnerID: $shopOwnerID, shopImagePath: $shopImagePath, addedAt: $addedAt}';
  }
}
