class OrderRequest {
  int cartId;
  int shopId;
  int paymentMethodId;
  int shippingZoneId;
  int shippingRateId;
  int couponId;
  String coupon;
  int packagingId;
  int taxId;
  int shipTo;
  int addressId;
  int carrierId;
  String email;
  String buyerNote;
  List<OrderRequestItems> items;

  OrderRequest(
      {this.cartId,
      this.shopId,
      this.paymentMethodId,
      this.shippingZoneId,
      this.shippingRateId,
      this.couponId,
      this.coupon,
      this.packagingId,
      this.taxId,
      this.shipTo,
      this.addressId,
      this.carrierId,
      this.email,
      this.buyerNote,
      this.items});

  OrderRequest.fromJson(Map<String, dynamic> json) {
    cartId = json['cartId'];
    shopId = json['shopId'];
    paymentMethodId = json['paymentMethodId'];
    shippingZoneId = json['shippingZoneId'];
    shippingRateId = json['shippingRateId'];
    couponId = json['couponId'];
    coupon = json['coupon'];
    packagingId = json['packagingId'];
    taxId = json['taxId'];
    shipTo = json['shipTo'];
    addressId = json['addressId'];
    carrierId = json['carrierId'];
    email = json['email'];
    buyerNote = json['buyerNote'];
    if (json['items'] != null) {
      items = <OrderRequestItems>[];
      json['items'].forEach((v) {
        items.add(new OrderRequestItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartId'] = this.cartId;
    data['shopId'] = this.shopId;
    data['paymentMethodId'] = this.paymentMethodId;
    data['shippingZoneId'] = this.shippingZoneId;
    data['shippingRateId'] = this.shippingRateId;
    data['couponId'] = this.couponId;
    data['coupon'] = this.coupon;
    data['packagingId'] = this.packagingId;
    data['taxId'] = this.taxId;
    data['shipTo'] = this.shipTo;
    data['addressId'] = this.addressId;
    data['carrierId'] = this.carrierId;
    data['email'] = this.email;
    data['buyerNote'] = this.buyerNote;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderRequestItems {
  int inventoryId;
  int quantity;
  int unitPrice;

  OrderRequestItems({this.inventoryId, this.quantity, this.unitPrice});

  OrderRequestItems.fromJson(Map<String, dynamic> json) {
    inventoryId = json['inventoryId'];
    quantity = json['quantity'];
    unitPrice = json['unitPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inventoryId'] = this.inventoryId;
    data['quantity'] = this.quantity;
    data['unitPrice'] = this.unitPrice;
    return data;
  }
}
