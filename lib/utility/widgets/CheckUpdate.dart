import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../SizeUtil.dart';

class CheckUpdate {
  static Future<bool> checkAppUpdate(
      {@required BuildContext context, @required String currentVersion}) async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/dotsockets/NaifarmApp/check_version/assets/json/appupdate.json'));

    if (response.statusCode == 200) {
      Map<String, dynamic> note = json.decode(response.body);
      if (Platform.isAndroid) {
        final android = note['os']['android'];
        if (android != null && android['version'] != currentVersion) {
          showAndroidUpdate(context, android);
          return false;
        }
      } else if (Platform.isIOS) {
        final ios = note['os']['ios'];
        if (ios != null && ios['version'] != currentVersion) {
          showIOSUpdate(context, ios);
          return false;
        }
      }
    }
    return true;
  }

  static showAndroidUpdate(BuildContext context, dynamic content) {
    print(EasyLocalization.of(context).currentLocale);
    final String local =
        EasyLocalization.of(context).currentLocale == Locale('th', 'TH')
            ? 'th'
            : 'en';
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                LocaleKeys.appUpdate_title.tr(),
                style: FunctionHelper.fontTheme(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeUtil.titleFontSize().sp),
              ),
              content: Text(
                "**" +
                        LocaleKeys.appUpdate_releaseNote.tr() +
                        "**" +
                        "\n" +
                        content["releaseNote"][local] ??
                    '',
                style: FunctionHelper.fontTheme(
                    fontWeight: FontWeight.w400,
                    fontSize: SizeUtil.titleSmallFontSize().sp),
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
                    launch("https://play.google.com/store/apps/details?id=com.naifarm.app");
                  },
                )
              ],
            ));
  }

  static showIOSUpdate(BuildContext context, dynamic content) {
    final String local =
        EasyLocalization.of(context).currentLocale == Locale('th', 'TH')
            ? 'th'
            : 'en';
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
          title: Container(
            padding: EdgeInsets.only(bottom: 0.5.h),
            child: Text(
              LocaleKeys.appUpdate_title.tr(),
              style: FunctionHelper.fontTheme(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeUtil.titleFontSize().sp),
            ),
          ),
          content: Center(
            child: Text(
              LocaleKeys.appUpdate_releaseNote.tr() +
                      "\n" +
                      content["releaseNote"][local] ??
                  '',
              textAlign: TextAlign.left,
              style: FunctionHelper.fontTheme(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeUtil.titleSmallFontSize().sp),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(LocaleKeys.appUpdate_updateButton.tr(),
                  style: FunctionHelper.fontTheme(
                      fontWeight: FontWeight.w400,
                      fontSize: SizeUtil.titleSmallFontSize().sp)),
              onPressed: () {
                // go app store
                launch("https://apps.apple.com/us/app/naifarm/id1561733274");
              },
            ),
          ]),
    );
  }
}
