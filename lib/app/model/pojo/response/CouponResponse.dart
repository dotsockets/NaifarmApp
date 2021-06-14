class CouponResponse {
  List<CouponData> data;
  int total;
  int page;
  int limit;

  CouponResponse({this.data, this.total, this.page, this.limit});

  CouponResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CouponData>[];
      json['data'].forEach((v) {
        data.add(new CouponData.fromJson(v));
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

class CouponData {
  int id;
  String name;
  String code;
  String description;
  CouponShippingZone couponShippingZone;
  int shippingZoneId;
  int value;
  int minOrderAmount;
  String type;
  int quantity;
  int quantityPerCustomer;
  String startingTime;
  String endingTime;
  int active;

  CouponData(
      {this.id,
      this.name,
      this.code,
      this.description,
      this.couponShippingZone,
      this.shippingZoneId,
      this.value,
      this.minOrderAmount,
      this.type,
      this.quantity,
      this.quantityPerCustomer,
      this.startingTime,
      this.endingTime,
      this.active});

  CouponData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    description = json['description'];
    couponShippingZone = json['couponShippingZone'] != null
        ? new CouponShippingZone.fromJson(json['couponShippingZone'])
        : null;
    shippingZoneId = json['shippingZoneId'];
    value = json['value'];
    minOrderAmount = json['minOrderAmount'];
    type = json['type'];
    quantity = json['quantity'];
    quantityPerCustomer = json['quantityPerCustomer'];
    startingTime = json['startingTime'];
    endingTime = json['endingTime'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['description'] = this.description;
    if (this.couponShippingZone != null) {
      data['couponShippingZone'] = this.couponShippingZone.toJson();
    }
    data['shippingZoneId'] = this.shippingZoneId;
    data['value'] = this.value;
    data['minOrderAmount'] = this.minOrderAmount;
    data['type'] = this.type;
    data['quantity'] = this.quantity;
    data['quantityPerCustomer'] = this.quantityPerCustomer;
    data['startingTime'] = this.startingTime;
    data['endingTime'] = this.endingTime;
    data['active'] = this.active;
    return data;
  }
}

class CouponShippingZone {
  int couponId;
  ShippingZone shippingZone;

  CouponShippingZone({this.couponId, this.shippingZone});

  CouponShippingZone.fromJson(Map<String, dynamic> json) {
    couponId = json['couponId'];
    shippingZone = json['shippingZone'] != null
        ? new ShippingZone.fromJson(json['shippingZone'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['couponId'] = this.couponId;
    if (this.shippingZone != null) {
      data['shippingZone'] = this.shippingZone.toJson();
    }
    return data;
  }
}

class ShippingZone {
  int id;
  int shopId;
  String name;
  Null taxId;
  String countryIds;
  String stateIds;
  int restOfTheWorld;
  int active;
  String createdAt;
  Null updatedAt;
  List<Rates> rates;

  ShippingZone(
      {this.id,
      this.shopId,
      this.name,
      this.taxId,
      this.countryIds,
      this.stateIds,
      this.restOfTheWorld,
      this.active,
      this.createdAt,
      this.updatedAt,
      this.rates});

  ShippingZone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shopId'];
    name = json['name'];
    taxId = json['taxId'];
    countryIds = json['countryIds'];
    stateIds = json['stateIds'];
    restOfTheWorld = json['restOfTheWorld'];
    active = json['active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['rates'] != null) {
      rates = new List<Rates>();
      json['rates'].forEach((v) {
        rates.add(new Rates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shopId'] = this.shopId;
    data['name'] = this.name;
    data['taxId'] = this.taxId;
    data['countryIds'] = this.countryIds;
    data['stateIds'] = this.stateIds;
    data['restOfTheWorld'] = this.restOfTheWorld;
    data['active'] = this.active;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.rates != null) {
      data['rates'] = this.rates.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rates {
  int id;
  String name;
  int shippingZoneId;
  int carrierId;
  String basedOn;
  int minimum;
  int maximum;
  int rate;
  String deliveryTakes;

  Rates(
      {this.id,
      this.name,
      this.shippingZoneId,
      this.carrierId,
      this.basedOn,
      this.minimum,
      this.maximum,
      this.rate,
      this.deliveryTakes});

  Rates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shippingZoneId = json['shippingZoneId'];
    carrierId = json['carrierId'];
    basedOn = json['basedOn'];
    minimum = json['minimum'];
    maximum = json['maximum'];
    rate = json['rate'];
    deliveryTakes = json['deliveryTakes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['shippingZoneId'] = this.shippingZoneId;
    data['carrierId'] = this.carrierId;
    data['basedOn'] = this.basedOn;
    data['minimum'] = this.minimum;
    data['maximum'] = this.maximum;
    data['rate'] = this.rate;
    data['deliveryTakes'] = this.deliveryTakes;
    return data;
  }
}
