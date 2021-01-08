import 'MyShopRespone.dart';
import 'ProducItemRespone.dart';
import 'ProductRespone.dart';

class ProductDetailObjectCombine{
  final ProducItemRespone productItem;
  final ProductRespone recommend;
  final MyShopRespone shopRespone;

  ProductDetailObjectCombine({this.productItem, this.recommend,this.shopRespone});
}