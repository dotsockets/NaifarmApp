import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/LoginRespone.dart';
import 'package:naifarm/app/model/pojo/response/User.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Usermanager {
  static final String _isLogin = "is_login";
  static final String phone = "phone";
  static final String token = "token";
  static final String name = "name";
  static final String email = "email";
  static final String imageURL = "imageurl";

  SharedPreferences _prefs;

  static final String userNameDemo = "ApisitKaewsasan@gmail.com";
  static final String passwordDemo = "cccza007";

  Future<bool> isLogin() async {
    _prefs = await SharedPreferences.getInstance();

    return _prefs.getBool(_isLogin) ?? false;
  }

  Future<String> isToken() async {
    _prefs = await SharedPreferences.getInstance();

    return _prefs.getString(token) ?? false;
  }

  Future<User> getUser() async {
    _prefs = await SharedPreferences.getInstance();
    return User(
        token: _prefs.getString(token),
        fullname: _prefs.getString(name),
        email: _prefs.getString(email),
        imageurl: _prefs.getString(imageURL));
  }


  Future<void> savelogin({LoginRespone user}) async {
    if (user.token != "") {
      _prefs = await SharedPreferences.getInstance();
      _prefs.setString(token, user.token);
      _prefs.setString(name, user.name);
      _prefs.setString(email, user.email);
      _prefs.setBool(_isLogin, true);
    }
    await Future<void>.delayed(Duration(seconds: 1));
  }

  Future<void> savePhone({String phones}) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString(phone, phones);
    await Future<void>.delayed(Duration(seconds: 1));
  }

  Future<void> saveShop({String phones}) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString(phone, phones);
    await Future<void>.delayed(Duration(seconds: 1));
  }

  Future<void> updatelogin({String col, String val}) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString(col, val);
    await Future<void>.delayed(Duration(seconds: 1));
  }

  Future<void> logout() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove(_isLogin);
    _prefs.remove(token);
    _prefs.remove(name);
    _prefs.remove(email);
    _prefs.remove(imageURL);
    _prefs.remove(_isLogin);
    await FacebookLogin().logOut();

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.cancelAll();

    NaiFarmLocalStorage.getCustomerInfo().then((value) async {
      await OneSignal.shared.deleteTag("shopID");
      OneSignal.shared.removeExternalUserId();
    });

    // return await Future<void>.delayed(Duration(seconds: 1));
  }
}
