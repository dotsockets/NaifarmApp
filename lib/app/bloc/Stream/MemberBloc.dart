
import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/bloc/Provider/InfoCustomerBloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/ModifyPasswordrequest.dart';
import 'package:naifarm/app/model/pojo/request/MyShopRequest.dart';
import 'package:naifarm/app/model/pojo/request/RegisterRequest.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/Fb_Profile.dart';
import 'package:naifarm/app/model/pojo/response/ProfileObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:naifarm/app/model/pojo/request/LoginRequest.dart';
import 'package:naifarm/app/model/pojo/response/LoginRespone.dart';
import 'dart:convert';

class MemberBloc{
  final AppNaiFarmApplication _application;

  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onSuccess = BehaviorSubject<Object>();

  final onLoad = BehaviorSubject<bool>();

  final onError = BehaviorSubject<String>();

  final customerInfoRespone = BehaviorSubject<ProfileObjectCombine>();

  final TextOn = BehaviorSubject<String>();

  final checkPhone = BehaviorSubject<bool>();
  Stream<Object> get feedList => onSuccess.stream;

  MemberBloc(this._application);

  void dispose() {
    _compositeSubscription.clear();
  }


  CustomerLogin({BuildContext context,LoginRequest loginRequest}) async{
     onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.CustomersLogin(loginRequest: LoginRequest(username: loginRequest.username,phone: loginRequest.phone,password: loginRequest.password))).listen((respone) {

      var item = (respone.respone as LoginRespone);
      if(respone.http_call_back.status==200){
        context.read<CustomerCountBloc>().loadCustomerCount(token: item.token);
        context.read<InfoCustomerBloc>().loadCustomInfo(token: item.token);
        Usermanager().Savelogin(user: LoginRespone(name: item.name,token: item.token,email: item.email)).then((value){
          onLoad.add(false);
          onSuccess.add(item);
        });
      }else{
        onLoad.add(false);
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  CustomersLoginSocial({BuildContext context,Fb_Profile loginRequest}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.CustomersLoginSocial(loginRequest: LoginRequest(name: loginRequest.name,email: loginRequest.email,accessToken: loginRequest.token))).listen((respone) {

      var item = (respone.respone as LoginRespone);
      if(respone.http_call_back.status==200){
        context.read<CustomerCountBloc>().loadCustomerCount(token: item.token);
        context.read<InfoCustomerBloc>().loadCustomInfo(token: item.token);
        Usermanager().Savelogin(user: LoginRespone(name: item.name,token: item.token,email: item.email)).then((value){
          onLoad.add(false);
          onSuccess.add(item);
        });
      }else{
        onLoad.add(false);
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  CheckEmail({Fb_Profile fb_profile}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.CheckEmail(email: fb_profile.email)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
      onSuccess.add(fb_profile);
      }else{

        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  getFBProfile({String accessToken}){

    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getFBProfile(access_token: accessToken)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        var item = (respone.respone as Fb_Profile);
        item.token = accessToken;
        CheckEmail(fb_profile: item);
        //onSuccess.add(true);
      }else{
        onLoad.add(false);
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  LoginFacebook() async{
    onLoad.add(true);
    final FacebookLogin facebookSignIn = new FacebookLogin();
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        onLoad.add(false);
        //  {"name":"Apisit Kaewsasan","first_name":"Apisit","last_name":"Kaewsasan","email":"apisitkaewsasan\u0040hotmail.com","id":"3899261036761384"}
        final FacebookAccessToken accessToken = result.accessToken;
        getFBProfile(accessToken: accessToken.token);
        break;
      case FacebookLoginStatus.cancelledByUser:
        onLoad.add(false);
        onError.add("Login cancelled by the user.");
        break;
      case FacebookLoginStatus.error:
        onLoad.add(false);
        onError.add("Something went wrong with the login process.");
        break;
    }
  }

  OTPRequest({String numberphone}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.OTPRequest(numberphone: numberphone)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  OTPVerify({String phone,String code,String ref}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.OtpVerify(phone: phone,ref: ref,code: code)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(true);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }


  CustomersRegister({BuildContext context,RegisterRequest registerRequest}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.CustomersRegister(registerRequest: registerRequest)).listen((respone) {

      if(respone.http_call_back.status==200 || respone.http_call_back.status==201){

        Usermanager().SavePhone(phone: registerRequest.phone).then((value){
          onLoad.add(false);
          CustomerLogin(context: context,loginRequest: LoginRequest(username: registerRequest.email,password: registerRequest.password));
        });
      }else{
        onLoad.add(false);
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  ForgotPassword({ String phone,String code,String ref,String password}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.ForgotPassword(code: code,ref: ref,phone: phone,password: password)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  ResetPasswordRequest({String email, String password,String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.ResetPasswordRequest(email: email,password: password,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  loadMyProfile({String token}){

    StreamSubscription subscription = Observable.combineLatest2(
        Observable.fromFuture(_application.appStoreAPIRepository.getCustomerInfo(token: token)),
        Observable.fromFuture(_application.appStoreAPIRepository.getMyShopInfo(access_token: token)),(a, b){
      final _customInfo = (a as ApiResult).respone;
      final _myshopInfo  =(b as ApiResult).respone;

      return ProfileObjectCombine(customerInfoRespone: _customInfo,myShopRespone: _myshopInfo);

    }).listen((event) {
      customerInfoRespone.add(event);
    });
    _compositeSubscription.add(subscription);


  }


  getCustomerInfo({String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getCustomerInfo(token: token)).listen((respone) {
      onLoad.add(false);

      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  ModifyProfile({BuildContext context,CustomerInfoRespone data ,String token,bool onload}) async{
    onload?onLoad.add(true):null;
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.ModifyProfile(data: data,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        context.read<InfoCustomerBloc>().loadCustomInfo(token:token);
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  ModifyPassword({ModifyPasswordrequest data ,String token}) async{
     onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.ModifyPassword(data: data,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
          onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  VerifyPassword({String password ,String token}) async{
     onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.VerifyPassword(password: password,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
          onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }


  CreateMyShop({String name, String slug, String description, String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.CreateMyShop(name: name,slug: slug,description: description,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  getMyShopInfo({String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getMyShopInfo(access_token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }


  MyShopUpdate({BuildContext context,MyShopRequest data, String access_token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.MyShopUpdate(data: data,access_token: access_token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
     //  context.read<InfoCustomerBloc>().loadCustomInfo(token:access_token);
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  UploadImage({BuildContext context,File imageFile,String imageableType, int imageableId, String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.UploadImage(imageFile: imageFile,imageableType: imageableType,imageableId: imageableId,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200 || respone.http_call_back.status==201){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  getInfoRules({String slug}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getInformationRules(slug)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  requestChangEmail({String email, String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.requestChangEmail(email: email,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  checkPhoneNumber({String phone}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.checkPhone(phone: phone)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        checkPhone.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

}

enum RequestOtp{
  Register,
  Forgotpassword,
  ChangPassword
}