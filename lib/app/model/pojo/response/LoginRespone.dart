

import 'ThrowIfNoSuccess.dart';

class LoginRespone {
  String token;
  String name;
  String email;
  ThrowIfNoSuccess http_call_back;

  LoginRespone({this.token, this.name, this.email,this.http_call_back});

  LoginRespone.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}