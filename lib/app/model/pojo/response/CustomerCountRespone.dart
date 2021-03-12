import 'ThrowIfNoSuccess.dart';

class CustomerCountRespone {
  int like;
  int watingReview;
  Notification notification;
  BuyOrder buyOrder;
  SellOrder sellOrder;
  int CartCount;
  ThrowIfNoSuccess http_call_back;

  CustomerCountRespone(
      {this.like=0,
        this.watingReview=0,
        this.notification,
        this.buyOrder,
        this.sellOrder,this.CartCount,this.http_call_back});

  CustomerCountRespone.fromJson(Map<String, dynamic> json) {
    like = json['like'];
    watingReview = json['watingReview'];
    notification = json['notification'] != null
        ? new Notification.fromJson(json['notification'])
        : null;
    buyOrder = json['buyOrder'] != null
        ? new BuyOrder.fromJson(json['buyOrder'])
        : null;
    sellOrder = json['sellOrder'] != null
        ? new SellOrder.fromJson(json['sellOrder'])
        : null;
    CartCount = json['CartCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['like'] = this.like;
    data['watingReview'] = this.watingReview;
    if (this.notification != null) {
      data['notification'] = this.notification.toJson();
    }
    if (this.buyOrder != null) {
      data['buyOrder'] = this.buyOrder.toJson();
    }
    if (this.sellOrder != null) {
      data['sellOrder'] = this.sellOrder.toJson();
    }
    data['CartCount'] = this.CartCount;
    return data;
  }
}

class Notification {
  int unreadCustomer;
  int unreadShop;

  Notification({this.unreadCustomer, this.unreadShop});

  Notification.fromJson(Map<String, dynamic> json) {
    unreadCustomer = json['unreadCustomer'];
    unreadShop = json['unreadShop'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unreadCustomer'] = this.unreadCustomer;
    data['unreadShop'] = this.unreadShop;
    return data;
  }
}

class BuyOrder {
  int unpaid;
  int failed;
  int confirm;
  int toBeRecieve;
  int delivered;
  int refund;
  int cancel;

  BuyOrder(
      {this.unpaid,
        this.failed,
        this.confirm,
        this.toBeRecieve,
        this.delivered,
        this.refund,
        this.cancel});

  BuyOrder.fromJson(Map<String, dynamic> json) {
    unpaid = json['unpaid'];
    failed = json['failed'];
    confirm = json['confirm'];
    toBeRecieve = json['toBeRecieve'];
    delivered = json['delivered'];
    refund = json['refund'];
    cancel = json['cancel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unpaid'] = this.unpaid;
    data['failed'] = this.failed;
    data['confirm'] = this.confirm;
    data['toBeRecieve'] = this.toBeRecieve;
    data['delivered'] = this.delivered;
    data['refund'] = this.refund;
    data['cancel'] = this.cancel;
    return data;
  }
}

class SellOrder {
  int unpaid;
  int failed;
  int confirm;
  int shipping;
  int delivered;
  int refund;
  int cancel;

  SellOrder(
      {this.unpaid,
        this.failed,
        this.confirm,
        this.shipping,
        this.delivered,
        this.refund,
        this.cancel});

  SellOrder.fromJson(Map<String, dynamic> json) {
    unpaid = json['unpaid'];
    failed = json['failed'];
    confirm = json['confirm'];
    shipping = json['shipping'];
    delivered = json['delivered'];
    refund = json['refund'];
    cancel = json['cancel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unpaid'] = this.unpaid;
    data['failed'] = this.failed;
    data['confirm'] = this.confirm;
    data['shipping'] = this.shipping;
    data['delivered'] = this.delivered;
    data['refund'] = this.refund;
    data['cancel'] = this.cancel;
    return data;
  }
}

