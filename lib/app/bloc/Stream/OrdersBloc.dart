import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductHistoryCache.dart';
import 'package:naifarm/app/model/pojo/response/ProductOrderCache.dart';
import 'package:naifarm/app/model/pojo/response/SystemRespone.dart';
import 'package:rxdart/rxdart.dart';

class OrdersBloc {
  final AppNaiFarmApplication _application;
  CompositeSubscription _compositeSubscription = CompositeSubscription();
  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<Object>();
  final onSuccess = BehaviorSubject<Object>();
  final orderList = BehaviorSubject<OrderData>();
  final systemRespone = BehaviorSubject<SystemRespone>();
  Stream<Object> get feedList => onSuccess.stream;
  List<OrderData> orderDataList = <OrderData>[];

  OrdersBloc(this._application);

  loadOrder(BuildContext context,
      {String orderType,
      int page = 1,
      int limit = 20,
      String statusId,
      String sort,
      String token,
      bool load = false}) async {
    if (load) {
      onLoad.add(true);
    }
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.getOrder(context,
                orderType: orderType,
                page: page,
                limit: limit,
                statusId: statusId,
                token: token,
                sort: sort))
        .listen((respone) {
      if (load) {
        onLoad.add(false);
      }
      if (respone.httpCallBack.status == 200) {
        var item = (respone.respone as OrderRespone);

        if (page == 1) {
          NaiFarmLocalStorage.getHistoryCache().then((value) {
            if (value != null) {
              for (var data in value.historyCache) {
                if (data.orderViewType == orderType &&
                    data.typeView == statusId) {
                  value.historyCache.remove(data);
                  orderDataList.clear();
                  break;
                }
              }
              value.historyCache.add(HistoryCache(
                  orderViewType: orderType,
                  orderRespone: item,
                  typeView: statusId));
              NaiFarmLocalStorage.saveHistoryCache(value).then((value) {
                orderDataList.addAll(item.data);
                onSuccess.add(OrderRespone(
                    data: orderDataList,
                    total: item.total,
                    limit: item.limit,
                    page: item.limit));
              });
            } else {
              List<HistoryCache> data = <HistoryCache>[];
              data.add(HistoryCache(
                  typeView: statusId,
                  orderViewType: orderType,
                  orderRespone: item));
              NaiFarmLocalStorage.saveHistoryCache(
                      ProductHistoryCache(historyCache: data))
                  .then((value) {
                orderDataList.addAll(item.data);
                onSuccess.add(OrderRespone(
                  data: orderDataList,
                  total: item.total,
                  limit: item.limit,
                  page: item.page,
                ));
              });
            }
          });
        } else {
          orderDataList.addAll(item.data);
          onSuccess.add(OrderRespone(
            data: orderDataList,
            total: item.total,
            limit: item.limit,
            page: item.page,
          ));
        }
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  Future<OrderData> getOrderByIdFuture(BuildContext context, {int id, String orderType,String token}) async {

    final respons = await _application.appStoreAPIRepository.getOrderById(context, id: id, orderType: orderType, token: token);
    if (respons.httpCallBack.status == 200) {
      return (respons.respone as OrderData);
    } else {

      return  OrderData();
    }

  }

  getOrderById(BuildContext context, {int id, String orderType, String token}) {
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .getOrderById(context, id: id, orderType: orderType, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        NaiFarmLocalStorage.getOrderCache().then((value) {
          if (value != null) {
            for (var data in value.orderCahe) {
              if (data.typeView == id.toString() &&
                  data.orderViewType == orderType) {
                value.orderCahe.remove(data);
                break;
              }
            }
            value.orderCahe.add(OrderCache(
                orderData: respone.respone,
                orderViewType: orderType,
                typeView: id.toString()));
            NaiFarmLocalStorage.saveOrderCache(value).then((value) {
              orderList.add((respone.respone as OrderData));
            });
          } else {
            List<OrderCache> data = <OrderCache>[];
            data.add(OrderCache(
                typeView: id.toString(),
                orderViewType: orderType,
                orderData: respone.respone));
            NaiFarmLocalStorage.saveOrderCache(
                    ProductOrderCache(orderCahe: data))
                .then((value) {
              //  orderList.addAll(respone.respone);
              orderList.add(respone.respone);
            });
          }
        });
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  markPaid(BuildContext context, {int orderId, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .markPaid(context, orderId: orderId, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(true);
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  uploadImage(BuildContext context,
      {File imageFile,
      String imageableType,
      int imageableId,
      String token}) async {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.uploadImage(context,
                imageFile: imageFile,
                imageableType: imageableType,
                imageableId: imageableId,
                token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200 ||
          respone.httpCallBack.status == 201) {
        //context.read<InfoCustomerBloc>().loadCustomInfo(token:token);
        requestPayment(context, orderId: imageableId, token: token);
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  requestPayment(BuildContext context, {int orderId, String token}) async {
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .requestPayment(context, orderId: orderId, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        //context.read<InfoCustomerBloc>().loadCustomInfo(token:token);
        onSuccess.add(true);
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  addTracking(BuildContext context,
      {String trackingId, String token, int orderId}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.addTracking(context,
                trackingId: trackingId, token: token, orderId: orderId))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(true);
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  goodsReceived(BuildContext context, {String token, int orderId}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .goodsReceived(context, token: token, orderId: orderId))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(true);
        orderList.add((respone.respone as OrderData));
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  orderCancel(BuildContext context, {String token, int orderId}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .orderCancel(context, token: token, orderId: orderId))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(true);
        orderList.add((respone.respone as OrderData));
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  int sumTotal(List<OrderItems> items, int rate) {
    var sum = 0;
    for (var item in items) {
      sum += ((item.offerPrice != null &&
                  double.parse(item.offerPrice.toString()) > 0
              ? double.parse(item.offerPrice.toString()).toInt()
              : double.parse(item.unitPrice.toString()).toInt()) *
          item.quantity);
    }
    return sum + rate;
  }

  getSystem(BuildContext context) async {
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.getSystem(context))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        NaiFarmLocalStorage.getSystemCache().then((value) {
          NaiFarmLocalStorage.saveSystemCache(respone.respone as SystemRespone)
              .then((value) {
            systemRespone.add(respone.respone as SystemRespone);
          });
        });
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }
}

enum OrderViewType { Shop, Purchase }
