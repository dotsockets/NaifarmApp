
import 'BannersRespone.dart';
import 'CategoryGroupRespone.dart';
import 'ProductRespone.dart';

class CategoryObjectCombin{
  final CategoryGroupRespone supGroup;
  final ProductRespone goupProduct;
  final ProductRespone recommend;
  final BannersRespone banner;
  final ProductRespone hotProduct;

  CategoryObjectCombin({this.supGroup, this.goupProduct, this.recommend, this.banner, this.hotProduct});

}