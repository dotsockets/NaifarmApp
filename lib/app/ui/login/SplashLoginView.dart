import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
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
    ScreenUtil.init(context);
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
                  children: [
                    _BorderHeader(context)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _BuildHeader(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height-ScreenUtil().setHeight(200),
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ThemeColor.primaryColor(),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40),
              bottomLeft: Radius.circular(40)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Env.value.appName,
              style: FunctionHelper.FontTheme(
                  color: Colors.white,
                  fontSize: SizeUtil.appNameFontSize().sp,
                  fontWeight: FontWeight.w500),

            ),
            SizedBox(height: ScreenUtil().setHeight(70),),
            Image.asset('assets/images/png/img_login.png',height: ScreenUtil().setHeight(600),),
            SizedBox(height: 3.0.h,),
            Text("แอปเพื่อเกษตรกรไทย ซื้อง่าย ขายคล่อง",style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.titleFontSize().sp),),
            SizedBox(height: ScreenUtil().setHeight(80),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  minWidth: ScreenUtil().setWidth(400),
                  height: ScreenUtil().setHeight(120),
                  color: ThemeColor.ColorSale(),
                  textColor: Colors.white,
                  splashColor: Colors.white.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  onPressed: () {
                     AppRoute.Login(context,IsCallBack: false,item: item,IsHeader: true);
                  },
                  child: Text(LocaleKeys.login_btn.tr(),
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(width: 2.0.h,),
                FlatButton(
                  minWidth: ScreenUtil().setWidth(400),
                  height: ScreenUtil().setHeight(120),
                  color: ThemeColor.secondaryColor(),
                  textColor: Colors.white,
                  splashColor: Colors.white.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  onPressed: () {
                    AppRoute.Register(context);
                  },
                  child: Text(LocaleKeys.register_btn.tr(),
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(60),),
            Wrap(
              children: [
                Text(LocaleKeys.splashLogin_skip_message.tr()+" ",style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.w500,fontSize: SizeUtil.titleFontSize().sp)),
                SizedBox(width: 8,),
                Column(
                  children: [
                    Container(
                      child: InkWell(child: Text(LocaleKeys.splashLogin_skip.tr(),style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.titleFontSize().sp)),onTap: (){
                        // FunctionHelper.showDialogProcess(context);
                        AppRoute.Home(context);
                      },),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.white, width: 2)),
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(40),),
          ],
        ));
  }

  Widget _BorderHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ThemeColor.ColorSale(),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40),
              bottomLeft: Radius.circular(40)),
        ),
        child: _BuildHeader(context));
  }

}
