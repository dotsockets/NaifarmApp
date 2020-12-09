
import 'package:basic_utils/basic_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/response/User.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:regexed_validator/regexed_validator.dart';

class LoginView extends StatefulWidget {
  final bool IsCallBack;

  const LoginView({Key key, this.IsCallBack=false}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _username.text = Usermanager.USERNAME_DEMO;
    _password.text = Usermanager.PASSWORD_DEMO;


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
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 30,),
            Text("เข้าสู่ระบบ",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),),
            SizedBox(height: 30,),
            BuildEditText(head: "เบอร์โทรศัพท์/อีเมลทรศัพท์", hint: "เบอร์โทรศัพท์/อีเมล",inputType: TextInputType.text,controller: _username,BorderOpacity: 0.3,borderRadius: 7,),
            SizedBox(height: 20,),
            BuildEditText(head: "รหัสผ่าน", hint: "รหัสผ่าน",inputType: TextInputType.text,controller: _password,BorderOpacity: 0.3,IsPassword: true,borderRadius: 7),
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
                onPressed: () => _validate(),
                child: Text("เข้าสู่ระบบ",
                  style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 3,child: Container(margin: EdgeInsets.only(left: 30),color: Colors.black.withOpacity(0.2),height: 1,),),
                Expanded(flex: 1,child: Align(alignment: Alignment.center,child: Text("หรือ",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize()),)),),
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
                child: Text("เข้าสู่ระบบด้วย Facebook",
                  style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Wrap(
              children: [
                Text("หากยังไม่ได้เป็นสมาชิก",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize(),height: 1.7,fontWeight: FontWeight.w500),),
                Column(

                  children: [
                    SizedBox(height: 3,),
                    InkWell(child: Text(" สมัครสมาชิก ",style: FunctionHelper.FontTheme(color: ThemeColor.secondaryColor(),fontSize: SizeUtil.titleSmallFontSize())),onTap: (){
                      AppRoute.Register(context);
                    },),
                    Container(
                      width: ScreenUtil().setWidth(180),
                      color: ThemeColor.secondaryColor(),
                      height: 1,
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 20,),
            Column(

              children: [
                SizedBox(height: 3,),
                InkWell(child: Text(" ลืมรหัสผ่าน ",style: FunctionHelper.FontTheme(color: ThemeColor.secondaryColor(),fontSize: SizeUtil.titleSmallFontSize())),onTap: (){
                  AppRoute.Home(context);
                },),
                Container(
                  width: ScreenUtil().setWidth(180),
                  color: ThemeColor.secondaryColor(),
                  height: 1,
                )
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
            Text("NaiFarm",style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.appNameFontSize(),fontWeight: FontWeight.w500),),
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
    RegExp nameRegExp = RegExp('[a-zA-Z]');
    // var stats_form = _form.currentState.validate();
    if(_username.text.isEmpty || _password.text.isEmpty){
      FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: "ชื่อผู้ใช้งาน หรือ รหัสผ่าน ห้ามว่าง",context: context);
    }else if(!validator.email(_username.text)){
      FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: "อีเมล์ไม่ถูกต้อง");
    }else if(!validator.password(_password.text)){
      FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: "เบอร์โทรศัพท์ไม่ถูกต้อง");
    }else{
      FunctionHelper.showDialogProcess(context);
      if(Usermanager.USERNAME_DEMO == _username.text && Usermanager.PASSWORD_DEMO == _password.text){
        Usermanager().Savelogin(user: User(id: "1",fullname: "John Mayer",username: "ApisitKaewsasan@gmail.com",email: "ApisitKaewsasan@gmail.com",phone: "0932971160",
            imageurl:  "https://freshairboutique.files.wordpress.com/2015/05/28438-long-red-head-girl.jpg")).then((value){
             Navigator.of(context).pop();
         // _navigateToProfilePage(context);
             widget.IsCallBack?Navigator.of(context).pop():AppRoute.Home(context);

        });

      }else{
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: "รหัสผ่านไม่ถูกต้อง");
      }
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
