import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: _BorderHeader(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _BuildHeader(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height-100,
        padding: EdgeInsets.all(30),
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
              style: GoogleFonts.sarabun(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w500),

            ),
            SizedBox(height: 30,),
            Image.asset('assets/images/png/img_login.png',height: 300,),
            SizedBox(height: 20,),
            Text("แอปเพื่อเกษตรกรไทย ซื่อง่าย ขายคล่อง",style: GoogleFonts.sarabun(color: Colors.white,fontSize: 20),),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  minWidth: 160,
                  height: 50,
                  color: ThemeColor.ColorSale(),
                  textColor: Colors.white,
                  splashColor: Colors.white.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  onPressed: () {
                     // AppRoute.Register(context);
                  },
                  child: Text("เข้าสู่ระบบ",
                    style: GoogleFonts.sarabun(fontSize: 20,fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(width: 20,),
                FlatButton(
                  minWidth: 160,
                  height: 50,
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
                    style: GoogleFonts.sarabun(fontSize: 20,fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
            SizedBox(height: 50,),
            Wrap(
              children: [
                Text("กดข้ามเพื่อเข้าสู่หน้าหลัก ",style: GoogleFonts.sarabun(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 20)),
                InkWell(child: Text("ข้ามหน้านี้ ",style: GoogleFonts.sarabun(color: Colors.white,fontSize: 20,decoration: TextDecoration.underline,)),onTap: (){
                  AppRoute.Home(context);
                },),
              ],
            ),
            SizedBox(height: 40,),
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
