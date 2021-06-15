
class NotificationOneSignal {
  Aps aps;
  Custom custom;

  NotificationOneSignal({this.aps, this.custom});

  NotificationOneSignal.fromJson(Map<String, dynamic> json) {
    aps = json['aps'] != null ? new Aps.fromJson(json['aps']) : null;
    custom =
    json['custom'] != null ? new Custom.fromJson(json['custom']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aps != null) {
      data['aps'] = this.aps.toJson();
    }
    if (this.custom != null) {
      data['custom'] = this.custom.toJson();
    }
    return data;
  }
}

class Aps {
  String alert;
  int mutableContent;
  String sound;

  Aps({this.alert, this.mutableContent, this.sound});

  Aps.fromJson(Map<String, dynamic> json) {
    alert = json['alert'];
    mutableContent = json['mutable-content'];
    sound = json['sound'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alert'] = this.alert;
    data['mutable-content'] = this.mutableContent;
    data['sound'] = this.sound;
    return data;
  }
}

class Custom {
  A a;
  String i;

  Custom({this.a, this.i});

  Custom.fromJson(Map<String, dynamic> json) {
    a = json['a'] != null ? new A.fromJson(json['a']) : null;
    i = json['i'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.a != null) {
      data['a'] = this.a.toJson();
    }
    data['i'] = this.i;
    return data;
  }
}

class A {
  String name;
  String image;
  String requirePaymentAt;
  String id;
  String customer;
  String customerName;
  String order;
  String status;
  String type;

  A(
      {this.name,
        this.image,
        this.requirePaymentAt,
        this.id,
        this.customer,
        this.customerName,
        this.order,
        this.status,this.type});

  A.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    requirePaymentAt = json['requirePaymentAt'];
    id = json['id'];
    customer = json['customer'];
    customerName = json['customerName'];
    order = json['order'];
    status = json['status'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['requirePaymentAt'] = this.requirePaymentAt;
    data['id'] = this.id;
    data['customer'] = this.customer;
    data['customerName'] = this.customerName;
    data['order'] = this.order;
    data['status'] = this.status;
    data['type'] = this.type;
    return data;
  }
}