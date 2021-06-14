import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/request/AddressCreaterequest.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/StatesRespone.dart';
import 'package:naifarm/app/model/pojo/response/zipCodeRespone.dart';
import 'package:rxdart/rxdart.dart';

class AddressBloc {
  final AppNaiFarmApplication _application;

  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onSuccess = BehaviorSubject<Object>();

  final onLoad = BehaviorSubject<bool>();

  final onError = BehaviorSubject<String>();

  Stream<Object> get feedList => onSuccess.stream;

  final province = BehaviorSubject<StatesRespone>();
  final city = BehaviorSubject<StatesRespone>();
  final zipCcde = BehaviorSubject<ZipCodeRespone>();
  //Stream<Object> get feedList => onSuccess.stream;

  final deleteData = [];

  AddressBloc(this._application);

  void dispose() {
    _compositeSubscription.clear();
  }

  statesProvice(BuildContext context, {String countries}) async {
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .statesProvice(context, countries: countries))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        province.add((respone.respone as StatesRespone));
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  statesCity(BuildContext context,
      {String countriesid, String statesId}) async {
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .statesCity(context, countriesid: countriesid, statesId: statesId))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        city.add((respone.respone as StatesRespone));
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  statesZipCode(BuildContext context,
      {String countries, String statesId, String cityId}) async {
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.statesZipCode(context,
                statesId: statesId, countries: countries, cityId: cityId))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        zipCcde.add((respone.respone as ZipCodeRespone));
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  createAddress(BuildContext context,
      {AddressCreaterequest addressCreaterequest, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.createAddress(context,
                addressCreaterequest: addressCreaterequest, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add((respone.respone as AddressesData));
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  addressesList(BuildContext context, {String token}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .addressesList(context, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        final data = [];
        for (var i = 0;
            i < (respone.respone as AddressesListRespone).data.length;
            i++)
          if ((respone.respone as AddressesListRespone).data[i].addressType ==
              "Primary")
            data.add((respone.respone as AddressesListRespone).data[i]);

        for (var i = 0;
            i < (respone.respone as AddressesListRespone).data.length;
            i++)
          if ((respone.respone as AddressesListRespone).data[i].addressType !=
              "Primary")
            data.add((respone.respone as AddressesListRespone).data[i]);

        onSuccess.add(AddressesListRespone(
            data: data,
            total: (respone.respone as AddressesListRespone).total,
            httpCallBack:
                (respone.respone as AddressesListRespone).httpCallBack));
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  deleteAddress(BuildContext context, {String id, String token}) async {
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .deleteAddress(context, id: id, token: token))
        .listen((respone) {
      //
      // if(respone.httpCallBack.status==200){
      // }else{
      //   onError.add(respone.httpCallBack.message);
      // }
    });
    _compositeSubscription.add(subscription);
  }

  updateAddress(BuildContext context,
      {AddressCreaterequest data, String token}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .updateAddress(context, data: data, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }
}
