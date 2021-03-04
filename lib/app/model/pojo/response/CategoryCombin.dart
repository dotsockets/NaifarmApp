
import 'CategoriesAllRespone.dart';
import 'CategoriesRespone.dart';
import 'StatesRespone.dart';

class CategoryCombin{
   CategoriesAllRespone categoriesAllRespone;
   CategoriesRespone categoriesRespone;
   StatesRespone statesRespone;

  CategoryCombin({this.categoriesAllRespone, this.categoriesRespone,this.statesRespone});

  CategoryCombin.fromJson(Map<String, dynamic> json) {

    categoriesAllRespone = json['categoriesAllRespone'] != null ? new CategoriesAllRespone.fromJson(json['categoriesAllRespone']) : null;
    categoriesRespone = json['categoriesRespone'] != null ? new CategoriesRespone.fromJson(json['categoriesRespone']) : null;
    statesRespone = json['statesRespone'] != null ? new StatesRespone.fromJson(json['statesRespone']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.categoriesAllRespone != null) {
      data['categoriesAllRespone'] = this.categoriesAllRespone.toJson();
    }

    if (this.categoriesRespone != null) {
      data['categoriesRespone'] = this.categoriesRespone.toJson();
    }

    if (this.statesRespone != null) {
      data['statesRespone'] = this.statesRespone.toJson();
    }

    return data;
  }
}