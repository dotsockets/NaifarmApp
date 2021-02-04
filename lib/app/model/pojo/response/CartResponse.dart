import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';

import 'ShippingsRespone.dart';
class CartResponse {
  List<CartData> data;
  String total;
  bool selectAll =false;

  CartResponse({this.data, this.total,this.selectAll= false});

  CartResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<CartData>();
      json['data'].forEach((v) {
        data.add(new CartData.fromJson(v));
      });
    }
    if(json['total'] is int){
      total = json['total'].toString();
    }else{
      total =  json['total'];
    }

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
class CartData {
  int id;
  int shopId;
  int shipTo;
  int shippingZoneId;
  int shippingRateId;
  int packagingId;
  int itemCount;
  int quantity;
  double shippingWeight;
  int total;
  int discount;
  int shipping;
  int packaging;
  int handling;
  int taxes;
  int taxRate;
  int grandTotal;
  int billingAddress;
  int shippingAddress;
  int couponId;
  int paymentStatus;
  int paymentMethodId;
  String messageToCustomer;
  CartShop shop;
  List<CartItems> items;
  PaymentMethod paymentMethod;
  Coupon coupon;
  String note;
  int carrierId;
  ShippingRates shippingRates;


  CartData(
      {this.id,
        this.shopId,
        this.shipTo,
        this.shippingZoneId,
        this.shippingRateId,
        this.packagingId,
        this.itemCount,
        this.quantity,
        this.shippingWeight,
        this.total,
        this.discount,
        this.shipping,
        this.packaging,
        this.handling,
        this.taxes,
        this.taxRate,
        this.grandTotal,
        this.billingAddress,
        this.shippingAddress,
        this.couponId,
        this.paymentStatus,
        this.paymentMethodId,
        this.messageToCustomer,
        this.shop,
        this.items,
        this.paymentMethod,
        this.coupon,this.note,this.carrierId,this.shippingRates});

  CartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shopId'];
    shipTo = json['shipTo'];
    shippingZoneId = json['shippingZoneId']!=null?json['shippingRateId']:0;
    shippingRateId = json['shippingRateId']!=null?json['shippingRateId']:0;
    packagingId = json['packagingId'];
    itemCount = json['itemCount'];
    quantity = json['quantity'];
    shippingWeight = json['shippingWeight'] > 0?json['shippingWeight']:0.0;
    total = json['total'];
    discount = json['discount'];
    shipping = json['shipping'];
    packaging = json['packaging'];
    handling = json['handling'];
    taxRate = json['taxRate'];
    taxes = json['taxes'];
    grandTotal = json['grandTotal'];
    billingAddress = json['billingAddress'];
    shippingAddress = json['shippingAddress'];
    couponId = json['couponId'];
    paymentStatus = json['paymentStatus'];
    paymentMethodId = json['paymentMethodId'];
    messageToCustomer = json['messageToCustomer'];
    shop = json['shop'] != null ? new CartShop.fromJson(json['shop']) : null;
    if (json['items'] != null) {
      items = new List<CartItems>();
      json['items'].forEach((v) {
        items.add(new CartItems.fromJson(v));
      });
    }
    paymentMethod = json['paymentMethod'] != null
        ? new PaymentMethod.fromJson(json['paymentMethod'])
        : null;
    coupon =
    json['coupon'] != null ? new Coupon.fromJson(json['coupon']) : null;
    note = json['note']!=null?json['note']:"note...";
    carrierId = json['carrierId']!=null?json['carrierId']:0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shopId'] = this.shopId;
    data['shipTo'] = this.shipTo;
    data['shippingZoneId'] = this.shippingZoneId;
    data['shippingRateId'] = this.shippingRateId;
    data['packagingId'] = this.packagingId;
    data['itemCount'] = this.itemCount;
    data['quantity'] = this.quantity;
    data['shippingWeight'] = this.shippingWeight;
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['shipping'] = this.shipping;
    data['packaging'] = this.packaging;
    data['handling'] = this.handling;
    data['taxes'] = this.taxes;
    data['taxRate'] = this.taxRate;
    data['grandTotal'] = this.grandTotal;
    data['billingAddress'] = this.billingAddress;
    data['shippingAddress'] = this.shippingAddress;
    data['couponId'] = this.couponId;
    data['paymentStatus'] = this.paymentStatus;
    data['paymentMethodId'] = this.paymentMethodId;
    data['messageToCustomer'] = this.messageToCustomer;
    if (this.shop != null) {
      data['shop'] = this.shop.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    if (this.paymentMethod != null) {
      data['paymentMethod'] = this.paymentMethod.toJson();
    }
    if (this.coupon != null) {
      data['coupon'] = this.coupon.toJson();
    }
    return data;
  }
}

class CartShop {
  int id;
  String name;
  String slug;
  CartState state;
  String updatedAt;
  List<ProductImage> image;

  CartShop({this.id, this.name, this.slug, this.state, this.updatedAt, this.image});

  CartShop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    state = json['state'] != null ? new CartState.fromJson(json['state']) : null;
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

class CartState {
  int id;
  String name;

  CartState({this.id, this.name});

  CartState.fromJson(Map<String, dynamic> json) {
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


class CartItems {
  String itemDescription;
  int quantity;
  int unitPrice;
  int total;
  CartInventory inventory;
  bool select=false;


  CartItems(
      {this.itemDescription,
        this.quantity,
        this.unitPrice,
        this.total,
        this.inventory,this.select});

  CartItems.fromJson(Map<String, dynamic> json) {
    itemDescription = json['itemDescription'];
    quantity = json['quantity'];
    unitPrice = json['unitPrice'];
    total = json['total'];
    inventory = json['inventory'] != null
        ? new CartInventory.fromJson(json['inventory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemDescription'] = this.itemDescription;
    data['quantity'] = this.quantity;
    data['unitPrice'] = this.unitPrice;
    data['total'] = this.total;
    if (this.inventory != null) {
      data['inventory'] = this.inventory.toJson();
    }
    return data;
  }
}




class PaymentMethod {
  int id;
  String code;
  String name;
  int type;

  PaymentMethod({this.id, this.code, this.name, this.type});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

class Coupon {
  int id;
  String name;
  String code;
  String description;
  int value;

  Coupon({this.id, this.name, this.code, this.description, this.value});

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    description = json['description'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['description'] = this.description;
    data['value'] = this.value;
    return data;
  }
}

class CartInventory {
  int id;
  String title;
  int warehouseId;
  String productId;
  String brand;
  int supplierId;
  String sku;
  String condition;
  String conditionNote;
  String description;
  String keyFeatures;
  int stockQuantity;
  int damagedQuantity;
  int purchasePrice;
  int salePrice;
  int offerPrice;
  int offerStart;
  int offerEnd;
  int preorder;
  String preorderMsg;
  String preorderStart;
  String preorderEnd;
  int shippingWeight;
  String freeShipping;
  int minOrderQuantity;
  String slug;
  String linkedItems;
  String metaTitle;
  String metaDescription;
  String stuffPick;
  CartProduct product;
  List<ProductImage> image;
  bool isActive;

  CartInventory(
      {this.id,
        this.title,
        this.warehouseId,
        this.productId,
        this.brand,
        this.supplierId,
        this.sku,
        this.condition,
        this.conditionNote,
        this.description,
        this.keyFeatures,
        this.stockQuantity,
        this.damagedQuantity,
        this.purchasePrice,
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
        this.slug,
        this.linkedItems,
        this.metaTitle,
        this.metaDescription,
        this.stuffPick,
        this.product,
        this.image,
        this.isActive});

  CartInventory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    warehouseId = json['warehouseId'];
    productId = json['productId'];
    brand = json['brand'];
    supplierId = json['supplierId'];
    sku = json['sku'];
    condition = json['condition'];
    conditionNote = json['conditionNote'];
    description = json['description'];
    keyFeatures = json['keyFeatures'];
    stockQuantity = json['stockQuantity'];
    damagedQuantity = json['damagedQuantity'];
    purchasePrice = json['purchasePrice'];
    salePrice = json['salePrice'];
    offerPrice = json['offerPrice'];
    offerStart = json['offerStart'];
    offerEnd = json['offerEnd'];
    preorder = json['preorder'];
    preorderMsg = json['preorderMsg'];
    preorderStart = json['preorderStart'];
    preorderEnd = json['preorderEnd'];
    shippingWeight = json['shippingWeight'];
    freeShipping = json['freeShipping'];
    minOrderQuantity = json['minOrderQuantity'];
    slug = json['slug'];
    linkedItems = json['linkedItems'];
    metaTitle = json['metaTitle'];
    metaDescription = json['metaDescription'];
    stuffPick = json['stuffPick'];
    product =
    json['product'] != null ? new CartProduct.fromJson(json['product']) : null;
    if (json['image'] != null) {
      image = new List<Null>();
      json['image'].forEach((v) {
        image.add(new ProductImage.fromJson(v));
      });
    }
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['warehouseId'] = this.warehouseId;
    data['productId'] = this.productId;
    data['brand'] = this.brand;
    data['supplierId'] = this.supplierId;
    data['sku'] = this.sku;
    data['condition'] = this.condition;
    data['conditionNote'] = this.conditionNote;
    data['description'] = this.description;
    data['keyFeatures'] = this.keyFeatures;
    data['stockQuantity'] = this.stockQuantity;
    data['damagedQuantity'] = this.damagedQuantity;
    data['purchasePrice'] = this.purchasePrice;
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
    data['slug'] = this.slug;
    data['linkedItems'] = this.linkedItems;
    data['metaTitle'] = this.metaTitle;
    data['metaDescription'] = this.metaDescription;
    data['stuffPick'] = this.stuffPick;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    data['isActive'] = this.isActive;
    return data;
  }
}


class CartProduct {
  int id;
  int shopId;
  Null manufacturerId;
  String brand;
  String name;
  String modelNumber;
  Null mpn;
  String description;
  int originCountry;
  int requiresShipping;
  Null downloadable;
  String slug;
  int saleCount;
  Null gtin;
  Null gtinType;
  int active;
  String createdAt;
  String updatedAt;
  List<ProductImage> image;
  int hasVariant;
  int minPrice;
  int maxPrice;
  int salePrice;
  int offerPrice;
  int discountPercent;
  int rating;
  double reviewCount;
  int stockQuantity;

  CartProduct(
      {this.id,
        this.shopId,
        this.manufacturerId,
        this.brand,
        this.name,
        this.modelNumber,
        this.mpn,
        this.description,
        this.originCountry,
        this.requiresShipping,
        this.downloadable,
        this.slug,
        this.saleCount,
        this.gtin,
        this.gtinType,
        this.active,
        this.createdAt,
        this.updatedAt,
        this.image,
        this.hasVariant,
        this.minPrice,
        this.maxPrice,
        this.salePrice,
        this.offerPrice,
        this.discountPercent,
        this.rating,
        this.reviewCount,
        this.stockQuantity});

  CartProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shopId'];
    manufacturerId = json['manufacturerId'];
    brand = json['brand'];
    name = json['name'];
    modelNumber = json['modelNumber'];
    mpn = json['mpn'];
    description = json['description'];
    originCountry = json['originCountry'];
    requiresShipping = json['requiresShipping'];
    downloadable = json['downloadable'];
    slug = json['slug'];
    saleCount = json['saleCount'];
    gtin = json['gtin'];
    gtinType = json['gtinType'];
    active = json['active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['image'] != null) {
      image = new List<ProductImage>();
      json['image'].forEach((v) {
        image.add(new ProductImage.fromJson(v));
      });
    }
    hasVariant = json['hasVariant'];
    minPrice = json['minPrice'];
    maxPrice = json['maxPrice'];
    salePrice = json['salePrice'];
    offerPrice = json['offerPrice'];
    discountPercent = json['discountPercent'];
    rating = json['rating'];
    reviewCount = json['reviewCount'];
    stockQuantity = json['stockQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shopId'] = this.shopId;
    data['manufacturerId'] = this.manufacturerId;
    data['brand'] = this.brand;
    data['name'] = this.name;
    data['modelNumber'] = this.modelNumber;
    data['mpn'] = this.mpn;
    data['description'] = this.description;
    data['originCountry'] = this.originCountry;
    data['requiresShipping'] = this.requiresShipping;
    data['downloadable'] = this.downloadable;
    data['slug'] = this.slug;
    data['saleCount'] = this.saleCount;
    data['gtin'] = this.gtin;
    data['gtinType'] = this.gtinType;
    data['active'] = this.active;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    data['hasVariant'] = this.hasVariant;
    data['minPrice'] = this.minPrice;
    data['maxPrice'] = this.maxPrice;
    data['salePrice'] = this.salePrice;
    data['offerPrice'] = this.offerPrice;
    data['discountPercent'] = this.discountPercent;
    data['rating'] = this.rating;
    data['reviewCount'] = this.reviewCount;
    data['stockQuantity'] = this.stockQuantity;
    return data;
  }
}