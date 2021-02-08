
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProfileObjectCombine.dart';
import 'package:rxdart/rxdart.dart';

class InfoCustomerBloc extends Cubit<InfoCustomerState> {

  final AppNaiFarmApplication _application;
  InfoCustomerBloc(this._application) : super(InfoCustomerInitial());


   loadCustomInfo({String token}) async{

     NaiFarmLocalStorage.getCustomer_Info().then((value){
       emit(InfoCustomerLoading(value));
     });

    Observable.combineLatest2(
        Observable.fromFuture(_application.appStoreAPIRepository.getCustomerInfo(token: token)),
        Observable.fromFuture(_application.appStoreAPIRepository.getMyShopInfo(access_token: token)),(a, b){
      final _customInfo = (a as ApiResult).respone;
      final _myshopInfo  =(b as ApiResult).respone;

      return ApiResult(respone: ProfileObjectCombine(customerInfoRespone: _customInfo,myShopRespone: _myshopInfo),http_call_back: (a as ApiResult).http_call_back);

    }).listen((respone) {
      if(respone.http_call_back.status==200){
        NaiFarmLocalStorage.saveCustomer_Info((respone.respone as ProfileObjectCombine)).then((value){
          emit(InfoCustomerLoaded((respone.respone as ProfileObjectCombine)));
        });
      }
    });
  }
}

@immutable
abstract class InfoCustomerState {
  const InfoCustomerState();
}

class InfoCustomerInitial extends InfoCustomerState {
  const InfoCustomerInitial();
}

class InfoCustomerLoading extends InfoCustomerState {
  final ProfileObjectCombine profileObjectCombine;
  const InfoCustomerLoading(this.profileObjectCombine);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is InfoCustomerLoading && o.profileObjectCombine == profileObjectCombine;
  }

  @override
  int get hashCode => profileObjectCombine.hashCode;
}

class InfoCustomerLoaded extends InfoCustomerState {
  final ProfileObjectCombine profileObjectCombine;
  const InfoCustomerLoaded(this.profileObjectCombine);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is InfoCustomerLoaded && o.profileObjectCombine == profileObjectCombine;
  }

  @override
  int get hashCode => profileObjectCombine.hashCode;
}

class OrdersError extends InfoCustomerState {
  final String message;
  const OrdersError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OrdersError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

