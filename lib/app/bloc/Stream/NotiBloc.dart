
import 'dart:async';

import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/response/NotiRespone.dart';
import 'package:rxdart/rxdart.dart';

class NotiBloc{
  final AppNaiFarmApplication _application;
  CompositeSubscription _compositeSubscription = CompositeSubscription();
  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<Object>();
  final onSuccess = BehaviorSubject<Object>();
  Stream<Object> get feedList => onSuccess.stream;

  NotiBloc(this._application);


  GetNotificationByGroup({String group, int page,String sort, int limit, String token}) async{
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.GetNotificationByGroup(group: group,limit: limit,page: page,sort: sort ,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
        onSuccess.add((respone.respone as NotiRespone));
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);

  }


}