
import 'dart:async';

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


  loadOrder({String orderType,int page=1,int limit=20,int statusId,String token}) async{
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


  GetOrderById({int id, String token}){
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.GetOrderById(id: id,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
        onSuccess.add((respone.respone as OrderData));
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

}