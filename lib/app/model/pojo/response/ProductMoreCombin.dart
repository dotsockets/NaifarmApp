import 'ProductRespone.dart';

class ProducMoreCache {
  List<ProductMoreCombin> productRespone;

  ProducMoreCache(this.productRespone);

  ProducMoreCache.fromJson(Map<String, dynamic> json) {
    if (json['productRespone'] != null) {
      productRespone = [];
      json['productRespone'].forEach((v) {
        productRespone.add(new ProductMoreCombin.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productRespone != null) {
      data['productRespone'] =
          this.productRespone.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductMoreCombin {
  ProductRespone searchRespone;
  String slag;

  ProductMoreCombin({this.searchRespone, this.slag});

  ProductMoreCombin.fromJson(Map<String, dynamic> json) {
    searchRespone = json['searchRespone'] != null
        ? new ProductRespone.fromJson(json['searchRespone'])
        : null;
    slag = json['slag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.searchRespone != null) {
      data['searchRespone'] = this.searchRespone.toJson();
    }
    data['slag'] = this.slag;
    return data;
  }
}
