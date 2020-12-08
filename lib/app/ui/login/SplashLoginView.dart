import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/SizeUtil.dart';


class SplashLoginView extends StatelessWidget {


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
              "NaiFarm",
              style: FunctionHelper.FontTheme(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(90),
                  fontWeight: FontWeight.w500),

            ),
            SizedBox(height: ScreenUtil().setHeight(70),),
            Image.asset('assets/images/png/img_login.png',height: ScreenUtil().setHeight(600),),
            SizedBox(height: 20,),
            Text("แอปเพื่อเกษตรกรไทย ซื่อง่าย ขายคล่อง",style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.titleFontSize()),),
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
                     AppRoute.Login(context,IsCallBack: false);
                  },
                  child: Text("เข้าสู่ระบบ",
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(width: 20,),
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
                  child: Text("สมัครสมาชิก",
                    style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(60),),
            Wrap(
              children: [
                Text("กดข้ามเพื่อเข้าสู่หน้าหลัก ",style: FunctionHelper.FontTheme(color: Colors.black,fontWeight: FontWeight.w500,fontSize: SizeUtil.titleFontSize())),
                Column(
                  children: [
                    InkWell(child: Text(" ข้ามหน้านี้ ",style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.titleFontSize())),onTap: (){
                      FunctionHelper.showDialogProcess(context);
                      AppRoute.Home(context);
                    },),
                    Container(
                      width: ScreenUtil().setWidth(150),
                      color: Colors.white,
                      height: 2,
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
