


import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:rxdart/rxdart.dart';




class CustomerCountBloc extends Cubit<CustomerCountState> {

  final AppNaiFarmApplication _application;
  CustomerCountBloc(this._application) : super(CustomerCountInitial());

  void loadCustomerCount({String token}){
    emit(CustomerCountLoading());
    Observable.fromFuture(_application.appStoreAPIRepository.GetCustomerCount(token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
        emit(CustomerCountLoaded((respone.respone as CustomerCountRespone)));
      }else{
        emit(CustomerCountError(respone.http_call_back.result.error.message));
      }
    });
  }
}


@immutable
abstract class CustomerCountState {
  const CustomerCountState();
}

class CustomerCountInitial extends CustomerCountState {
  const CustomerCountInitial();
}

class CustomerCountLoading extends CustomerCountState {
  const CustomerCountLoading();
}

class CustomerCountLoaded extends CustomerCountState {
  final CustomerCountRespone countLoaded;
  const CustomerCountLoaded(this.countLoaded);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is CustomerCountLoaded && o.countLoaded == countLoaded;
  }

  @override
  int get hashCode => countLoaded.hashCode;
}

class CustomerCountError extends CustomerCountState {
  final String message;
  const CustomerCountError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CustomerCountError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}




