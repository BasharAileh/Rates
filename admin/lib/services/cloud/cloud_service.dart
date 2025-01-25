// ignore_for_file: avoid_print

import 'dart:io';
import 'package:admin/services/auth/auth_service.dart';
import 'package:admin/services/cloud/cloud_instances.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class CloudService {
  Future<String> uploadPendingImage(File imageFile, String shopName) async {
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
          .child('pending/$shopName/shop_images/$shopName.jpg');

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

  Future<void> moveFolder(String sourceFolder, String destinationFolder) async {
    try {
      print('Moving folder...');

      final sourceRef = FirebaseStorage.instance.ref(sourceFolder);

      final ListResult result = await sourceRef.listAll();

      for (final fileRef in result.items) {
        final fullPath = fileRef.fullPath;

        final fileName = fullPath.split('/').last;

        final destinationPath = '$destinationFolder/$fileName';

        final fileBytes = await fileRef.getData();
        if (fileBytes != null) {
          await FirebaseStorage.instance
              .ref(destinationPath)
              .putData(fileBytes);
          print('Copied: $fullPath to $destinationPath');
        }

        await fileRef.delete();
        print('Deleted: $fullPath');
      }

      // Optionally: Delete the source folder (Firebase Storage does not have actual folders)
      print('Folder moved successfully!');
    } catch (e) {
      print('Failed to move folder: $e');
      rethrow;
    }
  }

  Future<void> moveFile(String oldPath, String newPath) async {
    try {
      final oldFileRef = FirebaseStorage.instance.ref(oldPath);

      final fileData = await oldFileRef.getData();

      if (fileData == null) {
        throw Exception('File not found at $oldPath');
      }

      final newFileRef = FirebaseStorage.instance.ref(newPath);

      await newFileRef.putData(fileData);

      await oldFileRef.delete();

      print('File moved successfully from $oldPath to $newPath');
    } catch (e) {
      print('Failed to move file: $e');
    }
  }

  Future<String> uploadShopImage(File imageFile, Shop shopData) async {
    try {
      print('Starting file upload...');

      if (!await imageFile.exists()) {
        print('File does not exist!');
        return '';
      }

      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('shops/${getCategoryId(
            shopData.categoryID,
          )}/${shopData.shopName}/shop_images/${shopData.shopName}_logo.jpg');

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
          data['doc_id'] = doc.id;
          restaurants.add(data);
        }

        print('Pending restaurants: $restaurants');

        return restaurants;
      });
    } catch (e) {
      print('Failed to get pending restaurants: $e');
      rethrow;
    }
  }

  Future<String> getCategoryId(String categoryName) async {
    try {
      // Fetch the document by its categoryName
      print(categoryName);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('category')
          .where('name', isEqualTo: categoryName.toLowerCase())
          .get();

      // Check if the document exists
      if (querySnapshot.docs.isEmpty) {
        throw Exception('Category not found with name $categoryName');
      }

      final category = querySnapshot.docs.first;
      final categoryID = category.id;

      // Return the category ID
      return categoryID;
    } catch (e) {
      throw Exception('Failed to get category ID: $e');
    }
  }

  Future<String> getCategoryName(String? catName) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('category')
          .doc(catName)
          .get();

      if (!documentSnapshot.exists) {
        throw Exception('Category not found with ID $catName');
      }

      final category = documentSnapshot.data();
      final categoryName = (category as Map<String, dynamic>?)?['name'] ?? '';

      return categoryName;
    } catch (e) {
      throw Exception('Failed to get category ID: $e');
    }
  }

  Future<String> getProductCategoryName(String productCategoryID) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('product_category')
          .doc(productCategoryID)
          .get();

      if (!documentSnapshot.exists) {
        throw Exception('Category not found with ID $productCategoryID');
      }

      final category = documentSnapshot.data();
      final categoryName = (category as Map<String, dynamic>?)?['name'] ?? '';

      return categoryName;
    } catch (e) {
      throw Exception('Failed to get category ID: $e');
    }
  }

  Future<String> getProductCategoryId(String categoryName) async {
    try {
      // Fetch the document by its categoryName
      print(categoryName);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('product_category_id')
          .where('name', isEqualTo: categoryName.toLowerCase())
          .get();

      // Check if the document exists
      if (querySnapshot.docs.isEmpty) {
        throw Exception('Category not found with name $categoryName');
      }

      final category = querySnapshot.docs.first;
      final categoryID = category.id;

      // Return the category ID
      return categoryID;
    } catch (e) {
      throw Exception('Failed to get category ID: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getShopsByCategory(
      String categoryPrefix) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('shop').get();

      // Filter documents by ID prefix
      final shops = querySnapshot.docs
          .where((doc) => doc.id.startsWith(categoryPrefix))
          .map((doc) => {
                'id': doc.id, // Add document ID
                'data': doc.data(), // Add document data
              })
          .toList();

      if (shops.isEmpty) {
        throw Exception(
            'No shops found with document name prefix $categoryPrefix');
      }

      return shops;
    } catch (e) {
      throw Exception('Failed to get shops by document name prefix: $e');
    }
  }

  Future<void> uploadShopData(
      {required Map<String, dynamic> shopData,
      required String category}) async {
    try {
      print('Starting shop data upload...');

      String? documentID;
      await getCategoryId(category).then(
        (categoryID) {
          shopData['category_id'] = categoryID;
          getShopsByCategory(categoryID).then(
            (shops) {
              String shop = shops.last['id'];

              int shopNumber = int.parse(shop.split(categoryID).last);
              shopNumber++;

              documentID =
                  '$categoryID${shopNumber.toString().padLeft(6, '0')}';
              shopData.remove('shop_id');
              return FirebaseFirestore.instance
                  .collection('shop')
                  .doc(documentID)
                  .set(shopData);
            },
          );
        },
      );
    } catch (e) {
      print('Failed to upload shop data: $e');
      rethrow;
    }
  }

  Future<void> deletePendingRestaurant(String documentID) async {
    try {
      print('Deleting pending restaurant...');

      await FirebaseFirestore.instance
          .collection('pending')
          .doc(documentID)
          .delete();

      print('Pending restaurant deleted successfully.');
    } catch (e) {
      print('Failed to delete pending restaurant: $e');
      rethrow;
    }
  }

  Future<Shop> getShopInfoByOwnerID(String ownerID) {
    try {
      print('Getting shop info by owner ID...');

      return FirebaseFirestore.instance
          .collection('shop')
          .where('owner_id', isEqualTo: ownerID)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          throw Exception('Shop not found');
        }

        final shopData = querySnapshot.docs.first.data();
        final shopID = querySnapshot.docs.first.id;

        return Shop.fromMap(shopData, shopID: shopID);
      });
    } catch (e) {
      throw Exception('Failed to get shop info by owner ID: $e');
    }
  }

  Future<void> updateShopInfo(
      {required String shopName,
      required String description,
      required String imagePath,
      required String shopLocation,
      required Map<String, String> contactInfo,
      required String availableHours,
      required Map<String, String> deliveryApps,
      required Map<String, String> socialLinks}) {
    try {
      print('Updating shop info...');

      return FirebaseFirestore.instance
          .collection('shop')
          .where('name', isEqualTo: shopName)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          throw Exception('Shop not found');
        }

        final shopID = querySnapshot.docs.first.id;

        return FirebaseFirestore.instance
            .collection('shop')
            .doc(shopID)
            .update({
          'description': description,
          'image': imagePath,
          'location': shopLocation,
          'contact_info': contactInfo,
          'available_hours': availableHours,
          'delivery_apps': deliveryApps,
          'social_links': socialLinks,
        });
      });
    } catch (e) {
      throw Exception('Failed to update shop info: $e');
    }
  }

  Future<void> addProduct({
    required Map<String, dynamic> data,
    required String productID,
  }) {
    try {
      print('Adding product...');

      return FirebaseFirestore.instance
          .collection('products')
          .doc(productID)
          .set(data);
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<String?> createProductId(String shopID, String categoryID) async {
    try {
      print('Creating product ID...');

      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('shop_id', isEqualTo: shopID)
          .where('category', isEqualTo: categoryID)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return '$shopID-$categoryID-1';
      }

      final products = querySnapshot.docs;

      final lastProduct = products.last;
      final lastProductID = lastProduct.id;

      final lastProductNumber = int.parse(lastProductID.split('-').last);
      final newProductNumber = lastProductNumber + 1;

      return '$shopID-$categoryID-$newProductNumber';
    } catch (e) {
      throw Exception('Failed to create product ID: $e');
    }
  }

  Future<String> getOwnerIdByEmail(email) {
    try {
      print('Getting shop info by owner email...');

      return FirebaseFirestore.instance
          .collection('shop')
          .where('contact_info.email', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          throw Exception('Shop not found');
        }

        final shop = querySnapshot.docs.first.data();
        final ownerID = shop['owner_id'];

        return ownerID;
      });
    } catch (e, stackTrace) {
      print('Failed to get shop info by owner email: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to get shop info by owner email: $e');
    }
  }
}
