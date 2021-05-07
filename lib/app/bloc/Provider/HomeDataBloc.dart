import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:rxdart/rxdart.dart';

class HomeDataBloc extends Cubit<HomeDataState> {
  final AppNaiFarmApplication _application;
  HomeDataBloc(this._application) : super(HomeDataInitial());

  loadHomeData(
    BuildContext context,
  ) async {
    NaiFarmLocalStorage.getHomeDataCache().then((value) {
      emit(HomeDataLoaded(value));
    });

    Observable.combineLatest8(
        Observable.fromFuture(_application.appStoreAPIRepository
            .getBanners(context,group: "home_top")) // สไลด์ภาพ
        ,
        Observable.fromFuture(_application.appStoreAPIRepository
            .getProductPopular(context, "1", 10)), // สินค้าขายดี
        Observable.fromFuture(_application.appStoreAPIRepository
            .getCategoryGroup(context)), // หมวดหมู่ทั่วไป
        Observable.fromFuture(_application.appStoreAPIRepository
            .getCategoriesFeatured(context)), // หมวดหมู่แนะนำ
        Observable.fromFuture(_application.appStoreAPIRepository
            .getProductTrending(context, "1", 6)), // สินค้าแนะนำ
        Observable.fromFuture(_application.appStoreAPIRepository.getShopProduct(
            context,
            shopId: 1,
            page: "1",
            limit: 10)), // สินค้าของ NaiFarm
        Observable.fromFuture(_application.appStoreAPIRepository
            .flashsale(context, page: "1", limit: 5)), //  Flashsale
        Observable.fromFuture(_application.appStoreAPIRepository.moreProduct(context, page: "1", limit: 10, link: "products/types/trending")), // สินค้าสำหรับคุน
        (a, b, c, d, e, f, g, h) {
      final _slider = (a as ApiResult).respone;
      final _product = (b as ApiResult).respone;
      final _category = (c as ApiResult).respone;
      final _featured = (d as ApiResult).respone;
      final _trending = (e as ApiResult).respone;
      final _martket = (f as ApiResult).respone;
      final _flashsale = (g as ApiResult).respone;
      final productForyou = (h as ApiResult).respone;

      return ApiResult(
          respone: HomeObjectCombine(
              sliderRespone: _slider,
              productRespone: _product,
              categoryGroupRespone: _category,
              featuredRespone: _featured,
              trendingRespone: _trending,
              martket: _martket,
              flashsaleRespone: _flashsale,
              productForyou: productForyou),
          httpCallBack: (b as ApiResult).httpCallBack);
    }).listen((respone) {
      if (respone.httpCallBack.status == 200) {
        NaiFarmLocalStorage.saveHomeData(respone.respone).then((value) {
          emit(HomeDataLoaded(respone.respone));
        });
      } else {
        NaiFarmLocalStorage.getHomeDataCache().then((value) {
          emit(HomeDataError(HomeObjectCombine(
              categoryGroupRespone: value.categoryGroupRespone,
              featuredRespone: value.featuredRespone,
              flashsaleRespone: value.flashsaleRespone,
              martket: value.martket,
              productForyou: value.productForyou,
              productRespone: value.productRespone,
              sliderRespone: value.sliderRespone,
              trendingRespone: value.trendingRespone,
              httpCallBack: respone.httpCallBack)));
        });
      }
    });
  }
}

@immutable
abstract class HomeDataState {
  const HomeDataState();
}

class HomeDataInitial extends HomeDataState {
  const HomeDataInitial();
}

class HomeDataLoading extends HomeDataState {
  final HomeObjectCombine homeObjectCombine;
  const HomeDataLoading(this.homeObjectCombine);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is HomeDataLoading && o.homeObjectCombine == homeObjectCombine;
  }

  @override
  int get hashCode => homeObjectCombine.hashCode;
}

class HomeDataLoaded extends HomeDataState {
  final HomeObjectCombine homeObjectCombine;
  const HomeDataLoaded(this.homeObjectCombine);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is HomeDataLoading && o.homeObjectCombine == homeObjectCombine;
  }

  @override
  int get hashCode => homeObjectCombine.hashCode;
}

class HomeDataError extends HomeDataState {
  final HomeObjectCombine homeObjectCombine;
  const HomeDataError(this.homeObjectCombine);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HomeDataError && o.homeObjectCombine == homeObjectCombine;
  }

  @override
  int get hashCode => homeObjectCombine.hashCode;
}
