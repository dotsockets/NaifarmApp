import 'dart:async';

import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/request/CartRequest.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:rxdart/rxdart.dart';

class CartBloc {

  final AppNaiFarmApplication _application;
  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<String>();
  final onSuccess = BehaviorSubject<Object>();
  final CartList = BehaviorSubject<CartResponse>();
  CartBloc(this._application);

  final deleteData = List<CartData>();

  void dispose() {
    _compositeSubscription.clear();
  }

  GetCartlists({String token}){
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.GetCartlists(token: token)).listen((respone) {

      if(respone.http_call_back.status==200){
        onLoad.add(false);
        CartList.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  DeleteCart({int cartid,int inventoryId,String token}) async{
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.DeleteCart(inventoryid: inventoryId,cartid: cartid,token: token)).listen((respone) {

       if(respone.http_call_back.status==200){
        // CartList.add(CartList.value);
      }else{

         onError.add(respone.http_call_back.result.error.message);
       }

    });
    _compositeSubscription.add(subscription);
  }


}