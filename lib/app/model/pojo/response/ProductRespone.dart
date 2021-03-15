import 'dart:io';

import 'package:naifarm/app/model/pojo/response/StatesRespone.dart';

class ProductRespone {
  List<ProductData> data;
  int total;
  int page;
  String limit;

  ProductRespone({this.data, this.total, this.page, this.limit});

  ProductRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new ProductData.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'] is String ? int.parse(json['page']) : json['page'];
    limit = json['limit'] is int ? json['limit'].toString() : json['limit'];
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
  double reviewCount;
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
      image = [];
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
  int ownerId;
  String name;
  Null legalName;
  String slug;
  String email;
  String description;
  Null externalUrl;
  int timezoneId;
  String currentBillingPlan;
  Null stripeId;
  Null cardHolderName;
  Null cardBrand;
  Null cardLastFour;
  Null paymentVerified;
  Null idVerified;
  Null phoneVerified;
  Null addressVerified;
  String createdAt;
  String updatedAt;
  List<ProductImage> image;
  DataStates state;
  int countProduct;
  int rating;

  ProductShop(
      {this.id,
      this.ownerId,
      this.name,
      this.legalName,
      this.slug,
      this.email,
      this.description,
      this.externalUrl,
      this.timezoneId,
      this.currentBillingPlan,
      this.stripeId,
      this.cardHolderName,
      this.cardBrand,
      this.cardLastFour,
      this.paymentVerified,
      this.idVerified,
      this.phoneVerified,
      this.addressVerified,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.state,
      this.countProduct,
      this.rating});

  ProductShop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['ownerId'];
    name = json['name'];
    legalName = json['legalName'];
    slug = json['slug'];
    email = json['email'];
    description = json['description'];
    externalUrl = json['externalUrl'];
    timezoneId = json['timezoneId'];
    currentBillingPlan = json['currentBillingPlan'];
    stripeId = json['stripeId'];
    cardHolderName = json['cardHolderName'];
    cardBrand = json['cardBrand'];
    cardLastFour = json['cardLastFour'];
    paymentVerified = json['paymentVerified'];
    idVerified = json['idVerified'];
    phoneVerified = json['phoneVerified'];
    addressVerified = json['addressVerified'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['image'] != null) {
      image = [];
      json['image'].forEach((v) {
        image.add(new ProductImage.fromJson(v));
      });
    }

    state =
        json['state'] != null ? new DataStates.fromJson(json['state']) : null;
    countProduct = json['countProduct'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ownerId'] = this.ownerId;
    data['name'] = this.name;
    data['legalName'] = this.legalName;
    data['slug'] = this.slug;
    data['email'] = this.email;
    data['description'] = this.description;
    data['externalUrl'] = this.externalUrl;
    data['timezoneId'] = this.timezoneId;
    data['currentBillingPlan'] = this.currentBillingPlan;
    data['stripeId'] = this.stripeId;
    data['cardHolderName'] = this.cardHolderName;
    data['cardBrand'] = this.cardBrand;
    data['cardLastFour'] = this.cardLastFour;
    data['paymentVerified'] = this.paymentVerified;
    data['idVerified'] = this.idVerified;
    data['phoneVerified'] = this.phoneVerified;
    data['addressVerified'] = this.addressVerified;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    if (this.state != null) {
      data['state'] = this.state.toJson();
    }
    data['countProduct'] = this.countProduct;
    data['rating'] = this.rating;
    return data;
  }
}

class ProductImage {
  String name;
  String path;
  File file;

  ProductImage({this.name = "", this.path = "", this.file});

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
