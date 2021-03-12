
import 'CategoryGroupRespone.dart';
import 'FlashsaleRespone.dart';
import 'MyShopRespone.dart';
import 'ProductRespone.dart';
import 'SliderRespone.dart';
import 'ThrowIfNoSuccess.dart';
import 'WishlistsRespone.dart';

class HomeObjectCombine{
  SliderRespone sliderRespone;
  ProductRespone productRespone;
  CategoryGroupRespone categoryGroupRespone;
  CategoryGroupRespone featuredRespone;
  ProductRespone  trendingRespone;
  ProductRespone martket;
  FlashsaleRespone flashsaleRespone;
  ProductRespone product_foryou;
  ThrowIfNoSuccess http_call_back;



  HomeObjectCombine({this.sliderRespone, this.productRespone,this.categoryGroupRespone,this.featuredRespone,this.trendingRespone,this.martket,this.flashsaleRespone,this.product_foryou,this.http_call_back});


  HomeObjectCombine.fromJson(Map<String, dynamic> json) {

    sliderRespone = json['sliderRespone'] != null ? new SliderRespone.fromJson(json['sliderRespone']) : null;
    productRespone = json['productRespone'] != null ? new ProductRespone.fromJson(json['productRespone']) : null;
    categoryGroupRespone = json['categoryGroupRespone'] != null ? new CategoryGroupRespone.fromJson(json['categoryGroupRespone']) : null;
    featuredRespone = json['featuredRespone'] != null ? new CategoryGroupRespone.fromJson(json['featuredRespone']) : null;
    trendingRespone = json['trendingRespone'] != null ? new ProductRespone.fromJson(json['trendingRespone']) : null;
    martket = json['martket'] != null ? new ProductRespone.fromJson(json['martket']) : null;
    flashsaleRespone = json['flashsaleRespone'] != null ? new FlashsaleRespone.fromJson(json['flashsaleRespone']) : null;
    product_foryou = json['product_foryou'] != null ? new ProductRespone.fromJson(json['product_foryou']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.sliderRespone != null) {
      data['sliderRespone'] = this.sliderRespone.toJson();
    }

    if (this.productRespone != null) {
      data['productRespone'] = this.productRespone.toJson();
    }

    if (this.categoryGroupRespone != null) {
      data['categoryGroupRespone'] = this.categoryGroupRespone.toJson();
    }

    if (this.featuredRespone != null) {
      data['featuredRespone'] = this.featuredRespone.toJson();
    }

    if (this.trendingRespone != null) {
      data['trendingRespone'] = this.trendingRespone.toJson();
    }

    if (this.martket != null) {
      data['martket'] = this.martket.toJson();
    }

    if (this.flashsaleRespone != null) {
      data['flashsaleRespone'] = this.flashsaleRespone.toJson();
    }

    if (this.product_foryou != null) {
      data['product_foryou'] = this.product_foryou.toJson();
    }

    return data;
  }
}