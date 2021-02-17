

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/response/LoginRespone.dart';
import 'package:naifarm/app/model/pojo/response/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Usermanager{

  static final String IS_LOGIN = "is_login";

  static final String PHONE = "phone";
  static final String TOKEN = "token";
  static final String NAME = "name";
  static final String EMAIL = "email";
  static final String IMAGEURL = "imageurl";

  SharedPreferences _prefs;

  static final String USERNAME_DEMO = "ApisitKaewsasan@gmail.com";
  static final String PASSWORD_DEMO = "cccza007";

  Future<bool> isLogin() async {
     _prefs = await SharedPreferences.getInstance();

    return _prefs.getBool(IS_LOGIN) ?? false;
  }

  Future<User> getUser() async {
     _prefs = await SharedPreferences.getInstance();
    return User(token: _prefs.getString(TOKEN),fullname: _prefs.getString(NAME),email: _prefs.getString(EMAIL),imageurl: _prefs.getString(IMAGEURL));
  }

  Future<void> Savelogin({LoginRespone user}) async {
    if (user.token != "") {
       _prefs = await SharedPreferences.getInstance();
      _prefs.setString(TOKEN, user.token);
      _prefs.setString(NAME, user.name);
      _prefs.setString(EMAIL, user.email);
      _prefs.setBool(IS_LOGIN, true);

    }
    await Future<void>.delayed(Duration(seconds: 1));
  }

  Future<void> SavePhone({String phone}) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString(PHONE, phone);
    await Future<void>.delayed(Duration(seconds: 1));
  }

  Future<void> Updatelogin({String col,String val}) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString(col, val);
    await Future<void>.delayed(Duration(seconds: 1));
  }


  Future<void> logout() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove(IS_LOGIN);
    _prefs.remove(TOKEN);
    _prefs.remove(NAME);
    _prefs.remove(EMAIL);
    _prefs.remove(IMAGEURL);
    _prefs.remove(IS_LOGIN);
    await FacebookLogin().logOut();

   // return await Future<void>.delayed(Duration(seconds: 1));
  }
}