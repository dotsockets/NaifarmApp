import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';

class OrderRespone {
  List<OrderData> data;
  int total;
  String page;
  String limit;

  OrderRespone({this.data, this.total, this.page, this.limit});

  OrderRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <OrderData>[];
      json['data'].forEach((v) {
        data.add(new OrderData.fromJson(v));
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

class OrderData {
  int id;
  String orderNumber;
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
  String billingAddress;
  String shippingAddress;
  String shippingAddressTitle;
  String shippingAddressPhone;
  String shippingDate;
  String deliveryDate;
  String trackingId;
  int couponId;
  int carrierId;
  Carrier carrier;
  int paymentStatus;
  int paymentMethodId;
  String messageToCustomer;
  String buyerNote;
  int disputed;
  int orderStatusId;
  String orderStatusName;
  String createdAt;
  String paymentAt;
  String requirePaymentAt;
  ProductShop shop;
  List<OrderItems> items;
  PaymentMethod paymentMethod;
  List<ProductImage> image;

  OrderData(
      {this.id,
      this.orderNumber,
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
      this.shippingAddressTitle,
      this.shippingAddressPhone,
      this.shippingDate,
      this.deliveryDate,
      this.trackingId,
      this.couponId,
      this.carrierId,
      this.carrier,
      this.paymentStatus,
      this.paymentMethodId,
      this.messageToCustomer,
      this.buyerNote,
      this.disputed,
      this.orderStatusId,
      this.orderStatusName,
      this.createdAt,
      this.paymentAt,
      this.requirePaymentAt,
      this.shop,
      this.items,
      this.paymentMethod,
      this.image});

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['orderNumber'];
    shipTo = json['shipTo'];
    shippingZoneId = json['shippingZoneId'];
    shippingRateId = json['shippingRateId'];
    packagingId = json['packagingId'];
    itemCount = json['itemCount'];
    quantity = json['quantity'];
    shippingWeight =
        json['shippingWeight'] > 0 ? json['shippingWeight'] * 1.0 : 0.0;
    total = json['total'];
    discount = json['discount'];
    shipping = json['shipping'];
    packaging = json['packaging'];
    handling = json['handling'];
    taxes = json['taxes'];
    taxRate = json['taxRate'];
    grandTotal = json['grandTotal'];
    billingAddress = json['billingAddress'];
    shippingAddress = json['shippingAddress'];
    shippingAddressTitle = json['shippingAddressTitle'];
    shippingAddressPhone = json['shippingAddressPhone'];
    shippingDate = json['shippingDate'];
    deliveryDate = json['deliveryDate'];
    trackingId = json['trackingId'];
    couponId = json['couponId'];
    carrierId = json['carrierId'];
    carrier =
        json['carrier'] != null ? new Carrier.fromJson(json['carrier']) : null;
    paymentStatus = json['paymentStatus'];
    paymentMethodId = json['paymentMethodId'];
    messageToCustomer = json['messageToCustomer'];
    buyerNote = json['buyerNote'];
    disputed = json['disputed'];
    orderStatusId = json['orderStatusId'];
    orderStatusName = json['orderStatusName'];
    createdAt = json['createdAt'];
    paymentAt = json['paymentAt'];
    requirePaymentAt = json['requirePaymentAt'];
    shop = json['shop'] != null ? new ProductShop.fromJson(json['shop']) : null;
    if (json['items'] != null) {
      items = <OrderItems>[];
      json['items'].forEach((v) {
        items.add(new OrderItems.fromJson(v));
      });
    }
    paymentMethod = json['paymentMethod'] != null
        ? new PaymentMethod.fromJson(json['paymentMethod'])
        : null;
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
    data['orderNumber'] = this.orderNumber;
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
    data['shippingAddressTitle'] = this.shippingAddressTitle;
    data['shippingAddressPhone'] = this.shippingAddressPhone;
    data['shippingDate'] = this.shippingDate;
    data['deliveryDate'] = this.deliveryDate;
    data['trackingId'] = this.trackingId;
    data['couponId'] = this.couponId;
    data['carrierId'] = this.carrierId;
    if (this.carrier != null) {
      data['carrier'] = this.carrier.toJson();
    }
    data['paymentStatus'] = this.paymentStatus;
    data['paymentMethodId'] = this.paymentMethodId;
    data['messageToCustomer'] = this.messageToCustomer;
    data['buyerNote'] = this.buyerNote;
    data['disputed'] = this.disputed;
    data['orderStatusId'] = this.orderStatusId;
    data['orderStatusName'] = this.orderStatusName;
    data['createdAt'] = this.createdAt;
    data['paymentAt'] = this.paymentAt;
    data['requirePaymentAt'] = this.requirePaymentAt;
    if (this.shop != null) {
      data['shop'] = this.shop.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    if (this.paymentMethod != null) {
      data['paymentMethod'] = this.paymentMethod.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Carrier {
  String name;

  Carrier({this.name});

  Carrier.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class OrderItems {
  int orderId;
  int inventoryId;
  String itemTitle;
  String itemImagePath;
  String itemDescription;
  String itemVariant;
  int quantity;
  String unitPrice;
  String offerPrice;
  Inventory inventory;

  OrderItems(
      {this.orderId,
      this.inventoryId,
      this.itemTitle,
      this.itemDescription,
      this.itemVariant,
      this.quantity,
      this.unitPrice,
      this.offerPrice,
      this.inventory});

  OrderItems.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    inventoryId = json['inventoryId'];
    itemTitle = json['itemTitle'];
    itemImagePath = json['itemImagePath'];
    itemDescription = json['itemDescription'];
    itemVariant = json['itemVariant'];
    quantity = json['quantity'];
    unitPrice = json['unitPrice'];
    offerPrice = json['offerPrice'];
    inventory = json['inventory'] != null
        ? new Inventory.fromJson(json['inventory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['inventoryId'] = this.inventoryId;
    data['itemTitle'] = this.itemTitle;
    data['itemImagePath'] = this.itemImagePath;
    data['itemDescription'] = this.itemDescription;
    data['itemVariant'] = this.itemVariant;
    data['quantity'] = this.quantity;
    data['unitPrice'] = this.unitPrice;
    data['offerPrice'] = this.offerPrice;
    if (this.inventory != null) {
      data['inventory'] = this.inventory.toJson();
    }
    return data;
  }
}

class Inventory {
  int id;
  String title;
  String brand;
  String sku;
  int salePrice;
  int offerPrice;
  int stockQuantity;
  List<ProductImage> image;
  ProductData product;

  Inventory(
      {this.id,
      this.title,
      this.brand,
      this.sku,
      this.salePrice,
      this.offerPrice,
      this.stockQuantity,
      this.image,
      this.product});

  Inventory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    brand = json['brand'];
    sku = json['sku'];
    salePrice = json['salePrice'];
    offerPrice = json['offerPrice'];
    stockQuantity = json['stockQuantity'];
    if (json['image'] != null) {
      image = <ProductImage>[];
      json['image'].forEach((v) {
        image.add(new ProductImage.fromJson(v));
      });
    }
    product = json['product'] != null
        ? new ProductData.fromJson(json['product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['brand'] = this.brand;
    data['sku'] = this.sku;
    data['salePrice'] = this.salePrice;
    data['offerPrice'] = this.offerPrice;
    data['stockQuantity'] = this.stockQuantity;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    if (this.product != null) {
      data['product'] = this.product.toJson();
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
