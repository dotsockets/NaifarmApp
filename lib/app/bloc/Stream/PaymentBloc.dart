
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/PaymentObjectCombine.dart';
import 'package:rxdart/rxdart.dart';

class PaymentBloc{
  final AppNaiFarmApplication _application;

  CompositeSubscription _compositeSubscription = CompositeSubscription();

  PaymentBloc(this._application);

  final onSuccess = BehaviorSubject<Object>();

  final onLoad = BehaviorSubject<bool>();

  final onError = BehaviorSubject<String>();

  final ZipPaymentObject= BehaviorSubject<PaymentObjectCombine>();

  void dispose() {
    _compositeSubscription.clear();
  }


  loadPaymentPage(BuildContext context,{String token}){

    StreamSubscription subscription = Observable.combineLatest2(
        Observable.fromFuture(_application.appStoreAPIRepository.GetPaymentList(context,)),
        Observable.fromFuture(_application.appStoreAPIRepository.GetPaymentMyShop(context,token: token)),(a, b){
      final _paymentlist = (a as ApiResult).respone;
      final _paymentmyshop =(b as ApiResult).respone;
      return PaymentObjectCombine(paymentRespone: _paymentlist,paymenMyshopRespone: _paymentmyshop);

    }).listen((event) {
      for(var item in event.paymentRespone.data){
         for(var value in event.paymenMyshopRespone.data){
            if(item.id == value.paymentMethodId){
              item.active = true;
              break;
            }else{
              item.active = false;
            }
         }
      }
      ZipPaymentObject.add(event);
    });
    _compositeSubscription.add(subscription);

  }

  DeletePayment(BuildContext context,{int paymentMethodId,String token}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.DELETEPaymentMyShop(context,paymentMethodId: paymentMethodId,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
       // ZipPaymentObject.add(event);
      }else{
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  AddPayment(BuildContext context,{int paymentMethodId,String token}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.AddPaymentMyShop(context,paymentMethodId: paymentMethodId,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
        // ZipPaymentObject.add(event);
      }else{
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

}