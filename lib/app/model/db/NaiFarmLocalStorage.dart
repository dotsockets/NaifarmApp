
import 'package:localstorage/localstorage.dart';
import 'package:naifarm/app/model/pojo/request/ProductMyShopRequest.dart';
import 'package:naifarm/app/model/pojo/request/UploadProductStorage.dart';
import 'package:naifarm/app/model/pojo/response/CategoriesAllRespone.dart';
import 'package:naifarm/app/model/pojo/response/CategoryCombin.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/CustomerCountRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/app/model/pojo/response/ProducItemRespone.dart';

class NaiFarmLocalStorage{
  static LocalStorage storage;
  static String NaiFarm_Storage = "NaiFarm";
  static String NaiFarm_HomeData = "homedata";
  static String NaiFarm_Allcategories = "allcategories";
  static String NaiFarm_Product_Upload = "product_upload";
  static String NaiFarm_NowPage = "NowPage";
  static String NaiFarm_Cus = "Customer_cus";

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