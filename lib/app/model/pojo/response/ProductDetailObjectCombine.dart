import 'MyShopRespone.dart';
import 'ProducItemRespone.dart';
import 'ProductRespone.dart';
import 'WishlistsRespone.dart';

class ProductDetailObjectCombine{
  final ProducItemRespone productItem;
  final ProductRespone recommend;
  final MyShopRespone shopRespone;
  final WishlistsRespone wishlistsRespone;

  ProductDetailObjectCombine({this.wishlistsRespone, this.productItem, this.recommend,this.shopRespone});
}