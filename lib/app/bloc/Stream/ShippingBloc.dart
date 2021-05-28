import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/PaymentObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ShppingMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/response/ShppingOjectCombine.dart';
import 'package:rxdart/rxdart.dart';

class ShippingBloc {
  final AppNaiFarmApplication _application;

  CompositeSubscription _compositeSubscription = CompositeSubscription();

  ShippingBloc(this._application);

  final onSuccess = BehaviorSubject<Object>();

  final onLoad = BehaviorSubject<bool>();

  final onError = BehaviorSubject<String>();

  final zipPaymentObject = BehaviorSubject<PaymentObjectCombine>();
  final zipShppingOject = BehaviorSubject<ShppingOjectCombine>();

  void dispose() {
    _compositeSubscription.clear();
    zipPaymentObject.close();
    zipShppingOject.close();
  }

  loadShppingPage({BuildContext context, String token}) {
    StreamSubscription subscription = Observable.combineLatest2(
        Observable.fromFuture(
            _application.appStoreAPIRepository.getCarriersList(
          context,
        )),
        Observable.fromFuture(_application.appStoreAPIRepository
            .getShippingMyShop(context, token: token)), (a, b) {
      final _shppinglist = (a as ApiResult).respone;
      final _shppingmyshop = (b as ApiResult).respone;
      return ShppingOjectCombine(
          carriersRespone: _shppinglist, shppingMyShopRespone: _shppingmyshop);
    }).listen((event) {
      if (event.carriersRespone != null) {
        for (var item in event.carriersRespone.data) {
          for (var value in event.shppingMyShopRespone.data[0].rates) {
            if (item.id == value.carrierId) {
              item.active = true;
              break;
            } else {
              item.active = false;
            }
          }
        }
      }
      //  print();

      zipShppingOject.add(event);
    });
    _compositeSubscription.add(subscription);
  }

  deleteShoppingMyShop(BuildContext context, {int ratesId, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .deleteShoppingMyShop(context, ratesId: ratesId, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        // ZipPaymentObject.add(event);
        onSuccess.add(true);
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  addShoppingMyShop(BuildContext context,
      {ShppingMyShopRequest shopRequest, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .addShoppingMyShop(context, shopRequest: shopRequest, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        // ZipPaymentObject.add(event);
        onSuccess.add(true);
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  editShoppingMyShop(BuildContext context,
      {ShppingMyShopRequest shopRequest, int rateID, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.editShoppingMyShop(context,
                rateID: rateID, shopRequest: shopRequest, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        // ZipPaymentObject.add(event);
        onSuccess.add(true);
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }
}
