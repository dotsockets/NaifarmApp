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
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/Fb_Profile.dart';
import 'package:naifarm/app/model/pojo/response/ProfileObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:rxdart/rxdart.dart';
import 'package:naifarm/app/model/pojo/request/LoginRequest.dart';
import 'package:naifarm/app/model/pojo/response/LoginRespone.dart';

class MemberBloc {
  final AppNaiFarmApplication _application;

  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onSuccess = BehaviorSubject<Object>();

  final onLoad = BehaviorSubject<bool>();

  final onError = BehaviorSubject<ThrowIfNoSuccess>();

  final customerInfoRespone = BehaviorSubject<ProfileObjectCombine>();

  final textOn = BehaviorSubject<String>();

  final checkPhone = BehaviorSubject<bool>();

  final checkExistingPhone = BehaviorSubject<bool>();

  Stream<Object> get feedList => onSuccess.stream;

  MemberBloc(this._application);

  void dispose() {
    _compositeSubscription.clear();
    textOn.close();
  }

  customerLogin({BuildContext context, LoginRequest loginRequest}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.customersLogin(context,
                loginRequest: LoginRequest(
                    username: loginRequest.username,
                    phone: loginRequest.phone,
                    password: loginRequest.password)))
        .listen((respone) {
      var item = (respone.respone as LoginRespone);
      if (respone.httpCallBack.status == 200) {
        context
            .read<CustomerCountBloc>()
            .loadCustomerCount(context, token: item.token);
        context
            .read<InfoCustomerBloc>()
            .loadCustomInfo(context, token: item.token, oneSignal: true);
        Usermanager().savelogin(
            user: LoginRespone(
                name: item.name, token: item.token, email: item.email));
        // onLoad.add(false);
        onSuccess.add(item);
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  customerLoginApple({BuildContext context, String accessToken}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .loginApple(context, accessToken: accessToken))
        .listen((respone) {
      var item = (respone.respone as LoginRespone);
      if (respone.httpCallBack.status == 200) {
        context
            .read<CustomerCountBloc>()
            .loadCustomerCount(context, token: item.token);
        context
            .read<InfoCustomerBloc>()
            .loadCustomInfo(context, token: item.token, oneSignal: true);
        Usermanager().savelogin(
            user: LoginRespone(
                name: item.name, token: item.token, email: item.email));
        // onLoad.add(false);
        onSuccess.add(item);
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  customersLoginSocial(
      {BuildContext context,
      FbProfile loginRequest,
      String provider,
      bool isLoad}) async {
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.customersLoginSocial(context,
                loginRequest: LoginRequest(
                    name: loginRequest.name,
                    email: loginRequest.email,
                    accessToken: loginRequest.token),
                provider: provider))
        .listen((respone) {
      var item = (respone.respone as LoginRespone);
      if (respone.httpCallBack.status == 200) {
        context
            .read<CustomerCountBloc>()
            .loadCustomerCount(context, token: item.token);
        context
            .read<InfoCustomerBloc>()
            .loadCustomInfo(context, token: item.token, oneSignal: true);

        Usermanager()
            .savelogin(
                user: LoginRespone(
                    name: item.name, token: item.token, email: item.email))
            .then((value) {
          if (isLoad) {
            onLoad.add(false);
          }
          onSuccess.add(item);
        });
      } else {
        Usermanager().logout();
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  checkEmail(BuildContext context, {FbProfile fbProfile}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .checkEmail(context, email: fbProfile.email))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(fbProfile);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }



  loginFacebook({BuildContext context, bool isLoad}) async {
    // onLoad.add(true);
    final FacebookLogin facebookSignIn = new FacebookLogin();
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    // facebookSignIn.loginBehavior = FacebookLoginBehavior.webViewOnly;
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        //  onLoad.add(false);
        //  {"name":"Apisit Kaewsasan","first_name":"Apisit","last_name":"Kaewsasan","email":"apisitkaewsasan\u0040hotmail.com","id":"3899261036761384"}
        final FacebookAccessToken accessToken = result.accessToken;


        break;
      case FacebookLoginStatus.cancelledByUser:
        //  onLoad.add(false);
        onError.add(ThrowIfNoSuccess(message: "Login cancelled by the user."));
        break;
      case FacebookLoginStatus.error:
        //  onLoad.add(false);
        onError.add(ThrowIfNoSuccess(message: result.errorMessage));
        break;
    }
  }

  otpRequest(BuildContext context, {String numberphone}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .otpRequest(context, numberphone: numberphone))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  otpVerify(BuildContext context,
      {String phone, String code, String ref}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .otpVerify(context, phone: phone, ref: ref, code: code))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(true);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  customersRegister(
      {BuildContext context, RegisterRequest registerRequest}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .customersRegister(context, registerRequest: registerRequest))
        .listen((respone) {
      if (respone.httpCallBack.status == 200 ||
          respone.httpCallBack.status == 201) {
        Usermanager().savePhone(phones: registerRequest.phone).then((value) {
          onLoad.add(false);
          customerLogin(
              context: context,
              loginRequest: LoginRequest(
                  username: registerRequest.email,
                  password: registerRequest.password));
        });
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  forgotPassword(BuildContext context,
      {String phone, String code, String ref, String password}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.forgotPassword(context,
                code: code, ref: ref, phone: phone, password: password))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  resetPasswordRequest(BuildContext context,
      {String email, String password, String token}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.resetPasswordRequest(context,
                email: email, password: password, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  loadMyProfile(BuildContext context, {String token}) {
    StreamSubscription subscription = Rx.combineLatest2(
        Stream.fromFuture(_application.appStoreAPIRepository
            .getCustomerInfo(context, token: token)),
        Stream.fromFuture(_application.appStoreAPIRepository
            .getMyShopInfo(context, accessToken: token)), (a, b) {
      final _customInfo = (a as ApiResult).respone;
      final _myshopInfo = (b as ApiResult).respone;

      return ProfileObjectCombine(
          customerInfoRespone: _customInfo, myShopRespone: _myshopInfo);
    }).listen((event) {
      customerInfoRespone.add(event);
    });
    _compositeSubscription.add(subscription);
  }

  getCustomerInfo(BuildContext context, {String token}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .getCustomerInfo(context, token: token))
        .listen((respone) {
      onLoad.add(false);

      if (respone.httpCallBack.status == 200) {
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  modifyProfile(
      {BuildContext context,
      CustomerInfoRespone data,
      String token,
      bool onload}) async {
    if (onload) {
      onLoad.add(true);
    }
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .modifyProfile(context, data: data, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        context.read<InfoCustomerBloc>().loadCustomInfo(context, token: token);
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  modifyPassword(BuildContext context,
      {ModifyPasswordrequest data, String token}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .modifyPassword(context, data: data, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  firstPassword(BuildContext context,
      {ModifyPasswordrequest data, String token}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .firstPassword(context, data: data, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  verifyPassword(BuildContext context, {String password, String token}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .verifyPassword(context, password: password, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  createMyShop(BuildContext context,
      {String name, String slug, String description, String token}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.createMyShop(context,
                name: name, slug: slug, description: description, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  getMyShopInfo(BuildContext context, {String token}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .getMyShopInfo(context, accessToken: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  myShopUpdate(
      {BuildContext context, MyShopRequest data, String accessToken}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.myShopUpdate(
                context: context, data: data, accessToken: accessToken))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        //  context.read<InfoCustomerBloc>().loadCustomInfo(token:access_token);
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  myShopActive({BuildContext context, int data, String accessToken}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.myShopActive(
                context: context, data: data, accessToken: accessToken))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        //  context.read<InfoCustomerBloc>().loadCustomInfo(token:access_token);
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  uploadImage(
      {BuildContext context,
      File imageFile,
      String imageableType,
      int imageableId,
      String token}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.uploadImage(context,
                imageFile: imageFile,
                imageableType: imageableType,
                imageableId: imageableId,
                token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200 ||
          respone.httpCallBack.status == 201) {
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  getInfoRules(BuildContext context, {String slug}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .getInformationRules(context, slug))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  requestChangEmail(BuildContext context, {String email, String token}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .requestChangEmail(context, email: email, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  checkPhoneNumber(BuildContext context, {String phone}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .checkPhone(context, phone: phone))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        checkPhone.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  checkExistingPhoneNumber(BuildContext context, {String phone}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .checkExistingPhone(context, phone: phone))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        checkExistingPhone.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }
}

enum RequestOtp { Register, Forgotpassword, ChangPassword }
