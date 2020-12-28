
import 'dart:async';

import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/StatesRespone.dart';
import 'package:naifarm/app/model/pojo/response/zipCodeRespone.dart';
import 'package:rxdart/rxdart.dart';

class AddressBloc{
  final AppNaiFarmApplication _application;

  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onSuccess = BehaviorSubject<Object>();

  final onLoad = BehaviorSubject<bool>();

  final onError = BehaviorSubject<String>();

  StreamController<StatesRespone> provice = new StreamController<StatesRespone>();
  StreamController<StatesRespone> city = new StreamController<StatesRespone>();
  StreamController<zipCodeRespone> zipCcde = new StreamController<zipCodeRespone>();
  //Stream<Object> get feedList => onSuccess.stream;

  AddressBloc(this._application);

  void dispose() {
    _compositeSubscription.clear();
  }

  StatesProvice({String countries}) async{

    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.StatesProvice(countries: countries)).listen((respone) {

      if(respone.http_call_back.status==200){
        provice.add((respone.respone as StatesRespone));
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  StatesCity({String countriesid, String statesId}) async{

    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.StatesCity(countriesid: countriesid,statesId: statesId)).listen((respone) {

      if(respone.http_call_back.status==200){
        city.add((respone.respone as StatesRespone));
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  StatesZipCode({String countries,String statesId,String cityId}) async{

    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.StatesZipCode(statesId: statesId,countries: countries,cityId: cityId)).listen((respone) {

      if(respone.http_call_back.status==200){
        zipCcde.add((respone.respone as zipCodeRespone));
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }
}