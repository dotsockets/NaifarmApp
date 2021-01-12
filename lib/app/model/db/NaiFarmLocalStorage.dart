
import 'package:localstorage/localstorage.dart';
import 'package:naifarm/app/model/pojo/response/CategoriesAllRespone.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';

class NaiFarmLocalStorage{
  static LocalStorage storage;
  static String NaiFarm_Storage = "NaiFarm";
  static String NaiFarm_HomeData = "homedata";
  static String NaiFarm_Allcategories = "allcategories";

  static Future<void> saveHomeData(HomeObjectCombine data) async {
    storage =  LocalStorage(NaiFarm_Storage);
    await storage.ready;
    storage.setItem(NaiFarm_HomeData, data);

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

  static Future<CategoriesAllRespone> getAllCategoriesCache() async {
    LocalStorage storage = new LocalStorage(NaiFarm_Storage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem(NaiFarm_Allcategories);
    if (data == null) {
      return null;
    }
    CategoriesAllRespone value = CategoriesAllRespone.fromJson(data);
    return value;
  }


  static Future<void> saveCategoriesAll(CategoriesAllRespone data) async {
    storage =  LocalStorage(NaiFarm_Storage);
    await storage.ready;
    storage.setItem(NaiFarm_Allcategories, data);

  }





}