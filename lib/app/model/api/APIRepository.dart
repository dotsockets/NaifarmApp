import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:naifarm/app/model/api/APIProvider.dart';
import 'package:naifarm/app/model/db/DBNaiFarmRepository.dart';
import 'package:naifarm/app/model/pojo/request/AddressCreaterequest.dart';
import 'package:naifarm/app/model/pojo/request/CartRequest.dart';
import 'package:naifarm/app/model/pojo/request/InventoriesRequest.dart';
import 'package:naifarm/app/model/pojo/request/LoginRequest.dart';
import 'package:naifarm/app/model/pojo/request/ModifyPasswordrequest.dart';
import 'package:naifarm/app/model/pojo/request/MyShopRequest.dart';
import 'package:naifarm/app/model/pojo/request/OrderRequest.dart';
import 'package:naifarm/app/model/pojo/request/ProductMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/request/RegisterRequest.dart';
import 'package:naifarm/app/model/pojo/response/CustomerInfoRespone.dart';
import 'package:naifarm/app/model/pojo/response/ApiResult.dart';
import 'package:naifarm/app/model/pojo/response/ShppingMyShopRequest.dart';

class APIRepository {
  static const String TAG = 'AppAPIRepository';

  APIProvider _apiProvider;
  DBBookingRepository dbAppStoreRepository;

  APIRepository(this._apiProvider, this.dbAppStoreRepository);

  Future<ApiResult> getFBProfile(BuildContext context, {String accessToken}) {
    return _apiProvider.getProFileFacebook(context, accessToken);
  }

  Future<ApiResult> customersLogin(BuildContext context,
      {LoginRequest loginRequest}) {
    return _apiProvider.customersLogin(context, loginRequest);
  }

  Future<ApiResult> checkEmail(BuildContext context, {String email}) {
    return _apiProvider.checkEmail(context, email: email);
  }

  Future<ApiResult> customersLoginSocial(BuildContext context,
      {LoginRequest loginRequest, String provider}) {
    return _apiProvider.customersLoginSocial(context, loginRequest, provider);
  }

  Future<ApiResult> customersRegister(BuildContext context,
      {RegisterRequest registerRequest}) {
    return _apiProvider.customersRegister(context, registerRequest);
  }

  Future<ApiResult> otpRequest(BuildContext context, {String numberphone}) {
    return _apiProvider.otpRequest(context, numberphone);
  }

  Future<ApiResult> otpVerify(BuildContext context,
      {String phone, String code, String ref}) {
    return _apiProvider.otpVerify(context, phone, code, ref);
  }

  Future<ApiResult> forgotPassword(BuildContext context,
      {String phone, String code, String ref, String password}) {
    return _apiProvider.forgotPasswordRequest(context,
        code: code, ref: ref, phone: phone, password: password);
  }

  Future<ApiResult> resetPasswordRequest(BuildContext context,
      {String email, String password, String token}) {
    return _apiProvider.resetPasswordRequest(context, email, password, token);
  }

  Future<ApiResult> getCustomerInfo(BuildContext context, {String token}) {
    return _apiProvider.getCustomerInfo(context, token);
  }

  Future<ApiResult> modifyProfile(BuildContext context,
      {CustomerInfoRespone data, String token}) {
    return _apiProvider.modifyProfile(context, data, token);
  }

  Future<ApiResult> modifyPassword(BuildContext context,
      {ModifyPasswordrequest data, String token}) {
    return _apiProvider.modifyPassword(context, data, token);
  }

  Future<ApiResult> verifyPassword(BuildContext context,
      {String password, String token}) {
    return _apiProvider.verifyPassword(context, password, token);
  }

  Future<ApiResult> addressesList(BuildContext context, {String token}) {
    return _apiProvider.addressesList(context, token);
  }

  Future<ApiResult> statesProvice(BuildContext context, {String countries}) {
    return _apiProvider.statesProvice(context, countries);
  }

  Future<ApiResult> statesCity(BuildContext context,
      {String countriesid, String statesId}) {
    return _apiProvider.statesCity(context, countriesid, statesId);
  }

  Future<ApiResult> statesZipCode(BuildContext context,
      {String countries, String statesId, String cityId}) {
    return _apiProvider.zipCode(context, countries, statesId, cityId);
  }

  Future<ApiResult> createAddress(BuildContext context,
      {AddressCreaterequest addressCreaterequest, String token}) {
    return _apiProvider.createAddress(context, addressCreaterequest, token);
  }

  Future<ApiResult> deleteAddress(BuildContext context,
      {String id, String token}) {
    return _apiProvider.deleteAddress(context, id, token);
  }

  Future<ApiResult> updateAddress(BuildContext context,
      {AddressCreaterequest data, String token}) {
    return _apiProvider.updateAddress(context, data, token);
  }

  Future<ApiResult> getSliderImage(
    BuildContext context,
  ) {
    return _apiProvider.getSliderImage(
      context,
    );
  }

  Future<ApiResult> getProductPopular(
      BuildContext context, String page, int limit) {
    return _apiProvider.getProductPopular(context, page, limit);
  }

  Future<ApiResult> getCategoryGroup(
    BuildContext context,
  ) {
    return _apiProvider.getCategoryGroup(
      context,
    );
  }

  Future<ApiResult> getCategoriesFeatured(
    BuildContext context,
  ) {
    return _apiProvider.getCategoriesFeatured(
      context,
    );
  }

  Future<ApiResult> getProductTrending(
      BuildContext context, String page, int limit) {
    return _apiProvider.getProductTrending(context, page, limit);
  }

  Future<ApiResult> getShopProduct(BuildContext context,
      {int shopId, String page, int limit}) {
    return _apiProvider.getShopProduct(context,
        shopId: shopId, page: page, limit: limit);
  }

  Future<ApiResult> getSearch(BuildContext context,
      {String page, String query, int limit}) {
    return _apiProvider.getSearch(context,
        page: page, query: query, limit: limit);
  }

  Future<ApiResult> createMyShop(BuildContext context,
      {String name, String slug, String description, String token}) {
    return _apiProvider.createMyShop(context,
        name: name, slug: slug, description: description, token: token);
  }

  Future<ApiResult> getMyShopInfo(BuildContext context, {String accessToken}) {
    return _apiProvider.getMyShopInfo(context, accessToken);
  }

  Future<ApiResult> myShopUpdate(
      {BuildContext context, MyShopRequest data, String accessToken}) {
    return _apiProvider.myShopUpdate(context,
        data: data, accessToken: accessToken);
  }

  Future<ApiResult> farmMarket(
    BuildContext context,
  ) {
    return _apiProvider.farmMarket(
      context,
    );
  }

  Future<ApiResult> moreProduct(BuildContext context,
      {String page, int limit, String link}) {
    return _apiProvider.moreProduct(context,
        page: page, limit: limit, link: link);
  }

  Future<ApiResult> myShopActive(
      {BuildContext context, int data, String accessToken}) {
    return _apiProvider.myShopActive(context,
        data: data, accessToken: accessToken);
  }

  Future<ApiResult> flashsale(BuildContext context, {String page, int limit}) {
    return _apiProvider.flashsale(context, page: page, limit: limit);
  }

  Future<ApiResult> uploadImage(BuildContext context,
      {File imageFile, String imageableType, int imageableId, String token}) {
    return _apiProvider.uploadImage(context,
        imageFile: imageFile,
        imageableType: imageableType,
        imageableId: imageableId,
        token: token);
  }

  Future<ApiResult> productsById(BuildContext context, {int id}) {
    return _apiProvider.productsById(context, id: id);
  }

  Future<ApiResult> shopById(BuildContext context, {int id}) {
    return _apiProvider.shopById(context, id: id);
  }

  Future<ApiResult> categoryGroupId(BuildContext context,
      {String page, int limit, int groupId}) {
    return _apiProvider.categoryGroupId(context,
        page: page, limit: limit, groupId: groupId);
  }

  Future<ApiResult> categorySubgroup(BuildContext context, {int groupId}) {
    return _apiProvider.categorySubgroup(context, groupId: groupId);
  }

  Future<ApiResult> getBanners(BuildContext context, {String group}) {
    return _apiProvider.getBanners(context, group: group);
  }

  Future<ApiResult> getPaymentList(
    BuildContext context,
  ) {
    return _apiProvider.getPaymentList(
      context,
    );
  }

  Future<ApiResult> getPaymentMyShop(BuildContext context, {String token}) {
    return _apiProvider.getPaymentMyShop(context, token: token);
  }

  Future<ApiResult> addPaymentMyShop(BuildContext context,
      {int paymentMethodId, String token}) {
    return _apiProvider.addPaymentMyShop(context,
        paymentMethodId: paymentMethodId, token: token);
  }

  Future<ApiResult> deletePaymentMyShop(BuildContext context,
      {int paymentMethodId, String token}) {
    return _apiProvider.deletePaymentMyShop(context,
        paymentMethodId: paymentMethodId, token: token);
  }

  Future<ApiResult> getCarriersList(
    BuildContext context,
  ) {
    return _apiProvider.getCarriersList(
      context,
    );
  }

  Future<ApiResult> getShippingMyShop(BuildContext context, {String token}) {
    return _apiProvider.getShippingMyShop(context, token: token);
  }

  Future<ApiResult> deleteShoppingMyShop(BuildContext context,
      {int ratesId, String token}) {
    return _apiProvider.deleteShoppingMyShop(context,
        ratesId: ratesId, token: token);
  }

  Future<ApiResult> addShoppingMyShop(BuildContext context,
      {ShppingMyShopRequest shopRequest, String token}) {
    return _apiProvider.addShoppingMyShop(context,
        shopRequest: shopRequest, token: token);
  }

  Future<ApiResult> editShoppingMyShop(BuildContext context,
      {ShppingMyShopRequest shopRequest, int rateID, String token}) {
    return _apiProvider.editShoppingMyShop(context,
        shopRequest: shopRequest, token: token, rateID: rateID);
  }

  Future<ApiResult> getProductMyShop(BuildContext context,
      {String page, int limit, String token, String filter}) {
    return _apiProvider.getProductMyShop(context,
        page: page, limit: limit, token: token, filter: filter);
  }

  Future<ApiResult> getWishlistsByProduct(BuildContext context,
      {int productID, String token}) {
    return _apiProvider.getWishlistsByProduct(context,
        productID: productID, token: token);
  }

  Future<ApiResult> deleteWishlists(BuildContext context,
      {int wishId, String token}) {
    return _apiProvider.deleteWishlists(context, wishId: wishId, token: token);
  }

  Future<ApiResult> addWishlists(BuildContext context,
      {int inventoryId, int productId, String token}) {
    return _apiProvider.addWishlists(context,
        inventoryId: inventoryId, productId: productId, token: token);
  }

  Future<ApiResult> getMyWishlists(BuildContext context, {String token}) {
    return _apiProvider.getMyWishlists(context, token: token);
  }

  Future<ApiResult> getCustomerCount(BuildContext context, {String token}) {
    return _apiProvider.getCustomerCount(context, token: token);
  }

  Future<ApiResult> getCategoriesAll(
    BuildContext context,
  ) {
    return _apiProvider.getCategoriesAll(
      context,
    );
  }

  Future<ApiResult> getCategories(
    BuildContext context,
  ) {
    return _apiProvider.getCategories(
      context,
    );
  }

  Future<ApiResult> addCartlists(BuildContext context,
      {CartRequest cartRequest, String token}) {
    return _apiProvider.addCartlists(context,
        cartRequest: cartRequest, token: token);
  }

  Future<ApiResult> addProductMyShop(BuildContext context,
      {ProductMyShopRequest shopRequest, String token}) {
    return _apiProvider.addProductMyShop(context,
        shopRequest: shopRequest, token: token);
  }

  Future<ApiResult> getCartlists(BuildContext context, {String token}) {
    return _apiProvider.getCartlists(context, token: token);
  }

  Future<ApiResult> deleteCart(BuildContext context,
      {int cartid, int inventoryid, String token}) {
    return _apiProvider.deleteCart(context,
        cartid: cartid, inventoryid: inventoryid, token: token);
  }

  Future<ApiResult> updateCart(BuildContext context,
      {CartRequest data, int cartid, String token}) {
    return _apiProvider.updateCart(context, data, cartid, token);
  }

  Future<ApiResult> updateProductMyShop(BuildContext context,
      {ProductMyShopRequest shopRequest, int productId, String token}) {
    return _apiProvider.updateProductMyShop(context,
        shopRequest: shopRequest, productId: productId, token: token);
  }

  Future<ApiResult> activeProduct(BuildContext context,
      {int active, int productId, String token}) {
    return _apiProvider.activeProduct(context,
        ative: active, productId: productId, token: token);
  }

  Future<ApiResult> deleteProductMyShop(BuildContext context,
      {int productId, String token}) {
    return _apiProvider.deleteProductMyShop(context,
        productId: productId, token: token);
  }

  Future<ApiResult> getProductIDMyShop(BuildContext context,
      {int productId, String token}) {
    return _apiProvider.getProductIDMyShop(context,
        productId: productId, token: token);
  }

  Future<ApiResult> updateProductInventories(BuildContext context,
      {InventoriesRequest inventoriesRequest,
      int productId,
      int inventoriesId,
      String token}) {
    return _apiProvider.updateProductInventories(context,
        productId: productId,
        token: token,
        inventoriesId: inventoriesId,
        inventoriesRequest: inventoriesRequest);
  }

  Future<ApiResult> deleteImageProduct(BuildContext context,
      {String imageableId, String imageableType, String path, String token}) {
    return _apiProvider.deleteImageProduct(context,
        imageableType: imageableType,
        imageableId: imageableId,
        path: path,
        token: token);
  }

  Future<ApiResult> getOrder(BuildContext context,
      {String orderType,
      int page = 1,
      int limit = 20,
      String statusId,
      String token,
      String sort}) {
    return _apiProvider.getOrder(context,
        orderType: orderType,
        page: page,
        limit: limit,
        statusId: statusId,
        token: token,
        sort: sort);
  }

  Future<ApiResult> getOrderById(BuildContext context,
      {int id, String orderType, String token}) {
    return _apiProvider.getOrderById(context,
        id: id, orderType: orderType, token: token);
  }

  Future<ApiResult> getProductTypeShop(BuildContext context,
      {String type, int shopId, String page, int limit, String token}) {
    return _apiProvider.getProductTypeShop(context,
        page: page, limit: limit, shopId: shopId, type: type, token: token);
  }

  Future<ApiResult> getNotificationByGroup(BuildContext context,
      {String group, int page, String sort, int limit, String token}) {
    return _apiProvider.getNotificationByGroup(context,
        group: group, limit: limit, page: page, sort: sort, token: token);
  }

  Future<ApiResult> createOrder(BuildContext context,
      {OrderRequest orderRequest, String token}) {
    return _apiProvider.createOrder(context,
        orderRequest: orderRequest, token: token);
  }

  Future<ApiResult> getShippings(BuildContext context, {int shopId}) {
    return _apiProvider.getShippings(context, shopId: shopId);
  }

  Future<ApiResult> markAsReadNotifications(BuildContext context,
      {String token}) {
    return _apiProvider.markAsReadNotifications(context, token: token);
  }

  Future<ApiResult> getSearchProduct(BuildContext context,
      {String page, String query, int shopId, int limit}) {
    return _apiProvider.getSearchProduct(context,
        page: page, query: query, shopId: shopId, limit: limit);
  }

  Future<ApiResult> getMyShopAttribute(BuildContext context, {String token}) {
    return _apiProvider.getMyShopAttribute(context, token);
  }

  Future<ApiResult> addMyShopAttribute(BuildContext context,
      {String name, String token}) {
    return _apiProvider.addMyShopAttribute(context, name: name, token: token);
  }

  Future<ApiResult> deleteMyShopAttribute(BuildContext context,
      {int id, String token}) {
    return _apiProvider.deleteMyShopAttribute(context, id: id, token: token);
  }

  Future<ApiResult> getAttributeDetail(BuildContext context,
      {String token, int id}) {
    return _apiProvider.getAttributeDetail(context, id, token);
  }

  Future<ApiResult> updateAttribute(BuildContext context,
      {String name, String token, int id}) {
    return _apiProvider.updateAttribute(context, name, id, token);
  }

  Future<ApiResult> addAttributeDetail(BuildContext context,
      {String value, String color, int id, String token}) {
    return _apiProvider.addAttributeDetail(context,
        token: token, id: id, color: color, value: value);
  }

  Future<ApiResult> updateAttributeDetail(
    BuildContext context, {
    String value,
    String color,
    int id,
    int vid,
    String token,
  }) {
    return _apiProvider.updateAttributeDetail(context,
        color: color, value: value, id: id, token: token, vid: vid);
  }

  Future<ApiResult> deleteAttributeDetail(BuildContext context,
      {int id, int vid, String token}) {
    return _apiProvider.deleteAttributeDetail(context,
        id: id, token: token, vid: vid);
  }

  Future<ApiResult> getCategoryByShop(BuildContext context,
      {int categoryId, String token}) {
    return _apiProvider.getCategoryByShop(context,
        categoryId: categoryId, token: token);
  }

  Future<ApiResult> getInformationRules(BuildContext context, String slug) {
    return _apiProvider.getInformationRules(context, slug);
  }

  Future<ApiResult> requestChangEmail(BuildContext context,
      {String email, String token}) {
    return _apiProvider.requestChangEmail(context, email: email, token: token);
  }

  Future<ApiResult> updateinventories(BuildContext context,
      {int productsId, int inventoriesId, int shippingWeight, String token}) {
    return _apiProvider.updateinventories(context,
        productsId: productsId,
        inventoriesId: inventoriesId,
        shippingWeight: shippingWeight,
        token: token);
  }

  Future<ApiResult> markPaid(BuildContext context,
      {int orderId, String token}) {
    return _apiProvider.markPaid(context, orderId: orderId, token: token);
  }

  Future<ApiResult> checkPhone(BuildContext context, {String phone}) {
    return _apiProvider.checkPhone(context, phone: phone);
  }

  Future<ApiResult> addTracking(BuildContext context,
      {String trackingId, String token, int orderId}) {
    return _apiProvider.addTracking(context,
        trackingId: trackingId, token: token, orderId: orderId);
  }

  Future<ApiResult> goodsReceived(BuildContext context,
      {String token, int orderId}) {
    return _apiProvider.goodsReceived(context, token: token, orderId: orderId);
  }

  Future<ApiResult> orderCancel(BuildContext context,
      {String token, int orderId}) {
    return _apiProvider.orderCancel(context, token: token, orderId: orderId);
  }

  Future<ApiResult> getSearchShop(BuildContext context,
      {String page,
      String query,
      int limit,
      int shopId,
      String filter,
      String token}) {
    return _apiProvider.getSearchShop(
        context: context,
        filter: filter,
        shopId: shopId,
        page: page,
        limit: limit,
        query: query,
        token: token);
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
