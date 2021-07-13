import 'ProductMyShopRespone.dart';

class ProductShopItemRespone {
  int id;
  int shopId;
  int manufacturerId;
  String brand;
  String name;
  String description;
  int  minPrice;
  int  maxPrice;
  int salePrice;
  int  offerPrice;
  int originCountry;
  int hasVariant;
  int requiresShipping;
  int downloadable;
  String slug;
  int saleCount;
  List<Inventories> inventories;
  Shop shop;
  List<Categories> categories;
  List<ImageProductShop> images;
  int discountPercent;
  double rating;
  double reviewCount;
  int stockQuantity;
  int active;
  int banned;

  ProductShopItemRespone(
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
        this.shop,
        this.categories,
        this.images,
        this.discountPercent,
        this.rating,
        this.reviewCount,
        this.stockQuantity,
        this.active,
        this.banned});

  ProductShopItemRespone.fromJson(Map<String, dynamic> json) {
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
      inventories = new List<Inventories>();
      json['inventories'].forEach((v) {
        inventories.add(new Inventories.fromJson(v));
      });
    }
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    if (json['image'] != null) {
      images = new List<ImageProductShop>();
      json['image'].forEach((v) {
        images.add(new ImageProductShop.fromJson(v));
      });
    }
    discountPercent = json['discountPercent'];
    if (json['rating'] == null) {
      rating = 0.0;
    } else if (json['rating'] is double) {
      rating = json['rating'];
    } else {
      rating = double.parse(json['rating'].toString());
    }
    if (json['reviewCount'] == null) {
      reviewCount = 0.0;
    } else if (json['reviewCount'] is double) {
      reviewCount = json['reviewCount'];
    } else {
      reviewCount = double.parse(json['reviewCount'].toString());
    }
    stockQuantity = json['stockQuantity'];
    active = json['active'];
    banned = json['banned'];
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
    if (this.shop != null) {
      data['shop'] = this.shop.toJson();
    }
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.images != null) {
      data['image'] = this.images.map((v) => v.toJson()).toList();
    }
    data['discountPercent'] = this.discountPercent;
    data['rating'] = this.rating;
    data['reviewCount'] = this.reviewCount;
    data['stockQuantity'] = this.stockQuantity;
    data['active'] = this.active;
    data['banned'] = this.banned;
    return data;
  }
}

class Inventories {
  int id;
  String title;
  int  warehouseId;
  String brand;
  String sku;
  String condition;
  String description;
  int  keyFeatures;
  int stockQuantity;
  int  damagedQuantity;
  int salePrice;
  int offerPrice;
  String offerStart;
  String offerEnd;
  int preorder;
  String preorderMsg;
  String preorderStart;
  String preorderEnd;
  double shippingWeight;
  int freeShipping;
  int minOrderQuantity;
  int  linkedItems;
  List<ImageProductShopItem> images;
  List<Feedbacks> feedbacks;
  List<AttributesList> attributes;

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
        this.shippingWeight,
        this.freeShipping,
        this.minOrderQuantity,
        this.linkedItems,
        this.images,
        this.feedbacks,
        this.attributes});

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
    shippingWeight =
    json['shippingWeight'] != null ? json['shippingWeight'] * 1.0 : 0.0;
    freeShipping = json['freeShipping'];
    minOrderQuantity = json['minOrderQuantity'];
    linkedItems = json['linkedItems'];
    if (json['image'] != null) {
      images = new List<Null>();
      json['image'].forEach((v) {
        images.add(new ImageProductShopItem.fromJson(v));
      });
    }
    if (json['feedbacks'] != null) {
      feedbacks = new List<Feedbacks>();
      json['feedbacks'].forEach((v) {
        feedbacks.add(new Feedbacks.fromJson(v));
      });
    }
    if (json['attributes'] != null) {
      attributes = new List<AttributesList>();
      json['attributes'].forEach((v) {
        attributes.add(new AttributesList.fromJson(v));
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
    data['shippingWeight'] = this.shippingWeight;
    data['freeShipping'] = this.freeShipping;
    data['minOrderQuantity'] = this.minOrderQuantity;
    data['linkedItems'] = this.linkedItems;
    if (this.images != null) {
      data['image'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.feedbacks != null) {
      data['feedbacks'] = this.feedbacks.map((v) => v.toJson()).toList();
    }
    if (this.attributes != null) {
      data['attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Feedbacks {
  int id;
  Customer customer;
  int rating;
  String comment;

  Feedbacks({this.id, this.customer, this.rating, this.comment});

  Feedbacks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    rating = json['rating'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    return data;
  }
}

class Customer {
  String name;
  Null niceName;
  String email;
  Images images;

  Customer({this.name, this.niceName, this.email, this.images});

  Customer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    niceName = json['niceName'];
    email = json['email'];
    images = json['image'] != null ? new Images.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['niceName'] = this.niceName;
    data['email'] = this.email;
    if (this.images != null) {
      data['image'] = this.images.toJson();
    }
    return data;
  }
}

class Images {
  String name;
  String path;

  Images({this.name, this.path});

  Images.fromJson(Map<String, dynamic> json) {
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

class AttributesList {
  List<AttributesItem> attributes;
  List<Values> values;

  AttributesList({this.attributes, this.values});

  AttributesList.fromJson(Map<String, dynamic> json) {
    if (json['attributes'] != null) {
      attributes = new List<AttributesItem>();
      json['attributes'].forEach((v) {
        attributes.add(new AttributesItem.fromJson(v));
      });
    }
    if (json['values'] != null) {
      values = new List<Values>();
      json['values'].forEach((v) {
        values.add(new Values.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attributes != null) {
      data['attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }
    if (this.values != null) {
      data['values'] = this.values.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttributesItem {
  int id;
  String name;

  AttributesItem({this.id, this.name});

  AttributesItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Values {
  int id;
  String value;
  String color;

  Values({this.id, this.value, this.color});

  Values.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['color'] = this.color;
    return data;
  }
}

class Shop {
  int id;
  int ownerId;
  String name;
  String legalName;
  String slug;
  String email;
  String description;
  String externalUrl;
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
  List<Images> images;
  DataStatesItem state;
  int countProduct;
  int rating;
  int active;

  Shop(
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
        this.images,
        this.state,
        this.countProduct,
        this.rating,
        this.active});

  Shop.fromJson(Map<String, dynamic> json) {
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
      images = new List<Images>();
      json['image'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    state =
    json['state'] != null ? new DataStatesItem.fromJson(json['state']) : null;
    countProduct = json['countProduct'];
    rating = json['rating'];
    active = json['active'];
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
    if (this.images != null) {
      data['image'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.state != null) {
      data['state'] = this.state.toJson();
    }
    data['countProduct'] = this.countProduct;
    data['rating'] = this.rating;
    data['active'] = this.active;
    return data;
  }
}

class DataStatesItem {
  int id;
  String name;

  DataStatesItem({this.id, this.name});

  DataStatesItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
class Categories {
  Category category;

  Categories({this.category});

  Categories.fromJson(Map<String, dynamic> json) {
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    return data;
  }
}

class Category {
  CategorySubGroup categorySubGroup;
  int id;
  String name;
  String slug;

  Category({this.categorySubGroup, this.id, this.name, this.slug});

  Category.fromJson(Map<String, dynamic> json) {
    categorySubGroup = json['categorySubGroup'] != null
        ? new CategorySubGroup.fromJson(json['categorySubGroup'])
        : null;
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categorySubGroup != null) {
      data['categorySubGroup'] = this.categorySubGroup.toJson();
    }
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class CategorySubGroup {
  CategoryGroup categoryGroup;
  int id;
  String name;
  String slug;

  CategorySubGroup({this.categoryGroup, this.id, this.name, this.slug});

  CategorySubGroup.fromJson(Map<String, dynamic> json) {
    categoryGroup = json['categoryGroup'] != null
        ? new CategoryGroup.fromJson(json['categoryGroup'])
        : null;
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categoryGroup != null) {
      data['categoryGroup'] = this.categoryGroup.toJson();
    }
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class CategoryGroup {
  int id;
  String name;
  String slug;

  CategoryGroup({this.id, this.name, this.slug});

  CategoryGroup.fromJson(Map<String, dynamic> json) {
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

class ImageProductShopItem {
  int id;
  String path;
  String name;
  String extension;
  String size;
  int imageableId;
  String imageableType;
  int featured;
  int order;

  ImageProductShopItem(
      {this.id,
        this.path,
        this.name,
        this.extension,
        this.size,
        this.imageableId,
        this.imageableType,
        this.featured,
        this.order});

  ImageProductShopItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    path = json['path'];
    name = json['name'];
    extension = json['extension'];
    size = json['size'];
    imageableId = json['imageableId'];
    imageableType = json['imageableType'];
    featured = json['featured'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['path'] = this.path;
    data['name'] = this.name;
    data['extension'] = this.extension;
    data['size'] = this.size;
    data['imageableId'] = this.imageableId;
    data['imageableType'] = this.imageableType;
    data['featured'] = this.featured;
    data['order'] = this.order;
    return data;
  }
}
