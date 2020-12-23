
import 'package:basic_utils/basic_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:naifarm/app/bloc/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/pojo/request/LoginRequest.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
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
  MemberBloc bloc;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _username.text = Usermanager.USERNAME_DEMO;
    _password.text = Usermanager.PASSWORD_DEMO;


  }

  void _init(){
    if(null == bloc){
      bloc = MemberBloc(AppProvider.getApplication(context));
      bloc.onLoad.stream.listen((event) {
        if(event){
          FunctionHelper.showDialogProcess(context);
        }else{
          Navigator.of(context).pop();
        }
      });
      bloc.onError.stream.listen((event) {
        //Navigator.of(context).pop();
        FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: event);
      });
      bloc.onSuccess.stream.listen((event) {
        widget.IsCallBack?Navigator.of(context).pop():AppRoute.Home(context);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    _init();
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
            Text(LocaleKeys.login_btn.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),),
            SizedBox(height: 30,),
            BuildEditText(head: LocaleKeys.my_profile_phone.tr()+"/"+LocaleKeys.my_profile_email.tr(), hint: LocaleKeys.my_profile_phone.tr()+"/"+LocaleKeys.my_profile_email.tr(),inputType: TextInputType.text,controller: _username,BorderOpacity: 0.3,borderRadius: 7,),
            SizedBox(height: 20,),
            BuildEditText(head: LocaleKeys.my_profile_password.tr(), hint: LocaleKeys.my_profile_password.tr(),inputType: TextInputType.text,controller: _password,BorderOpacity: 0.3,IsPassword: true,borderRadius: 7),
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
                child: Text(LocaleKeys.login_btn.tr(),
                  style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 3,child: Container(margin: EdgeInsets.only(left: 30),color: Colors.black.withOpacity(0.2),height: 1,),),
                Expanded(flex: 1,child: Align(alignment: Alignment.center,child: Text(LocaleKeys.or.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize()),)),),
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
                onPressed: ()=>bloc.LoginFacebook(),
                child: Text(LocaleKeys.facebook_login_btn.tr(),
                  style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize(),fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Wrap(
              children: [
                Text(LocaleKeys.login_not_member.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize(),height: 1.7,fontWeight: FontWeight.w500),),
                Column(

                  children: [
                    SizedBox(height: 3,),
                    InkWell(child: Text(" "+LocaleKeys.register_btn.tr()+" ",style: FunctionHelper.FontTheme(color: ThemeColor.secondaryColor(),fontSize: SizeUtil.titleSmallFontSize())),onTap: (){
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
                InkWell(child: Text(" "+LocaleKeys.login_forgot_password.tr(),style: FunctionHelper.FontTheme(color: ThemeColor.secondaryColor(),fontSize: SizeUtil.titleSmallFontSize())),onTap: (){
                  AppRoute.ForgotPassword(context);
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
      FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: LocaleKeys.message_error_userpass_empty.tr(),context: context);
    }else if(!nameRegExp.hasMatch(_username.text) && _username.text.length<10 || !nameRegExp.hasMatch(_username.text) && _username.text.length>10){
      FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: LocaleKeys.message_error_phone_invalid.tr(),context: context);
  }else if(!validator.email(_username.text) && nameRegExp.hasMatch(_username.text)){
      FunctionHelper.SnackBarShow(scaffoldKey: _scaffoldKey,message: LocaleKeys.message_error_mail_invalid.tr());
    }else{
        bloc.CustomerLogin(loginRequest: LoginRequest(username: validator.email(_username.text)?_username.text:"",phone: !validator.email(_username.text)?_username.text:"",password:_password.text));
    }
  }




}
