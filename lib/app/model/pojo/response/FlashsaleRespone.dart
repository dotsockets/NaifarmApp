
import 'ProductRespone.dart';
import 'StatesRespone.dart';

class FlashsaleRespone {
  List<FlashsaleData> data;
  int total;
  String page;
  String limit;

  FlashsaleRespone({this.data, this.total, this.page, this.limit});

  FlashsaleRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<FlashsaleData>();
      json['data'].forEach((v) {
        data.add(new FlashsaleData.fromJson(v));
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

class FlashsaleData {
  int id;
  String start;
  String end;
  List<FlashsaleItems> items;

  FlashsaleData({this.id, this.start, this.end, this.items});

  FlashsaleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    start = json['start'];
    end = json['end'];
    if (json['items'] != null) {
      items = new List<FlashsaleItems>();
      json['items'].forEach((v) {
        items.add(new FlashsaleItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start'] = this.start;
    data['end'] = this.end;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FlashsaleItems {
  FlashsaleProduct product;

  FlashsaleItems({this.product});

  FlashsaleItems.fromJson(Map<String, dynamic> json) {
    product =
    json['product'] != null ? new FlashsaleProduct.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class FlashsaleProduct {
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
  int reviewCount;
  int stockQuantity;

  FlashsaleProduct(
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

  FlashsaleProduct.fromJson(Map<String, dynamic> json) {
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



