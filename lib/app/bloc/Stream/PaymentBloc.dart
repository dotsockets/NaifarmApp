import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/PaymentObjectCombine.dart';
import 'package:rxdart/rxdart.dart';

class PaymentBloc {
  final AppNaiFarmApplication _application;

  CompositeSubscription _compositeSubscription = CompositeSubscription();

  PaymentBloc(this._application);

  final onSuccess = BehaviorSubject<Object>();

  final onLoad = BehaviorSubject<bool>();

  final onError = BehaviorSubject<String>();

  final zipPaymentObject = BehaviorSubject<PaymentObjectCombine>();

  void dispose() {
    _compositeSubscription.clear();
    onSuccess.close();
    onLoad.close();
    zipPaymentObject.close();
  }

  loadPaymentPage(BuildContext context, {String token}) {
    StreamSubscription subscription = Observable.combineLatest2(
        Observable.fromFuture(_application.appStoreAPIRepository.getPaymentList(
          context,shopIds: ""
        )),
        Observable.fromFuture(_application.appStoreAPIRepository
            .getPaymentMyShop(context, token: token)), (a, b) {
      final _paymentlist = (a as ApiResult).respone;
      final _paymentmyshop = (b as ApiResult).respone;
      return PaymentObjectCombine(
          paymentRespone: _paymentlist, paymenMyshopRespone: _paymentmyshop);
    }).listen((event) {
      for (var item in event.paymentRespone.data) {
        for (var value in event.paymenMyshopRespone.data) {
          if (item.id == value.paymentMethodId) {
            item.active = true;
            break;
          } else {
            item.active = false;
          }
        }
      }
      zipPaymentObject.add(event);
    });
    _compositeSubscription.add(subscription);
  }

  deletePayment(BuildContext context, {int paymentMethodId, String token}) {
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.deletePaymentMyShop(context,
                paymentMethodId: paymentMethodId, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        // ZipPaymentObject.add(event);
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  addPayment(BuildContext context, {int paymentMethodId, String token}) {
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.addPaymentMyShop(context,
                paymentMethodId: paymentMethodId, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        // ZipPaymentObject.add(event);
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }
}
