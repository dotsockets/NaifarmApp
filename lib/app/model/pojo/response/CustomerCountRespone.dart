class CustomerCountRespone {
  int like;
  int watingReview;
  Notification notification;
  BuyOrder buyOrder;
  BuyOrder sellOrder;

  CustomerCountRespone(
      {this.like,
        this.watingReview,
        this.notification,
        this.buyOrder,
        this.sellOrder});

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
        ? new BuyOrder.fromJson(json['sellOrder'])
        : null;
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
  int fulfill;
  int awaitingDelivered;
  int delivered;
  int refund;
  int cancel;

  BuyOrder(
      {this.unpaid,
        this.failed,
        this.confirm,
        this.fulfill,
        this.awaitingDelivered,
        this.delivered,
        this.refund,
        this.cancel});

  BuyOrder.fromJson(Map<String, dynamic> json) {
    unpaid = json['unpaid'];
    failed = json['failed'];
    confirm = json['confirm'];
    fulfill = json['fulfill'];
    awaitingDelivered = json['awaitingDelivered'];
    delivered = json['delivered'];
    refund = json['refund'];
    cancel = json['cancel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unpaid'] = this.unpaid;
    data['failed'] = this.failed;
    data['confirm'] = this.confirm;
    data['fulfill'] = this.fulfill;
    data['awaitingDelivered'] = this.awaitingDelivered;
    data['delivered'] = this.delivered;
    data['refund'] = this.refund;
    data['cancel'] = this.cancel;
    return data;
  }
}

