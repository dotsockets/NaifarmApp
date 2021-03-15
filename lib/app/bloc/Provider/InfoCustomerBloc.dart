import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/ProfileObjectCombine.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rxdart/rxdart.dart';

class InfoCustomerBloc extends Cubit<InfoCustomerState> {
  final AppNaiFarmApplication _application;
  InfoCustomerBloc(this._application) : super(InfoCustomerInitial());

  loadCustomInfo(BuildContext context,
      {String token, bool oneSignal = false}) async {
    NaiFarmLocalStorage.getCustomerInfo().then((value) {
      if (value != null) {
        emit(InfoCustomerLoading(value));
      }
    });

    Observable.combineLatest3(
        Observable.fromFuture(_application.appStoreAPIRepository
            .getCustomerInfo(context, token: token)),
        Observable.fromFuture(_application.appStoreAPIRepository
            .getMyShopInfo(context, accessToken: token)),
        Observable.fromFuture(_application.appStoreAPIRepository
            .getShippingMyShop(context, token: token)), (a, b, c) {
      final _customInfo = (a as ApiResult).respone;
      final _myshopInfo = (b as ApiResult).respone;
      final _shipping = (c as ApiResult).respone;
      return ApiResult(
          respone: ProfileObjectCombine(
              customerInfoRespone: _customInfo,
              myShopRespone: _myshopInfo,
              shppingMyShopRespone: _shipping),
          httpCallBack: (a as ApiResult).httpCallBack);
    }).listen((respone) async {
      if (respone.httpCallBack.status == 200) {
        if (oneSignal &&
            (respone.respone as ProfileObjectCombine).myShopRespone != null) {
          OneSignal.shared.setExternalUserId(
              (respone.respone as ProfileObjectCombine)
                  .customerInfoRespone
                  .id
                  .toString());
          OneSignal.shared.sendTag("shopID",
              "${(respone.respone as ProfileObjectCombine).myShopRespone.id}");
        }

        NaiFarmLocalStorage.saveCustomerInfo(
                (respone.respone as ProfileObjectCombine))
            .then((value) {
          emit(InfoCustomerLoaded((respone.respone as ProfileObjectCombine)));
        });
      } else {
        NaiFarmLocalStorage.getCustomerInfo().then((value) {
          emit(InfoCustomerError(ProfileObjectCombine(
              shppingMyShopRespone: value.shppingMyShopRespone,
              customerInfoRespone: value.customerInfoRespone,
              myShopRespone: value.myShopRespone,
              httpCallBack: respone.httpCallBack)));
        });
      }
    });
  }
}

@immutable
abstract class InfoCustomerState {
  const InfoCustomerState();
}

class InfoCustomerInitial extends InfoCustomerState {
  const InfoCustomerInitial();
}

class InfoCustomerLoading extends InfoCustomerState {
  final ProfileObjectCombine profileObjectCombine;
  const InfoCustomerLoading(this.profileObjectCombine);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is InfoCustomerLoading &&
        o.profileObjectCombine == profileObjectCombine;
  }

  @override
  int get hashCode => profileObjectCombine.hashCode;
}

class InfoCustomerLoaded extends InfoCustomerState {
  final ProfileObjectCombine profileObjectCombine;
  const InfoCustomerLoaded(this.profileObjectCombine);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is InfoCustomerLoaded &&
        o.profileObjectCombine == profileObjectCombine;
  }

  @override
  int get hashCode => profileObjectCombine.hashCode;
}

class InfoCustomerError extends InfoCustomerState {
  final ProfileObjectCombine profileObjectCombine;
  const InfoCustomerError(this.profileObjectCombine);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is InfoCustomerError &&
        o.profileObjectCombine == profileObjectCombine;
  }

  @override
  int get hashCode => profileObjectCombine.hashCode;
}
