

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:naifarm/app/model/api/APIProvider.dart';
import 'package:naifarm/app/model/db/DBNaiFarmRepository.dart';
import 'package:naifarm/app/model/pojo/request/AddressCreaterequest.dart';
import 'package:naifarm/app/model/pojo/request/AssetImages.dart';
import 'package:naifarm/app/model/pojo/request/CartRequest.dart';
import 'package:naifarm/app/model/pojo/request/InventoriesRequest.dart';
import 'package:naifarm/app/model/pojo/request/LoginRequest.dart';
import 'package:naifarm/app/model/pojo/request/ModifyPasswordrequest.dart';
import 'package:naifarm/app/model/pojo/request/MyShopRequest.dart';
import 'package:naifarm/app/model/pojo/request/OrderRequest.dart';
import 'package:naifarm/app/model/pojo/request/ProductMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/request/RegisterRequest.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/Fb_Profile.dart';
import 'package:naifarm/app/model/pojo/response/ForgotRespone.dart';
import 'package:naifarm/app/model/pojo/response/LoginRespone.dart';
import 'package:naifarm/app/model/pojo/response/OTPRespone.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/ShppingMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/response/VerifyRespone.dart';
import 'package:naifarm/app/model/pojo/response/RegisterRespone.dart';
import 'package:naifarm/app/model/pojo/response/Task.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/utility/http/HttpException.dart';
import 'package:naifarm/utility/log/DioLogger.dart';
import 'package:rxdart/rxdart.dart';


class APIRepository{
  static const String TAG = 'AppAPIRepository';

  APIProvider _apiProvider;
  DBBookingRepository _dbAppStoreRepository;

  APIRepository(this._apiProvider, this._dbAppStoreRepository);


  Future<ApiResult> getFBProfile(BuildContext context,{String access_token}){
    return _apiProvider.getProFileFacebook(context,access_token);
  }

  Future<ApiResult> CustomersLogin(BuildContext context,{LoginRequest loginRequest}){
    return _apiProvider.CustomersLogin(context,loginRequest);
  }

  Future<ApiResult> CheckEmail(BuildContext context,{String email}) {
    return _apiProvider.CheckEmail(context,email: email);
  }


  Future<ApiResult> CustomersLoginSocial(BuildContext context,{LoginRequest loginRequest,String provider}){
    return _apiProvider.CustomersLoginSocial(context,loginRequest,provider);
  }

  Future<ApiResult> CustomersRegister(BuildContext context,{RegisterRequest registerRequest}){
    return _apiProvider.CustomersRegister(context,registerRequest);
  }

  Future<ApiResult> OTPRequest(BuildContext context,{String numberphone}){
    return _apiProvider.OtpRequest(context,numberphone);
  }

  Future<ApiResult> OtpVerify(BuildContext context,{ String phone,String code,String ref}){
    return _apiProvider.OtpVerify(context,phone,code,ref);
  }

  Future<ApiResult> ForgotPassword(BuildContext context,{ String phone,String code,String ref,String password}){
    return _apiProvider.ForgotPasswordRequest(context,code: code,ref: ref,phone: phone,password: password);
  }


  Future<ApiResult> ResetPasswordRequest(BuildContext context,{String email, String password,String token}){
    return _apiProvider.ResetPasswordRequest(context,email,password,token);
  }

  Future<ApiResult> getCustomerInfo(BuildContext context,{String token}){
    return _apiProvider.getCustomerInfo(context,token);
  }

  Future<ApiResult> ModifyProfile(BuildContext context,{CustomerInfoRespone data ,String token}){
    return _apiProvider.ModifyProfile(context,data,token);
  }

  Future<ApiResult> ModifyPassword(BuildContext context,{ModifyPasswordrequest data ,String token}){
    return _apiProvider.ModifyPassword(context,data,token);
  }

  Future<ApiResult> VerifyPassword(BuildContext context,{String password ,String token}){
    return _apiProvider.VerifyPassword(context,password,token);
  }

  Future<ApiResult> AddressesList(BuildContext context,{String token}){
    return _apiProvider.AddressesList(context,token);
  }

  Future<ApiResult> StatesProvice(BuildContext context,{String countries}){
    return _apiProvider.StatesProvice(context,countries);
  }

  Future<ApiResult> StatesCity(BuildContext context,{String countriesid, String statesId}){
    return _apiProvider.StatesCity(context,countriesid,statesId);
  }

  Future<ApiResult> StatesZipCode(BuildContext context,{String countries,String statesId,String cityId}){
    return _apiProvider.zipCode(context,countries,statesId,cityId);
  }

  Future<ApiResult> CreateAddress(BuildContext context,{AddressCreaterequest addressCreaterequest,String token}){
    return _apiProvider.CreateAddress(context,addressCreaterequest,token);
  }

  Future<ApiResult> DeleteAddress(BuildContext context,{String id,String token}){
    return _apiProvider.DeleteAddress(context,id,token);
  }

  Future<ApiResult> UpdateAddress(BuildContext context,{AddressCreaterequest data, String token}){
    return _apiProvider.UpdateAddress(context,data,token);
  }

  Future<ApiResult> getSliderImage(BuildContext context,){
    return _apiProvider.getSliderImage(context,);
  }

  Future<ApiResult> getProductPopular(BuildContext context,String page,int limit){
    return _apiProvider.getProductPopular(context,page,limit

    );
  }

  Future<ApiResult> getCategoryGroup(BuildContext context,){
    return _apiProvider.getCategoryGroup(context,);
  }

  Future<ApiResult> getCategoriesFeatured(BuildContext context,){
    return _apiProvider.getCategoriesFeatured(context,);
  }

  Future<ApiResult> getProductTrending(BuildContext context,String page,int limit){
    return _apiProvider.getProductTrending(context,page,limit);
  }

  Future<ApiResult> getShopProduct(BuildContext context,{int ShopId,String page,int limit}){
    return _apiProvider.getShopProduct(context,ShopId: ShopId,page: page,limit: limit);
  }

  Future<ApiResult> getSearch(BuildContext context,{String page, String query,int limit}){
    return _apiProvider.getSearch(context,page: page,query: query,limit: limit);
  }

  Future<ApiResult> CreateMyShop(BuildContext context,{String name, String slug, String description, String token}){
    return _apiProvider.CreateMyShop(context,name: name,slug: slug,description: description,token: token);
  }

  Future<ApiResult> getMyShopInfo(BuildContext context,{String access_token}){
    return _apiProvider.getMyShopInfo(context,access_token);
  }

  Future<ApiResult> MyShopUpdate({BuildContext context,MyShopRequest data, String access_token}){
    return _apiProvider.MyShopUpdate(context,data: data,access_token: access_token);
  }

  Future<ApiResult> FarmMarket(BuildContext context,){
    return _apiProvider.FarmMarket(context,);
  }

  Future<ApiResult> MoreProduct(BuildContext context,{String page, int limit, String link}){
    return _apiProvider.MoreProduct(context,page: page,limit: limit,link: link);
  }

  Future<ApiResult> Flashsale(BuildContext context,{String page, int limit}){
    return _apiProvider.Flashsale(context,page: page,limit: limit);
  }

  Future<ApiResult> UploadImage(BuildContext context,{File imageFile,String imageableType, int imageableId, String token}){
    return _apiProvider.UploadImage(context,imageFile: imageFile,imageableType: imageableType,imageableId: imageableId,token: token);
  }


  Future<ApiResult> ProductsById(BuildContext context,{int id}){
    return _apiProvider.ProductsById(context,id: id);
  }

  Future<ApiResult> ShopById(BuildContext context,{int id}){
    return _apiProvider.ShopById(context,id: id);
  }


  Future<ApiResult> categoryGroupId(BuildContext context,{String page,int limit,int GroupId}){
    return _apiProvider.categoryGroupId(context,page: page,limit: limit,GroupId: GroupId);
  }

  Future<ApiResult> CategorySubgroup(BuildContext context,{int GroupId}){
    return _apiProvider.CategorySubgroup(context,GroupId: GroupId);
  }

  Future<ApiResult> GetBanners(BuildContext context,{String group}){
    return _apiProvider.GetBanners(context,group: group);
  }

  Future<ApiResult> GetPaymentList(BuildContext context,){
    return _apiProvider.GetPaymentList(context,);
  }

  Future<ApiResult> GetPaymentMyShop(BuildContext context,{String token}){
    return _apiProvider.GetPaymentMyShop(context,token: token);
  }


  Future<ApiResult> AddPaymentMyShop(BuildContext context,{int paymentMethodId, String token}){
    return _apiProvider.AddPaymentMyShop(context,paymentMethodId: paymentMethodId,token: token);
  }

  Future<ApiResult> DELETEPaymentMyShop(BuildContext context,{int paymentMethodId, String token}){
    return _apiProvider.DELETEPaymentMyShop(context,paymentMethodId: paymentMethodId,token: token);
  }

  Future<ApiResult> GetCarriersList(BuildContext context,){
    return _apiProvider.GetCarriersList(context,);
  }

  Future<ApiResult> GetShippingMyShop(BuildContext context,{String token}){
    return _apiProvider.GetShippingMyShop(context,token: token);
  }

  Future<ApiResult> DELETEShoppingMyShop(BuildContext context,{int ratesId,String token}){
    return _apiProvider.DELETEShoppingMyShop(context,ratesId: ratesId,token: token);
  }

  Future<ApiResult> AddShoppingMyShop(BuildContext context,{ShppingMyShopRequest shopRequest, String token}){
    return _apiProvider.AddShoppingMyShop(context,shopRequest: shopRequest,token: token);
  }

  Future<ApiResult> EditShoppingMyShop(BuildContext context,{ShppingMyShopRequest shopRequest,int rateID, String token}){
    return _apiProvider.EditShoppingMyShop(context,shopRequest: shopRequest,token: token,rateID: rateID);
  }

  Future<ApiResult> GetProductMyShop(BuildContext context,{String page, int limit,String token,String filter}){
    return _apiProvider.GetProductMyShop(context,page: page,limit: limit,token: token,filter: filter);
  }

  Future<ApiResult> GetWishlistsByProduct(BuildContext context,{int productID,String token}){
    return _apiProvider.GetWishlistsByProduct(context,productID: productID,token: token);
  }

  Future<ApiResult> DELETEWishlists(BuildContext context,{int WishId,String token}){
    return _apiProvider.DELETEWishlists(context,WishId: WishId,token: token);
  }

  Future<ApiResult> AddWishlists(BuildContext context,{int inventoryId,int productId,String token}){
    return _apiProvider.AddWishlists(context,inventoryId: inventoryId,productId: productId,token: token);
  }


  Future<ApiResult> GetMyWishlists(BuildContext context,{String token}){
    return _apiProvider.GetMyWishlists(context,token: token);
  }

  Future<ApiResult> GetCustomerCount(BuildContext context,{String token}){
    return _apiProvider.GetCustomerCount(context,token: token);
  }

  Future<ApiResult> GetCategoriesAll(BuildContext context,){
    return _apiProvider.GetCategoriesAll(context,);
  }

  Future<ApiResult> GetCategories(BuildContext context,){
    return _apiProvider.GetCategories(context,);
  }
  Future<ApiResult> AddCartlists(BuildContext context,{CartRequest cartRequest,String token}){
    return _apiProvider.AddCartlists(context,cartRequest: cartRequest,token: token);
  }

  Future<ApiResult> AddProductMyShop(BuildContext context,{ProductMyShopRequest shopRequest,String token}){
    return _apiProvider.AddProductMyShop(context,shopRequest: shopRequest,token: token);
  }
  Future<ApiResult> GetCartlists(BuildContext context,{String token}){
    return _apiProvider.GetCartlists(context,token: token);
  }

  Future<ApiResult> DeleteCart(BuildContext context,{int cartid,int inventoryid,String token}){
    return _apiProvider.DELETECart(context,cartid: cartid,inventoryid: inventoryid,token: token);
  }
  Future<ApiResult> UpdateCart(BuildContext context,{CartRequest data,int cartid, String token}){
    return _apiProvider.UpdateCart(context,data,cartid,token);
  }

  Future<ApiResult> UpdateProductMyShop(BuildContext context,{ProductMyShopRequest shopRequest,int productId,String token}){
    return _apiProvider.UpdateProductMyShop(context,shopRequest: shopRequest,productId: productId,token: token);
  }

  Future<ApiResult> DELETEProductMyShop(BuildContext context,{int ProductId, String token}){
    return _apiProvider.DELETEProductMyShop(context,ProductId: ProductId,token: token);
  }

  Future<ApiResult> GetProductIDMyShop(BuildContext context,{int ProductId, String token}){
    return _apiProvider.GetProductIDMyShop(context,productId: ProductId,token: token);
  }

  Future<ApiResult> UpdateProductInventories(BuildContext context,{InventoriesRequest inventoriesRequest, int productId, int inventoriesId, String token}){
    return _apiProvider.UpdateProductInventories(context,productId: productId,token: token,inventoriesId: inventoriesId,inventoriesRequest: inventoriesRequest);
  }


  Future<ApiResult> DeleteImageProduct(BuildContext context,{String imageableId, String imageableType, String path, String token}){
    return _apiProvider.DeleteImageProduct(context,imageableType: imageableType,imageableId: imageableId,path: path,token: token);
  }

  Future<ApiResult> GetOrder(BuildContext context,{String orderType,int page=1,int limit=20,String statusId,String token,String sort}){
    return _apiProvider.GetOrder(context,orderType: orderType,page: page,limit: limit,statusId: statusId,token: token,sort: sort);
  }

  Future<ApiResult> GetOrderById(BuildContext context,{int id,String orderType,String token}){
    return _apiProvider.GetOrderById(context,id: id,orderType: orderType,token: token);
  }


  Future<ApiResult> getProductTypeShop(BuildContext context,{String type,int shopId,String page,int limit,String token}){
    return _apiProvider.getProductTypeShop(context,page: page,limit: limit,shopId: shopId,type: type,token: token);
  }

  Future<ApiResult> GetNotificationByGroup(BuildContext context,{String group, int page,String sort, int limit, String token}){
    return _apiProvider.GetNotificationByGroup(context,group: group,limit: limit,page: page,sort: sort ,token: token);
  }

  Future<ApiResult> CreateOrder(BuildContext context,{OrderRequest orderRequest, String token}){
    return _apiProvider.CreateOrder(context,orderRequest: orderRequest,token: token);
  }

  Future<ApiResult> GetShippings(BuildContext context,{int shopId}){
    return _apiProvider.GetShippings(context,shopId: shopId);
  }

  Future<ApiResult> MarkAsReadNotifications(BuildContext context,{String token}){
    return _apiProvider.MarkAsReadNotifications(context,token: token);
  }

  Future<ApiResult> getSearchProduct(BuildContext context,{String page, String query, int shopId, int limit}){
    return _apiProvider.getSearchProduct(context,page: page,query: query,shopId: shopId,limit: limit);
  }

  Future<ApiResult> getMyShopAttribute(BuildContext context,{String token}){
    return _apiProvider.getMyShopAttribute(context,token);
  }
  Future<ApiResult> addMyShopAttribute(BuildContext context,{String name, String token}){
    return _apiProvider.addMyShopAttribute(context,name:name,token: token);
  }

  Future<ApiResult> deleteMyShopAttribute(BuildContext context,{int id, String token}){
    return _apiProvider.deleteMyShopAttribute(context,id:id,token: token);
  }

  Future<ApiResult> getAttributeDetail(BuildContext context,{String token,int id}){
    return _apiProvider.getAttributeDetail(context,id,token);
  }

  Future<ApiResult> updateAttribute(BuildContext context,{String name,String token,int id}){
    return _apiProvider.updateAttribute(context,name,id,token);
  }

  Future<ApiResult> addAttributeDetail(BuildContext context,{String value,String color,int id,String token}){
    return _apiProvider.addAttributeDetail(context,token: token,id: id,color: color,value: value);
  }

  Future<ApiResult> updateAttributeDetail(BuildContext context,{ String value,String color,int id,int vid,String token,}){
    return _apiProvider.updateAttributeDetail(context,color: color,value: value,id: id,token: token,vid: vid);
  }

  Future<ApiResult> deleteAttributeDetail(BuildContext context,{int id,int vid, String token}){
    return _apiProvider.deleteAttributeDetail(context,id:id,token: token,vid: vid);
  }
  Future<ApiResult> GetCategoryByShop(BuildContext context,{int CategoryId, String token}){
    return _apiProvider.GetCategoryByShop(context,CategoryId:CategoryId,token: token);
  }

  Future<ApiResult> getInformationRules(BuildContext context,String slug){
    return _apiProvider.getInformationRules(context,slug);
  }

  Future<ApiResult> requestChangEmail(BuildContext context,{String email, String token}){
    return _apiProvider.requestChangEmail(context,email: email,token: token);
  }

  Future<ApiResult> updateinventories(BuildContext context,{int productsId, int inventoriesId,int shippingWeight, String token}){
    return _apiProvider.updateinventories(context,productsId: productsId,inventoriesId: inventoriesId,shippingWeight: shippingWeight,token: token);
  }

  Future<ApiResult> MarkPaid(BuildContext context,{int OrderId, String token}){
    return _apiProvider.MarkPaid(context,orderId: OrderId,token: token);
  }

  Future<ApiResult> checkPhone(BuildContext context,{String phone}){
    return _apiProvider.checkPhone(context,phone: phone);
  }

  Future<ApiResult> AddTracking(BuildContext context,{String trackingId, String token,int OrderId}){
    return _apiProvider.AddTracking(context,trackingId: trackingId,token:  token,OrderId: OrderId);
  }

  Future<ApiResult> GoodsReceived(BuildContext context,{ String token,int OrderId}){
    return _apiProvider.GoodsReceived(context,token:  token,OrderId: OrderId);
  }


  Future<ApiResult> OrderCancel(BuildContext context,{ String token,int OrderId}){
    return _apiProvider.OrderCancel(context,token:  token,OrderId: OrderId);
  }

  Future<ApiResult> getSearchShop(BuildContext context,{ String page, String query,int limit,int shopId,String filter,String token}){
    return _apiProvider.getSearchShop(context: context,filter: filter,shopId: shopId,page: page,limit: limit,query: query,token: token);
  }





//  Observable<List<AppContent>> getTop100FreeApp(){
//    return Observable.fromFuture(_apiProvider.getTopFreeApp(TOP_100))
//        .flatMap(_convertFromEntry)
//        .flatMap((List<AppContent> list){
//      return Observable.fromFuture(_loadAndSaveTopFreeApp(list, ''));
//    });
//  }
//



}