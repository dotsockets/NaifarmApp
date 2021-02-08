
import 'CustomerInfoRespone.dart';
import 'MyShopRespone.dart';

class ProfileObjectCombine{
   CustomerInfoRespone customerInfoRespone;
   MyShopRespone myShopRespone;

  ProfileObjectCombine({this.customerInfoRespone, this.myShopRespone});


  ProfileObjectCombine.fromJson(Map<String, dynamic> json) {

    customerInfoRespone = json['customerInfoRespone'] != null ? new CustomerInfoRespone.fromJson(json['customerInfoRespone']) : null;
    myShopRespone = json['myShopRespone'] != null ? new MyShopRespone.fromJson(json['myShopRespone']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.customerInfoRespone != null) {
      data['customerInfoRespone'] = this.customerInfoRespone.toJson();
    }

    if (this.myShopRespone != null) {
      data['myShopRespone'] = this.myShopRespone.toJson();
    }

    return data;
  }
}