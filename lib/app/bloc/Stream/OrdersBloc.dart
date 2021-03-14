
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:rxdart/rxdart.dart';

class OrdersBloc{
  final AppNaiFarmApplication _application;
  CompositeSubscription _compositeSubscription = CompositeSubscription();
  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<Object>();
  final onSuccess = BehaviorSubject<Object>();
  final OrderList = BehaviorSubject<OrderData>();
  Stream<Object> get feedList => onSuccess.stream;
  List<OrderData> orderList = List<OrderData>();

  OrdersBloc(this._application);


  loadOrder(BuildContext context,{String orderType,int page=1,int limit=20,String statusId,String sort,String token,bool load=false}) async{
    load?onLoad.add(true):null;
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.GetOrder(context,orderType: orderType,page: page,limit: limit,statusId: statusId,token: token,sort: sort)).listen((respone) {
      load?onLoad.add(false):null;
      if(respone.http_call_back.status==200){
        var item = (respone.respone as OrderRespone);
        orderList.addAll(item.data);
        onSuccess.add(OrderRespone(data: orderList,total: item.total,limit: item.limit,page: item.page,));
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

        OrderList.add((respone.respone as OrderData));
      }else{
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  MarkPaid(BuildContext context,{int OrderId, String token}){
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.MarkPaid(context,OrderId: OrderId,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(true);
      }else{
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  UploadImage(BuildContext context,{File imageFile,String imageableType, int imageableId, String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.UploadImage(context,imageFile: imageFile,imageableType: imageableType,imageableId: imageableId,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200 || respone.http_call_back.status==201){
        //context.read<InfoCustomerBloc>().loadCustomInfo(token:token);
        onSuccess.add(true);
      }else{
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  AddTracking(BuildContext context,{String trackingId, String token,int OrderId}){
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.AddTracking(context,trackingId: trackingId,token: token,OrderId: OrderId)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(true);
      }else{
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  GoodsReceived(BuildContext context,{ String token,int OrderId}){
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.GoodsReceived(context,token: token,OrderId: OrderId)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(true);
        OrderList.add((respone.respone as OrderData));
      }else{
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  OrderCancel(BuildContext context,{ String token,int OrderId}){
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.OrderCancel(context,token: token,OrderId: OrderId)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(true);
        OrderList.add((respone.respone as OrderData));
      }else{
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  int SumTotal(List<OrderItems> items,int rate) {
    var sum = 0;
    for (var item in items) {
      sum += item.inventory!=null?(item.inventory.offerPrice!=null?item.inventory.offerPrice:item.inventory.salePrice)*item.quantity:double.parse(item.unitPrice.toString()).toInt()*item.quantity;
    }
    return sum+rate;
  }
}



enum OrderViewType { Shop,Purchase}
