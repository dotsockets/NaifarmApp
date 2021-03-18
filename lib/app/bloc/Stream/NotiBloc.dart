import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/NotiRespone.dart';
import 'package:naifarm/app/model/pojo/response/NotificationCombine.dart';
import 'package:rxdart/rxdart.dart';

class NotiBloc {
  final AppNaiFarmApplication _application;
  CompositeSubscription _compositeSubscription = CompositeSubscription();
  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<Object>();
  final onSuccess = BehaviorSubject<Object>();
  Stream<Object> get feedList => onSuccess.stream;
  List<NotiData> productMore = <NotiData>[];

  NotiBloc(this._application);

//NotificationCombine
  getNotification(
      {BuildContext context,
      String group,
      int page,
      String sort,
      int limit,
      String token}) async {
    if (page == 1) {
      productMore.clear();
    }

    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.getNotificationByGroup(context,
                group: group,
                limit: limit,
                page: page,
                sort: sort,
                token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        // onSuccess.add((respone.respone as NotiRespone));
        var item = (respone.respone as NotiRespone);
        if (item.data != null) {
          productMore.addAll(item.data);
          onSuccess.add(NotiRespone(
              data: productMore,
              limit: item.limit,
              page: item.page,
              total: item.total));
        }
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  getNotificationByGroup(
      {BuildContext context,
      String group,
      int page,
      String sort,
      int limit,
      String token}) async {
    StreamSubscription subscription = Observable.combineLatest2(
        Observable.fromFuture(_application.appStoreAPIRepository
            .getNotificationByGroup(context,
                group: "customer",
                limit: limit,
                page: page,
                sort: sort,
                token: token)),
        Observable.fromFuture(_application.appStoreAPIRepository
            .getNotificationByGroup(context,
                group: "shop",
                limit: limit,
                page: page,
                sort: sort,
                token: token)), (a, b) {
      final _cusNoti = (a as ApiResult).respone;
      final _shopNoti = (b as ApiResult).respone;

      return NotificationCombine(
          cusNotiRespone: _cusNoti, shopNotiRespone: _shopNoti);
    }).listen((event) {
      markAsReadNotifications(context, token: token);
      onSuccess.add(event);
    });
    _compositeSubscription.add(subscription);
  }

  markAsReadNotifications(BuildContext context, {String token}) async {
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .markAsReadNotifications(context, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  refreshProducts(BuildContext context, {int page, int limit, String group}) {
    Usermanager().getUser().then((value) {
      if (value.token != null) {
        NaiFarmLocalStorage.getNowPage().then((data) {
          if (data == 2) {
            getNotification(
                context: context,
                group: group,
                page: page,
                limit: limit,
                sort: "notification.createdAt:desc",
                token: value.token);
          }
        });
      }
    });
  }

  dispose() {
    onLoad.close();
  }
}
