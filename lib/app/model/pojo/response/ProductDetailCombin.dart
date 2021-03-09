
import 'ProductObjectCombine.dart';
import 'SearchRespone.dart';

class ProductDetailCombin{
    List<ProductDetailData> item;

  ProductDetailCombin(this.item);

    ProductDetailCombin.fromJson(Map<String, dynamic> json) {

     if (json['item'] != null) {
       item = new List<ProductDetailData>();
       json['item'].forEach((v) {
         item.add(new ProductDetailData.fromJson(v));
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

class ProductDetailData{
   ProductObjectCombine productObjectCombine;
   SearchRespone searchRespone;

  ProductDetailData({this.productObjectCombine, this.searchRespone});

  ProductDetailData.fromJson(Map<String, dynamic> json) {
    productObjectCombine = json['productObjectCombine'] != null ? new ProductObjectCombine.fromJson(json['productObjectCombine']) : null;
    searchRespone = json['searchRespone'] != null ? new SearchRespone.fromJson(json['searchRespone']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productObjectCombine != null) {
      data['productObjectCombine'] = this.productObjectCombine.toJson();
    }
    if (this.searchRespone != null) {
      data['searchRespone'] = this.searchRespone.toJson();
    }
    return data;
  }

}