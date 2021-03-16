import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';

class ProductHistoryCache {
  List<HistoryCache> historyCache;
  ProductHistoryCache({this.historyCache});

  ProductHistoryCache.fromJson(Map<String, dynamic> json) {
    if (json['historyCache'] != null) {
      historyCache = <HistoryCache>[];
      json['historyCache'].forEach((v) {
        historyCache.add(new HistoryCache.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.historyCache != null) {
      data['historyCache'] = this.historyCache.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HistoryCache {
  OrderRespone orderRespone;
  String typeView;
  String orderViewType;

  HistoryCache({this.orderRespone, this.typeView, this.orderViewType});

  HistoryCache.fromJson(Map<String, dynamic> json) {
    orderRespone = json['orderRespone'] != null
        ? new OrderRespone.fromJson(json['orderRespone'])
        : null;
    typeView = json['TypeView'];
    orderViewType = json['orderViewType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderRespone != null) {
      data['orderRespone'] = this.orderRespone.toJson();
    }
    data['TypeView'] = this.typeView;
    data['orderViewType'] = this.orderViewType;
    return data;
  }
}
