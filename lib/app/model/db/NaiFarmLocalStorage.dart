
import 'package:localstorage/localstorage.dart';
import 'package:naifarm/app/model/pojo/request/ProductMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/request/UploadProductStorage.dart';
import 'package:naifarm/app/model/pojo/response/CartResponse.dart';
import 'package:naifarm/app/model/pojo/response/CategoriesAllRespone.dart';
import 'package:naifarm/app/model/pojo/response/CategoryCombin.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';
import 'package:naifarm/app/model/pojo/response/ProductDetailCombin.dart';
import 'package:naifarm/app/model/pojo/response/ProductHistoryCache.dart';
import 'package:naifarm/app/model/pojo/response/ProductMoreCombin.dart';
import 'package:naifarm/app/model/pojo/response/ProductOrderCache.dart';
import 'package:naifarm/app/model/pojo/response/ProfileObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ZipShopObjectCombin.dart';

class NaiFarmLocalStorage{
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
    storage =  LocalStorage(NaiFarm_Storage);
    await storage.ready;
    storage.setItem(NaiFarm_Cart, cartResponse);
  }

  static Future<CartResponse> getCartCache() async {
    LocalStorage storage = new LocalStorage(NaiFarm_Storage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(NaiFarm_Cart);
    if (data == null) {
      return null;
    }
    CartResponse value = CartResponse.fromJson(data);
    return value;
  }


  static Future<void> saveProductMoreCache(ProducMoreCache producMoreCache) async {
    storage =  LocalStorage(NaiFarm_Storage);
    await storage.ready;
    storage.setItem(NaiFarm_ProductMore, producMoreCache);
  }

  static Future<ProducMoreCache> getProductMoreCache() async {
    LocalStorage storage = new LocalStorage(NaiFarm_Storage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(NaiFarm_ProductMore);
    if (data == null) {
      return null;
    }
    ProducMoreCache value = ProducMoreCache.fromJson(data);
    return value;
  }

  static Future<void> saveNaiFarm_ShopCache(NaiFarmShopCombin naiFarmShopCombin) async {
    storage =  LocalStorage(NaiFarm_Storage);
    await storage.ready;
    storage.setItem(NaiFarm_Shop, naiFarmShopCombin);
  }

  static Future<NaiFarmShopCombin> getNaiFarm_ShopCache() async {
    LocalStorage storage = new LocalStorage(NaiFarm_Storage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(NaiFarm_Shop);
    if (data == null) {
      return null;
    }
    NaiFarmShopCombin value = NaiFarmShopCombin.fromJson(data);
    return value;
  }



  static Future<void> saveProductDetailCache(ProductDetailCombin productDetailCombin) async {
    storage =  LocalStorage(NaiFarm_Storage);
    await storage.ready;
    storage.setItem(NaiFarm_ProductDetail, productDetailCombin);
  }

  static Future<ProductDetailCombin> getProductDetailCache() async {
    LocalStorage storage = new LocalStorage(NaiFarm_Storage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(NaiFarm_ProductDetail);
    if (data == null) {
      return null;
    }
    ProductDetailCombin value = ProductDetailCombin.fromJson(data);
    return value;
  }



  static Future<void> saveHomeData(HomeObjectCombine data) async {
    storage =  LocalStorage(NaiFarm_Storage);
    await storage.ready;
    storage.setItem(NaiFarm_HomeData, data);

  }


  static Future<void> saveCustomer_cuse(CustomerCountRespone countRespone) async {
    storage =  LocalStorage(NaiFarm_Storage);
    await storage.ready;
    storage.setItem(NaiFarm_Cus, countRespone);
  }

  static Future<CustomerCountRespone> getCustomer_cuse() async {
    storage =  LocalStorage(NaiFarm_Storage);
    Map<String, dynamic> data = storage.getItem(NaiFarm_Cus);
    if (data == null) {
      return null;
    }
    CustomerCountRespone value = CustomerCountRespone.fromJson(data);
    return value;
  }

  static Future<void> saveCustomer_Info(ProfileObjectCombine profileObjectCombine) async {
    storage =  LocalStorage(NaiFarm_Storage);
    await storage.ready;
    storage.setItem(NaiFarm_Info, profileObjectCombine);
  }

  static Future<ProfileObjectCombine> getCustomer_Info() async {
    storage =  LocalStorage(NaiFarm_Storage);
    Map<String, dynamic> data = storage.getItem(NaiFarm_Info);
    if (data == null) {
      return null;
    }
    ProfileObjectCombine value = ProfileObjectCombine.fromJson(data);
    return value;
  }

  static Future<void> saveNowPage(int page) async {
    storage =  LocalStorage(NaiFarm_Storage);
    await storage.ready;
    storage.setItem(NaiFarm_NowPage, page);
  }

  static Future<int> getNowPage() async {
    storage =  LocalStorage(NaiFarm_Storage);
    int data = storage.getItem(NaiFarm_NowPage);
    if(data == null){
      return 0;
    }
    return data;
  }

  static Future<void> Clean({String keyStore}) async {
    storage =  LocalStorage(keyStore);
    await storage.ready;
    storage.clear();
  }

  static Future<HomeObjectCombine> getHomeDataCache() async {
    LocalStorage storage = new LocalStorage(NaiFarm_Storage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(NaiFarm_HomeData);
    if (data == null) {
      return null;
    }
    HomeObjectCombine value = HomeObjectCombine.fromJson(data);
    return value;
  }

  static Future<CategoryCombin> getAllCategoriesCache() async {
    LocalStorage storage = new LocalStorage(NaiFarm_Storage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(NaiFarm_Allcategories);
    if (data == null) {
      return null;
    }
    CategoryCombin value = CategoryCombin.fromJson(data);
    return value;
  }


  static Future<void> saveCategoriesAll(CategoryCombin data) async {
    storage =  LocalStorage(NaiFarm_Storage);
    await storage.ready;
    storage.setItem(NaiFarm_Allcategories, data);

  }

  static Future<void> SaveProductStorage(UploadProductStorage data) async {
    storage =  LocalStorage(NaiFarm_Storage);
    await storage.ready;
    storage.setItem(NaiFarm_Product_Upload, data);

  }


  static Future<UploadProductStorage> getProductStorageCache() async {
    LocalStorage storage = new LocalStorage(NaiFarm_Storage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(NaiFarm_Product_Upload);

    if (data == null) {
      return null;
    }
    UploadProductStorage value = UploadProductStorage.fromJson(data);
    return value;
  }






  static Future<void> DeleteCacheByItem({String key}) async {
    storage =  LocalStorage(NaiFarm_Storage);
    await storage.ready;
    storage.deleteItem(key);
  }




}