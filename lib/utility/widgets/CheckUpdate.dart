import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import '../SizeUtil.dart';
import 'package:version/version.dart';

class CheckUpdate {
  static Future<bool> checkAppUpdate(
      {@required BuildContext context, @required String currentVersion}) async {
    final response = await http.get(Uri.parse(Env.value.appUpdateUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> note = json.decode(response.body);
      if (Platform.isAndroid) {
        final android = note['os']['android'];
        if (android != null && getCurrentVersion(android['version']) > getCurrentVersion(currentVersion)) {
          Vibration.vibrate();
          showAndroidUpdate(context, android, currentVersion);
          return false;
        }
      } else if (Platform.isIOS) {
        final ios = note['os']['ios'];
        if (ios != null && getCurrentVersion(ios['version']) > getCurrentVersion(currentVersion)) {
          Vibration.vibrate();
          showIOSUpdate(context, ios, currentVersion);
          return false;
        }
      }
    }
    return true;
  }


  static Version getCurrentVersion(String currentVersion){
    Version current = new Version(0, 0, 0);
    if(currentVersion.split(".").length==3){
      current = new Version(int.parse(currentVersion.split(".")[0]), int.parse(currentVersion.split(".")[1]), int.parse(currentVersion.split(".")[2]));
    }else if(currentVersion.split(".").length==2){
      current = new Version(int.parse(currentVersion.split(".")[0]), int.parse(currentVersion.split(".")[1]), 0);
    }else{
      current = new Version(int.parse(currentVersion.split(".")[0]),0, 0);
    }
    return current;
  }


  static showAndroidUpdate(
      BuildContext context, dynamic content, String currentVersion) {
    final String local =
    EasyLocalization.of(context).currentLocale == Locale('th', 'TH')
        ? 'th'
        : 'en';
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(
            LocaleKeys.appUpdate_title.tr(),
            style: FunctionHelper.fontTheme(
                fontWeight: FontWeight.bold,
                fontSize: SizeUtil.priceFontSize().sp),
          ),
          content: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: LocaleKeys.appUpdate_detail1.tr() +
                      ' ' +
                      content['version'] +
                      ' ' +
                      LocaleKeys.appUpdate_detail2.tr() +
                      ' ' +
                      currentVersion +
                      '.\n\n' +
                      LocaleKeys.appUpdate_requestUpdate.tr() +
                      '\n\n',
                  style: FunctionHelper.fontTheme(
                      fontWeight: FontWeight.w200,
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      color: Colors.black),
                ),
                TextSpan(
                  text: LocaleKeys.appUpdate_releaseNote.tr() + ':\n\n',
                  style: FunctionHelper.fontTheme(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeUtil.titleMeduimFontSize().sp,
                      color: Colors.black),
                ),
                TextSpan(
                  text: content["releaseNote"][local] ?? '',
                  style: FunctionHelper.fontTheme(
                      fontWeight: FontWeight.w200,
                      fontSize: SizeUtil.titleSmallFontSize().sp,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                LocaleKeys.appUpdate_updateButton.tr(),
                style: FunctionHelper.fontTheme(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: SizeUtil.titleSmallFontSize().sp),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  ThemeColor.primaryColor(),
                ),
              ),
              onPressed: () {
                launch(Env.value.androidAppUrl);
              },
            ),
          ],
        ),
      ),
    );
  }

  static showIOSUpdate(
      BuildContext context, dynamic content, String currentVersion) {
    final String local =
    EasyLocalization.of(context).currentLocale == Locale('th', 'TH')
        ? 'th'
        : 'en';
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(LocaleKeys.appUpdate_title.tr()+'\n',style: FunctionHelper.fontTheme(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeUtil.priceFontSize().sp)),
        content:RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.appUpdate_detail1.tr() +
                    ' ' +
                    content['version'] +
                    ' ' +
                    LocaleKeys.appUpdate_detail2.tr() +
                    ' ' +
                    currentVersion +
                    '.\n\n' +
                    LocaleKeys.appUpdate_requestUpdate.tr() +
                    '\n\n',
                style: FunctionHelper.fontTheme(
                    fontWeight: FontWeight.w200,
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    color: Colors.black),
              ),
              TextSpan(
                text: LocaleKeys.appUpdate_releaseNote.tr() + ':\n\n',
                style: FunctionHelper.fontTheme(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeUtil.titleMeduimFontSize().sp,
                    color: Colors.black),
              ),
              TextSpan(
                text: content["releaseNote"][local] ?? '',
                style: FunctionHelper.fontTheme(
                    fontWeight: FontWeight.w200,
                    fontSize: SizeUtil.titleSmallFontSize().sp,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          BasicDialogAction(
            title: Text(LocaleKeys.appUpdate_updateButton.tr(),style: FunctionHelper.fontTheme(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeUtil.titleSmallFontSize().sp)),
            onPressed: () {
              launch(Env.value.appleAppUrl);
              //Navigator.pop(context);
            },
          ),
        ],
      ),
    );
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Container(
    //       padding: EdgeInsets.only(bottom: 15.0),
    //       child: Text(
    //         LocaleKeys.appUpdate_title.tr(),
    //         textAlign: TextAlign.left,
    //         style: FunctionHelper.fontTheme(
    //             fontWeight: FontWeight.bold,
    //             fontSize: SizeUtil.priceFontSize().sp),
    //       ),
    //     ),
    //     content: RichText(
    //       text: TextSpan(
    //         children: [
    //           TextSpan(
    //             text: LocaleKeys.appUpdate_detail1.tr() +
    //                 ' ' +
    //                 content['version'] +
    //                 ' ' +
    //                 LocaleKeys.appUpdate_detail2.tr() +
    //                 ' ' +
    //                 currentVersion +
    //                 '.\n\n' +
    //                 LocaleKeys.appUpdate_requestUpdate.tr() +
    //                 '\n\n',
    //             style: FunctionHelper.fontTheme(
    //                 fontWeight: FontWeight.w200,
    //                 fontSize: SizeUtil.titleSmallFontSize().sp,
    //                 color: Colors.black),
    //           ),
    //           TextSpan(
    //             text: LocaleKeys.appUpdate_releaseNote.tr() + ':\n\n',
    //             style: FunctionHelper.fontTheme(
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: SizeUtil.titleMeduimFontSize().sp,
    //                 color: Colors.black),
    //           ),
    //           TextSpan(
    //             text: content["releaseNote"][local] ?? '',
    //             style: FunctionHelper.fontTheme(
    //                 fontWeight: FontWeight.w200,
    //                 fontSize: SizeUtil.titleSmallFontSize().sp,
    //                 color: Colors.black),
    //           ),
    //         ],
    //       ),
    //     ),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: new Text(LocaleKeys.appUpdate_updateButton.tr(),
    //             style: FunctionHelper.fontTheme(
    //                 fontWeight: FontWeight.w400,
    //                 fontSize: SizeUtil.titleSmallFontSize().sp)),
    //         onPressed: () {
    //           // go app store
    //           launch(Env.value.appleAppUrl);
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }
}
