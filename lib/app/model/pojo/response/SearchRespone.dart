import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';

class SearchRespone {
  List<Hits> hits;
  int offset;
  int limit;
  int nbHits;
  int processingTimeMs;
  bool exhaustiveNbHits;
  String query;

  SearchRespone(
      {this.hits,
        this.offset,
        this.limit,
        this.nbHits,
        this.processingTimeMs,
        this.exhaustiveNbHits,
        this.query});

  SearchRespone.fromJson(Map<String, dynamic> json) {
    if (json['hits'] != null) {
      hits = new List<Hits>();
      json['hits'].forEach((v) {
        hits.add(new Hits.fromJson(v));
      });
    }
    offset = json['offset'];
    limit = json['limit'];
    nbHits = json['nbHits'];
    processingTimeMs = json['processingTimeMs'];
    exhaustiveNbHits = json['exhaustiveNbHits'];
    query = json['query'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hits != null) {
      data['hits'] = this.hits.map((v) => v.toJson()).toList();
    }
    data['offset'] = this.offset;
    data['limit'] = this.limit;
    data['nbHits'] = this.nbHits;
    data['processingTimeMs'] = this.processingTimeMs;
    data['exhaustiveNbHits'] = this.exhaustiveNbHits;
    data['query'] = this.query;
    return data;
  }
}

class Hits {
  int productId;
  int shopId;
  int manufacturerId;
  String brand;
  String name;
  int saleCount;
  List<Inventories> inventories;
  List<Shop> shop;
  List<Categories> categories;
  List<ProductImage> image;
  int minPrice;
  int maxPrice;
  int salePrice;
  int offerPrice;
  int discountPercent;
  int rating;
  int reviewCount;
  int hasVariant;

  Hits(
      {this.productId,
        this.shopId,
        this.manufacturerId,
        this.brand,
        this.name,
        this.saleCount,
        this.inventories,
        this.shop,
        this.categories,
        this.image,
        this.minPrice,
        this.maxPrice,
        this.salePrice,
        this.offerPrice,
        this.discountPercent,
        this.rating,
        this.reviewCount,
        this.hasVariant});

  Hits.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    shopId = json['shopId'];
    manufacturerId = json['manufacturerId'];
    brand = json['brand'];
    name = json['name'];
    saleCount = json['saleCount'];
    if (json['inventories'] != null) {
      inventories = new List<Inventories>();
      json['inventories'].forEach((v) {
        inventories.add(new Inventories.fromJson(v));
      });
    }
    if (json['shop'] != null) {
      shop = new List<Shop>();
      json['shop'].forEach((v) {
        shop.add(new Shop.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    if (json['image'] != null) {
      image = new List<ProductImage>();
      json['image'].forEach((v) {
        image.add(new ProductImage.fromJson(v));
      });
    }
    minPrice = json['minPrice'];
    maxPrice = json['maxPrice'];
    salePrice = json['salePrice'];
    offerPrice = json['offerPrice'];
    discountPercent = json['discountPercent'];
    rating = json['rating'];
    reviewCount = json['reviewCount'];
    hasVariant = json['hasVariant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['shopId'] = this.shopId;
    data['manufacturerId'] = this.manufacturerId;
    data['brand'] = this.brand;
    data['name'] = this.name;
    data['saleCount'] = this.saleCount;
    if (this.inventories != null) {
      data['inventories'] = this.inventories.map((v) => v.toJson()).toList();
    }
    if (this.shop != null) {
      data['shop'] = this.shop.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    data['minPrice'] = this.minPrice;
    data['maxPrice'] = this.maxPrice;
    data['salePrice'] = this.salePrice;
    data['offerPrice'] = this.offerPrice;
    data['discountPercent'] = this.discountPercent;
    data['rating'] = this.rating;
    data['reviewCount'] = this.reviewCount;
    data['hasVariant'] = this.hasVariant;
    return data;
  }
}

class Inventories {
  int id;
  String title;
  int salePrice;
  int offerPrice;

  Inventories({this.id, this.title, this.salePrice, this.offerPrice});

  Inventories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    salePrice = json['salePrice'];
    offerPrice = json['offerPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['salePrice'] = this.salePrice;
    data['offerPrice'] = this.offerPrice;
    return data;
  }
}

class Shop {
  int id;
  String name;
  String slug;

  Shop({this.id, this.name, this.slug});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}



class Categories {
  int id;
  String name;
  String slug;

  Categories({this.id, this.name, this.slug});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

