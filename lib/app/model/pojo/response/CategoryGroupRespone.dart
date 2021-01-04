import 'SliderRespone.dart';

class CategoryGroupRespone {
  List<CategoryGroupData> data;
  int total;

  CategoryGroupRespone({this.data, this.total});

  CategoryGroupRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<CategoryGroupData>();
      json['data'].forEach((v) {
        data.add(new CategoryGroupData.fromJson(v));
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

class CategoryGroupData {
  int id;
  String name;
  String slug;
  String description;
  String icon;
  int order;
  List<SliderImage> image;

  CategoryGroupData(
      {this.id,
        this.name,
        this.slug,
        this.description,
        this.icon,
        this.order,
        this.image});

  CategoryGroupData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    icon = json['icon'];
    order = json['order'];
    if (json['image'] != null) {
      image = new List<SliderImage>();
      json['image'].forEach((v) {
        image.add(new SliderImage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['icon'] = this.icon;
    data['order'] = this.order;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

