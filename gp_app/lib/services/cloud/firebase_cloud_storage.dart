import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rates/services/cloud/cloud_instances.dart';

class FirebaseCloudStorage {
  // Singleton instance
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  Future<String> getHttpLink(String path) async {
    try {
      // Create a reference to the file
      Reference ref = FirebaseStorage.instance.ref(path);

      // Get the download URL (HTTP link)
      String downloadUrl = await ref.getDownloadURL();

      // Print the HTTP URL
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to get HTTP link: $e');
    }
  }

  Future<String> getShopImagePath(String categoryID, String shopName) async {
    try {
      // Fetch the document by its categoryID (document ID)
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('category')
          .doc(categoryID) // Use categoryID as document ID
          .get();

      // Check if the document exists
      if (!docSnapshot.exists) {
        throw Exception("Category not found for categoryID: $categoryID");
      }

      final category = docSnapshot.data() as Map<String, dynamic>;
      final categoryName =
          category['name'] ?? ''; // Default to empty string if null
      final shopImagePath = categoryName.isEmpty
          ? ''
          : 'shops/$categoryName/$shopName/shop_images/$shopName.jpg'
              .toLowerCase();

      // Return the shop image path
      return shopImagePath;
    } catch (e) {
      throw Exception('Failed to get shop image path: $e');
    }
  }

  Future<void> addServiceRating(ServiceRating data) async {
    try {
      // Create a reference to the document
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('services').doc();

      // Update the document with the new rating
      await docRef.set(data.toMap());
    } on Error catch (e) {
      throw Exception('Failed to add service rating: $e');
    }
  }
}
