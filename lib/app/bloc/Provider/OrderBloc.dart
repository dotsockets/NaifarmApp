
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:rxdart/rxdart.dart';

class OrderBloc extends Cubit<OrdersState> {

  final AppNaiFarmApplication _application;
  OrderBloc(this._application) : super(OrdersInitial());


   loadOrder({int page=1,int limit=20,int statusId,String token}) async{
    emit(OrdersLoading());
    Observable.fromFuture(_application.appStoreAPIRepository.GetOrder(page: page,limit: limit,statusId: statusId,token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
        emit(OrdersLoaded((respone.respone as OrderRespone)));
      }else{

        emit(OrdersError(respone.http_call_back.result.error.message));
      }
    });

  }

}

@immutable
abstract class OrdersState {
  const OrdersState();
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersLoaded extends OrdersState {
  final OrderRespone orderRespone;
  const OrdersLoaded(this.orderRespone);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is OrdersLoaded && o.orderRespone == orderRespone;
  }

  @override
  int get hashCode => orderRespone.hashCode;
}

class OrdersError extends OrdersState {
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

