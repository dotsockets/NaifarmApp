

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:naifarm/app/model/api/APIProvider.dart';
import 'package:naifarm/app/model/db/DBNaiFarmRepository.dart';
import 'package:naifarm/app/model/pojo/request/AddressCreaterequest.dart';
import 'package:naifarm/app/model/pojo/request/LoginRequest.dart';
import 'package:naifarm/app/model/pojo/request/ModifyPasswordrequest.dart';
import 'package:naifarm/app/model/pojo/request/MyShopRequest.dart';
import 'package:naifarm/app/model/pojo/request/RegisterRequest.dart';
import 'package:naifarm/app/model/pojo/response/AddressesListRespone.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/Fb_Profile.dart';
import 'package:naifarm/app/model/pojo/response/ForgotRespone.dart';
import 'package:naifarm/app/model/pojo/response/LoginRespone.dart';
import 'package:naifarm/app/model/pojo/response/OTPRespone.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
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

  Future<ApiResult> ForgotPassword({ String email}){
    return _apiProvider.ForgotPasswordRequest(email);
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

  Future<ApiResult> getProduct(String page,int limit){
    return _apiProvider.getProduct(page,limit);
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











//  Observable<List<AppContent>> getTop100FreeApp(){
//    return Observable.fromFuture(_apiProvider.getTopFreeApp(TOP_100))
//        .flatMap(_convertFromEntry)
//        .flatMap((List<AppContent> list){
//      return Observable.fromFuture(_loadAndSaveTopFreeApp(list, ''));
//    });
//  }
//



}