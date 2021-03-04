
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:rxdart/rxdart.dart';

class HomeDataBloc extends Cubit<HomeDataState> {

  final AppNaiFarmApplication _application;
  HomeDataBloc(this._application) : super(HomeDataInitial());

  loadHomeData()async{

    NaiFarmLocalStorage.getHomeDataCache().then((value){
      emit(HomeDataLoaded(value));
    });

      Observable.combineLatest8(Observable.fromFuture(_application.appStoreAPIRepository.getSliderImage()) // สไลด์ภาพ
          , Observable.fromFuture(_application.appStoreAPIRepository.getProductPopular("1",10)), // สินค้าขายดี
          Observable.fromFuture(_application.appStoreAPIRepository.getCategoryGroup()), // หมวดหมู่ทั่วไป
          Observable.fromFuture(_application.appStoreAPIRepository.getCategoriesFeatured()), // หมวดหมู่แนะนำ
          Observable.fromFuture(_application.appStoreAPIRepository.getProductTrending("1",6)), // สินค้าแนะนำ
          Observable.fromFuture(_application.appStoreAPIRepository.getShopProduct(ShopId: 1,page: "1",limit: 10)), // สินค้าของ NaiFarm
          Observable.fromFuture(_application.appStoreAPIRepository.Flashsale(page: "1",limit: 5)), //  Flashsale
          Observable.fromFuture(_application.appStoreAPIRepository.MoreProduct(page: "1",limit: 10,link: "products/types/trending")), // สินค้าสำหรับคุน
              (a, b,c,d,e,f,g,h){
            final _slider = (a as ApiResult).respone;
            final _product  =(b as ApiResult).respone;
            final _category =(c as ApiResult).respone;
            final _featured =(d as ApiResult).respone;
            final _trending =(e as ApiResult).respone;
            final _martket =(f as ApiResult).respone;
            final _flashsale =(g as ApiResult).respone;
            final product_foryou =(h as ApiResult).respone;


            return ApiResult(respone: HomeObjectCombine(sliderRespone: _slider,
                productRespone: _product, categoryGroupRespone: _category,featuredRespone: _featured,
                trendingRespone: _trending,martket: _martket,flashsaleRespone: _flashsale,product_foryou: product_foryou),http_call_back:(b as ApiResult).http_call_back);

          }).listen((respone) {
        if(respone.http_call_back.status==200){
          NaiFarmLocalStorage.saveHomeData(respone.respone).then((value){
            emit(HomeDataLoaded(respone.respone));
          });
        }else{
          emit(HomeDataError(respone.http_call_back.result.error.message));
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
  final String message;
  const HomeDataError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is HomeDataError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

