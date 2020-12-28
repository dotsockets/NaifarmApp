

import 'package:dio/dio.dart';
import 'package:naifarm/app/model/api/APIProvider.dart';
import 'package:naifarm/app/model/db/DBNaiFarmRepository.dart';
import 'package:naifarm/app/model/pojo/request/LoginRequest.dart';
import 'package:naifarm/app/model/pojo/request/ModifyPasswordrequest.dart';
import 'package:naifarm/app/model/pojo/request/RegisterRequest.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/Fb_Profile.dart';
import 'package:naifarm/app/model/pojo/response/ForgotRespone.dart';
import 'package:naifarm/app/model/pojo/response/LoginRespone.dart';
import 'package:naifarm/app/model/pojo/response/OTPRespone.dart';
import 'package:naifarm/app/model/pojo/response/ResponeObject.dart';
import 'package:naifarm/app/model/pojo/response/VerifyRespone.dart';
import 'package:naifarm/app/model/pojo/response/RegisterRespone.dart';
import 'package:naifarm/app/model/pojo/response/Task.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/http/HttpException.dart';
import 'package:naifarm/utility/log/DioLogger.dart';
import 'package:rxdart/rxdart.dart';


class APIRepository{
  static const String TAG = 'AppAPIRepository';

  APIProvider _apiProvider;
  DBBookingRepository _dbAppStoreRepository;

  APIRepository(this._apiProvider, this._dbAppStoreRepository);


  Future<Fb_Profile> getFBProfile({String access_token}){
   // throwIfNoSuccess(response);
    return _apiProvider.getProFileFacebook(access_token);
  }

  Future<ResponeObject> CustomersLogin({LoginRequest loginRequest}){
    // throwIfNoSuccess(response);
    return _apiProvider.CustomersLogin(loginRequest);
  }

  Future<ResponeObject> CustomersRegister({RegisterRequest registerRequest}){
    // throwIfNoSuccess(response);
    return _apiProvider.CustomersRegister(registerRequest);
  }

  Future<ResponeObject> OTPRequest({String numberphone}){
    // throwIfNoSuccess(response);
    return _apiProvider.OtpRequest(numberphone);
  }

  Future<ResponeObject> OtpVerify({ String phone,String code,String ref}){
    // throwIfNoSuccess(response);
    return _apiProvider.OtpVerify(phone,code,ref);
  }

  Future<ResponeObject> ForgotPassword({ String email}){
    // throwIfNoSuccess(response);
    return _apiProvider.ForgotPasswordRequest(email);
  }


  Future<ResponeObject> ResetPasswordRequest({String email, String password,String token}){
    // throwIfNoSuccess(response);
    return _apiProvider.ResetPasswordRequest(email,password,token);
  }

  Future<ResponeObject> getCustomerInfo({String token}){
    // throwIfNoSuccess(response);
    return _apiProvider.getCustomerInfo(token);
  }

  Future<ResponeObject> ModifyProfile({CustomerInfoRespone data ,String token}){
    // throwIfNoSuccess(response);
    return _apiProvider.ModifyProfile(data,token);
  }

  Future<ResponeObject> ModifyPassword({ModifyPasswordrequest data ,String token}){
    // throwIfNoSuccess(response);
    return _apiProvider.ModifyPassword(data,token);
  }

  Future<ResponeObject> VerifyPassword({String password ,String token}){
    // throwIfNoSuccess(response);
    return _apiProvider.VerifyPassword(password,token);
  }

  Future<ResponeObject> AddressesList({String token}){
    // throwIfNoSuccess(response);
    return _apiProvider.AddressesList(token);
  }

  Future<ResponeObject> StatesProvice({String countries}){
    // throwIfNoSuccess(response);
    return _apiProvider.StatesProvice(countries);
  }

  Future<ResponeObject> StatesCity({String countriesid, String statesId}){
    // throwIfNoSuccess(response);
    return _apiProvider.StatesCity(countriesid,statesId);
  }

  Future<ResponeObject> StatesZipCode({String countries,String statesId,String cityId}){
    // throwIfNoSuccess(response);
    return _apiProvider.zipCode(countries,statesId,cityId);
  }


//  Observable<List<AppContent>> getTop100FreeApp(){
//    return Observable.fromFuture(_apiProvider.getTopFreeApp(TOP_100))
//        .flatMap(_convertFromEntry)
//        .flatMap((List<AppContent> list){
//      return Observable.fromFuture(_loadAndSaveTopFreeApp(list, ''));
//    });
//  }
//



}