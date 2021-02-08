import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:naifarm/app/bloc/Provider/CustomerCountBloc.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/AddressCreaterequest.dart';
import 'package:naifarm/app/model/pojo/request/CartRequest.dart';
import 'package:naifarm/app/model/pojo/request/OrderRequest.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/PaymentRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShippingsRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShippingsRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShippingsRespone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc {
  final AppNaiFarmApplication _application;
  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<String>();
  final onSuccess = BehaviorSubject<Object>();
  final CartList = BehaviorSubject<CartResponse>();
  final AddressList = BehaviorSubject<AddressesListRespone>();
  final PaymentList = BehaviorSubject<PaymentRespone>();

  final Shippings = BehaviorSubject<ShippingsRespone>();

  final CheckOut = BehaviorSubject<bool>();

  final shipping_cost = BehaviorSubject<int>();
  final order_total_cost = BehaviorSubject<int>();
  final total_payment = BehaviorSubject<int>();

  bool check_note_update = true;
  int check_loop = 0;

  CartBloc(this._application) {
    AddressList.add(AddressesListRespone(total: 0));
    PaymentList.add(PaymentRespone(total: 0));
  }

  final deleteData = List<CartData>();

  void dispose() {
    _compositeSubscription.clear();
  }

  GetCartlists({BuildContext context,String token, CartActive cartActive}) {
    if (cartActive == CartActive.CartList) onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.GetCartlists(token: token))
        .listen((respone) {
      //  var item = (respone.respone as CartRequest);
      if (respone.http_call_back.status == 200) {
        //   onSuccess.add(item);

        if (cartActive == CartActive.CartList) onLoad.add(false);
        CartList.add(respone.respone);
      } else {
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  DeleteCart({BuildContext context,int cartid, int inventoryId, String token}) async {
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .DeleteCart(inventoryid: inventoryId, cartid: cartid, token: token))
        .listen((respone) {
      if (respone.http_call_back.status == 200) {

        GetCartlists(token: token, cartActive: CartActive.CartDelete);
        // CartList.add(CartResponse(data: CartList.value.data));
      } else {
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  UpdateCart({CartRequest data, int cartid, String token}) async {
    // onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .UpdateCart(data: data, cartid: cartid, token: token))
        .listen((respone) {
      if (respone.http_call_back.status == 200 ||
          respone.http_call_back.status == 201) {
        //onLoad.add(false);
        // bool temp = CartList.value.selectAll;
        // CartResponse(data: CartList.value.data);
        CartList.add(CartList.value);
      } else {
        GetCartlists(token: token, cartActive: CartActive.CartDelete);
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  GetPaymentList() async {
    // onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.GetPaymentList())
        .listen((respone) {
      if (respone.http_call_back.status == 200) {
        if ((respone.respone as PaymentRespone).data.isNotEmpty) {
          (respone.respone as PaymentRespone).data[0].active = true;
        }
        PaymentList.add(respone.respone);
        //onLoad.add(false);
        // bool temp = CartList.value.selectAll;
        // CartResponse(data: CartList.value.data);
        // CartList.add(CartList.value);
      } else {
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  Future<ShippingRates> GetShippings({int shopId, int id, int index}) async {
    if (check_note_update) {
      final response = await _application.appStoreAPIRepository
          .GetShippings(shopId: shopId) as ApiResult;

      for (var i = 0;
          i < (response.respone as ShippingsRespone).data[0].rates.length;
          i++) {
        if ((response.respone as ShippingsRespone).data[0].rates[i].id == id) {
          return (response.respone as ShippingsRespone).data[0].rates[i];
        }
      }

      return (response.respone as ShippingsRespone).data[0].rates[0];
    } else {
      return CartList.value.data[index].shippingRates;
    }
  }

  GetShippingsList({int shopId}) async {
    // onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.GetShippings(shopId: shopId))
        .listen((respone) {
      (respone.respone as ShippingsRespone).data[0].rates[0].select = true;
      Shippings.add(respone.respone);
    });
    _compositeSubscription.add(subscription);
  }

  AddressesList({String token,bool type=false}) async {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(
            _application.appStoreAPIRepository.AddressesList(token: token))
        .listen((respone) {
       onLoad.add(false);
      if (respone.http_call_back.status == 200) {
        List<AddressesData> data = List<AddressesData>();
      if(type){
        if ((respone.respone as AddressesListRespone).data.isNotEmpty) {
          for (var i = 0; i < (respone.respone as AddressesListRespone).data.length; i++){
            if ((respone.respone as AddressesListRespone).data[i].addressType ==
                "Primary") {
              (respone.respone as AddressesListRespone).data[i].select = true;
              data.add((respone.respone as AddressesListRespone).data[i]);
              break;
            }
          }
        }
      }else{
        if ((respone.respone as AddressesListRespone).data.isNotEmpty) {
          for (var i = 0; i < (respone.respone as AddressesListRespone).data.length; i++){
            if ((respone.respone as AddressesListRespone).data[i].addressType ==
                "Primary") {
              (respone.respone as AddressesListRespone).data[i].select = true;
              data.add((respone.respone as AddressesListRespone).data[i]);
            }
          }
          for (var i = 0; i < (respone.respone as AddressesListRespone).data.length; i++){
            if ((respone.respone as AddressesListRespone).data[i].addressType !=
                "Primary") {
              (respone.respone as AddressesListRespone).data[i].select = false;
              data.add((respone.respone as AddressesListRespone).data[i]);
            }
          }
        }

      }
        AddressList.add(AddressesListRespone(
            data: data,
            total: data.length,
            http_call_back:
            (respone.respone as AddressesListRespone).http_call_back));

      } else {
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  void CartPositiveQuantity(
      {CartData item, int indexShop, int indexShopItem, String token}) {
    List<Items> items = new List<Items>();
    items.clear();
    for (var i = 0; i < CartList.value.data[indexShop].items.length; i++) {
      if (CartList.value.data[indexShop].items[i].inventory.id ==
          item.items[indexShopItem].inventory.id) {
        if (CartList.value.data[indexShop].items[i].quantity <
            CartList.value.data[indexShop].items[i].inventory.stockQuantity) {
          CartList.value.data[indexShop].items[i].quantity =
              CartList.value.data[indexShop].items[i].quantity++;
          CartList.add(CartList.value);
          items.add(Items(
              inventoryId: item.items[indexShopItem].inventory.id,
              quantity: item.items[indexShopItem].quantity += 1));
          UpdateCart(
              data: CartRequest(items: items, shopId: item.shopId),
              cartid: item.id,
              token: token);
        } else if (CartList.value.data[indexShop].items[i].quantity ==
            CartList.value.data[indexShop].items[i].inventory.stockQuantity) {
          items.add(Items(
              inventoryId: item.items[indexShopItem].inventory.id,
              quantity: item.items[indexShopItem].quantity += 1));
          UpdateCart(
              data: CartRequest(items: items, shopId: item.shopId),
              cartid: item.id,
              token: token);
        }
        break;
      }
    }
  }

  void CartDeleteQuantity(
      {CartData item, int indexShop, int indexShopItem, String token}) {
    List<Items> items = new List<Items>();

    for (var i = 0; i < CartList.value.data[indexShop].items.length; i++) {
      if (CartList.value.data[indexShop].items[i].inventory.id ==
              item.items[indexShopItem].inventory.id &&
          item.items[indexShopItem].quantity > 1) {
        CartList.value.data[indexShop].items[i].quantity =
            CartList.value.data[indexShop].items[i].quantity--;
        CartList.add(CartList.value);
        items.add(Items(
            inventoryId: item.items[indexShopItem].inventory.id,
            quantity: item.items[indexShopItem].quantity > 1
                ? item.items[indexShopItem].quantity -= 1
                : 1));
        UpdateCart(
            data: CartRequest(items: items, shopId: item.shopId),
            cartid: item.id,
            token: token);
        break;
      }
    }
  }

  DeleteAddress({String id, String token}) async {
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .DeleteAddress(id: id, token: token))
        .listen((respone) {
      if (respone.http_call_back.status == 200) {
        AddressesList(token: token);
      } else {
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  UpdateAddress({AddressCreaterequest data, String token}) async {
    // onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .UpdateAddress(data: data, token: token))
        .listen((respone) {
      //  onLoad.add(false);
      if (respone.http_call_back.status == 200) {
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  CreateOrder({OrderRequest orderRequest, String token}) async {
    onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application
            .appStoreAPIRepository
            .CreateOrder(orderRequest: orderRequest, token: token))
        .listen((respone) {
      if (CartList.value.data.length == check_loop) {
        onLoad.add(false);
      }

      if (respone.http_call_back.status == 200 ||
          respone.http_call_back.status == 201) {
        onSuccess.add(respone.respone);
        check_loop++;
        // bool temp = CartList.value.selectAll;
        // CartResponse(data: CartList.value.data);
        // CartList.add(CartList.value);
      } else {
        onLoad.add(false);
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }

  OrderRequest ConvertOrderData({CartData cartData, String email}) {
    PaymentData data = PaymentData();

    for (var value in PaymentList.value.data) {
      if (value.active == true) {
        data = value;
        break;
      }
    }

    List<OrderRequestItems> items = List<OrderRequestItems>();
    for (var value in cartData.items) {
      items.add(OrderRequestItems(
          quantity: value.quantity,
          inventoryId: value.inventory.id,
          unitPrice: value.unitPrice));
    }
    return OrderRequest(
        items: items,
        cartId: cartData.id,
        shopId: cartData.shopId,
        couponId: cartData.couponId,
        coupon: "",
        email: email,
        taxId: 0,
        buyerNote: cartData.note,
        shipTo: 0,
        shippingRateId: cartData.shippingRateId,
        addressId: AddressList.value.data[0].id,
        paymentMethodId: data.id,
        carrierId: cartData.carrierId,
        shippingZoneId: cartData.shippingZoneId,
        packagingId: 0);
  }

  bool CheckListOut() {
    bool check = true;
    if (AddressList.value.total==0 || PaymentList.value.total == 0) {
      check = false;
    }

    for (var i = 0; i < CartList.value.data.length; i++) {
      var item = CartList.value.data[i];
      if (item.shippingRateId == 0 || item.shippingZoneId == 0) {
        check = false;
      }
    }

    return check;
  }

  void sumTotalPayment({ShippingRates snapshot, int index}) {
    shipping_cost.add(0);
    order_total_cost.add(0);
    order_total_cost.add(0);
    shipping_cost.add(shipping_cost.value + snapshot.rate);
    for (var value in CartList.value.data) {
      order_total_cost.add(order_total_cost.value += value.total);
    }

    total_payment.add(order_total_cost.value + shipping_cost.value);

    CartList.value.data[index].shippingRates = snapshot;
    CartList.value.data[index].shippingRateId = snapshot.id;
    CartList.value.data[index].carrierId = snapshot.carrierId;
    CartList.value.data[index].shippingZoneId = snapshot.shippingZoneId;
    CheckOut.add(true);
    check_note_update = false;
  }


}

enum CartActive { CartList, CartDelete, CartUpdate }
