import 'dart:async';

import 'package:naifarm/app/model/core/AppNaiFarmApplication.dart';
import 'package:naifarm/app/model/pojo/request/CartRequest.dart';
import 'package:naifarm/app/model/pojo/request/OrderRequest.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/ShippingsRespone.dart';
import 'package:rxdart/rxdart.dart';

class CartBloc {

  final AppNaiFarmApplication _application;
  CompositeSubscription _compositeSubscription = CompositeSubscription();

  final onLoad = BehaviorSubject<bool>();
  final onError = BehaviorSubject<String>();
  final onSuccess = BehaviorSubject<Object>();
  final CartList = BehaviorSubject<CartResponse>();
  final AddressList = BehaviorSubject<AddressesListRespone>();
  final Shippings = BehaviorSubject<ShippingsRespone>();


  CartBloc(this._application);

  final deleteData = List<CartData>();

  void dispose() {
    _compositeSubscription.clear();
  }

  GetCartlists({String token,CartActive cartActive}){
   if(cartActive==CartActive.CartList)
      onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.GetCartlists(token: token)).listen((respone) {
    //  var item = (respone.respone as CartRequest);
      if(respone.http_call_back.status==200){
     //   onSuccess.add(item);
        if(cartActive==CartActive.CartList)
            onLoad.add(false);
        CartList.add(respone.respone);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  DeleteCart({int cartid,int inventoryId,String token}) async{
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.DeleteCart(inventoryid: inventoryId,cartid: cartid,token: token)).listen((respone) {

       if(respone.http_call_back.status==200){
         GetCartlists(token: token,cartActive: CartActive.CartDelete);
        // CartList.add(CartResponse(data: CartList.value.data));
      }else{

         onError.add(respone.http_call_back.result.error.message);
       }

    });
    _compositeSubscription.add(subscription);
  }
  UpdateCart({CartRequest data,int cartid, String token}) async{
   // onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application.appStoreAPIRepository.UpdateCart(data: data,cartid:cartid,token: token)).listen((respone) {
      if(respone.http_call_back.status==200||respone.http_call_back.status == 201){
        //onLoad.add(false);
       // bool temp = CartList.value.selectAll;
       // CartResponse(data: CartList.value.data);
        CartList.add(CartList.value);
      }else{
        GetCartlists(token: token,cartActive: CartActive.CartDelete);
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }


  CreateOrder({OrderRequest orderRequest, String token}) async{
    // onLoad.add(true);
    StreamSubscription subscription = Observable.fromFuture(_application.appStoreAPIRepository.CreateOrder(orderRequest: orderRequest,token: token)).listen((respone) {
      if(respone.http_call_back.status==200||respone.http_call_back.status == 201){
        //onLoad.add(false);
        // bool temp = CartList.value.selectAll;
        // CartResponse(data: CartList.value.data);
       // CartList.add(CartList.value);
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }
    });
    _compositeSubscription.add(subscription);
  }



  Future<ShippingsRespone> GetShippings({int shopId}) async{
    final response = await _application.appStoreAPIRepository.GetShippings(shopId: shopId) as ApiResult;
    print("ewrfvregv ${(response.respone as ShippingsRespone)}");
    return response.respone as ShippingsRespone;
  }

  AddressesList({String token}) async{
    onLoad.add(true);
    StreamSubscription subscription =
    Observable.fromFuture(_application.appStoreAPIRepository.AddressesList(token: token)).listen((respone) {
      onLoad.add(false);
      if(respone.http_call_back.status==200){
        final  data = List<AddressesData>();
        for(var i=0;i<(respone.respone as AddressesListRespone).data.length;i++)
          if((respone.respone as AddressesListRespone).data[i].addressType=="Primary")
            data.add((respone.respone as AddressesListRespone).data[i]);

        for(var i=0;i<(respone.respone as AddressesListRespone).data.length;i++)
          if((respone.respone as AddressesListRespone).data[i].addressType!="Primary")
            data.add((respone.respone as AddressesListRespone).data[i]);


        AddressList.add(AddressesListRespone(data: data,total: (respone.respone as AddressesListRespone).total,http_call_back: (respone.respone as AddressesListRespone).http_call_back));
      }else{
        onError.add(respone.http_call_back.result.error.message);
      }

    });
    _compositeSubscription.add(subscription);
  }

  void CartPositiveQuantity({CartData item, int indexShop,int indexShopItem,String token}){
    List<Items> items = new List<Items>();
    items.clear();
    for(var i =0;i<CartList.value.data[indexShop].items.length;i++){
      if(CartList.value.data[indexShop].items[i].inventory.id == item.items[indexShopItem].inventory.id){
        if(CartList.value.data[indexShop].items[i].quantity < CartList.value.data[indexShop].items[i].inventory.stockQuantity){
          CartList.value.data[indexShop].items[i].quantity = CartList.value.data[indexShop].items[i].quantity++;
          CartList.add(CartList.value);
          items.add(Items(inventoryId: item.items[indexShopItem].inventory.id,quantity: item.items[indexShopItem].quantity += 1));
          UpdateCart(data: CartRequest(items: items,shopId: item.shopId),cartid:item.id ,token: token);
        }else if(CartList.value.data[indexShop].items[i].quantity == CartList.value.data[indexShop].items[i].inventory.stockQuantity){
          items.add(Items(inventoryId: item.items[indexShopItem].inventory.id,quantity: item.items[indexShopItem].quantity += 1));
          UpdateCart(data: CartRequest(items: items,shopId: item.shopId),cartid:item.id ,token: token);
        }
        break;
      }
    }
  }

  void CartDeleteQuantity({CartData item, int indexShop,int indexShopItem,String token}){
    List<Items> items = new List<Items>();

    for(var i =0;i<CartList.value.data[indexShop].items.length;i++){
      if(CartList.value.data[indexShop].items[i].inventory.id == item.items[indexShopItem].inventory.id && item.items[indexShopItem].quantity>1){
        CartList.value.data[indexShop].items[i].quantity = CartList.value.data[indexShop].items[i].quantity--;
        CartList.add(CartList.value);
        items.add(Items(inventoryId: item.items[indexShopItem].inventory.id,quantity: item.items[indexShopItem].quantity >1 ?item.items[indexShopItem].quantity -= 1:1));
        UpdateCart(data: CartRequest(items: items,shopId: item.shopId),cartid:item.id ,token: token);
        break;
      }
    }
  }
}

enum CartActive{
  CartList,
  CartDelete,
  CartUpdate
}