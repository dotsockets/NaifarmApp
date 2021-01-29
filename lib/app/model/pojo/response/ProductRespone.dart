
import 'dart:io';

class ProductRespone {
  List<ProductData> data;
  int total;
  String page;
  String limit;

  ProductRespone({this.data, this.total, this.page, this.limit});

  ProductRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ProductData>();
      json['data'].forEach((v) {
        data.add(new ProductData.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    limit = json['limit'] is int?json['limit'].toString():json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    return data;
  }
}

class ProductData {
  int id;
  String brand;
  String name;
  int minPrice;
  int maxPrice;
  int salePrice;
  int offerPrice;
  int hasVariant;
  String slug;
  int saleCount;
  ProductShop shop;
  List<ProductImage> image;
  int discountPercent;
  int rating;
  int reviewCount;
  int stockQuantity;

  ProductData(
      {this.id,
        this.brand,
        this.name,
        this.minPrice,
        this.maxPrice,
        this.salePrice,
        this.offerPrice,
        this.hasVariant,
        this.slug,
        this.saleCount,
        this.shop,
        this.image,
        this.discountPercent,
        this.rating,
        this.reviewCount,
        this.stockQuantity});

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brand = json['brand'];
    name = json['name'];
    minPrice = json['minPrice'];
    maxPrice = json['maxPrice'];
    salePrice = json['salePrice'];
    offerPrice = json['offerPrice'];
    hasVariant = json['hasVariant'];
    slug = json['slug'];
    saleCount = json['saleCount'];
    shop = json['shop'] != null ? new ProductShop.fromJson(json['shop']) : null;
    if (json['image'] != null) {
      image = new List<ProductImage>();
      json['image'].forEach((v) {
        image.add(new ProductImage.fromJson(v));
      });
    }
    discountPercent = json['discountPercent'];
    rating = json['rating'];
    reviewCount = json['reviewCount'];
    stockQuantity = json['stockQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brand'] = this.brand;
    data['name'] = this.name;
    data['minPrice'] = this.minPrice;
    data['maxPrice'] = this.maxPrice;
    data['salePrice'] = this.salePrice;
    data['offerPrice'] = this.offerPrice;
    data['hasVariant'] = this.hasVariant;
    data['slug'] = this.slug;
    data['saleCount'] = this.saleCount;
    if (this.shop != null) {
      data['shop'] = this.shop.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    data['discountPercent'] = this.discountPercent;
    data['rating'] = this.rating;
    data['reviewCount'] = this.reviewCount;
    data['stockQuantity'] = this.stockQuantity;
    return data;
  }
}

class ProductShop {
  int id;
  String name;
  String slug;
  String updatedAt;

  ProductShop({this.id, this.name, this.slug, this.updatedAt});

  ProductShop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class ProductImage {
  String name;
  String path;
  File file;

  ProductImage({this.name="", this.path="",this.file});

  ProductImage.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['path'] = this.path;
    return data;
  }
}