import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudService {
  Future<String> uploadImage(
      File imageFile, String fileName, String shopName) async {
    try {
      print('Starting file upload...');

      if (!await imageFile.exists()) {
        print('File does not exist!');
        return '';
      }

      Reference storageRef =
          FirebaseStorage.instance.ref().child('pending/$shopName/$fileName');

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
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

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
}
