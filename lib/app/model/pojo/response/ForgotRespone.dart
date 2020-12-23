import 'ThrowIfNoSuccess.dart';

class ForgotRespone {
  String email;
  String token;
  ThrowIfNoSuccess http_call_back;

  ForgotRespone({this.email, this.token,this.http_call_back});

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