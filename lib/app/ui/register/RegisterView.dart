
import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:http/http.dart' as http;


class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {


  TextEditingController PhoneController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PhoneController.text = "0932971160";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColor.primaryColor(),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              _BuildBar(context),
              _BuildHeader(context),
              _BuildContent(context)

            ],
          ),
        ),
      ),
    );
  }


  Widget _BuildContent(BuildContext context){
    return Container(
      padding: EdgeInsets.all(28),
      child: Column(
        children: [
          SizedBox(height: 20,),
          Text("ลงทะเบียน",style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(60),fontWeight: FontWeight.w500),),
         SizedBox(height: 30,),
          BuildEditText(head: "เบอร์โทรศัพท์ *", hint: "เบอร์โทรศัพท์",inputType: TextInputType.number,controller: PhoneController,BorderOpacity: 0.3,),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(right: 15,left: 15),
            child: FlatButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              color: ThemeColor.secondaryColor(),
              textColor: Colors.white,
              splashColor: Colors.white.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              onPressed: ()=>_validate(),
              child: Text("ยืนยัน",
                style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(45),fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 3,child: Container(margin: EdgeInsets.only(left: 30),color: Colors.black.withOpacity(0.2),height: 1,),),
              Expanded(flex: 1,child: Align(alignment: Alignment.center,child: Text("หรือ",style: GoogleFonts.sarabun(fontSize: 16),)),),
              Expanded(flex: 3,child: Container(margin: EdgeInsets.only(right: 30),color: Colors.black.withOpacity(0.2),height: 1,),),
            ],
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(right: 15,left: 15),
            child: FlatButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              color: Color(ColorUtils.hexToInt("#1f4dbf")),
              textColor: Colors.white,
              splashColor: Colors.white.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              onPressed: ()=>_login(),
              child: Text("สมัครด้วย Facebook",
                style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(45),fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(height: 30,),
          Wrap(
            children: [
              Text("ในการสมัครใช้งาน เราถือว่าคุณยอมรับ",style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(40),height: 1.7,fontWeight: FontWeight.w500),),
              Text(" ข้อตกลงในการใช้งาน",style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(40),color: ThemeColor.secondaryColor(),decoration: TextDecoration.underline,height: 1.7,fontWeight: FontWeight.w500),),
              Text(" และ ",style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(40),height: 1.7,fontWeight: FontWeight.w500),),
              Text("นโยบายความเป็นส่วนตัว",style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(40),color: ThemeColor.secondaryColor(),decoration: TextDecoration.underline,height: 1.7,fontWeight: FontWeight.w500),),
              Text(" กับทาง NaiFarm",style: GoogleFonts.sarabun(fontSize: ScreenUtil().setSp(40),height: 1.7,fontWeight: FontWeight.w500),),
            ],
          )
        ],
      )
    );
  }

  Widget _BuildHeader(BuildContext context){
    return Container(
        padding: EdgeInsets.only(bottom: 30),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ThemeColor.primaryColor(),
          borderRadius: BorderRadius.only(bottomRight:  Radius.circular(40),bottomLeft: Radius.circular(40)),
        ),
        child: Column(
          children: [
            Text("NaiFarm",style: GoogleFonts.sarabun(color: Colors.white,fontSize: ScreenUtil().setSp(70),fontWeight: FontWeight.w500),),

          ],
        )
    );
  }

  Widget _BuildBar(BuildContext context){
    return Container(
      padding: EdgeInsets.only(left: 20,top: 20),
      color: ThemeColor.primaryColor(),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          InkWell(child: Icon(Icons.arrow_back_ios,color: Colors.white,),onTap: ()=>Navigator.of(context).pop(),)
        ],
      ),
    );
  }

  void _validate() {
    if(PhoneController.text.isEmpty){
      FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: "เบอร์โทรต้องไม่ว่าง",context: context);
    }else if(PhoneController.text.length!=10){
      FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: "เบอร์โทรศัพท์ไม่ถูกต้อง");
    }else{
      FunctionHelper.showDialogProcess(context);
      Future.delayed(const Duration(milliseconds: 1000), () {
        Navigator.of(context).pop();
        AppRoute.RegisterOTP(context,phoneNumber: PhoneController.text);

      });

    }
  }


  Future<Null> _login() async {
    final FacebookLogin facebookSignIn = new FacebookLogin();
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        FunctionHelper.showDialogProcess(context);
        final FacebookAccessToken accessToken = result.accessToken;

        AppProvider.getApplication(context).appStoreAPIRepository.getFBProfile(access_token: accessToken.token).then((value){
          Navigator.of(context).pop();
          AppRoute.Register_FB(context,value.email);
        }).catchError((Object obj){
          switch (obj.runtimeType) {
            case DioError:
            // Here's the sample to get the failed response error code and message
              final res = (obj as DioError).response;
              Logger().e("Got error : ${res.statusCode} -> ${res.statusMessage}");
              break;
            default:
          }
        });
        //get image  https://graph.facebook.com/2305752019445635/picture?type=large&width=720&height=720

        // final graphResponse = await http.get(
        //     'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
        // final profile = JSON.decode(graphResponse.body);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

}
