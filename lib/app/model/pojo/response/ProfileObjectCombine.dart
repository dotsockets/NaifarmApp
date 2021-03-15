import 'CustomerInfoRespone.dart';
import 'MyShopRespone.dart';
import 'ShppingMyShopRespone.dart';
import 'ThrowIfNoSuccess.dart';

class ProfileObjectCombine {
  CustomerInfoRespone customerInfoRespone;
  MyShopRespone myShopRespone;
  ShppingMyShopRespone shppingMyShopRespone;
  ThrowIfNoSuccess httpCallBack;

  ProfileObjectCombine(
      {this.customerInfoRespone,
      this.myShopRespone,
      this.shppingMyShopRespone,
      this.httpCallBack});

  ProfileObjectCombine.fromJson(Map<String, dynamic> json) {
    customerInfoRespone = json['customerInfoRespone'] != null
        ? new CustomerInfoRespone.fromJson(json['customerInfoRespone'])
        : null;
    myShopRespone = json['myShopRespone'] != null
        ? new MyShopRespone.fromJson(json['myShopRespone'])
        : null;
    shppingMyShopRespone = json['shppingMyShopRespone'] != null
        ? new ShppingMyShopRespone.fromJson(json['shppingMyShopRespone'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.customerInfoRespone != null) {
      data['customerInfoRespone'] = this.customerInfoRespone.toJson();
    }

    if (this.myShopRespone != null) {
      data['myShopRespone'] = this.myShopRespone.toJson();
    }

    if (this.shppingMyShopRespone != null) {
      data['shppingMyShopRespone'] = this.shppingMyShopRespone.toJson();
    }

    return data;
  }
}
