

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
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
import 'package:naifarm/app/model/pojo/response/BannersRespone.dart';
import 'package:naifarm/app/model/pojo/response/CarriersRespone.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/CategoriesAllRespone.dart';
import 'package:naifarm/app/model/pojo/response/CategoriesRespone.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/Fb_Profile.dart';
import 'package:naifarm/app/model/pojo/response/FlashsaleRespone.dart';
import 'package:naifarm/app/model/pojo/response/ForgotRespone.dart';
import 'package:naifarm/app/model/pojo/response/ImageUploadRespone.dart';
import 'package:naifarm/app/model/pojo/response/InformationResponce.dart';
import 'package:naifarm/app/model/pojo/response/LoginRespone.dart';
import 'package:naifarm/app/model/pojo/response/MyShopAttributeRespone.dart';
import 'package:naifarm/app/model/pojo/response/MyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/NotiRespone.dart';
import 'package:naifarm/app/model/pojo/response/OTPRespone.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/OrderRespone.dart';
import 'package:naifarm/app/model/pojo/response/PaymenMyshopRespone.dart';
import 'package:naifarm/app/model/pojo/response/PaymentRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopListRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductRespone.dart';
import 'package:naifarm/app/model/pojo/response/SearchRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShippingsRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShppingMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/response/ShppingMyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/SliderRespone.dart';
import 'package:naifarm/app/model/pojo/response/StatesRespone.dart';
import 'package:naifarm/app/model/pojo/response/VerifyRespone.dart';
import 'package:naifarm/app/model/pojo/response/RegisterRespone.dart';
import 'package:naifarm/app/model/pojo/response/Task.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:naifarm/app/model/pojo/response/WishlistsRespone.dart';
import 'package:naifarm/utility/http/HttpException.dart';
import 'package:naifarm/app/model/pojo/response/zipCodeRespone.dart';
import 'package:naifarm/utility/http/ServerError.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:convert';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
part '_APIProvider.dart';

abstract class APIProvider{
  factory APIProvider(Dio dio, {String baseUrl}) = _APIProvider;



  @GET("/tasks/{id}")
  Future<ApiResult> getProFileFacebook(@Query("access_token") String access_token);

  @POST("/v1/customers/login")
  Future<ApiResult> CustomersLogin(@Body() LoginRequest loginRequest);

  @POST("/v1/customers/login-social")
  Future<ApiResult> CustomersLoginSocial(@Body() LoginRequest loginRequest);

  @POST("/v1/customers/check-email")
  Future<ApiResult> CheckEmail({String email});

  @POST("/v1/customers/register")
  Future<ApiResult> CustomersRegister(@Body() RegisterRequest registerRequest);

  @POST("/v1/otp/request")
  @FormUrlEncoded()
  Future<ApiResult> OtpRequest(@Field() String numbephone);

  @POST("/v1/otp/verify")
  @FormUrlEncoded()
  Future<ApiResult> OtpVerify(@Field() String phone,@Field() String code,@Field() String ref);

  @POST("/v1/customers/v1/customers/forgot-password-phone")
  Future<ApiResult> ForgotPasswordRequest({@Field() String phone,@Field() String code,@Field() String ref,@Field() String password});

  @POST("/v1/customers/reset-password")
  @FormUrlEncoded()
  Future<ApiResult> ResetPasswordRequest(@Field() String email,@Field() String password,@Field() String token);

  @GET("/v1/customers/info")
  Future<ApiResult> getCustomerInfo(String access_token);

  @PATCH("/v1/customers/modify-profile")
  Future<ApiResult> ModifyProfile(@Body() CustomerInfoRespone data,String access_token);

  @PATCH("/v1/customers/modify-password")
  Future<ApiResult> ModifyPassword(@Body() ModifyPasswordrequest data,String access_token);

  @POST("/v1/customers/verify-password")
  @FormUrlEncoded()
  Future<ApiResult> VerifyPassword(@Field() String password,String token);

  @GET("/v1/addresses")
  Future<ApiResult> AddressesList(String token);

  @GET("/v1/countries/1/states")
  Future<ApiResult> StatesProvice(String countries);

  @GET("/v1/countries/1/states/1/cities")
  Future<ApiResult> StatesCity(String countriesid,String statesId);

  @GET("/v1/countries/1/states/1/cities")
  Future<ApiResult> zipCode(String countries,String statesId,String cityId);

  @POST("/v1/addresses")
  Future<ApiResult> CreateAddress(@Body() AddressCreaterequest addressCreaterequest,String token);

  @DELETE("/v1/addresses")
  @FormUrlEncoded()
  Future<ApiResult> DeleteAddress(String id,String token);

  @PATCH("/v1/addresses")
  Future<ApiResult> UpdateAddress(@Body() AddressCreaterequest data,String access_token);


  @GET("/v1/sliders")
  Future<ApiResult> getSliderImage();

  @GET("/v1/products/types/popular?limit=9&page=1")
  Future<ApiResult> getProductPopular(String page,int limit);

  @GET("/v1/shop/1/products?limit=20&page=1")
  Future<ApiResult> getShopProduct({int ShopId,String page,int limit});

  @GET("/v1/category-group")
  Future<ApiResult> getCategoryGroup();

  @GET("/v1/categories/featured")
  Future<ApiResult> getCategoriesFeatured();

  @GET("/v1/products/types/trending?limit=6&page=1")
  Future<ApiResult> getProductTrending(String page,int limit);

  @GET("/v1/search/products?q=s&limit=10&page=1")
  Future<ApiResult> getSearch({String page, String query,int limit});

  @POST("/v1/customers/myshop")
  @FormUrlEncoded()
  Future<ApiResult> CreateMyShop({@Field() String name,@Field() String slug,@Field() String description,@Field() String token});

  @GET("/v1/myshop/shop")
  Future<ApiResult> getMyShopInfo(String access_token);

  @PATCH("/v1/myshop/shop")
  Future<ApiResult> MyShopUpdate({@Body() MyShopRequest data,String access_token});

  @GET("/v1/myshop/shop")
  Future<ApiResult> FarmMarket();



  Future<ApiResult> MoreProduct({String page, int limit, String link});

  @GET("/v1/flashsale?limit=20&page=1")
  Future<ApiResult> Flashsale({String page, int limit});

  @POST("/v1/image")
  Future<ApiResult> UploadImage({File imageFile,String imageableType, int imageableId, String token});

  @GET("/v1/products")
  Future<ApiResult> ProductsById({int id});

  @GET("/v1/shop")
  Future<ApiResult> ShopById({int id});

  @GET("/v1/products?limit=20&page=1&categoryGroupId=1")
  Future<ApiResult> categoryGroupId({String page,int limit,int GroupId});

  @GET("/v1/category-group")
  Future<ApiResult> CategorySubgroup({int GroupId});

  @GET("/v1/banners")
  Future<ApiResult> GetBanners({String group});

  @GET("/v1/payments")
  Future<ApiResult> GetPaymentList();

  @GET("/v1/payment")
  Future<ApiResult> GetPaymentMyShop({String token});

  @POST("/v1/myshop/payment")
  Future<ApiResult> AddPaymentMyShop({int paymentMethodId,String token});

  @DELETE("/v1/payment")
  Future<ApiResult> DELETEPaymentMyShop({int paymentMethodId,String token});

  @GET("/v1/carriers")
  Future<ApiResult> GetCarriersList();

  @GET("/v1/myshop/shipping")
  Future<ApiResult> GetShippingMyShop({String token});

  @DELETE("/v1/myshop/shipping")
  Future<ApiResult> DELETEShoppingMyShop({int ratesId,String token});

  @POST("/v1/myshop/shipping")
  Future<ApiResult> AddShoppingMyShop({ShppingMyShopRequest shopRequest,String token});

  @PATCH("/v1/myshop/shipping")
  Future<ApiResult> EditShoppingMyShop({ShppingMyShopRequest shopRequest,int rateID, String token});

  @GET("/v1/myshop/products")
  Future<ApiResult> GetProductMyShop({String page, int limit,String token,String filter});

  @POST("/v1/myshop/products")
  Future<ApiResult> AddProductMyShop({ProductMyShopRequest shopRequest,String token});

  @GET("/v1/wishlists/productId")
  Future<ApiResult> GetWishlistsByProduct({int productID,String token});

  @DELETE("/v1/wishlists")
  Future<ApiResult> DELETEWishlists({int WishId,String token});


  @POST("/v1/wishlists")
  Future<ApiResult> AddWishlists({int inventoryId,int productId,String token});

  @GET("/v1/wishlists")
  Future<ApiResult> GetMyWishlists({String token});

  @GET("/v1/customers/count")
  Future<ApiResult> GetCustomerCount({String token});

  @GET("/v1/all-categories")
  Future<ApiResult> GetCategoriesAll();

  @GET("/v1/categories")
  Future<ApiResult> GetCategories();

  @POST("/v1/cart")
  Future<ApiResult> AddCartlists({CartRequest cartRequest,String token});

  @PATCH("/v1/myshop/products")
  Future<ApiResult> UpdateProductMyShop({ProductMyShopRequest shopRequest,int productId,String token});

  @GET("/v1/cart")
  Future<ApiResult> GetCartlists({String token});

  @DELETE("/v1/myshop/products")
  Future<ApiResult> DELETEProductMyShop({int ProductId,String token});

  @DELETE("/v1/cart")
  Future<ApiResult> DELETECart({int cartid,int inventoryid,String token});

  @GET("/v1/myshop/products")
  Future<ApiResult> GetProductIDMyShop({int productId, String token});

  @PATCH("/v1/myshop/products")
  Future<ApiResult> UpdateProductInventories({InventoriesRequest inventoriesRequest,int productId,int inventoriesId,String token});

  @DELETE("/v1/image")
  Future<ApiResult> DeleteImageProduct({String imageableId,String imageableType,String path,String token});

  @GET("/v1/order?limit=20&page=1&sort=orders.createdAt:desc&orderStatusId=1")
  Future<ApiResult> GetOrder({String orderType,int page,int limit,String statusId,String token,String sort});

  @GET("/v1/order")
  Future<ApiResult> GetOrderById({int id,String orderType,String token});

  @GET("/v1/products/types/trending?shopId=1&limit=10&page=1")
  Future<ApiResult> getProductTypeShop({String type,int shopId,String page,int limit,String token});

  @GET("/v1/notifications?group=customer&page=1&limit=20&sort=notification.createdAt:desc")
  Future<ApiResult> GetNotificationByGroup({String group,int page,int limit,String sort,String token});


  @PATCH("/v1/cart")
  Future<ApiResult> UpdateCart(@Body() CartRequest data,int cartId,String token);

  @POST("/v1/order")
  Future<ApiResult> CreateOrder({OrderRequest orderRequest,String token});

  @GET("/v1/shop/1/shippings")
  Future<ApiResult> GetShippings({int shopId});

  @POST("/v1/notifications/markAsRead")
  Future<ApiResult> MarkAsReadNotifications({String token});

  @GET("/v1/search/products?q=%E0%B8%99%E0%B9%89%E0%B8%B3&limit=10&page=1&shopId=3")
  Future<ApiResult> getSearchMyshop({String page, String query,int shopId,int limit});

  @GET("/v1/myshop/attributes")
  Future<ApiResult> getMyShopAttribute(String token);

  @POST("/v1/myshop/attributes")
  Future<ApiResult> addMyShopAttribute({String name,String token});

  @DELETE("/v1/myshop/attributes")
  Future<ApiResult> deleteMyShopAttribute({int id,String token});

  @GET("/v1/myshop/attributes/1/values")
  Future<ApiResult> getAttributeDetail(int id,String token);

  @PATCH("/v1/myshop/attributes")
  Future<ApiResult> updateAttribute(String name,int id,String token);

  @POST("/v1/myshop/attributes/1/values")
  Future<ApiResult> addAttributeDetail({String value,String color,int id,String token});

  @PATCH("/v1/myshop/attributes/1/values/1")
  Future<ApiResult> updateAttributeDetail({String value,String color,int id,int vid,String token,});

  @DELETE("/v1/myshop/attributes")
  Future<ApiResult> deleteAttributeDetail({int id,String token,int vid});

  @GET("/v1/order")
  Future<ApiResult> GetCategoryByShop({int CategoryId,String token});


  @GET("/v1/page?slug=terms-of-use-customer")
  Future<ApiResult> getInformationRules(String slug);

  @GET("/v1/customers/request-change-email")
  Future<ApiResult> requestChangEmail({String email,String token});


  @PATCH("/v1/myshop/products/231/inventories/231")
  Future<ApiResult> updateinventories({int productsId,int inventoriesId,int shippingWeight,String token});

  @PATCH("/v1/order/220/mark-paid")
  Future<ApiResult> MarkPaid({int orderId,String token});

  @POST("/v1/customers/check-phone")
  Future<ApiResult> checkPhone({String phone});

  @POST("/v1/order/298/fulfill")
  Future<ApiResult> AddTracking({String trackingId, String token,int OrderId});

  @PATCH("/v1/order/298/goods-received")
  Future<ApiResult> GoodsReceived({String token,int OrderId});

  @PATCH("/v1/order/298/cancel")
  Future<ApiResult> OrderCancel({String token,int OrderId});


}





// @JsonSerializable()
// class Task {
//   String id;
//   String name;
//   String avatar;
//   String createdAt;
//
//   Task({this.id, this.name, this.avatar, this.createdAt});
//
//
//   factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
//   Map<String, dynamic> toJson() => _$TaskToJson(this);
// }
