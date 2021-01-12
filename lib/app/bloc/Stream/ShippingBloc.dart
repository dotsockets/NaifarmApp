
import 'dart:async';

import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/PaymentObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ShppingMyShopRequest.dart';
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

  DELETEShoppingMyShop({int ratesId,String token}){
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.DELETEShoppingMyShop(ratesId: ratesId ,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        // ZipPaymentObject.add(event);
        onSuccess.add(true);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  AddShoppingMyShop({ShppingMyShopRequest shopRequest,String token}){
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.AddShoppingMyShop(shopRequest: shopRequest,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        // ZipPaymentObject.add(event);
        onSuccess.add(true);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  EditShoppingMyShop({ShppingMyShopRequest shopRequest,int rateID, String token}){
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.EditShoppingMyShop(rateID: rateID,shopRequest: shopRequest,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        // ZipPaymentObject.add(event);
        onSuccess.add(true);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

}