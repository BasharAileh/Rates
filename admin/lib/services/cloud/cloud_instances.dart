import 'package:admin/services/cloud/cloud_constants.dart';

class Shop {
  final String? shopID;
  final String shopName;
  final String shopLocation;
  final String categoryID;
  final String shopOwnerID;
  final String shopImagePath;
  final String googleMapLink;
  final Map<String, dynamic> contactInfo;
  final String availableHours;
  final double bayesianAverage;
  final double annualBayesianAverage;
  final String addedAt;
  final Map<String, dynamic> deliveryApps;

  String description;

  Shop({
    this.shopID,
    required this.shopName,
    required this.shopLocation,
    required this.categoryID,
    required this.shopOwnerID,
    required this.shopImagePath,
    required this.googleMapLink,
    required this.contactInfo,
    required this.bayesianAverage,
    required this.annualBayesianAverage,
    required this.description,
    required this.addedAt,
    required this.availableHours,
    required this.deliveryApps,
  });

  factory Shop.fromMap(Map<String, dynamic> map, {String? shopID}) {
    return Shop(
      shopID: shopID,
      shopName: map[cloudShopName] ?? '',
      shopLocation: map[cloudShopLocation] ?? '',
      categoryID: map[cloudCategoryID] ?? '',
      shopOwnerID: map[cloudShopOwnerID] ?? '',
      shopImagePath: map[cloudShopImagePath] ?? '',
      googleMapLink: map[cloudGoogleMapLink] ?? '',
      contactInfo: map[cloudContactInfo] is Map<String, dynamic>
          ? map[cloudContactInfo]
          : {},
      bayesianAverage: (map[cloudBayesianAverage] ?? 0.0 as num).toDouble(),
      annualBayesianAverage:
          (map[cloudAnnualBayesianAverage] ?? 0.0 as num).toDouble(),
      description: map[cloudShopDescription] ?? '',
      addedAt: map[cloudAddedAt] ?? '',
      availableHours: map[cloudAvailableHours] ?? '',
      deliveryApps: map[cloudDeliveryApps] is Map<String, dynamic>
          ? map[cloudDeliveryApps]
          : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      cloudShopID: shopID,
      cloudShopName: shopName,
      cloudShopLocation: shopLocation,
      cloudCategoryID: categoryID,
      cloudShopOwnerID: shopOwnerID,
      cloudShopImagePath: shopImagePath,
      cloudGoogleMapLink: googleMapLink,
      cloudContactInfo: contactInfo,
      cloudBayesianAverage: bayesianAverage,
      cloudAnnualBayesianAverage: annualBayesianAverage,
      cloudShopDescription: description,
      cloudAddedAt: addedAt,
      cloudAvailableHours: availableHours,
      cloudDeliveryApps: deliveryApps,
    };
  }

  String get imagePath => shopImagePath;

  @override
  String toString() {
    return 'Shop{shopID: $shopID, shopName: $shopName, shopLocation: $shopLocation, categoryID: $categoryID, shopOwnerID: $shopOwnerID, shopImagePath: $shopImagePath, googleMapLink: $googleMapLink, contactInfo: $contactInfo, bayesianAverage: $bayesianAverage, annualBayesianAverage: $annualBayesianAverage, description: $description, addedAt: $addedAt, availableHours: $availableHours, deliveryApps: $deliveryApps}';
  }
}

class FireStoreUser {
  final String email;
  final String id;
  final bool isAnonymous;
  final bool isEmailVerified;
  final String numberOfRatings;
  final String profileImageURL;
  final String userName;
  final Map<String, dynamic> ratings;

  FireStoreUser({
    required this.email,
    required this.id,
    required this.isAnonymous,
    required this.isEmailVerified,
    required this.numberOfRatings,
    required this.profileImageURL,
    required this.userName,
    required this.ratings,
  });

  factory FireStoreUser.fromMap(Map<String, dynamic> map, {String? id}) {
    return FireStoreUser(
      email: map[cloudEmail] ?? '',
      id: id ?? '',
      isAnonymous: map[cloudIsAnonymous] ?? true,
      isEmailVerified: map[cloudIsEmailVerified] ?? false,
      numberOfRatings: map[cloudNumberOfRatings]?.toString() ?? '',
      profileImageURL: map[cloudProfileImageURL] ?? 'default_image_url',
      userName: map[cloudUserName] ?? '',
      ratings:
          map[cloudRatings] is Map<String, dynamic> ? map[cloudRatings] : {},
    );
  }

  String get imagePath => profileImageURL;

  @override
  String toString() {
    return 'FireStoreUser{email: $email, id: $id, isAnonymous: $isAnonymous, isEmailVerified: $isEmailVerified, numberOfRatings: $numberOfRatings, profileImageURL: $profileImageURL, userName: $userName, ratings: $ratings}';
  }
}

class Product {
  final String? productID;
  final String productName;
  final String productDescription;
  final String productPrice;
  final String productImagePath;
  final String categoryID;
  final double bayesianAverage;
  final double numberOfRatings;
  final double productAverageRating;
  final String shopID;
  final String addedAt;

  Product({
    this.productID,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productImagePath,
    required this.bayesianAverage,
    required this.numberOfRatings,
    required this.productAverageRating,
    required this.categoryID,
    required this.shopID,
    required this.addedAt,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productID: map[cloudProductID] as String?,
      productName: map[cloudProductName] ?? '',
      productDescription: map[cloudProductDescription] ?? '',
      productPrice: map[cloudProductPrice]?.toString() ?? '0',
      productImagePath: map[cloudProductImagePath] ?? '',
      bayesianAverage: (map[cloudBayesianAverage] is num)
          ? (map[cloudBayesianAverage] as num).toDouble()
          : double.tryParse(map[cloudBayesianAverage]?.toString() ?? '0') ??
              0.0,
      numberOfRatings: (map[cloudNumberOfRatings] is num)
          ? (map[cloudNumberOfRatings] as num).toDouble()
          : double.tryParse(map[cloudNumberOfRatings]?.toString() ?? '0') ??
              0.0,
      productAverageRating: (map[cloudproductAverageRating] is num)
          ? (map[cloudproductAverageRating] as num).toDouble()
          : double.tryParse(
                  map[cloudproductAverageRating]?.toString() ?? '0') ??
              0.0,
      categoryID: map[cloudCategoryID] ?? '',
      shopID: map[cloudShopID] ?? '',
      addedAt: map[cloudAddedAt] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      cloudProductID: productID,
      cloudProductName: productName,
      cloudProductDescription: productDescription,
      cloudProductPrice: productPrice,
      cloudProductImagePath: productImagePath,
      cloudProductImagePath: bayesianAverage,
      cloudNumberOfRatings: numberOfRatings,
      cloudShopID: shopID,
      cloudProductAddedAt: addedAt,
    };
  }

  @override
  String toString() {
    return 'Product{productID: $productID, productName: $productName, productDescription: $productDescription, productPrice: $productPrice, productImagePath: $productImagePath, bayesianAverage: $bayesianAverage,numberOfRatings: $numberOfRatings, shopID: $shopID, addedAt: $addedAt}';
  }
}

class Service {
  final String? serviceID;
  final String serviceName;
  final String serviceDescription;
  final String servicePrice;
  final String serviceDuration;
  final String shopID;
  final String serviceImagePath;
  final String addedAt;

  Service({
    this.serviceID,
    required this.serviceName,
    required this.serviceDescription,
    required this.servicePrice,
    required this.serviceDuration,
    required this.shopID,
    required this.serviceImagePath,
    required this.addedAt,
  });

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      serviceID: map[cloudServiceID] ?? '',
      serviceName: map[cloudServiceName] ?? '',
      serviceDescription: map[cloudServiceDescription] ?? '',
      servicePrice: map[cloudServicePrice] ?? '',
      serviceDuration: map[cloudServiceDuration] ?? '',
      shopID: map[cloudShopID] ?? '',
      serviceImagePath: map[cloudServiceImagePath] ?? '',
      addedAt: map[cloudServiceAddedAt] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      cloudServiceID: serviceID,
      cloudServiceName: serviceName,
      cloudServiceDescription: serviceDescription,
      cloudServicePrice: servicePrice,
      cloudServiceDuration: serviceDuration,
      cloudShopID: shopID,
      cloudServiceImagePath: serviceImagePath,
      cloudServiceAddedAt: addedAt,
    };
  }

  @override
  String toString() {
    return 'Service{id: $serviceID, serviceName: $serviceName, serviceDescription: $serviceDescription, servicePrice: $servicePrice, serviceDuration: $serviceDuration, shopID: $shopID, serviceImagePath: $serviceImagePath, addedAt: $addedAt}';
  }
}

class ProductRating {
  final String? productRatingID;
  final String userID;
  final String shopID;
  final String productID;
  final double ratingValue;
  final String ratingText;
  final String addedAt;
  final String updatedAt;

  ProductRating({
    this.productRatingID,
    required this.userID,
    required this.shopID,
    required this.productID,
    required this.ratingValue,
    required this.ratingText,
    required this.addedAt,
    required this.updatedAt,
  });

  factory ProductRating.fromMap(Map<String, dynamic> map) {
    return ProductRating(
      productRatingID: map[cloudProductRatingID] ?? '',
      userID: map[cloudUserID] ?? '',
      shopID: map[cloudShopID] ?? '',
      productID: map[cloudProductID] ?? '',
      ratingValue: (map[cloudRatingValue] as num).toDouble(),
      ratingText: map[cloudRatingText] ?? '',
      addedAt: map[cloudAddedAt] ?? '',
      updatedAt: map[cloudAddedAt] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      cloudProductRatingID: productRatingID,
      cloudUserID: userID,
      cloudShopID: shopID,
      cloudProductID: productID,
      cloudRatingValue: ratingValue,
      cloudRatingText: ratingText,
      cloudAddedAt: addedAt,
      cloudAddedAt: updatedAt,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductRating &&
        other.ratingValue == ratingValue &&
        other.userID == userID &&
        other.shopID == shopID &&
        other.productID == productID;
  }

  @override
  int get hashCode =>
      ratingValue.hashCode ^
      userID.hashCode ^
      shopID.hashCode ^
      productID.hashCode;

  @override
  String toString() {
    return 'ProductRating{id: $productRatingID, userID: $userID, shopID: $shopID, productID: $productID, ratingValue: $ratingValue, ratingText: $ratingText, addedAt: $addedAt, updatedAt: $updatedAt}';
  }
}

class ServiceRating {
  final String? serviceRatingID;
  final String userID;
  final String shopID;
  final String serviceID;
  final String ratingValue;
  final String ratingText;
  final String addedAt;
  final String updatedAt;

  ServiceRating({
    this.serviceRatingID,
    required this.userID,
    required this.shopID,
    required this.serviceID,
    required this.ratingValue,
    required this.ratingText,
    required this.addedAt,
    required this.updatedAt,
  });

  factory ServiceRating.fromMap(Map<String, dynamic> map) {
    return ServiceRating(
      serviceRatingID: map[cloudServiceRatingID] ?? '',
      userID: map[cloudUserID] ?? '',
      shopID: map[cloudShopID] ?? '',
      serviceID: map[cloudServiceID] ?? '',
      ratingValue: map[cloudRatingValue] ?? '',
      ratingText: map[cloudRatingText] ?? '',
      addedAt: map[cloudAddedAt] ?? '',
      updatedAt: map[cloudAddedAt] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      cloudServiceRatingID: serviceRatingID,
      cloudUserID: userID,
      cloudShopID: shopID,
      cloudServiceID: serviceID,
      cloudRatingValue: ratingValue,
      cloudRatingText: ratingText,
      cloudAddedAt: addedAt,
      cloudAddedAt: updatedAt,
    };
  }

  @override
  String toString() {
    return 'ServiceRating{id: $serviceRatingID, userID: $userID, shopID: $shopID, serviceID: $serviceID, ratingValue: $ratingValue, ratingText: $ratingText, addedAt: $addedAt, updatedAt: $updatedAt}';
  }
}

class ShopDelivery {
  final String shopDeliveryID;
  final String shopDeliveryName;
  final List<String>? appID;

  ShopDelivery({
    required this.shopDeliveryID,
    required this.shopDeliveryName,
    required this.appID,
  });

  factory ShopDelivery.fromMap(Map<String, dynamic> map) {
    return ShopDelivery(
      shopDeliveryID: map[cloudShopDeliveryID] ?? '',
      shopDeliveryName: map[cloudShopDeliveryName] ?? '',
      appID: List<String>.from(map[cloudAppID] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      cloudShopDeliveryID: shopDeliveryID,
      cloudShopDeliveryName: shopDeliveryName,
      cloudAppID: appID,
    };
  }
}

class DeliveryApps {
  final String deliveryAppsID;
  final String deliveryAppName;
  final String websiteURL;
  final String logoPath;
  final String addedAt;

  DeliveryApps({
    required this.deliveryAppsID,
    required this.deliveryAppName,
    required this.websiteURL,
    required this.logoPath,
    required this.addedAt,
  });

  factory DeliveryApps.fromMap(Map<String, dynamic> map) {
    return DeliveryApps(
      deliveryAppsID: map[cloudDeliveryAppsID] ?? '',
      deliveryAppName: map[cloudDeliveryAppName] ?? '',
      websiteURL: map[cloudWebsiteURL] ?? '',
      logoPath: map[cloudLogoPath] ?? '',
      addedAt: map[cloudAddedAt] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      cloudDeliveryAppsID: deliveryAppsID,
      cloudDeliveryAppName: deliveryAppName,
      cloudWebsiteURL: websiteURL,
      cloudLogoPath: logoPath,
      cloudAddedAt: addedAt,
    };
  }

  @override
  String toString() {
    return 'DeliveryApps{id: $deliveryAppsID, deliveryAppName: $deliveryAppName, websiteURL: $websiteURL, logoPath: $logoPath, addedAt: $addedAt}';
  }
}

class ContactInfo {
  final String shopID;
  final String contactType;

  ContactInfo({
    required this.shopID,
    required this.contactType,
  });

  factory ContactInfo.fromMap(Map<String, dynamic> map) {
    return ContactInfo(
      shopID: map[cloudShopID] ?? '',
      contactType: map[cloudContactType] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      cloudShopID: shopID,
      cloudContactType: contactType,
    };
  }

  @override
  String toString() {
    return 'ContactInfo{shopID: $shopID, contactType: $contactType}';
  }
}

class ContactType {
  final String contactTypeID;
  final String contactName;
  final String value;

  ContactType({
    required this.contactTypeID,
    required this.contactName,
    required this.value,
  });

  factory ContactType.fromMap(Map<String, dynamic> map) {
    return ContactType(
      contactTypeID: map[cloudContactTypeID] ?? '',
      contactName: map[cloudContactName] ?? '',
      value: map[cloudContactValue] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      cloudContactTypeID: contactTypeID,
      cloudContactName: contactName,
      cloudContactValue: value,
    };
  }

  @override
  String toString() {
    return 'ContactType{id: $contactTypeID, contactName: $contactName, value: $value}';
  }
}
/* 

Shop shop = Shop(
                                    shopName: 'shop1',
                                    categoryID: '10',
                                    shopLocation: 'new york',
                                    shopOwnerID: 'owner1',
                                    shopImagePath: 'shop1.jpg',
                                    contactInfo: ['1234567890'],
                                    addedAt: 'Timestamp.now()',
                                  );
                                  print(shop);
                                  print('\n\n\n');
                                  Product product = Product(
                                    productID: 'product1',
                                    productName: 'product1',
                                    productDescription: 'product1',
                                    productPrice: '100',
                                    productImagePath: 'product1.jpg',
                                    shopID: 'shop1',
                                    addedAt: 'Timestamp.now()',
                                  );
                                  print(product);
                                  print('\n\n\n');
                                  Service service = Service(
                                    serviceID: 'service1',
                                    serviceName: 'service1',
                                    serviceDescription: 'service1',
                                    servicePrice: '100',
                                    serviceDuration: '1',
                                    shopID: 'shop1',
                                    serviceImagePath: 'service1.jpg',
                                    addedAt: 'Timestamp.now()',
                                  );
                                  print(service);
                                  print('\n\n\n');
                                  ProductRating productRating = ProductRating(
                                    productRatingID: 'productRating1',
                                    userID: 'user1',
                                    productID: 'product1',
                                    ratingValue: '5',
                                    ratingText: 'good',
                                    shopID: 'shop1',
                                    addedAt: 'Timestamp.now()',
                                    updatedAt: 'Timestamp.now()',
                                  );
                                  print(productRating);
                                  print('\n\n\n');
                                  ServiceRating serviceRating = ServiceRating(
                                    serviceRatingID: 'serviceRating1',
                                    userID: 'user1',
                                    serviceID: 'service1',
                                    ratingValue: '5',
                                    ratingText: 'good',
                                    shopID: 'shop1',
                                    addedAt: 'Timestamp.now()',
                                    updatedAt: 'Timestamp.now()',
                                  );
                                  print(serviceRating);
                                  print('\n\n\n');
                                  ShopDelivery shopDelivery = ShopDelivery(
                                    shopDeliveryID: 'delivery1',
                                    shopDeliveryName: 'Fast Delivery',
                                    appID: ['app1', 'app2'],
                                  );
                                  print(shopDelivery);
                                  print('\n\n\n');
                                  DeliveryApps deliveryApps = DeliveryApps(
                                    deliveryAppsID: 'app1',
                                    deliveryAppName: 'QuickShip',
                                    websiteURL: 'https://quickship.com',
                                    logoPath: 'quickship_logo.jpg',
                                    addedAt: 'Timestamp.now()',
                                  );
                                  print(deliveryApps);
                                  print('\n\n\n');
                                  ContactInfo contactInfo = ContactInfo(
                                    shopID: 'shop1',
                                    contactType: 'Phone',
                                  );
                                  print(contactInfo);
                                  print('\n\n\n');
                                  ContactType contactType = ContactType(
                                    contactTypeID: 'type1',
                                    contactName: 'Phone',
                                    value: '1234567890',
                                  );
                                  print(contactType);
                                  print('\n\n\n');
                                  
 */
