import 'package:localstorage/localstorage.dart';
import 'package:naifarm/app/model/pojo/request/UploadProductStorage.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/CategoryCombin.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ProductDetailCombin.dart';
import 'package:naifarm/app/model/pojo/response/ProductHistoryCache.dart';
import 'package:naifarm/app/model/pojo/response/ProductMoreCombin.dart';
import 'package:naifarm/app/model/pojo/response/ProductOrderCache.dart';
import 'package:naifarm/app/model/pojo/response/ProfileObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ZipShopObjectCombin.dart';

class NaiFarmLocalStorage {
  static LocalStorage storage;
  static String NaiFarm_Storage = "NaiFarm";
  static String NaiFarm_HomeData = "homedata";
  static String NaiFarm_Allcategories = "allcategories";
  static String NaiFarm_Product_Upload = "product_upload";
  static String NaiFarm_NowPage = "NowPage";
  static String NaiFarm_Cus = "Customer_cus";
  static String NaiFarm_ProductDetail= "ProductDetail";
  static String NaiFarm_Info = "Customer_Info";
  static String NaiFarm_Shop = "NaiFarm_Shop";
  static String NaiFarm_Cart = "NaiFarm_Cart";
  static String NaiFarm_ProductMore = "NaiFarm_ProductMore";
  static String NaiFarm_HiSTORY = "NaiFarm_history";
  static String NaiFarm_Order = "NaiFarm_order";


  static Future<void> saveOrderCache(ProductOrderCache productOrderCache) async {
    storage =  LocalStorage(NaiFarm_Storage);
    await storage.ready;
    storage.setItem(NaiFarm_Order, productOrderCache);
  }

  static Future<ProductOrderCache> getOrderCache() async {
    LocalStorage storage = new LocalStorage(NaiFarm_Storage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(NaiFarm_Order);
    if (data == null) {
      return null;
    }
    ProductOrderCache value = ProductOrderCache.fromJson(data);
    return value;
  }


  static Future<void> saveHistoryCache(ProductHistoryCache productHistoryCache) async {
    storage =  LocalStorage(NaiFarm_Storage);
    await storage.ready;
    storage.setItem(NaiFarm_HiSTORY, productHistoryCache);
  }

  static Future<ProductHistoryCache> getHistoryCache() async {
    LocalStorage storage = new LocalStorage(NaiFarm_Storage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(NaiFarm_HiSTORY);
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
