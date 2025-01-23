import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CloudService {
  Future<String> uploadImage(
      File imageFile, String fileName, String shopName) async {
    try {
      print('Starting file upload...');

      // Check if the file exists
      if (!await imageFile.exists()) {
        print('File does not exist!');
        return ''; // Return early if the file doesn't exist
      }

      Reference storageRef =
          FirebaseStorage.instance.ref().child('pending/$shopName/$fileName');

      print('Uploading file: ${imageFile.path}');

      // Try to upload the file
      await storageRef.putFile(imageFile);

      // If upload succeeds, print success message
      print('File uploaded successfully.');

      // Retrieve the download URL
      String downloadUrl = await storageRef.getDownloadURL();

      // Print the download URL
      print('File uploaded successfully. URL: $downloadUrl');

      // Return the download URL
      return downloadUrl;
    } catch (e) {
      // If an error occurs, print the error message
      print('Failed to upload image: $e');
      rethrow; // Rethrow to propagate error up the stack
    }
  }
}
