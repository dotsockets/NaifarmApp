
import 'CategoryGroupRespone.dart';
import 'MyShopRespone.dart';
import 'ProductRespone.dart';

class NaiFarmShopCombin{
  List<ZipShopObjectCombin> item;

  NaiFarmShopCombin(this.item);

  NaiFarmShopCombin.fromJson(Map<String, dynamic> json) {

    if (json['item'] != null) {
      item = new List<ZipShopObjectCombin>();
      json['item'].forEach((v) {
        item.add(new ZipShopObjectCombin.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.item != null) {
      data['item'] = this.item.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ZipShopObjectCombin{
   ProductRespone productmyshop;
   ProductRespone productrecommend;
   MyShopRespone shopRespone;
   CategoryGroupRespone categoryGroupRespone;

  ZipShopObjectCombin( {this.productmyshop, this.productrecommend, this.shopRespone,this.categoryGroupRespone});

   ZipShopObjectCombin.fromJson(Map<String, dynamic> json) {
     productmyshop = json['productmyshop'] != null ? new ProductRespone.fromJson(json['productmyshop']) : null;
     productrecommend = json['productrecommend'] != null ? new ProductRespone.fromJson(json['productrecommend']) : null;
     shopRespone = json['shopRespone'] != null ? new MyShopRespone.fromJson(json['shopRespone']) : null;
     categoryGroupRespone = json['categoryGroupRespone'] != null ? new CategoryGroupRespone.fromJson(json['categoryGroupRespone']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productmyshop != null) {
      data['productmyshop'] = this.productmyshop.toJson();
    }
    if (this.productrecommend != null) {
      data['productrecommend'] = this.productrecommend.toJson();
    }
    if (this.shopRespone != null) {
      data['shopRespone'] = this.shopRespone.toJson();
    }
    if (this.categoryGroupRespone != null) {
      data['categoryGroupRespone'] = this.categoryGroupRespone.toJson();
    }
    return data;
  }
}