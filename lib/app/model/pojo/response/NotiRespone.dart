class NotiRespone {
  List<NotiData> data;
  int total;
  String page;
  String limit;

  NotiRespone({this.data, this.total, this.page, this.limit});

  NotiRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <NotiData>[];
      json['data'].forEach((v) {
        data.add(new NotiData.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'] is int ? json['page'].toString() : json['page'];
    limit = json['limit'] is int ? json['limit'].toString() : json['limit'];
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

class NotiData {
  String id;
  String type;
  String notifiableType;
  int notifiableId;
  Null createdBy;
  Null icon;
  Null actionText;
  Null actionUrl;
  String data;
  Meta meta;
  String readAt;

  NotiData(
      {this.id,
      this.type,
      this.notifiableType,
      this.notifiableId,
      this.createdBy,
      this.icon,
      this.actionText,
      this.actionUrl,
      this.data,
      this.meta,
      this.readAt});

  NotiData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    notifiableType = json['notifiableType'];
    notifiableId = json['notifiableId'];
    createdBy = json['createdBy'];
    icon = json['icon'];
    actionText = json['actionText'];
    actionUrl = json['actionUrl'];
    data = json['data'];
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    readAt = json['readAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['notifiableType'] = this.notifiableType;
    data['notifiableId'] = this.notifiableId;
    data['createdBy'] = this.createdBy;
    data['icon'] = this.icon;
    data['actionText'] = this.actionText;
    data['actionUrl'] = this.actionUrl;
    data['data'] = this.data;
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    data['readAt'] = this.readAt;
    return data;
  }
}

class Meta {
  String user;
  String name;
  String status;
  String id;
  String order;
  String customer;
  String customerName;
  String requirePaymentAt;
  String image;
  String shop;
  String trackingNumber;
  String carrierName;
  String shippingDate;
  String type;
  String paymentAt;
  String updateAt;
  String inventoryId;
  String inventoryTitle;
  int stockQuantity;
  int shopId;

  Meta({
    this.user,
    this.name,
    this.status,
    this.id,
    this.order,
    this.customer,
    this.customerName,
    this.image,
    this.shop,
    this.trackingNumber,
    this.carrierName,
    this.shippingDate,
    this.type,
    this.paymentAt,
    this.updateAt,
    this.inventoryId,
    this.inventoryTitle,
    this.stockQuantity,
    this.shopId,
  });

  Meta.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    name = json['name'];
    status = json['status'];
    id = json['id'];
    order = json['order'];
    customer = json['customer'];
    customerName = json['customerName'];
    requirePaymentAt = json['requirePaymentAt'];
    image = json['image'];
    shop = json['shop'];
    trackingNumber = json['trackingNumber'];
    carrierName = json['carrierName'];
    shippingDate = json['shippingDate'];
    type = json['type'];
    paymentAt = json['paymentAt'];
    updateAt = json['updateAt'];
    inventoryId = json['inventory_id'];
    inventoryTitle = json['inventory_title'];
    stockQuantity = json['stock_quantity'];
    shopId = json['shop_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['name'] = this.name;
    data['status'] = this.status;
    data['id'] = this.id;
    data['order'] = this.order;
    data['customer'] = this.customer;
    data['customerName'] = this.customerName;
    data['requirePaymentAt'] = this.requirePaymentAt;
    data['image'] = this.image;
    data['shop'] = this.shop;
    data['trackingNumber'] = this.trackingNumber;
    data['carrierName'] = this.carrierName;
    data['shippingDate'] = this.shippingDate;
    data['type'] = this.type;
    data['paymentAt'] = this.paymentAt;
    data['updateAt'] = this.updateAt;
    data['inventory_id'] = this.inventoryId;
    data['inventory_title'] = this.inventoryTitle;
    data['stock_quantity'] = this.stockQuantity;
    data['shop_id'] = this.shopId;
    return data;
  }
}
