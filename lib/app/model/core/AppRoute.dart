import 'package:flutter/cupertino.dart';
import 'package:naifarm/app/ui/home/HomeView.dart';
import 'package:naifarm/app/ui/market/MarketView.dart';
import 'package:naifarm/app/ui/product_detail/ProductDetailView.dart';
import 'package:page_transition/page_transition.dart';

class AppRoute{
  // static  home(BuildContext context){
  //   Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: HomeView()));
  // }

  static ProductDetail(BuildContext context,{String productImage,String productName,String productStatus,String productPrice}){
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ProductDetailView(productImage: productImage,productName: productName,productStatus: productStatus,productPrice: productPrice,)));
  }
  static  Market(BuildContext context){
  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MarketView()));
  }
}