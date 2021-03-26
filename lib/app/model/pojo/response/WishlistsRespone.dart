import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';

class WishlistsRespone {
  List<DataWishlists> data;
  int total;

  WishlistsRespone({this.data, this.total = 0});

  WishlistsRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataWishlists>[];
      json['data'].forEach((v) {
        data.add(new DataWishlists.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class DataWishlists {
  int id;
  int inventoryId;
  int productId;
  Product product;

  DataWishlists({this.id, this.inventoryId, this.productId, this.product});

  DataWishlists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    inventoryId = json['inventoryId'];
    productId = json['productId'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['inventoryId'] = this.inventoryId;
    data['productId'] = this.productId;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class Product {
  int id;
  int shopId;
  int manufacturerId;
  String brand;
  String name;
  String description;
  int minPrice;
  int maxPrice;
  int salePrice;
  int offerPrice;
  int originCountry;
  int hasVariant;
  int requiresShipping;
  String downloadable;
  String slug;
  int saleCount;
  List<Inventories> inventories;
  List<ProductImage> image;
  int discountPercent;
  int rating;
  double reviewCount;

  Product(
      {this.id,
      this.shopId,
      this.manufacturerId,
      this.brand,
      this.name,
      this.description,
      this.minPrice,
      this.maxPrice,
      this.salePrice,
      this.offerPrice,
      this.originCountry,
      this.hasVariant,
      this.requiresShipping,
      this.downloadable,
      this.slug,
      this.saleCount,
      this.inventories,
      this.image,
      this.discountPercent,
      this.rating,
      this.reviewCount});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shopId'];
    manufacturerId = json['manufacturerId'];
    brand = json['brand'];
    name = json['name'];
    description = json['description'];
    minPrice = json['minPrice'];
    maxPrice = json['maxPrice'];
    salePrice = json['salePrice'];
    offerPrice = json['offerPrice'];
    originCountry = json['originCountry'];
    hasVariant = json['hasVariant'];
    requiresShipping = json['requiresShipping'];
    downloadable = json['downloadable'];
    slug = json['slug'];
    saleCount = json['saleCount'];
    if (json['inventories'] != null) {
      inventories = <Inventories>[];
      json['inventories'].forEach((v) {
        inventories.add(new Inventories.fromJson(v));
      });
    }
    if (json['image'] != null) {
      image = <ProductImage>[];
      json['image'].forEach((v) {
        image.add(new ProductImage.fromJson(v));
      });
    }
    discountPercent = json['discountPercent'];
    rating = json['rating'];
    reviewCount = json['reviewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shopId'] = this.shopId;
    data['manufacturerId'] = this.manufacturerId;
    data['brand'] = this.brand;
    data['name'] = this.name;
    data['description'] = this.description;
    data['minPrice'] = this.minPrice;
    data['maxPrice'] = this.maxPrice;
    data['salePrice'] = this.salePrice;
    data['offerPrice'] = this.offerPrice;
    data['originCountry'] = this.originCountry;
    data['hasVariant'] = this.hasVariant;
    data['requiresShipping'] = this.requiresShipping;
    data['downloadable'] = this.downloadable;
    data['slug'] = this.slug;
    data['saleCount'] = this.saleCount;
    if (this.inventories != null) {
      data['inventories'] = this.inventories.map((v) => v.toJson()).toList();
    }
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    data['discountPercent'] = this.discountPercent;
    data['rating'] = this.rating;
    data['reviewCount'] = this.reviewCount;
    return data;
  }
}

class Inventories {
  int id;
  String title;
  int warehouseId;
  String brand;
  String sku;
  String condition;
  String description;
  String keyFeatures;
  int stockQuantity;
  int damagedQuantity;
  int salePrice;
  int offerPrice;
  String offerStart;
  String offerEnd;
  int preorder;
  String preorderMsg;
  String preorderStart;
  String preorderEnd;
  String freeShipping;
  int minOrderQuantity;
  String linkedItems;
  List<ProductImage> image;

  Inventories(
      {this.id,
      this.title,
      this.warehouseId,
      this.brand,
      this.sku,
      this.condition,
      this.description,
      this.keyFeatures,
      this.stockQuantity,
      this.damagedQuantity,
      this.salePrice,
      this.offerPrice,
      this.offerStart,
      this.offerEnd,
      this.preorder,
      this.preorderMsg,
      this.preorderStart,
      this.preorderEnd,
      this.freeShipping,
      this.minOrderQuantity,
      this.linkedItems,
      this.image});

  Inventories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    warehouseId = json['warehouseId'];
    brand = json['brand'];
    sku = json['sku'];
    condition = json['condition'];
    description = json['description'];
    keyFeatures = json['keyFeatures'];
    stockQuantity = json['stockQuantity'];
    damagedQuantity = json['damagedQuantity'];
    salePrice = json['salePrice'];
    offerPrice = json['offerPrice'];
    offerStart = json['offerStart'];
    offerEnd = json['offerEnd'];
    preorder = json['preorder'];
    preorderMsg = json['preorderMsg'];
    preorderStart = json['preorderStart'];
    preorderEnd = json['preorderEnd'];
    freeShipping = json['freeShipping'].toString();
    minOrderQuantity = json['minOrderQuantity'];
    linkedItems = json['linkedItems'];
    if (json['image'] != null) {
      image = <ProductImage>[];
      json['image'].forEach((v) {
        image.add(new ProductImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['warehouseId'] = this.warehouseId;
    data['brand'] = this.brand;
    data['sku'] = this.sku;
    data['condition'] = this.condition;
    data['description'] = this.description;
    data['keyFeatures'] = this.keyFeatures;
    data['stockQuantity'] = this.stockQuantity;
    data['damagedQuantity'] = this.damagedQuantity;
    data['salePrice'] = this.salePrice;
    data['offerPrice'] = this.offerPrice;
    data['offerStart'] = this.offerStart;
    data['offerEnd'] = this.offerEnd;
    data['preorder'] = this.preorder;
    data['preorderMsg'] = this.preorderMsg;
    data['preorderStart'] = this.preorderStart;
    data['preorderEnd'] = this.preorderEnd;
    data['freeShipping'] = this.freeShipping;
    data['minOrderQuantity'] = this.minOrderQuantity;
    data['linkedItems'] = this.linkedItems;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
