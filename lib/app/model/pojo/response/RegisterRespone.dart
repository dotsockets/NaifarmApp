import 'ThrowIfNoSuccess.dart';

class RegisterRespone {
  int id;
  String name;
  String niceName;
  String email;
  String phone;
  String sex;
  String dob;
  String description;
  String shop;
  ThrowIfNoSuccess http_call_back;

  RegisterRespone(
      {this.id,
        this.name,
        this.niceName,
        this.email,
        this.phone,
        this.sex,
        this.dob,
        this.description,
        this.shop,this.http_call_back});

  RegisterRespone.fromJson(Map<String, dynamic> json,) {
    id = json['id'];
    name = json['name'];
    niceName = json['niceName'];
    email = json['email'];
    phone = json['phone'];
    sex = json['sex'];
    dob = json['dob'];
    description = json['description'];
    shop = json['shop'];
    http_call_back = json['shop'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['niceName'] = this.niceName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['sex'] = this.sex;
    data['dob'] = this.dob;
    data['description'] = this.description;
    data['shop'] = this.shop;
    data['shop'] = this.shop;
    return data;
  }
}