
import 'OrderRespone.dart';

class ProductOrderCache{
  List<OrderCache> orderCahe;
  ProductOrderCache({this.orderCahe});

  ProductOrderCache.fromJson(Map<String, dynamic> json) {
    if (json['orderCahe'] != null) {
      orderCahe = new List<OrderCache>();
      json['orderCahe'].forEach((v) {
        orderCahe.add(new OrderCache.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.orderCahe != null) {
      data['orderCahe'] = this.orderCahe.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderCache{
  OrderData orderData;
  String TypeView;
  String orderViewType;

  OrderCache({this.orderData, this.TypeView, this.orderViewType});

  OrderCache.fromJson(Map<String, dynamic> json) {
    orderData = json['orderData'] != null ? new OrderData.fromJson(json['orderData']) : null;
    TypeView = json['TypeView'];
    orderViewType = json['orderViewType'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderData != null) {
      data['orderData'] = this.orderData.toJson();
    }
    data['TypeView'] = this.TypeView;
    data['orderViewType'] = this.orderViewType;
    return data;
  }

}