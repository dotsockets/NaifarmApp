import 'BannersRespone.dart';
import 'CategoryGroupRespone.dart';
import 'FlashsaleRespone.dart';
import 'ProductRespone.dart';
import 'ThrowIfNoSuccess.dart';

class HomeObjectCombine {
  BannersRespone sliderRespone;
  ProductRespone productRespone;
  CategoryGroupRespone categoryGroupRespone;
  CategoryGroupRespone featuredRespone;
  ProductRespone trendingRespone;
  ProductRespone martket;
  FlashsaleRespone flashsaleRespone;
  ProductRespone productForyou;
  ThrowIfNoSuccess httpCallBack;

  HomeObjectCombine(
      {this.sliderRespone,
      this.productRespone,
      this.categoryGroupRespone,
      this.featuredRespone,
      this.trendingRespone,
      this.martket,
      this.flashsaleRespone,
      this.productForyou,
      this.httpCallBack});

  HomeObjectCombine.fromJson(Map<String, dynamic> json) {
    sliderRespone = json['sliderRespone'] != null
        ? new BannersRespone.fromJson(json['sliderRespone'])
        : null;
    productRespone = json['productRespone'] != null
        ? new ProductRespone.fromJson(json['productRespone'])
        : null;
    categoryGroupRespone = json['categoryGroupRespone'] != null
        ? new CategoryGroupRespone.fromJson(json['categoryGroupRespone'])
        : null;
    featuredRespone = json['featuredRespone'] != null
        ? new CategoryGroupRespone.fromJson(json['featuredRespone'])
        : null;
    trendingRespone = json['trendingRespone'] != null
        ? new ProductRespone.fromJson(json['trendingRespone'])
        : null;
    martket = json['martket'] != null
        ? new ProductRespone.fromJson(json['martket'])
        : null;
    flashsaleRespone = json['flashsaleRespone'] != null
        ? new FlashsaleRespone.fromJson(json['flashsaleRespone'])
        : null;
    productForyou = json['product_foryou'] != null
        ? new ProductRespone.fromJson(json['product_foryou'])
        : null;
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

    if (this.productForyou != null) {
      data['product_foryou'] = this.productForyou.toJson();
    }

    return data;
  }
}
