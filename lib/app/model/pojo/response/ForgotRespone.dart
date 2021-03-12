import 'ThrowIfNoSuccess.dart';

class ForgotRespone {
  String email;
  String token;
  ThrowIfNoSuccess httpCallBack;

  ForgotRespone({this.email, this.token, this.httpCallBack});

  ForgotRespone.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['token'] = this.token;
    return data;
  }
}
