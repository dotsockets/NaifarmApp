
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
import 'package:onesignal_flutter/onesignal_flutter.dart';
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
    Observable.fromFuture(_application.appStoreAPIRepository.CustomersLogin(context,loginRequest: LoginRequest(username: loginRequest.username,phone: loginRequest.phone,password: loginRequest.password))).listen((respone) {

      var item = (respone.respone as LoginRespone);
      if(respone.http_call_back.status==200){

        context.read<CustomerCountBloc>().loadCustomerCount(context,token: item.token);
        context.read<InfoCustomerBloc>().loadCustomInfo(context,token: item.token,oneSignal: true);
        Usermanager().Savelogin(user: LoginRespone(name: item.name,token: item.token,email: item.email));
       // onLoad.add(false);
        onSuccess.add(item);
      }else{
        onLoad.add(false);
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  CustomersLoginSocial({BuildContext context,Fb_Profile loginRequest,String provider,bool isLoad}) async{

    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.CustomersLoginSocial(context,loginRequest: LoginRequest(name: loginRequest.name,email: loginRequest.email,accessToken: loginRequest.token),provider: provider)).listen((respone) {

      var item = (respone.respone as LoginRespone);
      if(respone.http_call_back.status==200){
        context.read<CustomerCountBloc>().loadCustomerCount(context,token: item.token);
        context.read<InfoCustomerBloc>().loadCustomInfo(context,token: item.token,oneSignal: true);

        Usermanager().Savelogin(user: LoginRespone(name: item.name,token: item.token,email: item.email)).then((value){
          if(isLoad){
            onLoad.add(false);
          }
          onSuccess.add(item);
        });
      }else{
        Usermanager().logout();
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  CheckEmail(BuildContext context,{Fb_Profile fb_profile}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.CheckEmail(context,email: fb_profile.email)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
      onSuccess.add(fb_profile);
      }else{

        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  getFBProfile({BuildContext context,String accessToken,bool isLoad}){

    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getFBProfile(context,access_token: accessToken)).listen((respone) {
     // onLoad.add(false);
      if(respone.http_call_back.status==200){
        var item = (respone.respone as Fb_Profile);
        item.token = accessToken;

        CustomersLoginSocial(context: context,loginRequest: item,provider: "facebook",isLoad: isLoad);
        //CheckEmail(fb_profile: item);
        //onSuccess.add(true);
      }else{
        Usermanager().logout();
        onLoad.add(false);
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  LoginFacebook({BuildContext context,bool isLoad}) async{
   // onLoad.add(true);
    final FacebookLogin facebookSignIn = new FacebookLogin();
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
   // facebookSignIn.loginBehavior = FacebookLoginBehavior.webViewOnly;
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
      //  onLoad.add(false);
        //  {"name":"Apisit Kaewsasan","first_name":"Apisit","last_name":"Kaewsasan","email":"apisitkaewsasan\u0040hotmail.com","id":"3899261036761384"}
        final FacebookAccessToken accessToken = result.accessToken;
        getFBProfile(context: context,accessToken: accessToken.token,isLoad: isLoad);
        break;
      case FacebookLoginStatus.cancelledByUser:
      //  onLoad.add(false);
        onError.add("Login cancelled by the user.");
        break;
      case FacebookLoginStatus.error:
      //  onLoad.add(false);
        onError.add("Something went wrong with the login process.");
        break;
    }
  }

  OTPRequest(BuildContext context,{String numberphone}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.OTPRequest(context,numberphone: numberphone)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  OTPVerify(BuildContext context,{String phone,String code,String ref}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.OtpVerify(context,phone: phone,ref: ref,code: code)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(true);
      }else{
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }


  CustomersRegister({BuildContext context,RegisterRequest registerRequest}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.CustomersRegister(context,registerRequest: registerRequest)).listen((respone) {

      if(respone.http_call_back.status==200 || respone.http_call_back.status==201){

        Usermanager().SavePhone(phone: registerRequest.phone).then((value){
          onLoad.add(false);
          CustomerLogin(context: context,loginRequest: LoginRequest(username: registerRequest.email,password: registerRequest.password));
        });
      }else{
        onLoad.add(false);
        onError.add(respone.http_call_back.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  ForgotPassword(BuildContext context,{ String phone,String code,String ref,String password}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.ForgotPassword(context,code: code,ref: ref,phone: phone,password: password)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  ResetPasswordRequest(BuildContext context,{String email, String password,String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.ResetPasswordRequest(context,email: email,password: password,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  loadMyProfile(BuildContext context,{String token}){

    StreamSubscription subscription = Observable.combineLatest2(
        Observable.fromFuture(_application.appStoreAPIRepository.getCustomerInfo(context,token: token)),
        Observable.fromFuture(_application.appStoreAPIRepository.getMyShopInfo(context,access_token: token)),(a, b){
      final _customInfo = (a as ApiResult).respone;
      final _myshopInfo  =(b as ApiResult).respone;

      return ProfileObjectCombine(customerInfoRespone: _customInfo,myShopRespone: _myshopInfo);

    }).listen((event) {
      customerInfoRespone.add(event);
    });
    _compositeSubscription.add(subscription);


  }


  getCustomerInfo(BuildContext context,{String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getCustomerInfo(context,token: token)).listen((respone) {
      onLoad.add(false);

      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  ModifyProfile({BuildContext context,CustomerInfoRespone data ,String token,bool onload}) async{
    onload?onLoad.add(true):null;
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.ModifyProfile(context,data: data,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        context.read<InfoCustomerBloc>().loadCustomInfo(context,token:token);
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  ModifyPassword(BuildContext context,{ModifyPasswordrequest data ,String token}) async{
     onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.ModifyPassword(context,data: data,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
          onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  VerifyPassword(BuildContext context,{String password ,String token}) async{
     onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.VerifyPassword(context,password: password,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
          onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }


  CreateMyShop(BuildContext context,{String name, String slug, String description, String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.CreateMyShop(context,name: name,slug: slug,description: description,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  getMyShopInfo(BuildContext context,{String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getMyShopInfo(context,access_token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }


  MyShopUpdate({BuildContext context,MyShopRequest data, String access_token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.MyShopUpdate(context: context,data: data,access_token: access_token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
     //  context.read<InfoCustomerBloc>().loadCustomInfo(token:access_token);
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  UploadImage({BuildContext context,File imageFile,String imageableType, int imageableId, String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.UploadImage(context,imageFile: imageFile,imageableType: imageableType,imageableId: imageableId,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200 || respone.http_call_back.status==201){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  getInfoRules(BuildContext context,{String slug}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.getInformationRules(context,slug)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  requestChangEmail(BuildContext context,{String email, String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.requestChangEmail(context,email: email,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        onSuccess.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  checkPhoneNumber(BuildContext context,{String phone}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.checkPhone(context,phone: phone)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        checkPhone.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.message);
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