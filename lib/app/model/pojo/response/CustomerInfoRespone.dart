import 'package:naifarm/app/model/pojo/response/StatesRespone.dart';

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
  Shop shop;
  List<ImageShop> image;
  ThrowIfNoSuccess httpCallBack;

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
      this.image,
      this.httpCallBack});

  CustomerInfoRespone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    niceName = json['niceName'];
    email = json['email'];
    phone = json['phone'];
    sex = json['sex'];
    dob = json['dob'];
    description = json['description'];
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
    if (json['image'] != null) {
      image = [];
      json['image'].forEach((v) {
        image.add(new ImageShop.fromJson(v));
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
    if (this.shop != null) {
      data['shop'] = this.shop.toJson();
    }
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageShop {
  String name;
  String path;

  ImageShop({this.name, this.path});

  ImageShop.fromJson(Map<String, dynamic> json) {
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

class Shop {
  int id;
  String name;
  String slug;
  DataStates state;
  String updatedAt;
  List<ImageShop> image;

  Shop({this.id, this.name, this.slug, this.state, this.updatedAt, this.image});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    state =
        json['state'] != null ? new DataStates.fromJson(json['state']) : null;
    updatedAt = json['updatedAt'];
    if (json['image'] != null) {
      image = [];
      json['image'].forEach((v) {
        image.add(new ImageShop.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    if (this.state != null) {
      data['state'] = this.state.toJson();
    }
    data['updatedAt'] = this.updatedAt;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
