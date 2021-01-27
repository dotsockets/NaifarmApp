

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:naifarm/app/model/api/APIProvider.dart';
import 'package:naifarm/app/model/db/DBNaiFarmRepository.dart';
import 'package:naifarm/app/model/pojo/request/AddressCreaterequest.dart';
import 'package:naifarm/app/model/pojo/request/AssetImage.dart';
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


  Future<Fb_Profile> getFBProfile({String access_token}){
    return _apiProvider.getProFileFacebook(access_token);
  }

  Future<ApiResult> CustomersLogin({LoginRequest loginRequest}){
    return _apiProvider.CustomersLogin(loginRequest);
  }

  Future<ApiResult> CustomersRegister({RegisterRequest registerRequest}){
    return _apiProvider.CustomersRegister(registerRequest);
  }

  Future<ApiResult> OTPRequest({String numberphone}){
    return _apiProvider.OtpRequest(numberphone);
  }

  Future<ApiResult> OtpVerify({ String phone,String code,String ref}){
    return _apiProvider.OtpVerify(phone,code,ref);
  }

  Future<ApiResult> ForgotPassword({ String phone,String code,String ref,String password}){
    return _apiProvider.ForgotPasswordRequest(code: code,ref: ref,phone: phone,password: password);
  }


  Future<ApiResult> ResetPasswordRequest({String email, String password,String token}){
    return _apiProvider.ResetPasswordRequest(email,password,token);
  }

  Future<ApiResult> getCustomerInfo({String token}){
    return _apiProvider.getCustomerInfo(token);
  }

  Future<ApiResult> ModifyProfile({CustomerInfoRespone data ,String token}){
    return _apiProvider.ModifyProfile(data,token);
  }

  Future<ApiResult> ModifyPassword({ModifyPasswordrequest data ,String token}){
    return _apiProvider.ModifyPassword(data,token);
  }

  Future<ApiResult> VerifyPassword({String password ,String token}){
    return _apiProvider.VerifyPassword(password,token);
  }

  Future<ApiResult> AddressesList({String token}){
    return _apiProvider.AddressesList(token);
  }

  Future<ApiResult> StatesProvice({String countries}){
    return _apiProvider.StatesProvice(countries);
  }

  Future<ApiResult> StatesCity({String countriesid, String statesId}){
    return _apiProvider.StatesCity(countriesid,statesId);
  }

  Future<ApiResult> StatesZipCode({String countries,String statesId,String cityId}){
    return _apiProvider.zipCode(countries,statesId,cityId);
  }

  Future<ApiResult> CreateAddress({AddressCreaterequest addressCreaterequest,String token}){
    return _apiProvider.CreateAddress(addressCreaterequest,token);
  }

  Future<ApiResult> DeleteAddress({String id,String token}){
    return _apiProvider.DeleteAddress(id,token);
  }

  Future<ApiResult> UpdateAddress({AddressCreaterequest data, String token}){
    return _apiProvider.UpdateAddress(data,token);
  }

  Future<ApiResult> getSliderImage(){
    return _apiProvider.getSliderImage();
  }

  Future<ApiResult> getProductPopular(String page,int limit){
    return _apiProvider.getProductPopular(page,limit

    );
  }

  Future<ApiResult> getCategoryGroup(){
    return _apiProvider.getCategoryGroup();
  }

  Future<ApiResult> getCategoriesFeatured(){
    return _apiProvider.getCategoriesFeatured();
  }

  Future<ApiResult> getProductTrending(String page,int limit){
    return _apiProvider.getProductTrending(page,limit);
  }

  Future<ApiResult> getShopProduct({int ShopId,String page,int limit}){
    return _apiProvider.getShopProduct(ShopId: ShopId,page: page,limit: limit);
  }

  Future<ApiResult> getSearch({String page, String query,int limit}){
    return _apiProvider.getSearch(page: page,query: query,limit: limit);
  }

  Future<ApiResult> CreateMyShop({String name, String slug, String description, String token}){
    return _apiProvider.CreateMyShop(name: name,slug: slug,description: description,token: token);
  }

  Future<ApiResult> getMyShopInfo({String access_token}){
    return _apiProvider.getMyShopInfo(access_token);
  }

  Future<ApiResult> MyShopUpdate({MyShopRequest data, String access_token}){
    return _apiProvider.MyShopUpdate(data: data,access_token: access_token);
  }

  Future<ApiResult> FarmMarket(){
    return _apiProvider.FarmMarket();
  }

  Future<ApiResult> MoreProduct({String page, int limit, String link}){
    return _apiProvider.MoreProduct(page: page,limit: limit,link: link);
  }

  Future<ApiResult> Flashsale({String page, int limit}){
    return _apiProvider.Flashsale(page: page,limit: limit);
  }

  Future<ApiResult> UploadImage({File imageFile,String imageableType, int imageableId, String token}){
    return _apiProvider.UploadImage(imageFile: imageFile,imageableType: imageableType,imageableId: imageableId,token: token);
  }


  Future<ApiResult> ProductsById({int id}){
    return _apiProvider.ProductsById(id: id);
  }

  Future<ApiResult> ShopById({int id}){
    return _apiProvider.ShopById(id: id);
  }


  Future<ApiResult> categoryGroupId({String page,int limit,int GroupId}){
    return _apiProvider.categoryGroupId(page: page,limit: limit,GroupId: GroupId);
  }

  Future<ApiResult> CategorySubgroup({int GroupId}){
    return _apiProvider.CategorySubgroup(GroupId: GroupId);
  }

  Future<ApiResult> GetBanners({String group}){
    return _apiProvider.GetBanners(group: group);
  }

  Future<ApiResult> GetPaymentList(){
    return _apiProvider.GetPaymentList();
  }

  Future<ApiResult> GetPaymentMyShop({String token}){
    return _apiProvider.GetPaymentMyShop(token: token);
  }


  Future<ApiResult> AddPaymentMyShop({int paymentMethodId, String token}){
    return _apiProvider.AddPaymentMyShop(paymentMethodId: paymentMethodId,token: token);
  }

  Future<ApiResult> DELETEPaymentMyShop({int paymentMethodId, String token}){
    return _apiProvider.DELETEPaymentMyShop(paymentMethodId: paymentMethodId,token: token);
  }

  Future<ApiResult> GetCarriersList(){
    return _apiProvider.GetCarriersList();
  }

  Future<ApiResult> GetShippingMyShop({String token}){
    return _apiProvider.GetShippingMyShop(token: token);
  }

  Future<ApiResult> DELETEShoppingMyShop({int ratesId,String token}){
    return _apiProvider.DELETEShoppingMyShop(ratesId: ratesId,token: token);
  }

  Future<ApiResult> AddShoppingMyShop({ShppingMyShopRequest shopRequest, String token}){
    return _apiProvider.AddShoppingMyShop(shopRequest: shopRequest,token: token);
  }

  Future<ApiResult> EditShoppingMyShop({ShppingMyShopRequest shopRequest,int rateID, String token}){
    return _apiProvider.EditShoppingMyShop(shopRequest: shopRequest,token: token,rateID: rateID);
  }

  Future<ApiResult> GetProductMyShop({String page, int limit,String token}){
    return _apiProvider.GetProductMyShop(page: page,limit: limit,token: token);
  }

  Future<ApiResult> GetWishlistsByProduct({int productID,String token}){
    return _apiProvider.GetWishlistsByProduct(productID: productID,token: token);
  }

  Future<ApiResult> DELETEWishlists({int WishId,String token}){
    return _apiProvider.DELETEWishlists(WishId: WishId,token: token);
  }

  Future<ApiResult> AddWishlists({int inventoryId,int productId,String token}){
    return _apiProvider.AddWishlists(inventoryId: inventoryId,productId: productId,token: token);
  }


  Future<ApiResult> GetMyWishlists({String token}){
    return _apiProvider.GetMyWishlists(token: token);
  }

  Future<ApiResult> GetCustomerCount({String token}){
    return _apiProvider.GetCustomerCount(token: token);
  }

  Future<ApiResult> GetCategoriesAll(){
    return _apiProvider.GetCategoriesAll();
  }

  Future<ApiResult> GetCategories(){
    return _apiProvider.GetCategories();
  }
  Future<ApiResult> AddCartlists({CartRequest cartRequest,String token}){
    return _apiProvider.AddCartlists(cartRequest: cartRequest,token: token);
  }

  Future<ApiResult> AddProductMyShop({ProductMyShopRequest shopRequest,String token}){
    return _apiProvider.AddProductMyShop(shopRequest: shopRequest,token: token);
  }
  Future<ApiResult> GetCartlists({String token}){
    return _apiProvider.GetCartlists(token: token);
  }

  Future<ApiResult> DeleteCart({int cartid,int inventoryid,String token}){
    return _apiProvider.DELETECart(cartid: cartid,inventoryid: inventoryid,token: token);
  }
  Future<ApiResult> UpdateCart({CartRequest data,int cartid, String token}){
    return _apiProvider.UpdateCart(data,cartid,token);
  }

  Future<ApiResult> UpdateProductMyShop({ProductMyShopRequest shopRequest,int productId,String token}){
    return _apiProvider.UpdateProductMyShop(shopRequest: shopRequest,productId: productId,token: token);
  }

  Future<ApiResult> DELETEProductMyShop({int ProductId, String token}){
    return _apiProvider.DELETEProductMyShop(ProductId: ProductId,token: token);
  }

  Future<ApiResult> GetProductIDMyShop({int ProductId, String token}){
    return _apiProvider.GetProductIDMyShop(productId: ProductId,token: token);
  }

  Future<ApiResult> UpdateProductInventories({InventoriesRequest inventoriesRequest, int productId, int inventoriesId, String token}){
    return _apiProvider.UpdateProductInventories(productId: productId,token: token,inventoriesId: inventoriesId,inventoriesRequest: inventoriesRequest);
  }


  Future<ApiResult> DeleteImageProduct({String imageableId, String imageableType, String path, String token}){
    return _apiProvider.DeleteImageProduct(imageableType: imageableType,imageableId: imageableId,path: path,token: token);
  }

  Future<ApiResult> GetOrder({String orderType,int page=1,int limit=20,int statusId,String token}){
    return _apiProvider.GetOrder(orderType: orderType,page: page,limit: limit,statusId: statusId,token: token);
  }

  Future<ApiResult> GetOrderById({int id,String token}){
    return _apiProvider.GetOrderById(id: id,token: token);
  }


  Future<ApiResult> getProductTypeShop({String type,int shopId,String page,int limit,String token}){
    return _apiProvider.getProductTypeShop(page: page,limit: limit,shopId: shopId,type: type,token: token);
  }

  Future<ApiResult> GetNotificationByGroup({String group, int page,String sort, int limit, String token}){
    return _apiProvider.GetNotificationByGroup(group: group,limit: limit,page: page,sort: sort ,token: token);
  }

  Future<ApiResult> CreateOrder({OrderRequest orderRequest, String token}){
    return _apiProvider.CreateOrder(orderRequest: orderRequest,token: token);
  }

  Future<ApiResult> GetShippings({int shopId}){
    return _apiProvider.GetShippings(shopId: shopId);
  }

  Future<ApiResult> MarkAsReadNotifications({String token}){
    return _apiProvider.MarkAsReadNotifications(token: token);
  }

  Future<ApiResult> getSearchMyshop({String page, String query, int shopId, int limit}){
    return _apiProvider.getSearchMyshop(page: page,query: query,shopId: shopId,limit: limit);
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