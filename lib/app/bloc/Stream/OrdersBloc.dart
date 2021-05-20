import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/AssetImages.dart';
import 'package:naifarm/app/model/pojo/response/FeedbackRespone.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductHistoryCache.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductOrderCache.dart';
import 'package:naifarm/app/model/pojo/response/SystemRespone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class OrdersBloc {
  final AppNaiFarmApplication _application;
  CompositeSubscription _compositeSubscription = CompositeSubscription();
  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<Object>();
  final onSuccess = BehaviorSubject<Object>();
  final orderList = BehaviorSubject<OrderData>();
  final systemRespone = BehaviorSubject<SystemRespone>();
  final isUpdateFeedback = BehaviorSubject<bool>();
  Stream<Object> get feedList => onSuccess.stream;
  List<OrderData> orderDataList = <OrderData>[];
  HashMap feedbackMap = new HashMap<int, int>();

  OrdersBloc(this._application);

  loadOrder(BuildContext context,
      {String orderType,
      int page = 1,
      int limit = 20,
      String statusId,
      String sort,
      String token,
      bool load = false}) async {
    if (load) {
      onLoad.add(true);
    }
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.getOrder(context,
                orderType: orderType,
                page: page,
                limit: limit,
                statusId: statusId,
                token: token,
                sort: sort))
        .listen((respone) {
      if (load) {
        onLoad.add(false);
      }
      if (respone.httpCallBack.status == 200) {
        var item = (respone.respone as OrderRespone);

        if (page == 1) {
          NaiFarmLocalStorage.getHistoryCache().then((value) {
            if (value != null) {
              for (var data in value.historyCache) {
                if (data.orderViewType == orderType &&
                    data.typeView == statusId) {
                  value.historyCache.remove(data);
                  orderDataList.clear();
                  break;
                }
              }
              value.historyCache.add(HistoryCache(
                  orderViewType: orderType,
                  orderRespone: item,
                  typeView: statusId));
              NaiFarmLocalStorage.saveHistoryCache(value).then((value) {
                orderDataList.addAll(item.data);
                onSuccess.add(OrderRespone(
                    data: orderDataList,
                    total: item.total,
                    limit: item.limit,
                    page: item.limit));
              });
            } else {
              List<HistoryCache> data = <HistoryCache>[];
              data.add(HistoryCache(
                  typeView: statusId,
                  orderViewType: orderType,
                  orderRespone: item));
              NaiFarmLocalStorage.saveHistoryCache(
                      ProductHistoryCache(historyCache: data))
                  .then((value) {
                orderDataList.addAll(item.data);
                onSuccess.add(OrderRespone(
                  data: orderDataList,
                  total: item.total,
                  limit: item.limit,
                  page: item.page,
                ));
              });
            }
          });
        } else {
          orderDataList.addAll(item.data);
          onSuccess.add(OrderRespone(
            data: orderDataList,
            total: item.total,
            limit: item.limit,
            page: item.page,
          ));
        }
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  Future<OrderData> getOrderByIdFuture(BuildContext context,
      {int id, String orderType, String token}) async {
    final respons = await _application.appStoreAPIRepository
        .getOrderById(context, id: id, orderType: orderType, token: token);
    if (respons.httpCallBack.status == 200) {
      return (respons.respone as OrderData);
    } else {
      return OrderData();
    }
  }

  getOrderById(BuildContext context, {int id, String orderType, String token}) {
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .getOrderById(context, id: id, orderType: orderType, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        NaiFarmLocalStorage.getOrderCache().then((value) {
          if (value != null) {
            for (var data in value.orderCahe) {
              if (data.typeView == id.toString() &&
                  data.orderViewType == orderType) {
                value.orderCahe.remove(data);
                break;
              }
            }
            value.orderCahe.add(OrderCache(
                orderData: respone.respone,
                orderViewType: orderType,
                typeView: id.toString()));
            NaiFarmLocalStorage.saveOrderCache(value).then((value) {
              orderList.add((respone.respone as OrderData));
            });
          } else {
            List<OrderCache> data = <OrderCache>[];
            data.add(OrderCache(
                typeView: id.toString(),
                orderViewType: orderType,
                orderData: respone.respone));
            NaiFarmLocalStorage.saveOrderCache(
                    ProductOrderCache(orderCahe: data))
                .then((value) {
              //  orderList.addAll(respone.respone);
              orderList.add(respone.respone);
            });
          }
        });
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  markPaid(BuildContext context, {int orderId, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .markPaid(context, orderId: orderId, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(true);
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  uploadImage(BuildContext context,
      {File imageFile,
      String imageableType,
      int imageableId,
      String token,bool requestPayments}) async {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.uploadImage(context,
                imageFile: imageFile,
                imageableType: imageableType,
                imageableId: imageableId,
                token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200 ||
          respone.httpCallBack.status == 201) {
        //context.read<InfoCustomerBloc>().loadCustomInfo(token:token);
        if(requestPayments){
          requestPayment(context, orderId: imageableId, token: token);
        }else{
          onLoad.add(false);
        }

      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  uploadImages(BuildContext context,
      {String imageableType,
      int imageableId,
      String token,
      List<File> imageList}) async {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.uploadImages(context,
                imageFile: imageList,
                imageableType: imageableType,
                imageableId: imageableId,
                token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200 ||
          respone.httpCallBack.status == 201) {
        onLoad.add(false);
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  requestPayment(BuildContext context, {int orderId, String token}) async {
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .requestPayment(context, orderId: orderId, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        //context.read<InfoCustomerBloc>().loadCustomInfo(token:token);
        onSuccess.add(true);
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  addTracking(BuildContext context,
      {String trackingId, String token, int orderId}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.addTracking(context,
                trackingId: trackingId, token: token, orderId: orderId))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(true);
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  goodsReceived(BuildContext context, {String token, int orderId}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .goodsReceived(context, token: token, orderId: orderId))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(true);
        orderList.add((respone.respone as OrderData));
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  orderCancel(BuildContext context, {String token, int orderId}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .orderCancel(context, token: token, orderId: orderId))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(true);
        orderList.add((respone.respone as OrderData));
      } else {
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  int sumTotal(List<OrderItems> items, int rate) {
    var sum = 0;
    for (var item in items) {
      sum += ((item.offerPrice != null &&
                  double.parse(item.offerPrice.toString()) > 0
              ? double.parse(item.offerPrice.toString()).toInt()
              : double.parse(item.unitPrice.toString()).toInt()) *
          item.quantity);
    }
    return sum + rate;
  }

  getSystem(BuildContext context) async {
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.getSystem(context))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        NaiFarmLocalStorage.getSystemCache().then((value) {
          NaiFarmLocalStorage.saveSystemCache(respone.respone as SystemRespone)
              .then((value) {
            systemRespone.add(respone.respone as SystemRespone);
          });
        });
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  addFeedback(BuildContext context,
      {int rating,
      String comment,
      int inventoryId,
      int orderId,
      String token,
      List<AssetImages> imageList,
      int index}) {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.createFeedback(context,
                token: token,
                inventoryId: inventoryId,
                rating: rating,
                orderId: orderId,
                comment: comment))
        .listen((respone) async {
      if (respone.httpCallBack.status == 200) {

        feedbackMap[index] = (respone.respone as FeedbackData).rating;
        //  onSuccess.add(true);
        // indexRate.add(index);
        // List<File> fileList = <File>[];
        if (imageList.length == 0) {
          isUpdateFeedback.add(true);
          onLoad.add(false);
        } else
          for (var item in imageList) {
            writeToFile(await item.getByteData(quality: 100)).then((file) {
              //fileList.add(file);
              uploadImage(
                context,
                token: token,
                imageableId: int.parse((respone.respone as FeedbackData).id),
                imageFile: file,
                imageableType: "feedback"
              );
            });
          }
        //feedbackData.add(respone.respone as FeedbackData);
        // uploadImages(
        //   context,
        //   token: token,
        //   imageableId:
        //       int.parse((respone.respone as FeedbackRespone).feedbackableId),
        //   imageList: fileList,
        //   imageableType: "feedback",
        // );
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath +
        '/${DateTime.now().millisecondsSinceEpoch}.jpg'; // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}

enum OrderViewType { Shop, Purchase }
