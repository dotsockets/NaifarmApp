import 'package:flutter/cupertino.dart';
import 'package:naifarm/app/ui/flashsale/FlashSaleView.dart';
import 'package:naifarm/app/ui/market/MarketView.dart';
import 'package:naifarm/app/ui/me/deliveryCost/DeliveryCostView.dart';
import 'package:naifarm/app/ui/me/mynewproduct/MyNewProductView.dart';
import 'package:naifarm/app/ui/me/myproduct/MyProductView.dart';
import 'package:naifarm/app/ui/me/myshop/myshophistory/MyShophiStoryView.dart';
import 'package:naifarm/app/ui/me/myshop/withdrawmoney/WithdrawMoneyView.dart';
import 'package:naifarm/app/ui/me/payment/PaymentView.dart';
import 'package:naifarm/app/ui/mycart/cart/MyCartView.dart';
import 'package:naifarm/app/ui/mycart/cartaddress/CartAaddressView.dart';
import 'package:naifarm/app/ui/mycart/cartbank/CartBankView.dart';
import 'package:naifarm/app/ui/me/delivery/DeliveryView.dart';
import 'package:naifarm/app/ui/mycart/cartsummary/CartSummaryView.dart';
import 'package:naifarm/app/ui/mylike/MyLikeView.dart';
import 'package:naifarm/app/ui/noti/notidetail/NotiDetailView.dart';
import 'package:naifarm/app/ui/noti/notilist/NotiView.dart';
import 'package:naifarm/app/ui/order/OrderView.dart';
import 'package:naifarm/app/ui/product_detail/ProductDetailView.dart';
import 'package:naifarm/app/ui/shopmain/ShopMainView.dart';
import 'package:naifarm/app/ui/shopmain/followers/FollowersView.dart';
import 'package:naifarm/app/ui/specialproducts/SpecialproductsView.dart';
import 'package:page_transition/page_transition.dart';

class AppRoute{
  // static  home(BuildContext context){
  //   Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: HomeView()));
  // }

  static ProductDetail(BuildContext context,{String productImage}){
    Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: ProductDetailView(productImage: productImage)));
  }
  static  Market(BuildContext context){
  Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MarketView()));
  }
  static  Specialproducts(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: SpecialproductsView()));
  }
  static  FlashSaleAll(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: FlashSaleView()));
  }

  static  MyCart(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyCartView()));
  }


  static  MyNoti(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: NotiView()));
  }

  static  NotiDetail(BuildContext context,String notiImage,String notiTitle){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: NotiDetailView(notiImage: notiImage,notiTitle: notiTitle,)));
  }

  static  MyLike(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyLikeView()));
  }
  static  OrderDetail(BuildContext context,int  Status_Sell){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: OrderView( Status_Sell: Status_Sell)));
  }

  static  CartSummary(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: CartSummaryView()));
  }

  static  CartAaddres(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: CartAaddressView()));
  }

  static  CartBank(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: CartBankView()));
  }

  static DeliveryMe(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: DeliveryView()));
  }
  static PaymentMe(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: PaymentView()));
  }
  static MyProduct(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyProductView()));
  }
  static MyNewProduct(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyNewProductView()));
  }


  static ShopMain(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: ShopMainView()));
  }


  static Followers(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: FollowersView()));
  }

  static DeliveryCost(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: DeliveryCostView()));
  }

  static WithdrawMoney(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: WithdrawMoneyView()));
  }

  static MyShophistory(BuildContext context){
    Navigator.push(context, PageTransition(duration: Duration(milliseconds: 300),type: PageTransitionType.fade, child: MyShophistoryView()));
  }
}

