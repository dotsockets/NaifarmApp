import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';

class CategoriesAllRespone {
  List<CategoriesAllData> data;
  int total;

  CategoriesAllRespone({this.data, this.total});

  CategoriesAllRespone.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new CategoriesAllData.fromJson(v));
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

class CategoriesAllData {
  int id;
  String name;
  String slug;
  String description;
  String icon;
  int order;
  List<ProductImage> image;
  List<CategorySubGroups> categorySubGroups;

  CategoriesAllData(
      {this.id,
      this.name,
      this.slug,
      this.description,
      this.icon,
      this.order,
      this.image,
      this.categorySubGroups});

  CategoriesAllData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    icon = json['icon'];
    order = json['order'];
    if (json['image'] != null) {
      image = [];
      json['image'].forEach((v) {
        image.add(new ProductImage.fromJson(v));
      });
    }
    if (json['categorySubGroups'] != null) {
      categorySubGroups = [];
      json['categorySubGroups'].forEach((v) {
        categorySubGroups.add(new CategorySubGroups.fromJson(v));
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
    if (this.categorySubGroups != null) {
      data['categorySubGroups'] =
          this.categorySubGroups.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategorySubGroups {
  int id;
  String name;
  String slug;
  int order;
  List<ProductImage> image;
  List<Category> category;

  CategorySubGroups(
      {this.id, this.name, this.slug, this.order, this.image, this.category});

  CategorySubGroups.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    order = json['order'];
    if (json['image'] != null) {
      image = [];
      json['image'].forEach((v) {
        image.add(new ProductImage.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = [];
      json['category'].forEach((v) {
        category.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['order'] = this.order;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int id;
  int categorySubGroupId;
  String name;
  String slug;
  String description;
  int order;

  Category(
      {this.id,
      this.categorySubGroupId,
      this.name,
      this.slug,
      this.description,
      this.order});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categorySubGroupId = json['categorySubGroupId'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categorySubGroupId'] = this.categorySubGroupId;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['order'] = this.order;
    return data;
  }
}
