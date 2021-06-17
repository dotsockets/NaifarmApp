import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/request/AddressCreaterequest.dart';
import 'package:naifarm/app/model/pojo/request/CartRequest.dart';
import 'package:naifarm/app/model/pojo/request/OrderRequest.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/CouponResponse.dart';
import 'package:naifarm/app/model/pojo/response/PaymentRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShippingsRespone.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:rxdart/rxdart.dart';

class CartBloc {
  final AppNaiFarmApplication _application;
  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<ThrowIfNoSuccess>();
  final onSuccess = BehaviorSubject<Object>();
  final cartList = BehaviorSubject<CartResponse>();
  final addressList = BehaviorSubject<AddressesListRespone>();
  final paymentList = BehaviorSubject<PaymentRespone>();
  final shippings = BehaviorSubject<ShippingsRespone>();
  final checkOut = BehaviorSubject<bool>();
  final shippingCost = BehaviorSubject<int>();
  final orderTotalCost = BehaviorSubject<int>();
  final totalPayment = BehaviorSubject<int>();
  final couponList = BehaviorSubject<CouponResponse>();
  bool checkNoteUpdate = true;
  int checkLoop = 0;

  CartBloc(this._application) {
    addressList.add(AddressesListRespone(total: 0));
    paymentList.add(PaymentRespone(total: 0));
  }

  final deleteData = [];

  void dispose() {
    _compositeSubscription.clear();
    cartList.close();
    shippings.close();
    checkOut.close();
    shippingCost.close();
    orderTotalCost.close();
    totalPayment.close();
    couponList.close();
  }

  getCartlists(
      {BuildContext context,
      String token,
      CartActive cartActive,
      List<ProductData> cartNowId}) {
    if (cartActive == CartActive.CartList) onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .getCartlists(context, token: token))
        .listen((respone) {
      //  var item = (respone.respone as CartRequest);
      if (respone.httpCallBack.status == 200) {
        //   onSuccess.add(item);

        if (cartActive == CartActive.CartList ||
            cartActive == CartActive.CartDelete) onLoad.add(false);
        var item = (respone.respone as CartResponse);

        if (cartNowId != null && cartNowId.isNotEmpty) {
          for (var value in item.data[0].items) {
            for (var cart_select in cartNowId) {
              //  print("wefcwecde ${value.inventory.id}  ${cart_select.id}  ${value.select}");
              if (value.inventory.id == cart_select.id) {
                value.select = true;
                // break;
              }
            }
          }
        }

        cartList.add(
            CartResponse(data: item.data, total: item.total, selectAll: false));
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  deleteCart(
      {BuildContext context, int cartid, int inventoryId, String token}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.deleteCart(context,
                inventoryid: inventoryId, cartid: cartid, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        getCartlists(
            context: context, token: token, cartActive: CartActive.CartDelete);
        onSuccess.add(true);
        // CartList.add(CartResponse(data: CartList.value.data));
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  updateCart(BuildContext context,
      {CartRequest data, int cartid, String token}) async {
    // onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .updateCart(context, data: data, cartid: cartid, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200 ||
          respone.httpCallBack.status == 201) {
        //onLoad.add(false);
        // bool temp = CartList.value.selectAll;
        // CartResponse(data: CartList.value.data);
        cartList.add(cartList.value);
      } else {
        getCartlists(
            context: context, token: token, cartActive: CartActive.CartDelete);
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  getPaymentList(BuildContext context, {String shopIds}) async {
    // onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .getPaymentList(context, shopIds: shopIds ?? ""))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        if ((respone.respone as PaymentRespone).data.isNotEmpty) {
          (respone.respone as PaymentRespone).data[0].active = true;
        }
        paymentList.add(respone.respone);
        //onLoad.add(false);
        // bool temp = CartList.value.selectAll;
        // CartResponse(data: CartList.value.data);
        // CartList.add(CartList.value);
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  String getAllShopID() {
    String id = "";
    int i = 0;
    for (var item in cartList.value.data) {
      if ((i + 1) == cartList.value.data.length) {
        id += "${item.shopId}";
      } else {
        id += "${item.shopId},";
      }
      i++;
    }
    return id;
  }

  Future<ShippingRates> getShippings(BuildContext context,
      {int shopId, int id, int index}) async {
    if (checkNoteUpdate) {
      final response = await _application.appStoreAPIRepository
          .getShippings(context, shopId: shopId);

      for (var i = 0;
          i < (response.respone as ShippingsRespone).data[0].rates.length;
          i++) {
        if ((response.respone as ShippingsRespone).data[0].rates[i].id == id) {
          return (response.respone as ShippingsRespone).data[0].rates[i];
        }
      }

      return (response.respone as ShippingsRespone).data[0].rates[0];
    } else {
      return cartList.value.data[index].shippingRates;
    }
  }

  getShippingsList(BuildContext context, {int shopId}) async {
    // onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .getShippings(context, shopId: shopId))
        .listen((respone) {
      (respone.respone as ShippingsRespone).data[0].rates[0].select = true;
      shippings.add(respone.respone);
    });
    _compositeSubscription.add(subscription);
  }

  addressesList(BuildContext context, {String token, bool type = false}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .addressesList(context, token: token))
        .listen((respone) {
      onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        List<AddressesData> data = <AddressesData>[];
        if (type) {
          if ((respone.respone as AddressesListRespone).data.isNotEmpty) {
            for (var i = 0;
                i < (respone.respone as AddressesListRespone).data.length;
                i++) {
              if ((respone.respone as AddressesListRespone)
                      .data[i]
                      .addressType ==
                  "Primary") {
                (respone.respone as AddressesListRespone).data[i].select = true;
                data.add((respone.respone as AddressesListRespone).data[i]);
                break;
              }
            }
          }
        } else {
          if ((respone.respone as AddressesListRespone).data.isNotEmpty) {
            for (var i = 0;
                i < (respone.respone as AddressesListRespone).data.length;
                i++) {
              if ((respone.respone as AddressesListRespone)
                      .data[i]
                      .addressType ==
                  "Primary") {
                (respone.respone as AddressesListRespone).data[i].select = true;
                data.add((respone.respone as AddressesListRespone).data[i]);
              }
            }
            for (var i = 0;
                i < (respone.respone as AddressesListRespone).data.length;
                i++) {
              if ((respone.respone as AddressesListRespone)
                      .data[i]
                      .addressType !=
                  "Primary") {
                (respone.respone as AddressesListRespone).data[i].select =
                    false;
                data.add((respone.respone as AddressesListRespone).data[i]);
              }
            }
          }
        }
        addressList.add(AddressesListRespone(
            data: data,
            total: data.length,
            httpCallBack:
                (respone.respone as AddressesListRespone).httpCallBack));
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  void cartPositiveQuantity(BuildContext context,
      {CartData item, int indexShop, int indexShopItem, String token}) {
    List<Items> items = <Items>[];
    items.clear();
    for (var i = 0; i < cartList.value.data[indexShop].items.length; i++) {
      if (cartList.value.data[indexShop].items[i].inventory.id ==
          item.items[indexShopItem].inventory.id) {
        if (cartList.value.data[indexShop].items[i].quantity <
            cartList.value.data[indexShop].items[i].inventory.stockQuantity) {
          cartList.value.data[indexShop].items[i].quantity =
              cartList.value.data[indexShop].items[i].quantity++;
          cartList.add(cartList.value);
          items.add(Items(
              inventoryId: item.items[indexShopItem].inventory.id,
              quantity: item.items[indexShopItem].quantity += 1));
          updateCart(context,
              data: CartRequest(items: items, shopId: item.shopId),
              cartid: item.id,
              token: token);
        } else if (cartList.value.data[indexShop].items[i].quantity ==
            cartList.value.data[indexShop].items[i].inventory.stockQuantity) {
          items.add(Items(
              inventoryId: item.items[indexShopItem].inventory.id,
              quantity: item.items[indexShopItem].quantity += 1));
          updateCart(context,
              data: CartRequest(items: items, shopId: item.shopId),
              cartid: item.id,
              token: token);
        }
        break;
      }
    }
  }

  void cartDeleteQuantity(BuildContext context,
      {CartData item, int indexShop, int indexShopItem, String token}) {
    List<Items> items = <Items>[];

    for (var i = 0; i < cartList.value.data[indexShop].items.length; i++) {
      if (cartList.value.data[indexShop].items[i].inventory.id ==
              item.items[indexShopItem].inventory.id &&
          item.items[indexShopItem].quantity > 1) {
        cartList.value.data[indexShop].items[i].quantity =
            cartList.value.data[indexShop].items[i].quantity--;
        cartList.add(cartList.value);
        items.add(Items(
            inventoryId: item.items[indexShopItem].inventory.id,
            quantity: item.items[indexShopItem].quantity > 1
                ? item.items[indexShopItem].quantity -= 1
                : 1));
        updateCart(context,
            data: CartRequest(items: items, shopId: item.shopId),
            cartid: item.id,
            token: token);
        break;
      }
    }
  }

  deleteAddress(BuildContext context, {String id, String token}) async {
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .deleteAddress(context, id: id, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        addressesList(context, token: token);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  updateAddress(BuildContext context,
      {AddressCreaterequest data, String token}) async {
    // onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .updateAddress(context, data: data, token: token))
        .listen((respone) {
      //  onLoad.add(false);
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(respone.respone);
      } else {
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  createOrder(BuildContext context,
      {OrderRequest orderRequest, String token}) async {
    // onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .createOrder(context, orderRequest: orderRequest, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200 ||
          respone.httpCallBack.status == 201) {
        checkLoop++;
        // bool temp = CartList.value.selectAll;
        // CartResponse(data: CartList.value.data);
        // CartList.add(CartList.value);
        if (cartList.value.data.length == checkLoop) {
          onLoad.add(false);
          onSuccess.add(respone.respone);
        }
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  OrderRequest convertOrderData(BuildContext context,
      {CartData cartData, String email}) {
    PaymentData data = PaymentData();

    for (var value in paymentList.value.data) {
      if (value.active == true) {
        data = value;
        break;
      }
    }

    List<OrderRequestItems> items = <OrderRequestItems>[];
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
        addressId: addressList.value.data[0].id,
        paymentMethodId: data.id,
        carrierId: cartData.carrierId,
        shippingZoneId: cartData.shippingZoneId,
        packagingId: 0);
  }

  bool checkListOut() {
    bool check = true;
    if (addressList.value.total == 0 || paymentList.value.total == 0) {
      check = false;
    }

    for (var i = 0; i < cartList.value.data.length; i++) {
      var item = cartList.value.data[i];
      if (item.shippingRateId == 0 || item.shippingZoneId == 0) {
        check = false;
      }
    }

    return check;
  }

  void sumTotalPayment(BuildContext context,
      {ShippingRates snapshot, int index}) {
    // shipping_cost.add(0);
    orderTotalCost.add(0);
    totalPayment.add(0);

    //shipping_cost.add(shipping_cost.value+snapshot.rate);

    for (var item in cartList.value.data) {
      if (item.id == cartList.value.data[index].id) {
        if (item.shippingRates != null) {
          // print("serwfer  ${(shipping_cost.value-item.shippingRates.rate)} ${snapshot.rate}");
          shippingCost.add(
              (shippingCost.value - item.shippingRates.rate) + snapshot.rate);
        } else {
          shippingCost.add(shippingCost.value + snapshot.rate);
        }
      }
      orderTotalCost.add(orderTotalCost.value += item.total);
    }

    totalPayment.add(orderTotalCost.value + shippingCost.value);

    // order_total_cost.add(order_total_cost.value += item.total);
    cartList.value.data[index].shippingRates = snapshot;
    cartList.value.data[index].shippingRateId = snapshot.id;
    cartList.value.data[index].carrierId = snapshot.carrierId;
    cartList.value.data[index].shippingZoneId = snapshot.shippingZoneId;
    checkOut.add(true);
    checkNoteUpdate = false;
  }

  getCouponlists({BuildContext context, String token}) {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .getCouponLists(context, token: token))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        var item = (respone.respone as CouponResponse);
        couponList.add(CouponResponse(
            data: item.data,
            total: item.total,
            page: item.page,
            limit: item.limit));
        onLoad.add(false);
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  addCoupon({BuildContext context, String token, CouponData addData}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .addCoupon(context, token: token, addData: addData))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        var item = (respone.respone as CouponResponse);
        onSuccess.add(item);
        onLoad.add(false);
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  updateCoupon(
      {BuildContext context, String token, CouponData updateData}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .updateCoupon(context, token: token, updateData: updateData))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        var item = (respone.respone as CouponResponse);
        onSuccess.add(item);
        onLoad.add(false);
      } else {
        onLoad.add(false);
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  deleteCoupon(BuildContext context, {String token, int couponId}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .deleteCoupon(context, token: token, couponId: couponId))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(true);
        onLoad.add(false);
      } else {
        onError.add(respone.httpCallBack);
        onLoad.add(false);
      }
    });
    _compositeSubscription.add(subscription);
  }

  applyCoupon(
      {BuildContext context,
      String token,
      int cartId,
      CouponData coupon}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(
            _application.appStoreAPIRepository.applyCoupon(context,
                token: token, cartId: cartId, couponCode: coupon.code))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        var item = (respone.respone as CartResponse);
        if (item.data.length > 0) {
          for (var cart in item.data) {
            cart.coupon = Coupon(
              id: coupon.id,
              code: coupon.code,
              name: coupon.name,
              value: coupon.value,
              description: coupon.description,
            );
          }
        }
        onSuccess.add(item);
        onLoad.add(false);
      } else {
        onLoad.add(false);
        respone.httpCallBack.code = 99;
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }

  deleteCartCoupon({BuildContext context, String token, int cartId}) async {
    onLoad.add(true);
    StreamSubscription subscription = Stream.fromFuture(_application
            .appStoreAPIRepository
            .deleteCartCoupon(context, token: token, cartId: cartId))
        .listen((respone) {
      if (respone.httpCallBack.status == 200) {
        onSuccess.add(cartId);
        onLoad.add(false);
      } else {
        onLoad.add(false);
        respone.httpCallBack.code = 99;
        onError.add(respone.httpCallBack);
      }
    });
    _compositeSubscription.add(subscription);
  }
}

enum CartActive { CartList, CartDelete, CartUpdate }
