import 'ThrowIfNoSuccess.dart';

class OTPRespone {
  String phone;
  String refCode;
  ThrowIfNoSuccess httpCallBack;

  OTPRespone({this.phone, this.refCode, this.httpCallBack});

  OTPRespone.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    refCode = json['refCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['refCode'] = this.refCode;
    return data;
  }
}
