
import 'package:naifarm/app/bloc/Stream/OrdersBloc.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';

class ProductHistoryCache{
    List<HistoryCache> historyCache;
   ProductHistoryCache({this.historyCache});

    ProductHistoryCache.fromJson(Map<String, dynamic> json) {
      if (json['historyCache'] != null) {
        historyCache = new List<HistoryCache>();
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

class HistoryCache{
   OrderRespone orderRespone;
   String TypeView;
   String orderViewType;

  HistoryCache({this.orderRespone, this.TypeView, this.orderViewType});

  HistoryCache.fromJson(Map<String, dynamic> json) {
    orderRespone = json['orderRespone'] != null ? new OrderRespone.fromJson(json['orderRespone']) : null;
    TypeView = json['TypeView'];
    orderViewType = json['orderViewType'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderRespone != null) {
      data['orderRespone'] = this.orderRespone.toJson();
    }
    data['TypeView'] = this.TypeView;
    data['orderViewType'] = this.orderViewType;
    return data;
  }

}