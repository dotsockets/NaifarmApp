import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';

class CategoriesRespone {
  List<CategoriesData> data;
  int total;

  CategoriesRespone({this.data, this.total});

  CategoriesRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new CategoriesData.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class CategoriesData {
  int id;
  int categorySubGroupId;
  String name;
  String slug;
  String description;
  int order;
  List<ProductImage> image;

  CategoriesData(
      {this.id,
      this.categorySubGroupId,
      this.name,
      this.slug,
      this.description,
      this.order,
      this.image});

  CategoriesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categorySubGroupId = json['categorySubGroupId'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    order = json['order'];
    if (json['image'] != null) {
      image = [];
      json['image'].forEach((v) {
        image.add(new ProductImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categorySubGroupId'] = this.categorySubGroupId;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['order'] = this.order;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
