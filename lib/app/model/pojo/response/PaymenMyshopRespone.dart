class PaymenMyshopRespone {
  List<PaymenMyshopData> data;
  int total;

  PaymenMyshopRespone({this.data, this.total});

  PaymenMyshopRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new PaymenMyshopData.fromJson(v));
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

class PaymenMyshopData {
  int paymentMethodId;
  int shopId;

  PaymenMyshopData({this.paymentMethodId, this.shopId});

  PaymenMyshopData.fromJson(Map<String, dynamic> json) {
    paymentMethodId = json['paymentMethodId'];
    shopId = json['shopId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentMethodId'] = this.paymentMethodId;
    data['shopId'] = this.shopId;
    return data;
  }
}
