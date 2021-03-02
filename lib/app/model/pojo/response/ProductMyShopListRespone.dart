import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/StatesRespone.dart';

class ProductMyShopListRespone {
  List<ProductMyShop> data;
  int total;
  String page;
  String limit;

  ProductMyShopListRespone({this.data, this.total, this.page, this.limit});

  ProductMyShopListRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ProductMyShop>();
      json['data'].forEach((v) {
        data.add(new ProductMyShop.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
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

class ProductMyShop {
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
  Shop shop;
  List<ProductImage> image;
  int discountPercent;
  int rating;
  double reviewCount;
  int likeCount;
  int stockQuantity;
  int active;

  ProductMyShop(
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
        this.likeCount,
        this.stockQuantity,
        this.active});

  ProductMyShop.fromJson(Map<String, dynamic> json) {
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
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
    if (json['image'] != null) {
      image = new List<ProductImage>();
      json['image'].forEach((v) {
        image.add(new ProductImage.fromJson(v));
      });
    }
    discountPercent = json['discountPercent'];
    rating = json['rating'];
    reviewCount = json['reviewCount'];
    likeCount = json['likeCount'];
    stockQuantity = json['stockQuantity'];
    active = json['active'];
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
    data['likeCount'] = this.likeCount;
    data['stockQuantity'] = this.stockQuantity;
    data['active'] = this.active;
    return data;
  }
}

class Shop {
  int id;
  String name;
  String slug;
  DataStates state;
  String updatedAt;
  List<ProductImage> image;

  Shop({this.id, this.name, this.slug, this.state, this.updatedAt, this.image});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    state = json['state'] != null ? new DataStates.fromJson(json['state']) : null;
    updatedAt = json['updatedAt'];
    if (json['image'] != null) {
      image = new List<ProductImage>();
      json['image'].forEach((v) {
        image.add(new ProductImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    if (this.state != null) {
      data['state'] = this.state.toJson();
    }
    data['updatedAt'] = this.updatedAt;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



