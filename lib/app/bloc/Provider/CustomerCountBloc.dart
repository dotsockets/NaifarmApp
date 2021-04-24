import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:rxdart/rxdart.dart';

class CustomerCountBloc extends Cubit<CustomerCountState> {
  final AppNaiFarmApplication _application;
  CustomerCountBloc(this._application) : super(CustomerCountInitial());

  void loadCustomerCount(BuildContext context, {String token}) {
    NaiFarmLocalStorage.getCustomerCuse().then((value) {
      emit(CustomerCountLoading(value));
    });

    Observable.combineLatest2(
        Observable.fromFuture(_application.appStoreAPIRepository
            .getCustomerCount(context, token: token)),
        Observable.fromFuture(_application.appStoreAPIRepository
            .getCartlists(context, token: token)), (a, b) {
      final customerCount = (a as ApiResult).respone;
      final cartCout = (b as ApiResult).respone;
      var item = (customerCount as CustomerCountRespone);
      var cartItem = (cartCout as CartResponse);
      if ((a as ApiResult).httpCallBack.status == 200) {
        return ApiResult(
            respone: CustomerCountRespone(
              cartCount: countCartItem(item: cartItem),
              buyOrder: item.buyOrder,
              like: item.like,
              notification: item.notification,
              sellOrder: item.sellOrder,
              watingReview: item.watingReview,
            ),
            httpCallBack: (a as ApiResult).httpCallBack);
      } else {
        return ApiResult(
            respone: item, httpCallBack: (a as ApiResult).httpCallBack);
      }
    }).listen((event) {
      if (event.httpCallBack.status == 200) {
        var item = (event.respone as CustomerCountRespone);

        if (item.notification.unreadCustomer + item.notification.unreadShop >
                0 ||
            item.buyOrder.cancel > 0 ||
            item.buyOrder.confirm > 0 ||
            item.buyOrder.delivered > 0 ||
            item.buyOrder.failed > 0 ||
            item.buyOrder.refund > 0 ||
            item.buyOrder.toBeRecieve > 0 ||
            item.buyOrder.unpaid > 0 ||
            item.sellOrder.unpaid > 0 ||
            item.sellOrder.refund > 0 ||
            item.sellOrder.failed > 0 ||
            item.sellOrder.delivered > 0 ||
            item.sellOrder.confirm > 0 ||
            item.sellOrder.shipping > 0 ||
            item.sellOrder.cancel > 0 ||
            item.like > 0 ||
            item.watingReview > 0 ||
            item.cartCount > 0) {
          NaiFarmLocalStorage.saveCustomerCuse(item);
        } else {
          NaiFarmLocalStorage.saveCustomerCuse(null);
        }

        emit(CustomerCountLoaded((event.respone as CustomerCountRespone)));
      } else if (event.httpCallBack.status == 401 || event.httpCallBack.status == 406) {
        NaiFarmLocalStorage.saveCustomerCuse(null);
        emit(CustomerCountError(CustomerCountRespone()));
      } else {
        NaiFarmLocalStorage.getCustomerCuse().then((value) {
          if (value != null) {
            emit(CustomerCountError(CustomerCountRespone(
                buyOrder: value.buyOrder,
                cartCount: value.cartCount,
                like: value.like,
                notification: value.notification,
                sellOrder: value.sellOrder,
                watingReview: value.watingReview,
                httpCallBack: event.httpCallBack)));
          } else {
            emit(CustomerCountError(null));
          }
        });

        //  emit(CustomerCountError(event.http_call_back.message));
      }
    });
  }

  int countCartItem({CartResponse item}) {
    int count = 0;
    NaiFarmLocalStorage.saveCartCache(item);
    for (var value in item.data) {
      count += value.items.length;
    }
    return count;
  }
}

@immutable
abstract class CustomerCountState {
  const CustomerCountState();
}

class CustomerCountInitial extends CustomerCountState {
  const CustomerCountInitial();
}

class CustomerCountLoading extends CustomerCountState {
  final CustomerCountRespone countLoaded;
  const CustomerCountLoading(this.countLoaded);
  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is CustomerCountLoading && o.countLoaded == countLoaded;
  }

  @override
  int get hashCode => countLoaded.hashCode;
}

class CustomerCountLoaded extends CustomerCountState {
  final CustomerCountRespone countLoaded;
  const CustomerCountLoaded(this.countLoaded);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is CustomerCountLoaded && o.countLoaded == countLoaded;
  }

  @override
  int get hashCode => countLoaded.hashCode;
}

class CustomerCountError extends CustomerCountState {
  final CustomerCountRespone countRespone;
  const CustomerCountError(this.countRespone);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CustomerCountError && o.countRespone == countRespone;
  }

  @override
  int get hashCode => countRespone.hashCode;
}
