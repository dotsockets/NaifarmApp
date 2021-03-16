class ShippingsRespone {
  List<ShippingsData> data;
  int total;

  ShippingsRespone({this.data, this.total});

  ShippingsRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ShippingsData>[];
      json['data'].forEach((v) {
        data.add(new ShippingsData.fromJson(v));
      });
    }
    total = json['total'];
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

class ShippingsData {
  int id;
  int shopId;
  String name;
  int taxId;
  String countryIds;
  String stateIds;
  int restOfTheWorld;
  int active;
  String createdAt;
  String updatedAt;
  List<ShippingRates> rates;

  ShippingsData(
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

  ShippingsData.fromJson(Map<String, dynamic> json) {
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
      rates = <ShippingRates>[];
      json['rates'].forEach((v) {
        rates.add(new ShippingRates.fromJson(v));
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

class ShippingRates {
  int id;
  String name;
  int shippingZoneId;
  int carrierId;
  Carrier carrier;
  String basedOn;
  int minimum;
  int maximum;
  int rate;
  String deliveryTakes;
  bool select;

  ShippingRates(
      {this.id,
      this.name,
      this.shippingZoneId,
      this.carrierId,
      this.carrier,
      this.basedOn,
      this.minimum,
      this.maximum,
      this.rate,
      this.deliveryTakes,
      this.select});

  ShippingRates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shippingZoneId = json['shippingZoneId'];
    carrierId = json['carrierId'];
    carrier =
        json['carrier'] != null ? new Carrier.fromJson(json['carrier']) : null;
    basedOn = json['basedOn'];
    minimum = json['minimum'];
    maximum = json['maximum'];
    rate = json['rate'] != null ? json['rate'] : 0;
    deliveryTakes = json['deliveryTakes'];
    select = json['select'] != null ? json['select'] : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['shippingZoneId'] = this.shippingZoneId;
    data['carrierId'] = this.carrierId;
    if (this.carrier != null) {
      data['carrier'] = this.carrier.toJson();
    }
    data['basedOn'] = this.basedOn;
    data['minimum'] = this.minimum;
    data['maximum'] = this.maximum;
    data['rate'] = this.rate;
    data['deliveryTakes'] = this.deliveryTakes;
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
