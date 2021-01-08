
import 'dart:async';

import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/PaymentObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ShppingOjectCombine.dart';
import 'package:rxdart/rxdart.dart';

class ShippingBloc{
  final AppNaiFarmApplication _application;

  CompositeSubscription _compositeSubscription = CompositeSubscription();

  ShippingBloc(this._application);

  final onSuccess = BehaviorSubject<Object>();

  final onLoad = BehaviorSubject<bool>();

  final onError = BehaviorSubject<String>();

  final ZipPaymentObject= BehaviorSubject<PaymentObjectCombine>();
  final ZipShppingOject= BehaviorSubject<ShppingOjectCombine>();



  void dispose() {
    _compositeSubscription.clear();
  }

  loadShppingPage({String token}){

    StreamSubscription subscription = Observable.combineLatest2(
        Observable.fromFuture(_application.appStoreAPIRepository.GetCarriersList()),
        Observable.fromFuture(_application.appStoreAPIRepository.GetShippingMyShop(token: token)),(a, b){
      final _shppinglist = (a as ApiResult).respone;
      final _shppingmyshop =(b as ApiResult).respone;
      return ShppingOjectCombine(carriersRespone: _shppinglist,shppingMyShopRespone: _shppingmyshop);

    }).listen((event) {
      for(var item in event.carriersRespone.data){
        for(var value in event.shppingMyShopRespone.data[0].rates){

          if(item.id == value.carrierId){
            item.active = true;
            break;
          }else{
            item.active = false;
          }
        }
      }
    //  print();
      ZipShppingOject.add(event);
    });
    _compositeSubscription.add(subscription);

  }

}