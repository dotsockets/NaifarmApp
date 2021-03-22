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
  String customer;
  String customerName;
  String order;
  String status;
  String type;

  Data(
      {this.name,
      this.image,
      this.requirePaymentAt,
      this.id,
        this.customer,
        this.customerName,
      this.order,
      this.status,this.type});

  Data.fromJson(Map<String, dynamic> json) {
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
