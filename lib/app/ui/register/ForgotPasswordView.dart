

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
import 'package:naifarm/app/model/pojo/response/ForgotRespone.dart';
import 'package:naifarm/app/model/pojo/response/LoginRespone.dart';
import 'package:naifarm/app/model/pojo/response/RegisterRespone.dart';
import 'package:naifarm/app/model/pojo/response/User.dart';
import 'package:naifarm/generated/locale_keys.g.dart';
import 'package:naifarm/utility/SizeUtil.dart';
import 'package:naifarm/utility/widgets/BuildEditText.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:sizer/sizer.dart';


class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _repassword = new TextEditingController();
  MemberBloc bloc;
  ForgotRespone _forgotRespone;
  String emailError="",passwordError="",repasswordError="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _email.text = "ApisitKaewsasan@gmail.com";
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
        if(event is ForgotRespone){
         setState(()=>_forgotRespone = (event as ForgotRespone));
        }else if(event is RegisterRespone){
          FunctionHelper.SuccessDialog(context,message: "ตั้งรหัสผ่านสำเร็จ",onClick: (){
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
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
            Text(LocaleKeys.login_forgot_password.tr(),style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),),
            SizedBox(height: 30,),
            BuildEditText(head: LocaleKeys.my_profile_email.tr(), hint: LocaleKeys.my_profile_email.tr(),inputType: TextInputType.text,controller: _email,BorderOpacity: 0.3,borderRadius: 7,onError: emailError,),
            SizedBox(height: 20,),
            _forgotRespone!=null?BuildEditText(head: LocaleKeys.my_profile_password.tr(), hint: LocaleKeys.my_profile_password.tr(),inputType: TextInputType.text,controller: _password,BorderOpacity: 0.3,IsPassword: true,borderRadius: 7,onError: passwordError,):SizedBox(),
            _forgotRespone!=null?SizedBox(height: 20,):SizedBox(),
            _forgotRespone!=null?BuildEditText(head: LocaleKeys.confirm_btn.tr()+LocaleKeys.my_profile_password.tr(), hint: LocaleKeys.confirm_btn.tr()+LocaleKeys.my_profile_password.tr(),inputType: TextInputType.text,controller: _repassword,BorderOpacity: 0.3,IsPassword: true,borderRadius: 7,onError: repasswordError,):SizedBox(),
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
                child: Text(_forgotRespone==null?LocaleKeys.my_profile_request_change_password.tr():LocaleKeys.my_profile_change_password.tr(),
                  style: FunctionHelper.FontTheme(fontSize: SizeUtil.titleFontSize().sp,fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 30,),

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
            Text("NaiFarm",style: FunctionHelper.FontTheme(color: Colors.white,fontSize: SizeUtil.appNameFontSize().sp,fontWeight: FontWeight.w500),),
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
    bool check = true;
    if(_email.text.isEmpty){
      check = false;
      setState(()=>emailError=LocaleKeys.message_error_mail_empty.tr());
    } if(!validator.email(_email.text)){
      check = false;
      setState(()=>emailError=LocaleKeys.message_error_mail_invalid.tr());
    } if(_password.text.length < 8 && _forgotRespone!=null){
      check = false;
      setState(()=>passwordError=LocaleKeys.message_error_password_length.tr());
    } if(_repassword.text.length < 8 && _forgotRespone!=null){
      check = false;
      setState(()=>repasswordError=LocaleKeys.message_error_password_length.tr());
    } if(_password.text != _repassword.text && _forgotRespone!=null){
      check = false;
      setState((){
        passwordError=LocaleKeys.message_error_password_not_match.tr();
        repasswordError=LocaleKeys.message_error_password_not_match.tr();
      });
    }
    if(check){
      _forgotRespone==null?bloc.ForgotPassword(email: _email.text):bloc.ResetPasswordRequest(email: _email.text,password: _repassword.text,token: _forgotRespone.token);
    }
  }




}