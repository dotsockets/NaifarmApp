
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
  Stream<Object> get feedList => onSuccess.stream;

  OrdersBloc(this._application);


  loadOrder({String orderType,int page=1,int limit=20,String statusId,String token}) async{
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.GetOrder(orderType: orderType,page: page,limit: limit,statusId: statusId,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
        onSuccess.add((respone.respone as OrderRespone));
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);

  }


  GetOrderById({int id,String orderType, String token}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.GetOrderById(id: id,orderType:orderType ,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
        onSuccess.add((respone.respone as OrderData));
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  MarkPaid({int OrderId, String token}){
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.MarkPaid(OrderId: OrderId,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add((respone.respone as OrderRespone));
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  UploadImage({BuildContext context,File imageFile,String imageableType, int imageableId, String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.UploadImage(imageFile: imageFile,imageableType: imageableType,imageableId: imageableId,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200 || respone.http_call_back.status==201){
        //context.read<InfoCustomerBloc>().loadCustomInfo(token:token);
        onSuccess.add(true);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

}