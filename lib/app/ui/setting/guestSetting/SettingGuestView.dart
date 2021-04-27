import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/ListMenuItem.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingGuestView extends StatelessWidget {
  const SettingGuestView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: ThemeColor.primaryColor(),
        child: SafeArea(
          bottom: false,
          child: body(context),
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appBar(context),
            header(context),
            content(context),
          ],
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: ThemeColor.primaryColor(),
      child: IconButton(
        padding: EdgeInsets.only(left: 5.0.w),
        alignment: Alignment.centerLeft,
        icon: Icon(
          Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios_rounded,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context, false);
        },
      ),
    );
  }

  Widget header(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(3.0.w, 2.0.w, 2.0.w, 3.5.h),
          color: ThemeColor.primaryColor(),
          child: Row(
            children: [
              Container(
                width: SizeUtil.mediumImgProfileSize().w,
                height: SizeUtil.mediumImgProfileSize().w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: SizeUtil.mediumIconSize().w,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(2.0.w, 2.0.w, 2.0.w, 3.5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 2.0.w),
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      ThemeColor.colorSale(),
                    ),
                    overlayColor: MaterialStateProperty.all(
                      Colors.white.withOpacity(0.3),
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 3.0.w),
                    ),
                  ),
                  onPressed: () => AppRoute.login(context,
                      isHeader: true,
                      isCallBack: true, homeCallBack: (bool fix) {
                    Navigator.of(context).pop();
                  }),
                  child: Text(
                    LocaleKeys.btn_login.tr(),
                    style: FunctionHelper.fontTheme(
                        color: Colors.white,
                        fontSize: SizeUtil.titleMeduimFontSize().sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    ThemeColor.secondaryColor(),
                  ),
                  overlayColor: MaterialStateProperty.all(
                    Colors.white.withOpacity(0.3),
                  ),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 3.0.w),
                  ),
                ),
                onPressed: () {
                  AppRoute.register(context);
                },
                child: Text(
                  LocaleKeys.btn_register.tr(),
                  style: FunctionHelper.fontTheme(
                      color: Colors.white,
                      fontSize: SizeUtil.titleMeduimFontSize().sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget divider() {
    return Container(
      height: 0.1.w,
      color: Colors.black.withOpacity(0.4),
    );
  }

  Widget content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListMenuItem(
          icon: 'assets/images/svg/latest.svg',
          title: LocaleKeys.me_title_history.tr(),
          iconSize: 7.0.w,
          onClick: () => AppRoute.login(context,
              isHeader: true, isCallBack: true, homeCallBack: (bool fix) {
            Navigator.of(context).pop();
          }),
        ),
        divider(),
        ListMenuItem(
            icon: 'assets/images/svg/like_2.svg',
            title: LocaleKeys.me_title_likes.tr(),
            message: "",
            iconSize: 7.0.w,
            onClick: () => AppRoute.login(context,
                    isHeader: true, isCallBack: true, homeCallBack: (bool fix) {
                  Navigator.of(context).pop();
                })),
        divider(),
        menuTitle(LocaleKeys.setting_account_head_setting.tr()),
        ListMenuItem(
          icon: 'assets/images/svg/translate.svg',
          iconSize: 7.0.w,
          message: FunctionHelper.localeLanguage(
              locale: EasyLocalization.of(context).locale),
          title: LocaleKeys.setting_account_title_language.tr(),
          onClick: () => AppRoute.settingLanguage(context),
        ),
        divider(),
        ListMenuItem(
          iconSize: 7.0.w,
          icon: 'assets/images/svg/editprofile.svg',
          title: LocaleKeys.me_title_setting.tr(),
          onClick: () => AppRoute.login(context,
              isHeader: true, isCallBack: true, homeCallBack: (bool fix) {
            Navigator.of(context).pop();
          }),
        ),
        menuTitle(LocaleKeys.setting_account_head_help.tr()),
        ListMenuItem(
          icon: 'assets/images/svg/ruleofuse.svg',
          title: LocaleKeys.setting_account_title_rule.tr(),
          iconSize: 7.0.w,
          onClick: () {
            AppRoute.settingRules(context);
          },
        ),
        divider(),
        ListMenuItem(
          icon: 'assets/images/svg/policy.svg',
          title: LocaleKeys.setting_account_title_policy.tr(),
          iconSize: 7.0.w,
          onClick: () {
            AppRoute.settingPolicy(context);
          },
        ),
        divider(),
        ListMenuItem(
          icon: 'assets/images/svg/about.svg',
          title: LocaleKeys.setting_account_title_about.tr(),
          iconSize: 7.0.w,
          onClick: () {
            AppRoute.settingAbout(context);
          },
        ),
        divider(),
      ],
    );
  }

  Widget menuTitle(String text) {
    return Container(
      padding: EdgeInsets.only(left: 3.0.w, top: 1.0.h, bottom: 1.0.h),
      child: Text(
        text,
        style: FunctionHelper.fontTheme(
            fontSize: SizeUtil.titleSmallFontSize().sp),
      ),
    );
  }
}
