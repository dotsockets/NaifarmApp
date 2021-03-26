import 'ProducItemRespone.dart';
import 'WishlistsRespone.dart';

class ProductObjectCombine {
  ProducItemRespone producItemRespone;
  DataWishlists dataWishlists;

  ProductObjectCombine({this.producItemRespone, this.dataWishlists});

  ProductObjectCombine.fromJson(Map<String, dynamic> json) {
    producItemRespone = json['producItemRespone'] != null ? new ProducItemRespone.fromJson(json['producItemRespone']) : null;
    dataWishlists = json['dataWishlists'] != null ? new DataWishlists.fromJson(json['dataWishlists']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.producItemRespone != null) {
      data['producItemRespone'] = this.producItemRespone.toJson();
    }


    if (this.dataWishlists != null) {
      data['dataWishlists'] = this.dataWishlists.toJson();
    }
    return data;
  }
}
