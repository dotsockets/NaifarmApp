import 'package:localstorage/localstorage.dart';
import 'package:naifarm/app/model/pojo/request/UploadProductStorage.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/CategoryCombin.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/OneSignalNoificationId.dart';
import 'package:naifarm/app/model/pojo/response/ProductDetailCombin.dart';
import 'package:naifarm/app/model/pojo/response/ProductHistoryCache.dart';
import 'package:naifarm/app/model/pojo/response/ProductMoreCombin.dart';
import 'package:naifarm/app/model/pojo/response/ProductMyShopRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductOrderCache.dart';
import 'package:naifarm/app/model/pojo/response/ProfileObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ZipShopObjectCombin.dart';

class NaiFarmLocalStorage {
  static LocalStorage storage;
  static String naiFarmStorage = "NaiFarm";
  static String naiFarmHomeData = "homedata";
  static String naiFarmAllcategories = "allcategories";
  static String naiFarmProductUpload = "product_upload";
  static String naiFarmNowPage = "NowPage";
  static String naiFarmCus = "Customer_cus";
  static String naiFarmProductDetail = "ProductDetail";
  static String naiFarmInfo = "Customer_Info";
  static String naiFarmShop = "NaiFarm_Shop";
  static String naiFarmCart = "NaiFarm_Cart";
  static String naiFarmProductMore = "NaiFarm_ProductMore";
  static String naiFarmHiSTORY = "NaiFarm_history";
  static String naiFarmOrder = "NaiFarm_order";
  static String naiFarmOneSiganl = "NaiFarm_onesignal";
  static String naiFarmProductMyShop = "ProductMyShop";

  static Future<void> saveOneSiganlCache(
      OneSignalNoificationId oneSignalNoificationId) async {
    storage = LocalStorage(naiFarmStorage);
    await storage.ready;
    storage.setItem(naiFarmOneSiganl, oneSignalNoificationId);
  }

  static Future<OneSignalNoificationId> getOneSiganlCache() async {
    LocalStorage storage = new LocalStorage(naiFarmStorage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(naiFarmOneSiganl);
    if (data == null) {
      return null;
    }
    OneSignalNoificationId value = OneSignalNoificationId.fromJson(data);
    return value;
  }

  static Future<void> saveOrderCache(
      ProductOrderCache productOrderCache) async {
    storage = LocalStorage(naiFarmStorage);
    await storage.ready;
    storage.setItem(naiFarmOrder, productOrderCache);
  }

  static Future<ProductOrderCache> getOrderCache() async {
    LocalStorage storage = new LocalStorage(naiFarmStorage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(naiFarmOrder);
    if (data == null) {
      return null;
    }
    ProductOrderCache value = ProductOrderCache.fromJson(data);
    return value;
  }

  static Future<void> saveHistoryCache(
      ProductHistoryCache productHistoryCache) async {
    storage = LocalStorage(naiFarmStorage);
    await storage.ready;
    storage.setItem(naiFarmHiSTORY, productHistoryCache);
  }

  static Future<ProductHistoryCache> getHistoryCache() async {
    LocalStorage storage = new LocalStorage(naiFarmStorage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(naiFarmHiSTORY);
    if (data == null) {
      return null;
    }
    ProductHistoryCache value = ProductHistoryCache.fromJson(data);
    return value;
  }

  static Future<void> saveCartCache(CartResponse cartResponse) async {
    storage = LocalStorage(naiFarmStorage);
    await storage.ready;
    storage.setItem(naiFarmCart, cartResponse);
  }

  static Future<CartResponse> getCartCache() async {
    LocalStorage storage = new LocalStorage(naiFarmStorage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(naiFarmCart);
    if (data == null) {
      return null;
    }
    CartResponse value = CartResponse.fromJson(data);
    return value;
  }

  static Future<void> saveProductMoreCache(
      ProducMoreCache producMoreCache) async {
    storage = LocalStorage(naiFarmStorage);
    await storage.ready;
    storage.setItem(naiFarmProductMore, producMoreCache);
  }

  static Future<ProducMoreCache> getProductMoreCache() async {
    LocalStorage storage = new LocalStorage(naiFarmStorage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(naiFarmProductMore);
    if (data == null) {
      return null;
    }
    ProducMoreCache value = ProducMoreCache.fromJson(data);
    return value;
  }

  static Future<void> saveNaiFarmShopCache(
      NaiFarmShopCombin naiFarmShopCombin) async {
    storage = LocalStorage(naiFarmStorage);
    await storage.ready;
    storage.setItem(naiFarmShop, naiFarmShopCombin);
  }

  static Future<NaiFarmShopCombin> getNaiFarmShopCache() async {
    LocalStorage storage = new LocalStorage(naiFarmStorage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(naiFarmShop);
    if (data == null) {
      return null;
    }
    NaiFarmShopCombin value = NaiFarmShopCombin.fromJson(data);
    return value;
  }

  static Future<void> saveProductDetailCache(
      ProductDetailCombin productDetailCombin) async {
    storage = LocalStorage(naiFarmStorage);
    await storage.ready;
    storage.setItem(naiFarmProductDetail, productDetailCombin);
  }

  static Future<ProductDetailCombin> getProductDetailCache() async {
    LocalStorage storage = new LocalStorage(naiFarmStorage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(naiFarmProductDetail);
    if (data == null) {
      return null;
    }
    ProductDetailCombin value = ProductDetailCombin.fromJson(data);

    return value;
  }

  static Future<void> saveProductMyShopCache(
      ProductMyShopCombine productMyShopCombine) async {
    storage = LocalStorage(naiFarmStorage);
    await storage.ready;
    storage.setItem(naiFarmProductMyShop, productMyShopCombine);
  }

  static Future<ProductMyShopCombine> getProductMyShopCache() async {
    LocalStorage storage = new LocalStorage(naiFarmStorage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(naiFarmProductMyShop);
    if (data == null) {
      return null;
    }
    ProductMyShopCombine value = ProductMyShopCombine.fromJson(data);
    return value;
  }

  static Future<void> saveHomeData(HomeObjectCombine data) async {
    storage = LocalStorage(naiFarmStorage);
    await storage.ready;
    storage.setItem(naiFarmHomeData, data);
  }

  static Future<void> saveCustomerCuse(
      CustomerCountRespone countRespone) async {
    storage = LocalStorage(naiFarmStorage);
    await storage.ready;
    storage.setItem(naiFarmCus, countRespone);
  }

  static Future<CustomerCountRespone> getCustomerCuse() async {
    storage = LocalStorage(naiFarmStorage);
    Map<String, dynamic> data = storage.getItem(naiFarmCus);
    if (data == null) {
      return null;
    }
    CustomerCountRespone value = CustomerCountRespone.fromJson(data);
    return value;
  }

  static Future<void> saveCustomerInfo(
      ProfileObjectCombine profileObjectCombine) async {
    storage = LocalStorage(naiFarmStorage);
    await storage.ready;
    storage.setItem(naiFarmInfo, profileObjectCombine);
  }

  static Future<ProfileObjectCombine> getCustomerInfo() async {
    storage = LocalStorage(naiFarmStorage);
    Map<String, dynamic> data = storage.getItem(naiFarmInfo);
    if (data == null) {
      return null;
    }
    ProfileObjectCombine value = ProfileObjectCombine.fromJson(data);
    return value;
  }

  static Future<void> saveNowPage(int page) async {
    storage = LocalStorage(naiFarmStorage);
    await storage.ready;
    storage.setItem(naiFarmNowPage, page);
  }

  static Future<int> getNowPage() async {
    storage = LocalStorage(naiFarmStorage);
    int data = storage.getItem(naiFarmNowPage);
    if (data == null) {
      return 0;
    }
    return data;
  }

  static Future<void> clean({String keyStore}) async {
    storage = LocalStorage(keyStore);
    await storage.ready;
    storage.clear();
  }

  static Future<HomeObjectCombine> getHomeDataCache() async {
    LocalStorage storage = new LocalStorage(naiFarmStorage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(naiFarmHomeData);
    if (data == null) {
      return null;
    }
    HomeObjectCombine value = HomeObjectCombine.fromJson(data);
    return value;
  }

  static Future<CategoryCombin> getAllCategoriesCache() async {
    LocalStorage storage = new LocalStorage(naiFarmStorage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(naiFarmAllcategories);
    if (data == null) {
      return null;
    }
    CategoryCombin value = CategoryCombin.fromJson(data);
    return value;
  }

  static Future<void> saveCategoriesAll(CategoryCombin data) async {
    storage = LocalStorage(naiFarmStorage);
    await storage.ready;
    storage.setItem(naiFarmAllcategories, data);
  }

  static Future<void> saveProductStorage(UploadProductStorage data) async {
    storage = LocalStorage(naiFarmStorage);
    await storage.ready;
    storage.setItem(naiFarmProductUpload, data);
  }

  static Future<UploadProductStorage> getProductStorageCache() async {
    LocalStorage storage = new LocalStorage(naiFarmStorage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(naiFarmProductUpload);

    if (data == null) {
      return null;
    }
    UploadProductStorage value = UploadProductStorage.fromJson(data);
    return value;
  }

  static Future<void> deleteCacheByItem({String key}) async {
    storage = LocalStorage(naiFarmStorage);
    await storage.ready;
    storage.deleteItem(key);
  }
}
