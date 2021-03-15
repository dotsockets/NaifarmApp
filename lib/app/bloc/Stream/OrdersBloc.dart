import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductHistoryCache.dart';
import 'package:naifarm/app/model/pojo/response/ProductOrderCache.dart';
import 'package:rxdart/rxdart.dart';

class OrdersBloc {
  final AppNaiFarmApplication _application;
  CompositeSubscription _compositeSubscription = CompositeSubscription();
  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<Object>();
  final onSuccess = BehaviorSubject<Object>();
  final orderList = BehaviorSubject<OrderData>();
  Stream<Object> get feedList => onSuccess.stream;
  List<OrderData> orderDataList = [];

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
        if(page==1){
          NaiFarmLocalStorage.getHistoryCache().then((value){
            if(value!=null ){

              for(var data in value.historyCache){
                if(data.orderViewType==orderType && data.TypeView==statusId){
                  value.historyCache.remove(data);
                  orderList.clear();
                  break;
                }
              }
              value.historyCache.add(HistoryCache(orderViewType: orderType,orderRespone: item,TypeView: statusId));
              NaiFarmLocalStorage.saveHistoryCache(value).then((value){
                orderList.addAll(item.data);
                onSuccess.add(OrderRespone(data: orderList,total: item.total,limit: item.limit,page: item.limit));
              });

            }else{

              List<HistoryCache> data = List<HistoryCache>();
              data.add(HistoryCache(TypeView: statusId,orderViewType: orderType,orderRespone: item));
              NaiFarmLocalStorage.saveHistoryCache(ProductHistoryCache(historyCache: data)).then((value){
                orderList.addAll(item.data);
                onSuccess.add(OrderRespone(data: orderList,total: item.total,limit: item.limit,page: item.page,));
              });

            }
          });
        }else{
          orderList.addAll(item.data);
          onSuccess.add(OrderRespone(data: orderList,total: item.total,limit: item.limit,page: item.page,));
        }
      }else{
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }


  GetOrderById(BuildContext context,{int id,String orderType, String token}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.GetOrderById(context,id: id,orderType:orderType ,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){

        NaiFarmLocalStorage.getOrderCache().then((value){
           if(value!=null){
             for(var data in value.orderCahe){
               if(data.TypeView==id.toString() && data.orderViewType==orderType){
                 value.orderCahe.remove(data);
                 break;
               }
             }
             value.orderCahe.add(OrderCache(orderData: respone.respone,orderViewType: orderType,TypeView: id.toString()));
             NaiFarmLocalStorage.saveOrderCache(value).then((value) {
               OrderList.add((respone.respone as OrderData));
             });
           }else{
             List<OrderCache> data = List<OrderCache>();
             data.add(OrderCache(TypeView: id.toString(),orderViewType: orderType,orderData: respone.respone));
             NaiFarmLocalStorage.saveOrderCache(ProductOrderCache(orderCahe: data)).then((value){
             //  orderList.addAll(respone.respone);
               OrderList.add(respone.respone);
             });
           }
        });


      }else{
        onError.add(respone.http_call_back.message);
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
      onLoad.add(false);
      if (respone.httpCallBack.status == 200 ||
          respone.httpCallBack.status == 201) {
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
      sum += item.inventory != null
          ? (item.inventory.offerPrice != null
                  ? item.inventory.offerPrice
                  : item.inventory.salePrice) *
              item.quantity
          : double.parse(item.unitPrice.toString()).toInt() * item.quantity;
    }
    return sum + rate;
  }
}

enum OrderViewType { Shop, Purchase }
