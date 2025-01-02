import 'package:rates/services/cloud/cloud_constants.dart';

class Shop {
  final String? shopID;
  final String shopName;
  final String shopLocation;
  final String categoryID;
  final String shopOwnerID;
  final String shopImagePath;
  final List<String> contactInfo;
  final double bayesianAverage;
  final String addedAt;

  Shop({
    this.shopID,
    required this.shopName,
    required this.shopLocation,
    required this.categoryID,
    required this.shopOwnerID,
    required this.shopImagePath,
    required this.contactInfo,
    required this.bayesianAverage,
    required this.addedAt,
  });

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      shopID: map[cloudShopID] ?? '',
      shopName: map[cloudShopName] ?? '',
      shopLocation: map[cloudShopLocation] ?? '',
      categoryID: map[cloudCategoryID] ?? '',
      shopOwnerID: map[cloudShopOwnerID] ?? '',
      shopImagePath: map[cloudShopImagePath] ?? '',
      contactInfo: List<String>.from(map[cloudContactInfo] ?? []),
      bayesianAverage: (map[cloudBayesianAverage] as num).toDouble() ?? 0.0,
      addedAt: map[cloudAddedAt] ?? '',
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
      cloudContactInfo: contactInfo,
      cloudContactInfo: bayesianAverage,
      cloudAddedAt: addedAt,
    };
  }

  @override
  String toString() {
    return 'Shop{shopID: $shopID, shopName: $shopName, shopLocation: $shopLocation, categoryID: $categoryID, shopOwnerID: $shopOwnerID, shopImagePath: $shopImagePath, contactInfo: $contactInfo, bayesian_average: $bayesianAverage,addedAt: $addedAt}\n\n';
  }
}

class Product {
  final String? productID;
  final String productName;
  final String productDescription;
  final String productPrice;
  final String productImagePath;
  final String shopID;
  final String addedAt;

  Product({
    this.productID,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productImagePath,
    required this.shopID,
    required this.addedAt,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productID: map[cloudProductID] ?? '',
      productName: map[cloudProductName] ?? '',
      productDescription: map[cloudProductDescription] ?? '',
      productPrice: map[cloudProductPrice] ?? '',
      productImagePath: map[cloudProductImagePath] ?? '',
      shopID: map[cloudShopID] ?? '',
      addedAt: map[cloudProductAddedAt] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      cloudProductID: productID,
      cloudProductName: productName,
      cloudProductDescription: productDescription,
      cloudProductPrice: productPrice,
      cloudProductImagePath: productImagePath,
      cloudShopID: shopID,
      cloudProductAddedAt: addedAt,
    };
  }

  @override
  String toString() {
    return 'Product{productID: $productID, productName: $productName, productDescription: $productDescription, productPrice: $productPrice, productImagePath: $productImagePath, shopID: $shopID, addedAt: $addedAt}';
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
  final String ratingValue;
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
      ratingValue: map[cloudRatingValue] ?? '',
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