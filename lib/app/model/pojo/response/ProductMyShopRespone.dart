class ProductMyShopRespone {
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
  int downloadable;
  String slug;
  int saleCount;
  List<Inventories> inventories;
  Shop shop;
  List<Categories> categories;
  List<Image> image;
  int discountPercent;
  int rating;
  int reviewCount;

  ProductMyShopRespone(
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
        this.image,
        this.discountPercent,
        this.rating,
        this.reviewCount});

  ProductMyShopRespone.fromJson(Map<String, dynamic> json) {
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
      image = new List<Image>();
      json['image'].forEach((v) {
        image.add(new Image.fromJson(v));
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
    if (this.shop != null) {
      data['shop'] = this.shop.toJson();
    }
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
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
  int minPrice;
  int salePrice;
  int offerPrice;
  String offerStart;
  String offerEnd;
  int preorder;
  String preorderMsg;
  String preorderStart;
  String preorderEnd;
  int freeShipping;
  int minOrderQuantity;
  String linkedItems;
  List<Image> image;
  List<Feedbacks> feedbacks;
  List<AttributesItem> attributes;
  int discountPercent;
  int rating;
  int reviewCount;

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
        this.minPrice,
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
        this.image,
        this.feedbacks,
        this.attributes,
        this.discountPercent,
        this.rating,
        this.reviewCount});

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
    minPrice = json['minPrice'];
    salePrice = json['salePrice'];
    offerPrice = json['offerPrice'];
    offerStart = json['offerStart'];
    offerEnd = json['offerEnd'];
    preorder = json['preorder'];
    preorderMsg = json['preorderMsg'];
    preorderStart = json['preorderStart'];
    preorderEnd = json['preorderEnd'];
    freeShipping = json['freeShipping'];
    minOrderQuantity = json['minOrderQuantity'];
    linkedItems = json['linkedItems'];
    if (json['image'] != null) {
      image = new List<Image>();
      json['image'].forEach((v) {
        image.add(new Image.fromJson(v));
      });
    }
    if (json['feedbacks'] != null) {
      feedbacks = new List<Feedbacks>();
      json['feedbacks'].forEach((v) {
        feedbacks.add(new Feedbacks.fromJson(v));
      });
    }
    if (json['attributes'] != null) {
      attributes = new List<AttributesItem>();
      json['attributes'].forEach((v) {
        attributes.add(new AttributesItem.fromJson(v));
      });
    }
    discountPercent = json['discountPercent'];
    rating = json['rating'];
    reviewCount = json['reviewCount'];
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
    data['minPrice'] = this.minPrice;
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
    if (this.feedbacks != null) {
      data['feedbacks'] = this.feedbacks.map((v) => v.toJson()).toList();
    }
    if (this.attributes != null) {
      data['attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }
    data['discountPercent'] = this.discountPercent;
    data['rating'] = this.rating;
    data['reviewCount'] = this.reviewCount;
    return data;
  }
}

class Image {
  int id;
  String path;
  String name;
  String extension;
  String size;
  int imageableId;
  String imageableType;
  int featured;
  int order;

  Image(
      {this.id,
        this.path,
        this.name,
        this.extension,
        this.size,
        this.imageableId,
        this.imageableType,
        this.featured,
        this.order});

  Image.fromJson(Map<String, dynamic> json) {
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

class Feedbacks {
  int id;
  int customerId;
  int rating;
  String comment;
  String feedbackableId;
  String feedbackableType;

  Feedbacks(
      {this.id,
        this.customerId,
        this.rating,
        this.comment,
        this.feedbackableId,
        this.feedbackableType});

  Feedbacks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    rating = json['rating'];
    comment = json['comment'];
    feedbackableId = json['feedbackableId'];
    feedbackableType = json['feedbackableType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    data['feedbackableId'] = this.feedbackableId;
    data['feedbackableType'] = this.feedbackableType;
    return data;
  }
}

class AttributesItem {
  AttributesItem attributes;
  Values values;

  AttributesItem({this.attributes, this.values});

  AttributesItem.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? new AttributesItem.fromJson(json['attributes'])
        : null;
    values =
    json['values'] != null ? new Values.fromJson(json['values']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attributes != null) {
      data['attributes'] = this.attributes.toJson();
    }
    if (this.values != null) {
      data['values'] = this.values.toJson();
    }
    return data;
  }
}

class Attributes {
  int id;
  String name;

  Attributes({this.id, this.name});

  Attributes.fromJson(Map<String, dynamic> json) {
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
  String name;
  String slug;
  Attributes state;
  String updatedAt;
  List<Image> image;

  Shop({this.id, this.name, this.slug, this.state, this.updatedAt, this.image});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    state =
    json['state'] != null ? new Attributes.fromJson(json['state']) : null;
    updatedAt = json['updatedAt'];
    if (json['image'] != null) {
      image = new List<Image>();
      json['image'].forEach((v) {
        image.add(new Image.fromJson(v));
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

