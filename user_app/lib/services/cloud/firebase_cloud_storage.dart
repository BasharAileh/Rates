import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rates/services/auth/auth_user.dart';
import 'package:rates/services/cloud/cloud_instances.dart';
import 'package:rates/services/cloud/cloud_storage_exception.dart';
import 'package:http/http.dart' as http;

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

  Future<String> getCategoryID(String categoryName) async {
    try {
      // Fetch the document by its categoryName
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('category')
          .where('name', isEqualTo: categoryName.toLowerCase())
          .get();

      // Check if the document exists
      if (querySnapshot.docs.isEmpty) {
        throw CategoryNotFoundException();
      }

      final category = querySnapshot.docs.first;
      final categoryID = category.id;

      // Return the category ID
      return categoryID;
    } catch (e) {
      throw CategoryNotFoundException();
    }
  }

  Future<QuerySnapshot> getLimitedShops(int limit, String categoryID) async {
    try {
      // Fetch the documents by categoryID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('shops')
          .where('category_id', isEqualTo: categoryID)
          .limit(limit)
          .get();

      // Check if the documents exist
      if (querySnapshot.docs.isEmpty) {
        throw Exception('No shops found for categoryID: $categoryID');
      }

      // Return the querySnapshot
      return querySnapshot;
    } catch (e) {
      throw CategoryNotFoundException();
    }
  }

  Future<void> addUserData(AuthUser user) async {
    try {
      // Create a reference to the document
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc(user.id);

      // Update the document with the new user data
      await docRef.set(user.toMap());
    } on Error catch (e) {
      throw Exception('Failed to add user data: $e');
    }
  }

  Future<void> insertDocument(String collection, Map<String, dynamic> data,
      {String? id}) async {
    try {
      id == null
          ? await FirebaseFirestore.instance.collection(collection).add(data)
          : await FirebaseFirestore.instance
              .collection(collection)
              .doc(id)
              .set(data);
    } catch (_) {
      throw CouldNotInsertDoc();
    }
  }

  Future<AuthUser> getUserInfo(String id) async {
    try {
      // Fetch the document by its ID
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance.collection('user').doc(id).get();

      // Check if the document exists
      if (!docSnapshot.exists) {
        throw Exception('User not found for ID: $id');
      }

      AuthUser user =
          AuthUser.fromMap(docSnapshot.data() as Map<String, dynamic>);

      // Return the email
      return user;
    } catch (e) {
      throw Exception('Failed to get user info: $e');
    }
  }

  Future<Shop> getShopInfo(String shopID) async {
    try {
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance.collection('shop').doc(shopID).get();

      if (!docSnapshot.exists) {
        throw Exception('Shop not found for shopID: $shopID');
      }
      Shop shop = Shop.fromMap(docSnapshot.data() as Map<String, dynamic>);

      return shop;
    } catch (e) {
      throw Exception('Failed to get shop info: $e');
    }
  }

  Stream<DocumentSnapshot> getUserStream(String id) {
    return FirebaseFirestore.instance.collection('user').doc(id).snapshots();
  }

  Future<Map<String, dynamic>> getReceiptInfo(String receiptID) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('receipt')
          .doc(receiptID)
          .get();

      if (!docSnapshot.exists) {
        throw Exception('Receipt not found for shopID: $receiptID');
      }

      final receipt = docSnapshot.data() as Map<String, dynamic>;

      return receipt;
    } catch (e) {
      throw Exception('Failed to get receipt info: $e');
    }
  }

  Future<bool> isImageAvailable(String url) async {
    try {
      final response = await http.head(Uri.parse(url));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String> getProductID(String productName, String shopID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('product')
          .where('product_name', isEqualTo: productName)
          .where('shop_id', isEqualTo: shopID)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Product not found for productName: $productName');
      }

      final product = querySnapshot.docs.first;
      final productID = product.id;

      return productID;
    } catch (e) {
      throw Exception('Failed to get product ID: $e');
    }
  }

  Future<Product> getProductInfo(String productID) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('product')
          .doc(productID)
          .get();

      if (!docSnapshot.exists) {
        throw Exception('Product not found for productID: $productID');
      }

      Product product =
          Product.fromMap(docSnapshot.data() as Map<String, dynamic>);

      return product;
    } catch (e) {
      throw Exception('Failed to get product info: $e');
    }
  }

  Future<bool> incrementUserCategoryRatings(String userID, String categoryID,
      {int? increment = 1}) async {
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('user').doc(userID);

      DocumentSnapshot docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw Exception('User not found for userID: $userID');
      }

      final user = docSnapshot.data() as Map<String, dynamic>;

      user['ratings'][categoryID] = user['ratings'][categoryID] + increment;

      await docRef.set(
        user,
        SetOptions(merge: true),
      );

      return true;
    } catch (e) {
      throw Exception('Failed to increment user category ratings: $e');
    }
  }
}
