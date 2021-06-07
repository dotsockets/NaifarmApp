import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/model/pojo/request/AddressCreaterequest.dart';
import 'package:naifarm/app/model/pojo/request/CartRequest.dart';
import 'package:naifarm/app/model/pojo/request/InventoriesAttrRequest.dart';
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
import 'package:naifarm/app/model/pojo/response/FeedbackRespone.dart';
import 'package:naifarm/app/model/pojo/response/FlashsaleRespone.dart';
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
import 'package:naifarm/app/model/pojo/response/ProductShopItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/SearchRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShippingsRespone.dart';
import 'package:naifarm/app/model/pojo/response/ShppingMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/response/ShppingMyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/SliderRespone.dart';
import 'package:naifarm/app/model/pojo/response/StatesRespone.dart';
import 'package:naifarm/app/model/pojo/response/RegisterRespone.dart';
import 'package:naifarm/app/model/pojo/response/SystemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ThrowIfNoSuccess.dart';
import 'package:naifarm/app/model/pojo/response/WishlistsRespone.dart';
import 'package:naifarm/app/model/pojo/response/zipCodeRespone.dart';
import 'package:naifarm/utility/http/ServerError.dart';
import 'package:retrofit/retrofit.dart';

part '_APIProvider.dart';

abstract class APIProvider {
  factory APIProvider(Dio dio, {String baseUrl}) = _APIProvider;

  @GET("/tasks/{id}")
  Future<ApiResult> getProFileFacebook(
      BuildContext context, @Query("accessToken") String accessToken);

  @POST("/v1/customers/login")
  Future<ApiResult> customersLogin(
      BuildContext context, @Body() LoginRequest loginRequest);

  @POST("/v1/customers/login/login-apple")
  Future<ApiResult> loginApple(BuildContext context, String accessToken);

  @POST("/v1/customers/login-social")
  Future<ApiResult> customersLoginSocial(
      BuildContext context, @Body() LoginRequest loginRequest, String provider);

  @POST("/v1/customers/check-email")
  Future<ApiResult> checkEmail(BuildContext context, {String email});

  @POST("/v1/customers/register")
  Future<ApiResult> customersRegister(
      BuildContext context, @Body() RegisterRequest registerRequest);

  @POST("/v1/otp/request")
  @FormUrlEncoded()
  Future<ApiResult> otpRequest(
      BuildContext context, @Field() String numbephone);

  @POST("/v1/otp/verify")
  @FormUrlEncoded()
  Future<ApiResult> otpVerify(BuildContext context, @Field() String phone,
      @Field() String code, @Field() String ref);

  @POST("/v1/customers/v1/customers/forgot-password-phone")
  Future<ApiResult> forgotPasswordRequest(BuildContext context,
      {@Field() String phone,
      @Field() String code,
      @Field() String ref,
      @Field() String password});

  @POST("/v1/customers/reset-password")
  @FormUrlEncoded()
  Future<ApiResult> resetPasswordRequest(BuildContext context,
      @Field() String email, @Field() String password, @Field() String token);

  @GET("/v1/customers/info")
  Future<ApiResult> getCustomerInfo(BuildContext context, String accessToken);

  @PATCH("/v1/customers/modify-profile")
  Future<ApiResult> modifyProfile(BuildContext context,
      @Body() CustomerInfoRespone data, String accessToken);

  @PATCH("/v1/customers/modify-password")
  Future<ApiResult> modifyPassword(BuildContext context,
      @Body() ModifyPasswordrequest data, String accessToken);

  @PATCH("/v1/customers/first-password")
  Future<ApiResult> firstPassword(BuildContext context,
      @Body() ModifyPasswordrequest data, String accessToken);

  @POST("/v1/customers/verify-password")
  @FormUrlEncoded()
  Future<ApiResult> verifyPassword(
      BuildContext context, @Field() String password, String token);

  @GET("/v1/addresses")
  Future<ApiResult> addressesList(BuildContext context, String token);

  @GET("/v1/countries/1/states")
  Future<ApiResult> statesProvice(BuildContext context, String countries);

  @GET("/v1/countries/1/states/1/cities")
  Future<ApiResult> statesCity(
      BuildContext context, String countriesid, String statesId);

  @GET("/v1/countries/1/states/1/cities")
  Future<ApiResult> zipCode(
      BuildContext context, String countries, String statesId, String cityId);

  @POST("/v1/addresses")
  Future<ApiResult> createAddress(BuildContext context,
      @Body() AddressCreaterequest addressCreaterequest, String token);

  @DELETE("/v1/addresses")
  @FormUrlEncoded()
  Future<ApiResult> deleteAddress(
      BuildContext context, String id, String token);

  @PATCH("/v1/addresses")
  Future<ApiResult> updateAddress(BuildContext context,
      @Body() AddressCreaterequest data, String accessToken);

  @GET("/v1/sliders")
  Future<ApiResult> getSliderImage(BuildContext context);

  @GET("/v1/products/types/popular?limit=9&page=1")
  Future<ApiResult> getProductPopular(
      BuildContext context, String page, int limit);

  @GET("/v1/shop/1/products?limit=20&page=1")
  Future<ApiResult> getShopProduct(BuildContext context,
      {int shopId, String page, int limit});

  @GET("/v1/category-group")
  Future<ApiResult> getCategoryGroup(BuildContext context);

  @GET("/v1/categories/featured")
  Future<ApiResult> getCategoriesFeatured(
    BuildContext context,
  );

  @GET("/v1/products/types/trending?limit=6&page=1")
  Future<ApiResult> getProductTrending(
      BuildContext context, String page, int limit);

  @GET("/v1/search/products?q=s&limit=10&page=1")
  Future<ApiResult> getSearch(BuildContext context,
      {String page, String query, int limit});

  @POST("/v1/customers/myshop")
  @FormUrlEncoded()
  Future<ApiResult> createMyShop(BuildContext context,
      {@Field() String name,
      @Field() String slug,
      @Field() String description,
      @Field() String token});

  @GET("/v1/myshop/shop")
  Future<ApiResult> getMyShopInfo(BuildContext context, String accessToken);

  @PATCH("/v1/myshop/shop")
  Future<ApiResult> myShopUpdate(BuildContext context,
      {@Body() MyShopRequest data, String accessToken});

  @PATCH("/v1/myshop/shop")
  Future<ApiResult> myShopActive(BuildContext context,
      {@Body() int data, String accessToken});

  @GET("/v1/myshop/shop")
  Future<ApiResult> farmMarket(BuildContext context);

  Future<ApiResult> moreProduct(BuildContext context,
      {String page, int limit, String link});

  @GET("/v1/flashsale?limit=20&page=1")
  Future<ApiResult> flashsale(BuildContext context, {String page, int limit});

  @POST("/v1/image")
  Future<ApiResult> uploadImage(BuildContext context,
      {File imageFile, String imageableType, int imageableId, String token});

  @POST("/v1/image")
  Future<ApiResult> uploadImages(BuildContext context,
      {List<File> imageFile,
      String imageableType,
      int imageableId,
      String token});

  @GET("/v1/products")
  Future<ApiResult> productsById(BuildContext context, {int id});

  @GET("/v1/shop")
  Future<ApiResult> shopById(BuildContext context, {int id});

  @GET("/v1/products?limit=20&page=1&categoryGroupId=1")
  Future<ApiResult> categoryGroupId(BuildContext context,
      {String page, int limit, int groupId});

  @GET("/v1/category-group")
  Future<ApiResult> categorySubgroup(BuildContext context, {int groupId});

  @GET("/v1/banners")
  Future<ApiResult> getBanners(BuildContext context, {String group});

  @GET("/v1/payments")
  Future<ApiResult> getPaymentList(BuildContext context, {String shopIds});

  @GET("/v1/payment")
  Future<ApiResult> getPaymentMyShop(BuildContext context, {String token});

  @POST("/v1/myshop/payment")
  Future<ApiResult> addPaymentMyShop(BuildContext context,
      {int paymentMethodId, String token});

  @DELETE("/v1/payment")
  Future<ApiResult> deletePaymentMyShop(BuildContext context,
      {int paymentMethodId, String token});

  @GET("/v1/carriers")
  Future<ApiResult> getCarriersList(
    BuildContext context,
  );

  @GET("/v1/myshop/shipping")
  Future<ApiResult> getShippingMyShop(BuildContext context, {String token});

  @DELETE("/v1/myshop/shipping")
  Future<ApiResult> deleteShoppingMyShop(BuildContext context,
      {int ratesId, String token});

  @POST("/v1/myshop/shipping")
  Future<ApiResult> addShoppingMyShop(BuildContext context,
      {ShppingMyShopRequest shopRequest, String token});

  @PATCH("/v1/myshop/shipping")
  Future<ApiResult> editShoppingMyShop(BuildContext context,
      {ShppingMyShopRequest shopRequest, int rateID, String token});

  @GET("/v1/myshop/products")
  Future<ApiResult> getProductMyShop(BuildContext context,
      {String page, int limit, String token, String filter});

  @POST("/v1/myshop/products")
  Future<ApiResult> addProductMyShop(BuildContext context,
      {ProductMyShopRequest shopRequest, String token});

  @GET("/v1/wishlists/productId")
  Future<ApiResult> getWishlistsByProduct(BuildContext context,
      {int productID, String token});

  @DELETE("/v1/wishlists")
  Future<ApiResult> deleteWishlists(BuildContext context,
      {int wishId, String token});

  @POST("/v1/wishlists")
  Future<ApiResult> addWishlists(BuildContext context,
      {int inventoryId, int productId, String token});

  @GET("/v1/wishlists")
  Future<ApiResult> getMyWishlists(BuildContext context, {String token});

  @GET("/v1/customers/count")
  Future<ApiResult> getCustomerCount(BuildContext context, {String token});

  @GET("/v1/all-categories")
  Future<ApiResult> getCategoriesAll(BuildContext context);

  @GET("/v1/categories")
  Future<ApiResult> getCategories(BuildContext context);

  @POST("/v1/cart")
  Future<ApiResult> addCartlists(BuildContext context,
      {CartRequest cartRequest, String token});

  @PATCH("/v1/myshop/products")
  Future<ApiResult> updateProductMyShop(BuildContext context,
      {ProductMyShopRequest shopRequest, int productId, String token});

  @PATCH("/v1/myshop/products")
  Future<ApiResult> activeProduct(BuildContext context,
      {int ative, int productId, String token});

  @GET("/v1/cart")
  Future<ApiResult> getCartlists(BuildContext context, {String token});

  @DELETE("/v1/myshop/products")
  Future<ApiResult> deleteProductMyShop(BuildContext context,
      {int productId, String token});

  @DELETE("/v1/cart")
  Future<ApiResult> deleteCart(BuildContext context,
      {int cartid, int inventoryid, String token});

  @GET("/v1/myshop/products")
  Future<ApiResult> getProductIDMyShop(BuildContext context,
      {int productId, String token});

  @PATCH("/v1/myshop/products")
  Future<ApiResult> updateProductInventories(BuildContext context,
      {InventoriesRequest inventoriesRequest,
      int productId,
      int inventoriesId,
      String token});

  @DELETE("/v1/image")
  Future<ApiResult> deleteImageProduct(BuildContext context,
      {String imageableId, String imageableType, String path, String token});

  @GET("/v1/order?limit=20&page=1&sort=orders.createdAt:desc&orderStatusId=1")
  Future<ApiResult> getOrder(BuildContext context,
      {String orderType,
      int page,
      int limit,
      String statusId,
      String token,
      String sort});

  @GET("/v1/order")
  Future<ApiResult> getOrderById(BuildContext context,
      {int id, String orderType, String token});

  @GET("/v1/products/types/trending?shopId=1&limit=10&page=1")
  Future<ApiResult> getProductTypeShop(BuildContext context,
      {String type, int shopId, String page, int limit, String token});

  @GET(
      "/v1/notifications?group=customer&page=1&limit=20&sort=notification.createdAt:desc")
  Future<ApiResult> getNotificationByGroup(BuildContext context,
      {String group, int page, int limit, String sort, String token});

  @PATCH("/v1/cart")
  Future<ApiResult> updateCart(
      BuildContext context, @Body() CartRequest data, int cartId, String token);

  @POST("/v1/order")
  Future<ApiResult> createOrder(BuildContext context,
      {OrderRequest orderRequest, String token});

  @GET("/v1/shop/1/shippings")
  Future<ApiResult> getShippings(BuildContext context, {int shopId});

  @POST("/v1/notifications/markAsRead")
  Future<ApiResult> markAsReadNotifications(BuildContext context,
      {String token});

  @GET(
      "/v1/search/products?q=%E0%B8%99%E0%B9%89%E0%B8%B3&limit=10&page=1&shopId=3")
  Future<ApiResult> getSearchProduct(BuildContext context,
      {String page, String query, int shopId, int limit});

  @GET("/v1/myshop/attributes")
  Future<ApiResult> getMyShopAttribute(BuildContext context, String token);

  @POST("/v1/myshop/attributes")
  Future<ApiResult> addMyShopAttribute(BuildContext context,
      {String name, String token});

  @DELETE("/v1/myshop/attributes")
  Future<ApiResult> deleteMyShopAttribute(BuildContext context,
      {int id, String token});

  @GET("/v1/myshop/attributes/1/values")
  Future<ApiResult> getAttributeDetail(
      BuildContext context, int id, String token);

  @PATCH("/v1/myshop/attributes")
  Future<ApiResult> updateAttribute(
      BuildContext context, String name, int id, String token);

  @POST("/v1/myshop/attributes/1/values")
  Future<ApiResult> addAttributeDetail(BuildContext context,
      {String value, String color, int id, String token});

  @PATCH("/v1/myshop/attributes/1/values/1")
  Future<ApiResult> updateAttributeDetail(
    BuildContext context, {
    String value,
    String color,
    int id,
    int vid,
    String token,
  });

  @DELETE("/v1/myshop/attributes")
  Future<ApiResult> deleteAttributeDetail(BuildContext context,
      {int id, String token, int vid});

  @GET("/v1/order")
  Future<ApiResult> getCategoryByShop(BuildContext context,
      {int categoryId, String token});

  @GET("/v1/page?slug=terms-of-use-customer")
  Future<ApiResult> getInformationRules(BuildContext context, String slug);

  @GET("/v1/customers/request-change-email")
  Future<ApiResult> requestChangEmail(BuildContext context,
      {String email, String token});

  @PATCH("/v1/myshop/products/231/inventories/231")
  Future<ApiResult> updateinventories(BuildContext context,
      {int productsId, int inventoriesId, int shippingWeight, String token});

  @PATCH("/v1/order/220/mark-paid")
  Future<ApiResult> markPaid(BuildContext context, {int orderId, String token});

  @POST("/v1/customers/check-phone")
  Future<ApiResult> checkPhone(BuildContext context, {String phone});

  @POST("/v1/customers/check-existing-phone")
  Future<ApiResult> checkExistingPhone(BuildContext context, {String phone});

  @POST("/v1/order/298/fulfill")
  Future<ApiResult> addTracking(BuildContext context,
      {String trackingId, String token, int orderId});

  @PATCH("/v1/order/298/goods-received")
  Future<ApiResult> goodsReceived(BuildContext context,
      {String token, int orderId});

  @PATCH("/v1/order/298/cancel")
  Future<ApiResult> orderCancel(BuildContext context,
      {String token, int orderId});

  @GET(
      "/v1/myshop/search/products?limit=10&page=1&shopId=18&filter=available&q=%22%22")
  Future<ApiResult> getSearchShop(
      {BuildContext context,
      String page,
      String query,
      int limit,
      int shopId,
      String filter,
      String token});

  @PATCH("/v1/order/767/request-payment")
  Future<ApiResult> requestPayment(BuildContext context,
      {int orderId, String token});

  @GET("/v1/system")
  Future<ApiResult> getSystem(BuildContext context);

 @POST("/v1/feedback")
 Future<ApiResult> createFeedback(BuildContext context, {int rating,String comment,int inventoryId,String token,int orderId});

  @GET("/v1/products/85/feedbacks")
  Future<ApiResult> getFeedback(BuildContext context, {int id,int limit,int page,});

  @PATCH("/v1/myshop/products")
  Future<ApiResult>  updateInventoriesAttr(BuildContext context,
      {InventoriesAttrRequest inventoriesRequest,
        int productId,
        int inventoriesId,
        String token});
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
