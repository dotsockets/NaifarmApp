
import 'dart:async';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/ModifyPasswordrequest.dart';
import 'package:naifarm/app/model/pojo/request/RegisterRequest.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:rxdart/rxdart.dart';
import 'package:naifarm/app/model/pojo/request/LoginRequest.dart';
import 'package:naifarm/app/model/pojo/response/LoginRespone.dart';

class MemberBloc{
  final AppNaiFarmApplication _application;

  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onSuccess = BehaviorSubject<Object>();

  final onLoad = BehaviorSubject<bool>();

  final onError = BehaviorSubject<String>();

  Stream<Object> get feedList => onSuccess.stream;

  MemberBloc(this._application);

  void dispose() {
    _compositeSubscription.clear();
  }


  CustomerLogin({LoginRequest loginRequest}) async{
     onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.CustomersLogin(loginRequest: LoginRequest(username: loginRequest.username,phone: loginRequest.phone,password: loginRequest.password))).listen((respone) {

      var item = (respone.respone as LoginRespone);
      if(respone.http_call_back.status==200){
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

  LoginFacebook() async{
    onLoad.add(true);
    final FacebookLogin facebookSignIn = new FacebookLogin();
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        onLoad.add(false);
        final FacebookAccessToken accessToken = result.accessToken;
        print("wcsf ${accessToken.token}");
        onError.add("Not yet available");

        // AppProvider.getApplication(context).appStoreAPIRepository.getFBProfile(access_token: accessToken.token).then((value){
        //   Navigator.of(context).pop();
        //   AppRoute.Register_FB(context,value.email);
        // }).catchError((Object obj){
        //   switch (obj.runtimeType) {
        //     case DioError:
        //     // Here's the sample to get the failed response error code and message
        //       final res = (obj as DioError).response;
        //       Logger().e("Got error : ${res.statusCode} -> ${res.statusMessage}");
        //       break;
        //     default:
        //   }
        // });
        //get image  https://graph.facebook.com/2305752019445635/picture?type=large&width=720&height=720

        // final graphResponse = await http.get(
        //     'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
        // final profile = JSON.decode(graphResponse.body);
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


  CustomersRegister({RegisterRequest registerRequest}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.CustomersRegister(registerRequest: registerRequest)).listen((respone) {

      if(respone.http_call_back.status==200 || respone.http_call_back.status==201){

        Usermanager().SavePhone(phone: registerRequest.phone).then((value){
          onLoad.add(false);
          CustomerLogin(loginRequest: LoginRequest(username: registerRequest.email,password: registerRequest.password));
        });
      }else{
        onLoad.add(false);
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  ForgotPassword({String email}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.ForgotPassword(email:email)).listen((respone) {
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

  ModifyProfile({CustomerInfoRespone data ,String token,bool onload}) async{
    onload?onLoad.add(true):null;
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.ModifyProfile(data: data,token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
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



}