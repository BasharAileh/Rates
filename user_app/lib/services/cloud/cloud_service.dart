// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class CloudService {
  Future<String> uploadImage(File imageFile, String shopName) async {
    try {
      print('Starting file upload...');

      if (!await imageFile.exists()) {
        print('File does not exist!');
        return '';
      }

      // Generate a unique file name using a combination of shop name and timestamp.
      String uniqueFileName =
          '${DateTime.now().millisecondsSinceEpoch}_${Uuid().v4()}.jpg';

      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('pending/$shopName/$uniqueFileName');

      print('Uploading file: ${imageFile.path}');

      await storageRef.putFile(imageFile);

      print('File uploaded successfully.');

      String downloadUrl = await storageRef.getDownloadURL();

      print('File uploaded successfully. URL: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      rethrow;
    }
  }

  Future<void> uploadUserDetails(String uid, Map<String, dynamic> data) async {
    try {
      print('Starting user details upload...');

      await FirebaseFirestore.instance.collection('pending').doc(uid).set(data);

      print('User details uploaded successfully.');
    } catch (e) {
      print('Failed to upload user details: $e');
      rethrow;
    }
  }

  Future<String> getUserType(String uid) async {
    try {
      print('Getting user type...');

      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();

      if (snapshot.exists) {
        String userType =
            (snapshot.data() as Map<String, dynamic>)['user_type'] ?? '';

        print('User type: $userType');

        return userType;
      } else {
        print('User type not found.');
        return '';
      }
    } catch (e) {
      print('Failed to get user type: $e');
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> getPendingRestaurants() {
    try {
      print('Getting pending restaurants...');

      return FirebaseFirestore.instance
          .collection('pending')
          .snapshots()
          .map((snapshot) {
        List<Map<String, dynamic>> restaurants = [];

        for (QueryDocumentSnapshot doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          restaurants.add({
            'name': doc.id,
            'image': data['image_path'],
            'status': data['status'],
          });
        }

        print('Pending restaurants: $restaurants');

        return restaurants;
      });
    } catch (e) {
      print('Failed to get pending restaurants: $e');
      rethrow;
    }
  }
}
