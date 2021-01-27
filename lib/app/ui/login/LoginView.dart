
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naifarm/app/bloc/Stream/MemberBloc.dart';
import 'package:naifarm/app/model/core/AppProvider.dart';
import 'package:naifarm/app/model/core/AppRoute.dart';
import 'package:naifarm/app/model/core/FunctionHelper.dart';
import 'package:naifarm/app/model/core/ThemeColor.dart';
import 'package:naifarm/app/model/core/Usermanager.dart';
import 'package:naifarm/app/model/db/NaiFarmLocalStorage.dart';
import 'package:naifarm/app/model/pojo/request/LoginRequest.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:naifarm/app/model/pojo/response/HomeObjectCombine.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:sizer/sizer.dart';

class LoginView extends StatefulWidget {
  final bool IsCallBack;
  final HomeObjectCombine item;
  final bool IsHeader;
  final Function(bool) homeCallBack;

  const LoginView({Key key, this.IsCallBack=false, this.item, this.IsHeader=true, this.homeCallBack}) : super(key: key);

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
        // if(widget.IsCallBack){
        //   NaiFarmLocalStorage.saveNowPage(3).then((value) =>  AppRoute.Home(context,item: widget.item));
        // }else{
        //   AppRoute.Home(context,item: widget.item);
        // }
        if(widget.IsHeader){
          AppRoute.Home(context);
        }else{
          widget.homeCallBack(true);
        }



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
          body: SingleChildScrollView(
            child: Column(
              children: [
                _BuildBar(context),
                _BuildContent(context)
              ],
            ),
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
            SizedBox(height: 4.0.h,),
            Text(LocaleKeys.login_btn.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp+2,fontWeight: FontWeight.w500),),
            SizedBox(height: 3.0.h,),
            BuildEditText(head: LocaleKeys.my_profile_phone.tr()+"/"+LocaleKeys.my_profile_email.tr(), hint: LocaleKeys.my_profile_phone.tr()+"/"+LocaleKeys.my_profile_email.tr(),inputType: TextInputType.text,controller: _username,BorderOpacity: 0.3,borderRadius: 7,),
            SizedBox(height: 2.0.h,),
            BuildEditText(head: LocaleKeys.my_profile_password.tr(), hint: LocaleKeys.my_profile_password.tr(),inputType: TextInputType.text,controller: _password,BorderOpacity: 0.3,IsPassword: true,borderRadius: 7),
            SizedBox(height: 4.0.h,),
            Padding(
              padding: const EdgeInsets.only(right: 15,left: 15),
              child: FlatButton(
                minWidth: MediaQuery.of(context).size.width,
                height: 7.0.h,
                color: ThemeColor.secondaryColor(),
                textColor: Colors.white,
                splashColor: Colors.white.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                onPressed: () => _validate(),
                child: Text(LocaleKeys.login_btn.tr(),
                  style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 3.5.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 3,child: Container(margin: EdgeInsets.only(left: 30),color: Colors.black.withOpacity(0.2),height: 1,),),
                Expanded(flex: 1,child: Align(alignment: Alignment.center,child: Text(LocaleKeys.or.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp),)),),
                Expanded(flex: 3,child: Container(margin: EdgeInsets.only(right: 30),color: Colors.black.withOpacity(0.2),height: 1,),),
              ],
            ),
            SizedBox(height: 3.5.h,),
            Padding(
              padding: const EdgeInsets.only(right: 15,left: 15),
              child: FlatButton(
                minWidth: MediaQuery.of(context).size.width,
                height: 7.0.h,
                color: Color(ColorUtils.hexToInt("#1f4dbf")),
                textColor: Colors.white,
                splashColor: Colors.white.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                onPressed: (){
                  //bloc.LoginFacebook();
                  FunctionHelper.AlertDialogShop(context,title: "Error",message: "The system is not supported yet.");
                },
                child: Text(LocaleKeys.facebook_login_btn.tr(),
                  style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 3.0.h,),
            Wrap(
              children: [
                Text(LocaleKeys.login_not_member.tr()+" ",style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleSmallFontSize().sp,height: 1.7,fontWeight: FontWeight.w500),),
                Column(
                  children: [
                    InkWell(child: Text(LocaleKeys.register_btn.tr(),style: FunctionHelper.FontTheme(color: ThemeColor.secondaryColor(),fontSize: SizeUtil.titleSmallFontSize().sp,decoration: TextDecoration.underline,height: 1.7,fontWeight: FontWeight.w500)),onTap: (){
                      AppRoute.Register(context);
                    },),

                  ],
                )
              ],
            ),

            Column(
              children: [
                SizedBox(height: 1.0.h,),
                InkWell(child: Text(LocaleKeys.login_forgot_password.tr(),style: FunctionHelper.FontTheme(color: ThemeColor.secondaryColor(),fontSize: SizeUtil.titleSmallFontSize().sp,decoration: TextDecoration.underline,height: 1.7,fontWeight: FontWeight.w500)),onTap: (){
                  AppRoute.ForgotPassword(context);
                },),

              ],
            )
          ],
        )
    );
  }

  Widget _BuildHeader(BuildContext context){
    return Container(
        padding: EdgeInsets.only(bottom: 4.0.h),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ThemeColor.primaryColor(),
          borderRadius: BorderRadius.only(bottomRight:  Radius.circular(40),bottomLeft: Radius.circular(40)),
        ),
        child: Column(
          children: [
            Text("NaiFarm",style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.appNameFontSize().sp,fontWeight: FontWeight.w500),),
          ],
        )
    );
  }

  Widget _BuildBar(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: ThemeColor.primaryColor(),
        borderRadius: BorderRadius.only(bottomRight:  Radius.circular(40),bottomLeft: Radius.circular(40)),
      ),
      width: MediaQuery.of(context).size.width,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.IsHeader?GestureDetector(
            child: Container(
              margin: EdgeInsets.only(left: 2.0.w,top: 2.0.w),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 4.5.w,),
              ),
            ),
            onTap: ()=>Navigator.pop(context, false),
          ):SizedBox(height: 4.0.h,),
          _BuildHeader(context),
        ],
      ),
    );
  }


  void _validate() {
    FocusScope.of(context).unfocus();
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
