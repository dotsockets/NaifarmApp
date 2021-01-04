
import 'dart:async';

import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/request/AddressCreaterequest.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/StatesRespone.dart';
import 'package:naifarm/app/model/pojo/response/zipCodeRespone.dart';
import 'package:rxdart/rxdart.dart';

class AddressBloc{
  final AppNaiFarmApplication _application;

  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onSuccess = BehaviorSubject<Object>();

  final onLoad = BehaviorSubject<bool>();

  final onError = BehaviorSubject<String>();

  Stream<Object> get feedList => onSuccess.stream;



  final provice = BehaviorSubject<StatesRespone>();
  final city = BehaviorSubject<StatesRespone>();
  final zipCcde =  BehaviorSubject<zipCodeRespone>();
  //Stream<Object> get feedList => onSuccess.stream;

  final deleteData = List<AddressesData>();


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


  CreateAddress({AddressCreaterequest addressCreaterequest,String token}){
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.CreateAddress(addressCreaterequest: addressCreaterequest,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add((respone.respone as AddressesData));
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  AddressesList({String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.AddressesList(token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        final  data = List<AddressesData>();
        for(var i=0;i<(respone.respone as AddressesListRespone).data.length;i++)
          if((respone.respone as AddressesListRespone).data[i].addressType=="Primary")
            data.add((respone.respone as AddressesListRespone).data[i]);

        for(var i=0;i<(respone.respone as AddressesListRespone).data.length;i++)
          if((respone.respone as AddressesListRespone).data[i].addressType!="Primary")
            data.add((respone.respone as AddressesListRespone).data[i]);


        onSuccess.add(AddressesListRespone(data: data,total: (respone.respone as AddressesListRespone).total,http_call_back: (respone.respone as AddressesListRespone).http_call_back));
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  DeleteAddress({String id,String token}) async{
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.DeleteAddress(id: id,token: token)).listen((respone) {
      //
      // if(respone.http_call_back.status==200){
      // }else{
      //   onError.add(respone.http_call_back.result.error.message);
      // }

    });
    _compositeSubscription.add(subscription);
  }

  UpdateAddress({AddressCreaterequest data, String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.UpdateAddress(data: data,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);



  }


}