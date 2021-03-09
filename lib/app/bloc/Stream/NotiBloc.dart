
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/NotiRespone.dart';
import 'package:naifarm/app/model/pojo/response/NotificationCombine.dart';
import 'package:rxdart/rxdart.dart';

class NotiBloc{
  final AppNaiFarmApplication _application;
  CompositeSubscription _compositeSubscription = CompositeSubscription();
  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<Object>();
  final onSuccess = BehaviorSubject<Object>();
  Stream<Object> get feedList => onSuccess.stream;
  List<NotiData> product_more = List<NotiData>();

  NotiBloc(this._application);

//NotificationCombine
  GetNotification({BuildContext context,String group, int page,String sort, int limit, String token}) async{
    if(page==1){
      product_more.clear();
    }


    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.GetNotificationByGroup(context,group: group,limit: limit,page: page,sort: sort ,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
       // onSuccess.add((respone.respone as NotiRespone));
        var item = (respone.respone as NotiRespone);
        if(item.data!=null){
          product_more.addAll(item.data);
          onSuccess.add(NotiRespone(data: product_more,limit: item.limit,page: item.page,total: item.total));
        }

      }else{
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);

  }

  GetNotificationByGroup({BuildContext context,String group, int page,String sort, int limit, String token}) async{


    StreamSubscription subscription = Observable.combineLatest2(
        Observable.fromFuture(_application.appStoreAPIRepository.GetNotificationByGroup(context,group: "customer",limit: limit,page: page,sort: sort ,token: token))
        ,Observable.fromFuture(_application.appStoreAPIRepository.GetNotificationByGroup(context,group: "shop",limit: limit,page: page,sort: sort ,token: token)),
            (a,b){
          final _cusNoti = (a as ApiResult).respone;
          final _shopNoti  =(b as ApiResult).respone;


          return NotificationCombine(CusNotiRespone: _cusNoti,ShopNotiRespone: _shopNoti);

        }).listen((event) {
      MarkAsReadNotifications(context,token: token);
      onSuccess.add(event);

    });
    _compositeSubscription.add(subscription);


  }


  MarkAsReadNotifications(BuildContext context,{String token}) async{
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.MarkAsReadNotifications(context,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
       onSuccess.add(respone.respone);

      }else{
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);

  }

  refreshProducts(BuildContext context,{int page,int limit ,String group}){

    Usermanager().getUser().then((value) {
      if (value.token != null) {
        NaiFarmLocalStorage.getNowPage().then((data){
          if(data==2){
            GetNotification(context: context,group: group,page: page,limit: limit,sort: "notification.createdAt:desc",token: value.token);
          }

        });

      }
    });
  }





}