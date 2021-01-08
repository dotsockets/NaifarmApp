class ShppingMyShopRequest {
  String name;
  int shippingZoneId;
  int carrierId;
  String basedOn;
  int minimum;
  int maximum;
  int rate;
  String deliveryTakes;

  ShppingMyShopRequest(
      {this.name,
        this.shippingZoneId,
        this.carrierId,
        this.basedOn,
        this.minimum,
        this.maximum,
        this.rate,
        this.deliveryTakes});

  ShppingMyShopRequest.fromJson(Map<String, dynamic> json) {
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

