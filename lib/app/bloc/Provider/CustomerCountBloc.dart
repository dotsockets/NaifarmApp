


import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:rxdart/rxdart.dart';




class CustomerCountBloc extends Cubit<CustomerCountRespone> {

  final AppNaiFarmApplication _application;
  CustomerCountBloc(this._application) : super(CustomerCountRespone());

  void loadCustomerCount({String token}){
    Observable.fromFuture(_application.appStoreAPIRepository.GetCustomerCount(token: token)).listen((respone) {
      emit((respone as ApiResult).respone);
    });
  }
}


