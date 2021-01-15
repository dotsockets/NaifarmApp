class CartRequest {
  int shopId;
  String ipAddress;
  int paymentMethodId;
  int shippingZoneId;
  int shippingRateId;
  int couponId;
  String coupon;
  int packagingId;
  int taxId;
  int shipTo;
  List<Items> items;

  CartRequest(
      {this.shopId,
        this.ipAddress,
        this.paymentMethodId,
        this.shippingZoneId,
        this.shippingRateId,
        this.couponId,
        this.coupon,
        this.packagingId,
        this.taxId,
        this.shipTo,
        this.items});

  CartRequest.fromJson(Map<String, dynamic> json) {
    shopId = json['shopId'];
    ipAddress = json['ipAddress'];
    paymentMethodId = json['paymentMethodId'];
    shippingZoneId = json['shippingZoneId'];
    shippingRateId = json['shippingRateId'];
    couponId = json['couponId'];
    coupon = json['coupon'];
    packagingId = json['packagingId'];
    taxId = json['taxId'];
    shipTo = json['shipTo'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shopId'] = this.shopId;
    data['ipAddress'] = this.ipAddress;
    data['paymentMethodId'] = this.paymentMethodId;
    data['shippingZoneId'] = this.shippingZoneId;
    data['shippingRateId'] = this.shippingRateId;
    data['couponId'] = this.couponId;
    data['coupon'] = this.coupon;
    data['packagingId'] = this.packagingId;
    data['taxId'] = this.taxId;
    data['shipTo'] = this.shipTo;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int inventoryId;
  int quantity;

  Items({this.inventoryId, this.quantity});

  Items.fromJson(Map<String, dynamic> json) {
    inventoryId = json['inventoryId'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inventoryId'] = this.inventoryId;
    data['quantity'] = this.quantity;
    return data;
  }
}