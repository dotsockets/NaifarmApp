import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/config/Env.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:sizer/sizer.dart';

class SplashLoginView extends StatelessWidget {
  final HomeObjectCombine item;

  const SplashLoginView({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [borderHeader(context)],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height - 12.0.h,
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ThemeColor.primaryColor(),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Env.value.appName,
              style: FunctionHelper.fontTheme(
                  color: Colors.white,
                  fontSize: SizeUtil.appNameFontSize().sp,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5.0.h,
            ),
            Image.asset(
              'assets/images/png/img_login.png',
              height: 35.0.h,
            ),
            SizedBox(
              height: 3.0.h,
            ),
            Text(
              "แอปเพื่อเกษตรกรไทย ซื้อง่าย ขายคล่อง",
              style: FunctionHelper.fontTheme(
                  color: Colors.white, fontSize: SizeUtil.titleFontSize().sp),
            ),
            SizedBox(
              height: 4.0.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(
                      Size(40.0.w, 5.0.h),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      ThemeColor.colorSale(),
                    ),
                    overlayColor: MaterialStateProperty.all(
                      Colors.white.withOpacity(0.3),
                    ),
                  ),
                  onPressed: () {
                    AppRoute.login(context, isCallBack: false, isHeader: true,isSetting: true);
                  },
                  child: Text(
                    LocaleKeys.btn_login.tr(),
                    style: FunctionHelper.fontTheme(
                        color: Colors.white,
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  width: 2.0.h,
                ),
                TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(
                      Size(40.0.w, 5.0.h),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      ThemeColor.secondaryColor(),
                    ),
                    overlayColor: MaterialStateProperty.all(
                      Colors.white.withOpacity(0.3),
                    ),
                  ),
                  onPressed: () {
                    AppRoute.register(context);
                  },
                  child: Text(
                    LocaleKeys.btn_register.tr(),
                    style: FunctionHelper.fontTheme(
                        color: Colors.white,
                        fontSize: SizeUtil.titleFontSize().sp,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4.0.h,
            ),
            Wrap(
              children: [
                Text(LocaleKeys.splashLogin_skip_message.tr() + " ",
                    style: FunctionHelper.fontTheme(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: SizeUtil.titleFontSize().sp)),
                SizedBox(
                  width: 8,
                ),
                Column(
                  children: [
                    Container(
                      child: InkWell(
                        child: Text(LocaleKeys.splashLogin_skip.tr(),
                            style: FunctionHelper.fontTheme(
                                color: Colors.white,
                                fontSize: SizeUtil.titleFontSize().sp)),
                        onTap: () {
                          // FunctionHelper.showDialogProcess(context);
                          AppRoute.home(context);
                        },
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.white, width: 2)),
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 5.0.h),
          ],
        ));
  }

  Widget borderHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ThemeColor.colorSale(),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50)),
        ),
        child: buildHeader(context));
  }
}
