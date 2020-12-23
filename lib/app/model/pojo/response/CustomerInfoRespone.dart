import 'ThrowIfNoSuccess.dart';

class CustomerInfoRespone {
  int id;
  String name;
  String niceName;
  String email;
  String phone;
  String sex;
  String dob;
  String description;
  String shop;
  List<Image> image;
  ThrowIfNoSuccess http_call_back;

  CustomerInfoRespone(
      {this.id,
        this.name,
        this.niceName,
        this.email,
        this.phone,
        this.sex,
        this.dob,
        this.description,
        this.shop,
        this.image,this.http_call_back});

  CustomerInfoRespone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    niceName = json['niceName'];
    email = json['email'];
    phone = json['phone'];
    sex = json['sex'];
    dob = json['dob'];
    description = json['description'];
    shop = json['shop'];
    if (json['image'] != null) {
      image = new List<Image>();
      json['image'].forEach((v) {
        image.add(new Image.fromJson(v));
      });
    }
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
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Image {
  String name;
  String path;

  Image({this.name, this.path});

  Image.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['path'] = this.path;
    return data;
  }
}