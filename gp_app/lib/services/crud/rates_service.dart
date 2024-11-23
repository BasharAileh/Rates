import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rates/services/crud/crud_exception.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;

class RatesService {
  Database? _db;

  List<DatabaseRate> _rates = [];
  final _ratesStreamController =
      StreamController<List<DatabaseRate>>.broadcast();

  Future<void> _catchRates() async {
    final allRates = await getRates();
    _rates = allRates;
    _ratesStreamController.add(_rates);
  }

  /// Helper function to get the current database instance or throw an exception
  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) throw DatabaseIsNotOpen();
    return db;
  }

  /// Open the database and initialize tables
  Future<void> open() async {
    if (_db != null) throw DatabaseAlreadyOpenException();

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(createUsersTable);
      await db.execute(createShopTable);
      await db.execute(createProductsTable);
      await db.execute(createRateTable);

      await _catchRates();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  /// Close the database connection
  Future<void> close() async {
    final db = _db;
    if (db == null) throw DatabaseIsNotOpen();
    await db.close();
    _db = null;
  }

  // ===================== USER FUNCTIONS ===================== //

  /// Create a new user
  Future<DatabaseUser> createUser(String email, String username) async {
    final db = _getDatabaseOrThrow();

    // Validate email
    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email)) {
      throw InvalidEmailFormat();
    }

    // Check if the user already exists
    final results = await db.query(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) throw UserAlreadyExists();

    // Insert the new user
    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
      usernameColumn: username,
    });

    return DatabaseUser(
        id: userId, email: email.toLowerCase(), username: username);
  }

  ///
  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on UserDoesNotExist {
      return createUser(email, email.split('@').first);
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch a user by email
  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
      limit: 1,
    );

    if (results.isEmpty) throw UserDoesNotExist();
    return DatabaseUser.fromMap(results.first);
  }

  /// Delete a user by ID
  Future<void> deleteUser(int id) async {
    final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(
      userTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount != 1) throw CouldNotDeleteUser();
  }

  // ===================== RATE FUNCTIONS ===================== //

  /// Add a new rate
  Future<DatabaseRate> addRate({
    required DatabaseUser user,
    required int productId,
    required int rate,
  }) async {
    final db = _getDatabaseOrThrow();

    // Validate rate value
    if (rate <= 1 || rate >= 5) throw InvalidRateValue();

    final dbUser = await getUser(email: user.email);
    if (dbUser != user) throw CouldNotFindUser();

    final rateId = await db.insert(rateTable, {
      userIdColumn: dbUser.id,
      productIdColumn: productId,
      rateColumn: rate,
    });

    final dbRate = DatabaseRate(
        rateId: rateId, userId: dbUser.id, productId: productId, rate: rate);

    _rates.add(dbRate);
    _ratesStreamController.add(_rates);
    return dbRate;
  }

  /// Get all rates
  Future<List<DatabaseRate>> getRates() async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(rateTable);
    return results.map((e) => DatabaseRate.fromMap(e)).toList();
  }

  /// Delete all rates
  Future<int> deleteAllRates() async {
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(rateTable);
    _rates.clear();
    _ratesStreamController.add(_rates);
    return numberOfDeletions;
  }

  Future<void> deleteRate({required int rateId}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      rateTable,
      where: 'rate_id = ?',
      whereArgs: [rateId],
    );
    if (deletedCount == 0) throw CouldNotDeleteRate();
    _rates.removeWhere((element) => element.rateId == rateId);
    _ratesStreamController.add(_rates);
  }
}

// ===================== MODELS ===================== //

@immutable
class DatabaseUser {
  final int id;
  final String email;
  final String username;

  const DatabaseUser({
    required this.id,
    required this.email,
    required this.username,
  });

  DatabaseUser.fromMap(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String,
        username = map[usernameColumn] as String;
}

class DatabaseRate {
  final int rateId;
  final int userId;
  final int productId;
  final int rate;

  DatabaseRate({
    required this.rateId,
    required this.userId,
    required this.productId,
    required this.rate,
  });

  DatabaseRate.fromMap(Map<String, Object?> map)
      : rateId = map[rateIdColumn] as int,
        userId = map[userIdColumn] as int,
        productId = map[productIdColumn] as int,
        rate = map[rateColumn] as int;
}

// ===================== CONSTANTS ===================== //

const dbName = 'rates.db';
const userTable = 'user';
const rateTable = 'rate';

const idColumn = 'id';
const emailColumn = 'email';
const usernameColumn = 'username';
const rateIdColumn = 'rate_id';
const userIdColumn = 'user_id';
const productIdColumn = 'product_id';
const rateColumn = 'rate';

const createUsersTable = '''
  CREATE TABLE IF NOT EXISTS "user" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "email" TEXT NOT NULL UNIQUE,
    "username" TEXT NOT NULL
  )
''';

const createRateTable = '''
  CREATE TABLE IF NOT EXISTS "rate" (
    "rate_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "user_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "rate" INTEGER NOT NULL,
    FOREIGN KEY("user_id") REFERENCES "user"("id")
  )
''';

const createShopsTable = '''
  CREATE TABLE IF NOT EXISTS "shops" (
    "shop_id" INTEGER NOT NULL,
    "category" TEXT NOT NULL,
    FOREIGN KEY("shop_id") REFERENCES "shop"("id")
  )
''';

const createShopTable = '''
  CREATE TABLE IF NOT EXISTS "shop" (
    "id" INTEGER,
    "shop_name" TEXT NOT NULL,
    "products_id" INTEGER NOT NULL,
    PRIMARY KEY("id")
  )
''';

const createProductsTable = '''
  CREATE TABLE IF NOT EXISTS "product" (
    "id" INTEGER,
    PRIMARY KEY("id")
  )
''';









// TODO: implement createUser

/*
 final db = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (db, version) async {
          // Create tables on first run
          await db.execute(createUsersTable);
          await db.execute(createShopTable);
          await db.execute(createProductsTable);
          await db.execute(createRateTable);
        },
      );
 */





/* import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;

class RatesService {
  Database? _db;

//database functions
  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) throw DatabaseIsNotOpen();
    return _db!;
  }

  Future<void> open() async {
    if (_db != null) throw DatabaseAlreadyOpenException();
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      // Create the user table
      await db.execute(createUsersTable);
      // Create the shops table
      await db.execute(createShopsTable);
      // Create the shop table
      await db.execute(createShopTable);
      // Create the products table
      await db.execute(createProductsTable);
      // Create the rate table
      await db.execute(createRateTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> close() async {
    if (_db == null) throw DatabaseIsNotOpen();
    await _db!.close();
    _db = null;
  }

//user functions
  Future<DatabaseUser> createUser(String email, String username) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) throw UserAlreadyExists();
    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
      usernameColumn: username.toLowerCase(),
    });
    return DatabaseUser(
      id: userId,
      email: email.toLowerCase(),
      username: username,
    );
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) throw UserDoesNotExist();
    return DatabaseUser.fromMap(results.first);
  }

  Future<void> deleteUser(int id) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

//rate functions
  Future<DatabaseRate> addRate({
    required DatabaseUser user,
    required int productId,
    required int rate,
  }) async {
    final db = _getDatabaseOrThrow();
    final dbuser = await getUser(email: user.email);

    if (dbuser != user) throw CouldNotFindUser();

    final rateId = await db.insert(rateTable, {
      idColumn: dbuser.id,
      rateColumn: rate,
      productIdColumn: productId,
    });

    return DatabaseRate(
      rateId: rateId,
      userId: dbuser.id,
      productId: productId,
      rate: rate,
    );
  }

  Future<List<DatabaseRate>> getRates() async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(rateTable);
    return results.map((e) => DatabaseRate(
          rateId: e['rate_id'] as int,
          userId: e['user_id'] as int,
          productId: e['product_id'] as int,
          rate: e['rate'] as int,
        )).toList();
  }

Future<List<DatabaseRate>> getUserRates({required DatabaseUser user})async{

  final db = _getDatabaseOrThrow();
  final dbuser = await getUser(email: user.email);
  if (dbuser != user) throw CouldNotFindUser();
  final results = await db.query(
    rateTable,
    where: 'user_id = ?',
    whereArgs: [dbuser.id],
  );
  return results.map((e) => DatabaseRate(
    rateId: e['rate_id'] as int,
    userId: e['user_id'] as int,
    productId: e['product_id'] as int,
    rate: e['rate'] as int,
  )).toList();

}

Future<DatabaseRate> getRate({required int rateId}) async {
  final db = _getDatabaseOrThrow();
  final results = await db.query(
    rateTable,
    limit: 1,
    where: 'rate_id = ?',
    whereArgs: [rateId],
  );
  if (results.isEmpty) throw CouldNotFindRate();
  return DatabaseRate(
    rateId: results.first['rate_id'] as int,
    userId: results.first['user_id'] as int,
    productId: results.first['product_id'] as int,
    rate: results.first['rate'] as int,
  );
}



//

  Future<int> deleteAllRates() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(rateTable);
  }

  Future<void> deleteRate({required int rateId}) async {
    final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(
      rateTable,
      where: 'rate_id = ?',
      whereArgs: [rateId],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteRate();
    }
  }
}

class DatabaseAlreadyOpenException implements Exception {}

class UnableToGetDocumentsDirectory implements Exception {}

class DatabaseIsNotOpen implements Exception {}

class CouldNotDeleteUser implements Exception {}

class UserAlreadyExists implements Exception {}

class UserDoesNotExist implements Exception {}

class CouldNotFindUser implements Exception {}

class CouldNotDeleteRate implements Exception {}

class CouldNotFindRate implements Exception {}

@immutable
class DatabaseUser {
  final int id;
  final String email;
  final String username;
  final String? avatarPath;
  final int? dateOfBirth;
  final Char? gender;
  const DatabaseUser({
    required this.id,
    required this.email,
    required this.username,
    this.gender,
    this.avatarPath,
    this.dateOfBirth,
  });
  DatabaseUser.fromMap(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String,
        username = map[usernameColumn] as String,
        avatarPath = map[avatarPathColumn] as String?,
        dateOfBirth = map[dateOfBirthColumn] as int?,
        gender = map[genderColumn] as Char?;

  @override
  String toString() => 'Person ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseShops {
  final int shopId;
  final String category;

  DatabaseShops({required this.shopId, required this.category});

  DatabaseShops.fromMap(Map<String, Object?> map)
      : shopId = map[shopIdColumn] as int,
        category = map[categoryColumn] as String;
  @override
  String toString() => 'Shop ID = $shopId, Category ID = $category';

  /*  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode; */
}

class DatabaseShop {
  final String id;
  final String name;
  final String product;

  DatabaseShop({
    required this.id,
    required this.name,
    required this.product,
  });

  @override
  bool operator ==(covariant DatabaseShop other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatebaseProduct {
  final String id;
  final String name;
  final String price;
  final String description;
  final String image;
  final String category;
  final String shopId;

  DatebaseProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
    required this.shopId,
  });

  @override
  bool operator ==(covariant DatebaseProduct other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseRate {
  final int rateId;
  final int userId;
  final int rate;
  final int productId;


  DatabaseRate({
    required this.rateId,
    required this.userId,
    required this.productId, 
    required this.rate,
  });

  @override
  bool operator ==(covariant DatabaseRate other) => rateId == other.rateId;

  @override
  int get hashCode => rateId.hashCode;
}

const dbName = 'rates.db';
const userTable = 'user';
const shopsTable = 'shops';
const shopTable = 'shop';
const productTable = 'products';
const rateTable = 'rate';

const idColumn = 'id';
const emailColumn = 'email';
const usernameColumn = 'username';
const rateColumn = 'rate';
const categoryColumn = 'category';
const shopIdColumn = 'shop_id';
const avatarPathColumn = 'avatar_path';
const dateOfBirthColumn = 'date_of_birth';
const genderColumn = 'gender';
const productIdColumn = 'product_id';

const createUsersTable = '''
  CREATE TABLE IF NOT EXISTS "user" (
    "user_id" INTEGER,
    "email" TEXT NOT NULL UNIQUE,
    "username" TEXT NOT NULL,
    "avatar_path" TEXT,
    "date_of_birth" INTEGER,
    "gender" INTEGER,
    PRIMARY KEY("user_id" AUTOINCREMENT)
  )
''';

const createShopsTable = '''
  CREATE TABLE IF NOT EXISTS "shops" (
    "shop_id" INTEGER NOT NULL,
    "category" TEXT NOT NULL,
    FOREIGN KEY("shop_id") REFERENCES "shop"("id")
  )
''';

const createShopTable = '''
  CREATE TABLE IF NOT EXISTS "shop" (
    "id" INTEGER,
    "shop_name" TEXT NOT NULL,
    "products_id" INTEGER NOT NULL,
    PRIMARY KEY("id")
  )
''';

const createProductsTable = '''
  CREATE TABLE IF NOT EXISTS "product" (
    "id" INTEGER,
    PRIMARY KEY("id")
  )
''';

const createRateTable = '''
  CREATE TABLE IF NOT EXISTS "rate" (
    "rate_id" INTEGER,
    "user_id" INTEGER NOT NULL,
    "product_id" INTEGER NOT NULL,
    "rate" INTEGER NOT NULL,
    PRIMARY KEY("rate_id" AUTOINCREMENT),
    FOREIGN KEY("user_id") REFERENCES "user"("user_id")
  )
''';
 */





/* Future<List<DatabaseRate>> getRates({required DatabaseUser user}) async {
    final db = _getDatabaseOrThrow();
    final dbuser = await getUser(email: user.email);
    final results = await db.query(
      rateTable,
      where: 'user_id = ?',
      whereArgs: [dbuser.id],
    );
    return results.map((e) => DatabaseRate(
      rateId: e['rate_id'] as int,
      userId: e['user_id'] as int,
      rate: e['rate'] as int,
    )).toList();
  } */



/* 
  final int id;
  final String name;
  final String location;
  final String phone;
  final String email;
  final String website;
  final String description;
  final String image;
  final String category;
  final String subcategory;
  final String rating;
  final String reviews;
  final String price;
  final String date;
  final String time;
  final String status;
  final String latitude;
  final String longitude;
  final String distance;
  final String duration;
  final String durationInTraffic;
  final String travelMode;
  final String trafficModel;
  final String departureTime;
  final String arrivalTime;
  final String origin;
  final String destination;
  final String waypoints;
  final String alternatives;
  final String optimizeWaypoints;
  final String region;
  final String language;
  final String unitSystem;
  final String avoid;
  final String travelMode2;
  final String trafficModel2;
  final String departureTime2;
  final String arrivalTime2;
  final String origin2;
  final String destination2;
  final String waypoints2;
  final String alternatives2;
  final String optimizeWaypoints2;
  final String region2;
  final String language2;
  final String unitSystem2;
  final String avoid2;
  final String travelMode3;
  final String trafficModel3;
  final String departureTime3;
  final String arrivalTime3;
  final String origin3;
  final String destination3;
  final String waypoints3;
  final String alternatives3;
  final String optimizeWaypoints3;
  final String region3;
  final String language3;
  final String unitSystem3;
  final String avoid3;
  final String travelMode4;
  final String trafficModel4;
  final String departureTime4;
  final String arrivalTime4;
  final String origin4;
  final String destination4;
  final String waypoints4;
  final String alternatives4;
  final String optimizeWaypoints4;
  final String region4;
  final String language4;
  final String unitSystem4;
  final String avoid4;
  final String travelMode5;
  final String trafficModel5;
  final String departureTime5;
  final String arrivalTime5;
  final String origin5;
  final String destination5;
  final String waypoints5;
  final String alternatives5;
  final String optimizeWaypoints5;
  final String region
   */