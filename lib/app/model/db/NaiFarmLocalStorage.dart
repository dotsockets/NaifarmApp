
import 'package:localstorage/localstorage.dart';
import 'package:naifarm/app/model/pojo/response/CategoryGroupRespone.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';

class NaiFarmLocalStorage{
  static LocalStorage storage;
  static String NaiFarm_Storage = "NaiFarm";

  static Future<void> saveHomeData(HomeObjectCombine data) async {
    storage =  LocalStorage(NaiFarm_Storage);
    await storage.ready;
    storage.setItem("homedata", data);

  }

  static Future<void> Clean({String keyStore}) async {
    storage =  LocalStorage(keyStore);
    await storage.ready;
    storage.clear();
  }

  static Future<HomeObjectCombine> getHomeDataCache() async {
    LocalStorage storage = new LocalStorage(NaiFarm_Storage);
    await storage.ready;
    Map<String, dynamic> data = storage.getItem('homedata');
    if (data == null) {
      return null;
    }
    HomeObjectCombine value = HomeObjectCombine.fromJson(data);
    return value;
  }



}