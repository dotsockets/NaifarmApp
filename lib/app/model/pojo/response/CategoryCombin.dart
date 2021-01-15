
import 'CategoriesAllRespone.dart';
import 'CategoriesRespone.dart';

class CategoryCombin{
   CategoriesAllRespone categoriesAllRespone;
   CategoriesRespone categoriesRespone;

  CategoryCombin({this.categoriesAllRespone, this.categoriesRespone});

  CategoryCombin.fromJson(Map<String, dynamic> json) {

    categoriesAllRespone = json['categoriesAllRespone'] != null ? new CategoriesAllRespone.fromJson(json['categoriesAllRespone']) : null;
    categoriesRespone = json['categoriesRespone'] != null ? new CategoriesRespone.fromJson(json['categoriesRespone']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.categoriesAllRespone != null) {
      data['categoriesAllRespone'] = this.categoriesAllRespone.toJson();
    }

    if (this.categoriesRespone != null) {
      data['categoriesRespone'] = this.categoriesRespone.toJson();
    }

    return data;
  }
}