


import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:rxdart/rxdart.dart';




class CustomerCountBloc extends Cubit<CustomerCountState> {

  final AppNaiFarmApplication _application;
  CustomerCountBloc(this._application) : super(CustomerCountInitial());

  void loadCustomerCount({String token}){
    NaiFarmLocalStorage.getCustomer_cuse().then((value){
      emit(CustomerCountLoading(value));
    });

    Observable.fromFuture(_application.appStoreAPIRepository.GetCustomerCount(token: token)).listen((respone) {
      if(respone.http_call_back.status==200){
        var item =(respone.respone as CustomerCountRespone);
        if(item.notification.unreadCustomer+item.notification.unreadShop>0 || item.buyOrder.cancel>0 || item.buyOrder.confirm>0 || item.buyOrder.delivered>0
        || item.buyOrder.failed>0 || item.buyOrder.refund>0 || item.buyOrder.toBeRecieve>0 || item.buyOrder.unpaid>0 || item.buyOrder.fulfill>0
        || item.sellOrder.unpaid>0 || item.sellOrder.refund>0 || item.sellOrder.failed>0 || item.sellOrder.delivered >0 || item.sellOrder.confirm>0
            || item.sellOrder.shipping>0 || item.sellOrder.cancel>0 || item.like>0 || item.watingReview> 0 ){
          NaiFarmLocalStorage.saveCustomer_cuse(item);
      }else{
          NaiFarmLocalStorage.saveCustomer_cuse(null);
        }

        emit(CustomerCountLoaded((respone.respone as CustomerCountRespone)));
      }else{
        NaiFarmLocalStorage.saveCustomer_cuse(null);
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
  final CustomerCountRespone countLoaded;
  const CustomerCountLoading(this.countLoaded);
  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is CustomerCountLoading && o.countLoaded == countLoaded;
  }

  @override
  int get hashCode => countLoaded.hashCode;
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




