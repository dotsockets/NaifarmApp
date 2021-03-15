class NotificationOneSignal {
  Data item;
  String i;

  NotificationOneSignal({this.item, this.i});

  NotificationOneSignal.fromJson(Map<String, dynamic> json) {
    item = json['a'] != null ? new Data.fromJson(json['a']) : null;
    i = json['i'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.item != null) {
      data['a'] = this.item.toJson();
    }
    data['i'] = this.i;
    return data;
  }
}

class Data {
  String name;
  String image;
  String requirePaymentAt;
  String id;
  String order;
  String status;

  Data(
      {this.name,
      this.image,
      this.requirePaymentAt,
      this.id,
      this.order,
      this.status});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    requirePaymentAt = json['requirePaymentAt'];
    id = json['id'];
    order = json['order'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['requirePaymentAt'] = this.requirePaymentAt;
    data['id'] = this.id;
    data['order'] = this.order;
    data['status'] = this.status;
    return data;
  }
}
