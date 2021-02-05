
import 'CategoryGroupRespone.dart';
import 'MyShopRespone.dart';
import 'ProductRespone.dart';

class ZipShopObjectCombin{
  final ProductRespone productmyshop;
  final ProductRespone productrecommend;
  final MyShopRespone shopRespone;
  final CategoryGroupRespone categoryGroupRespone;

  ZipShopObjectCombin( {this.productmyshop, this.productrecommend, this.shopRespone,this.categoryGroupRespone});
}