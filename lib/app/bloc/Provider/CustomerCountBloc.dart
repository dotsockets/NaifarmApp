


import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rxdart/rxdart.dart';




class CustomerCountBloc extends Cubit<CustomerCountState> {

  final AppNaiFarmApplication _application;
  CustomerCountBloc(this._application) : super(CustomerCountInitial());

  void loadCustomerCount(BuildContext context,{String token}){
    NaiFarmLocalStorage.getCustomer_cuse().then((value){

      emit(CustomerCountLoading(value));
    });

    Observable.combineLatest2(
        Observable.fromFuture(_application.appStoreAPIRepository.GetCustomerCount(context,token: token)),
        Observable.fromFuture(_application.appStoreAPIRepository.GetCartlists(context,token: token)),(a, b){
      final CustomerCount= (a as ApiResult).respone;
      final CartCout  =(b as ApiResult).respone;
      var item = (CustomerCount as CustomerCountRespone);
      var cart_item = (CartCout as CartResponse);
      if((a as ApiResult).http_call_back.status==200){

        return ApiResult(respone: CustomerCountRespone(CartCount: CountCartItem(item: cart_item),buyOrder: item.buyOrder,like: item.like,notification: item.notification,sellOrder: item.sellOrder,watingReview: item.watingReview,
        ),http_call_back: (a as ApiResult).http_call_back);
      }else{
        return ApiResult(respone: item,http_call_back: (a as ApiResult).http_call_back);
      }


    }).listen((event) {
      if(event.http_call_back.status==200){
        var item =(event.respone as CustomerCountRespone);


        if(item.notification.unreadCustomer+item.notification.unreadShop>0 || item.buyOrder.cancel>0 || item.buyOrder.confirm>0 || item.buyOrder.delivered>0
            || item.buyOrder.failed>0 || item.buyOrder.refund>0 || item.buyOrder.toBeRecieve>0 || item.buyOrder.unpaid>0
            || item.sellOrder.unpaid>0 || item.sellOrder.refund>0 || item.sellOrder.failed>0 || item.sellOrder.delivered >0 || item.sellOrder.confirm>0
            || item.sellOrder.shipping>0 || item.sellOrder.cancel>0 || item.like>0 || item.watingReview> 0 || item.CartCount>0){
          NaiFarmLocalStorage.saveCustomer_cuse(item);

        }else{
          NaiFarmLocalStorage.saveCustomer_cuse(null);
        }

        emit(CustomerCountLoaded((event.respone as CustomerCountRespone)));
      }else{
        NaiFarmLocalStorage.saveCustomer_cuse(null);
        emit(CustomerCountError(event.http_call_back.result.error));
      }
    });


  }

  int CountCartItem({CartResponse item}){
    int count = 0;
    NaiFarmLocalStorage.saveCartCache(item);
    for(var value in item.data){
      count+=value.items.length;
    }
    return count;
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




