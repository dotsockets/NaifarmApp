import 'ProducItemRespone.dart';
import 'WishlistsRespone.dart';

class ProductObjectCombine {
  ProducItemRespone producItemRespone;
  WishlistsRespone wishlistsRespone;

  ProductObjectCombine({this.producItemRespone, this.wishlistsRespone});

  ProductObjectCombine.fromJson(Map<String, dynamic> json) {
    producItemRespone = json['producItemRespone'] != null
        ? new ProducItemRespone.fromJson(json['producItemRespone'])
        : null;
    wishlistsRespone = json['wishlistsRespone'] != null
        ? new WishlistsRespone.fromJson(json['wishlistsRespone'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.producItemRespone != null) {
      data['producItemRespone'] = this.producItemRespone.toJson();
    }
    if (this.wishlistsRespone != null) {
      data['wishlistsRespone'] = this.wishlistsRespone.toJson();
    }
    return data;
  }
}
